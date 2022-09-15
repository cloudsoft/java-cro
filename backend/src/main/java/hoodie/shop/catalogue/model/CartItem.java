package hoodie.shop.catalogue.model;

import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;
import java.io.Serializable;
import java.sql.Timestamp;
import java.time.LocalDateTime;

@Entity
@Table(name = "cart_item")
public class CartItem implements Serializable {

    public enum OrderStatus  {
        IN_PROGRESS,
        COMPLETED,
        ARCHIVED // not used for now
    }

    @Enumerated(EnumType.STRING)
    private OrderStatus status;

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO, generator="native")
    @GenericGenerator(name = "native", strategy = "native")
    @Column(name="cart_id")
    private Integer id;

    @Column(name="order_id") // the frontend generated id
    private String orderId;

    @ManyToOne
    @JoinColumn(name="hoodie_id", nullable=false)
    Hoodie hoodie;

    @Column(name="dimension")
    private String size;

    private Integer quantity;

    private Float price;

    @Column(name="created_at")
    private Timestamp createdAt;

    @Column(name="completed_at")
    private Timestamp completedAt;

    @Column(name="expires_at")
    private Timestamp expiresAt;

    public CartItem() {
        createdAt = Timestamp.valueOf(LocalDateTime.now());
        expiresAt = Timestamp.valueOf(LocalDateTime.now().plusYears(1));
        status = OrderStatus.IN_PROGRESS;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String clientId) {
        this.orderId = clientId;
    }

    public Hoodie getHoodie() {
        return hoodie;
    }

    public void setHoodie(Hoodie hoodie) {
        this.hoodie = hoodie;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public Float getPrice() {
        return price;
    }

    public void setPrice(Float price) {
        this.price = price;
    }

    public Timestamp getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(Timestamp expiredAt) {
        this.expiresAt = expiredAt;
    }

    public OrderStatus getStatus() {
        return status;
    }

    public void setStatus(OrderStatus status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(Timestamp completedAt) {
        this.completedAt = completedAt;
    }
}
