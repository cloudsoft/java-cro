package hoodie.shop.catalogue.model;

import javax.persistence.*;
import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "hoodie")
public class Hoodie implements Serializable {
    @Id
    //@GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name="hoodie_id")
    private String id;

    private String name;
    private String description;
    private Float price;

    private Integer count;

    @Column(name = "image_url_1")
    private String imageUrl1;
    @Column(name = "image_url_2")
    private String imageUrl2;

    @ManyToMany(fetch = FetchType.EAGER) // we want the tags for the hoodie
    @JoinTable(name = "hoodie_tag",
            joinColumns = @JoinColumn(name = "hoodie_id"),
            inverseJoinColumns = @JoinColumn(name = "tag_id"))
    private Set<Tag> tags = new HashSet<>();

    @ManyToMany(fetch = FetchType.EAGER) // we want the sizes for the hoodie
    @JoinTable(name = "hoodie_size",
            joinColumns = @JoinColumn(name = "hoodie_id"),
            inverseJoinColumns = @JoinColumn(name = "size_id"))
    private Set<Size> sizes = new HashSet<>();

    public Hoodie() {
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setPrice(Float price) {
        this.price = price;
    }

    public void setCount(Integer count) {
        this.count = count;
    }

    public void setImageUrl1(String imageUrl1) {
        this.imageUrl1 = imageUrl1;
    }

    public void setImageUrl2(String imageUrl2) {
        this.imageUrl2 = imageUrl2;
    }

    public Set<Tag> getTags() {
        return tags;
    }

    public void setTags(Set<Tag> tags) {
        this.tags = tags;
    }

    public String getName() {
        return name;
    }

    public String getDescription() {
        return description;
    }

    public Float getPrice() {
        return price;
    }

    public Integer getCount() {
        return count;
    }

    public String getImageUrl1() {
        return imageUrl1;
    }

    public String getImageUrl2() {
        return imageUrl2;
    }

    public Set<Size> getSizes() {
        return sizes;
    }

    public void setSizes(Set<Size> sizes) {
        this.sizes = sizes;
    }
}
