package hoodie.shop.catalogue.init;

import hoodie.shop.catalogue.model.CartItem;
import hoodie.shop.catalogue.model.Hoodie;
import hoodie.shop.catalogue.model.Size;
import hoodie.shop.catalogue.repo.CartItemRepo;
import hoodie.shop.catalogue.repo.HoodieRepo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.core.io.ClassPathResource;
import org.springframework.jdbc.datasource.init.ResourceDatabasePopulator;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import javax.sql.DataSource;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.ThreadLocalRandom;

@Service
public class DbInitializer {
    private static final Logger LOG = LoggerFactory.getLogger(DbInitializer.class);

    @Autowired
    private DataSource dataSource;

    private final HoodieRepo hoodieRepo;
    private final CartItemRepo cartItemRepo;

    public DbInitializer(HoodieRepo hoodieRepo, CartItemRepo cartItemRepo) {
        this.hoodieRepo = hoodieRepo;
        this.cartItemRepo = cartItemRepo;
    }

    @EventListener(ApplicationReadyEvent.class)
    public void loadData() {
        if(hoodieRepo.count() == 0) {
            LOG.info("Populate with hoodies, tags and sizes from SQL...");
            ResourceDatabasePopulator resourceDatabasePopulator = new
                    ResourceDatabasePopulator(true, true, "UTF-8", new ClassPathResource("data.sql"));
            resourceDatabasePopulator.execute(dataSource);
            LOG.info("[DONE]: Populate with hoodies, tags and sizes from SQL.");
        }
        genSomeCartItems();
    }


    //@PostConstruct
    void genSomeCartItems(){
        LOG.info("Populating the database with random orders (this might take a while) ...");
        List<Hoodie> hoodies = new ArrayList<>();
        hoodieRepo.findAll().iterator().forEachRemaining(hoodies::add);

        int orderCount = 2000;

        do {
            int months = ThreadLocalRandom.current().nextInt(0, 10);
            String orderId = UUID.randomUUID().toString().substring(0, 8);
            List<CartItem> order = new ArrayList<>();
            int cartItemsCount = ThreadLocalRandom.current().nextInt(0, 10);
            for (int i = 0; i < cartItemsCount; i++) {
                int hoodieIdx = ThreadLocalRandom.current().nextInt(0, hoodies.size());
                Hoodie hoodie = hoodies.get(hoodieIdx);
                CartItem cartItem = new CartItem();
                cartItem.setOrderId(orderId);
                cartItem.setHoodie(hoodie);
                int sizeIdx = ThreadLocalRandom.current().nextInt(0, hoodie.getSizes().size());
                List<Size> sizes = new ArrayList<>(hoodie.getSizes());
                cartItem.setSize(sizes.get(sizeIdx).getName());
                cartItem.setQuantity(ThreadLocalRandom.current().nextInt(0, 5));
                cartItem.setPrice(hoodie.getPrice());
                cartItem.setCreatedAt(Timestamp.valueOf(LocalDateTime.now().minusMonths(months).minusHours(ThreadLocalRandom.current().nextInt(0, 22))));
                cartItem.setStatus(CartItem.OrderStatus.COMPLETED);
                cartItem.setCompletedAt(Timestamp.valueOf(LocalDateTime.now().minusMonths(months).plusHours(ThreadLocalRandom.current().nextInt(0, 22))));
                order.add(cartItem);
            }
            cartItemRepo.saveAll(order);
        } while ( --orderCount > 0);
        LOG.info("[Done]: Populating the database with random orders.");
    }
}
