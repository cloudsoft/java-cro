package hoodie.shop.catalogue.service;

import hoodie.shop.catalogue.model.CartItem;
import hoodie.shop.catalogue.repo.CartItemRepo;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneOffset;

@Service
public class CartCleaner {
    private final CartItemRepo cartItemRepo;

    public CartCleaner(CartItemRepo cartItemRepo) {
        this.cartItemRepo = cartItemRepo;
    }

    @Scheduled(cron = "0 0 23 * * *")
    public void scheduleCleanerTask(){
        Iterable<CartItem> carts =  cartItemRepo.findAll();
        for (CartItem cartItem : carts) {
            LocalDateTime ldt = LocalDateTime.ofInstant(Instant.now(), ZoneOffset.UTC);
            Timestamp current = Timestamp.valueOf(ldt);
            if (current.after(cartItem.getExpiresAt())) {
                cartItemRepo.deleteById(cartItem.getId());
            }
        }
    }
}
