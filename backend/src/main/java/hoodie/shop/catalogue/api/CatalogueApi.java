package hoodie.shop.catalogue.api;


import hoodie.shop.catalogue.Health;
import hoodie.shop.catalogue.model.*;
import hoodie.shop.catalogue.repo.CartItemRepo;
import hoodie.shop.catalogue.repo.HoodieRepo;
import hoodie.shop.catalogue.repo.SizeRepo;
import hoodie.shop.catalogue.repo.TagRepo;
import hoodie.shop.catalogue.*;
import hoodie.shop.catalogue.model.*;
import org.apache.commons.io.IOUtils;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@CrossOrigin("*")
@RestController
public class CatalogueApi {

    private final HoodieRepo hoodieRepo;
    private final CartItemRepo cartItemRepo;
    private final TagRepo tagRepo;
    private final SizeRepo sizeRepo;

    public CatalogueApi(HoodieRepo hoodieRepo, TagRepo tagRepo, SizeRepo sizeRepo, CartItemRepo cartItemRepo) {
        this.hoodieRepo = hoodieRepo;
        this.tagRepo = tagRepo;
        this.sizeRepo = sizeRepo;
        this.cartItemRepo = cartItemRepo;
    }

    @GetMapping(path = "/hoodie", produces = MediaType.APPLICATION_JSON_VALUE)
    public List<Hoodie> getAllHoodies(){
        List<Hoodie> hoodies = new ArrayList<>();
        hoodieRepo.findAll().iterator().forEachRemaining(hoodies::add);
        return hoodies;
    }

    @GetMapping(path = "/hoodie/{id}" ,produces = MediaType.APPLICATION_JSON_VALUE)
    public Hoodie getHoodieById(@PathVariable String id){
        return hoodieRepo.findById(id).orElse(null);
    }

    @GetMapping(value = "/images/{name}", produces = MediaType.IMAGE_PNG_VALUE)
    public byte[] getImage(@PathVariable String name) throws IOException {
        InputStream in = getClass().getResourceAsStream("/static/images/" + name);
        return IOUtils.toByteArray(in);
    }

    @GetMapping(path = "/size")
    public Integer countTags(){
        return Math.toIntExact(tagRepo.count()); // this is counting tags - why ?
    }

    @GetMapping(path = "/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    public Hoodie getHoodie(@PathVariable String id){
        return hoodieRepo.findById(id).orElse(null);
    }

    @GetMapping(path = "/tags", produces = MediaType.APPLICATION_JSON_VALUE)
    public List<Tag> getAllTags(){
        return (List<Tag>) tagRepo.findAll();
    }

    @GetMapping(path = "/sizes", produces = MediaType.APPLICATION_JSON_VALUE)
    public List<Size> getAllSizes(){
        return (List<Size>) sizeRepo.findAll();
    }

    @GetMapping(path = "/health", produces = MediaType.APPLICATION_JSON_VALUE)
    public List<Health> getHealth(){
        List<Health> healthList = new ArrayList<>();
        healthList.add(Health.ofService("catalogue", "OK"));
        try {
            tagRepo.count();
            healthList.add(Health.ofService("catalogue-db", "OK"));
        } catch (Exception e) {
            healthList.add(Health.ofService("catalogue-db", "err"));
        }
        return healthList;
    }

    @GetMapping(path = "/hello")
    public String hello() {
        return "this works!";
    }

    @ResponseStatus(HttpStatus.CREATED)
    @PostMapping(path = "/cart/{orderId}", consumes = MediaType.APPLICATION_JSON_VALUE)
    public void saveCart(@PathVariable String orderId,  @RequestBody CartView[] cartViewItems ){
        cartItemRepo.deleteByOrderId(orderId, CartItem.OrderStatus.IN_PROGRESS); // I know sloppy and stupid, but it gets the job done

        List<CartItem> cartItems = Arrays.stream(cartViewItems).map(cvi -> {
            CartItem cartItem = new CartItem();
            cartItem.setOrderId(orderId);
            Hoodie hoodie = hoodieRepo.findById(cvi.getId()).orElse(null);
            cartItem.setHoodie(hoodie);
            cartItem.setSize(cvi.getSize().getName());
            cartItem.setQuantity(1);
            cartItem.setPrice(cvi.getPrice());
            return cartItem;
        }).collect(Collectors.toList());

        cartItemRepo.saveAll(cartItems);
    }

    @GetMapping(path = "/cart/{orderId}", produces = MediaType.APPLICATION_JSON_VALUE)
    public List<CartView> retrieveCart(@PathVariable String orderId){
        return cartItemRepo.findByOrderId(orderId, CartItem.OrderStatus.IN_PROGRESS).stream().map(
                c -> {
                    CartView cartView = new CartView();
                    Hoodie hoodie = c.getHoodie();
                    cartView.setId(hoodie.getId());
                    cartView.setName(hoodie.getName());
                    cartView.setPrice(hoodie.getPrice());
                    cartView.setDescription(hoodie.getDescription());
                    cartView.setPrice(hoodie.getPrice());
                    cartView.setCount(hoodie.getCount());
                    cartView.setImageUrl1(hoodie.getImageUrl1());
                    cartView.setImageUrl2(hoodie.getImageUrl2());
                    cartView.setSizes(hoodie.getSizes());
                    cartView.setTags(hoodie.getTags());
                    cartView.setSize(hoodie.getSizes().stream().filter(s -> s.getName().equals(c.getSize())).findFirst()
                            .orElse(null));
                    return cartView;
                }
        ).collect(Collectors.toList());
    }

    @ResponseStatus(HttpStatus.CREATED)
    @PostMapping(path = "/checkout/{orderId}", consumes = MediaType.APPLICATION_JSON_VALUE)
    public void checkoutIteams(@PathVariable String orderId){
        List<CartItem> cartItems = cartItemRepo.findByOrderId(orderId, CartItem.OrderStatus.IN_PROGRESS);
        cartItemRepo.saveAll(cartItems.stream().peek(c -> {
            c.setStatus(CartItem.OrderStatus.COMPLETED);
            c.setCompletedAt(Timestamp.valueOf(LocalDateTime.now()));
        }).collect(Collectors.toList()));
    }

}
