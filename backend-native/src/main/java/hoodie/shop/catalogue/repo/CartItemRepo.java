package hoodie.shop.catalogue.repo;

import hoodie.shop.catalogue.model.CartItem;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface CartItemRepo extends CrudRepository<CartItem, Integer> {

    @Query("SELECT c FROM CartItem c WHERE c.orderId = :orderId and c.status= :status")
    List<CartItem> findByOrderId(@Param("orderId") String orderId, @Param("status") CartItem.OrderStatus status);

    @Transactional
    @Modifying
    @Query("DELETE FROM CartItem c WHERE c.orderId = :orderId and c.status= :status" )
    void deleteByOrderId(@Param("orderId") String orderId, @Param("status") CartItem.OrderStatus status);
}


