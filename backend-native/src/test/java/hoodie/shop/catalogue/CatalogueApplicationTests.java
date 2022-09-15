package hoodie.shop.catalogue;

import hoodie.shop.catalogue.model.CartItem;
import hoodie.shop.catalogue.model.Hoodie;
import hoodie.shop.catalogue.model.Size;
import hoodie.shop.catalogue.model.Tag;
import hoodie.shop.catalogue.repo.CartItemRepo;
import hoodie.shop.catalogue.repo.HoodieRepo;
import hoodie.shop.catalogue.repo.SizeRepo;
import hoodie.shop.catalogue.repo.TagRepo;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.assertEquals;

@Disabled
@SpringBootTest(classes = {CatalogueApplication.class}, webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class CatalogueApplicationTests {

	@Autowired
    HoodieRepo hoodieRepo;
	@Autowired TagRepo tagRepo;
	@Autowired
    SizeRepo sizeRepo;
	@Autowired
    CartItemRepo cartItemRepo;

	@Order(1)
	@Test
	void checkRepos() {
		assertEquals(0, hoodieRepo.count());
		assertEquals(0, tagRepo.count());
		assertEquals(0, sizeRepo.count());
		assertEquals(0, cartItemRepo.count());
	}

	@Order(2)
	@Test
	void checkCart() {
		Size size = new Size();
		size.setName("T");
		size.setLabel("test");
		Size savedsize = sizeRepo.save(size);
		assertEquals(1, sizeRepo.count());

		Tag tag = new Tag();
		tag.setName("Test");
		Tag savedTag = tagRepo.save(tag);
		assertEquals(1, tagRepo.count());

		Hoodie hoodie = new Hoodie();
		hoodie.setId(UUID.randomUUID().toString());
		hoodie.setName("test hoodie");
		hoodie.setDescription("test hoodie");
		hoodie.setPrice(3.14f);
		hoodie.setCount(42);
		hoodie.getTags().add(savedTag);
		hoodie.getSizes().add(savedsize);
		Hoodie savedHoodie = hoodieRepo.save(hoodie);
		assertEquals(1, hoodieRepo.count());

		CartItem cartItem1 = new CartItem();
		String orderId = UUID.randomUUID().toString().substring(0, 9);
		cartItem1.setOrderId(orderId);
		cartItem1.setHoodie(savedHoodie);
		cartItem1.setSize("T");
		cartItem1.setQuantity(42);
		cartItem1.setPrice(3.12f); // assume ordered when they were cheaper
		cartItem1.setExpiresAt(Timestamp.valueOf(LocalDateTime.now().plusHours(24)));

		CartItem cartItem2 = new CartItem();
		cartItem2.setOrderId(orderId);
		cartItem2.setHoodie(savedHoodie);
		cartItem2.setSize("XXL");
		cartItem2.setQuantity(2);
		cartItem2.setPrice(4f); // assume ordered when they were cheaper
		cartItem2.setExpiresAt(Timestamp.valueOf(LocalDateTime.now().plusHours(24)));
		List<CartItem> cartItems = new ArrayList<>();
		cartItems.add(cartItem1);
		cartItems.add(cartItem2);
		cartItemRepo.saveAll(cartItems);

		assertEquals(2, cartItemRepo.count());

		cartItemRepo.deleteByOrderId(cartItem1.getOrderId(), CartItem.OrderStatus.IN_PROGRESS);
		assertEquals(0, cartItemRepo.count());
	}


}
