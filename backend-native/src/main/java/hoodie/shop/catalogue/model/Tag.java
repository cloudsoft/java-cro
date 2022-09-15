package hoodie.shop.catalogue.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;
import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "tag")
public class Tag implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO, generator="native")
    @GenericGenerator(name = "native", strategy = "native")
    @Column(name="tag_id")
    private Integer id;

    private String name;

    public Tag() {
    }

    @JsonIgnore
    @ManyToMany
    @JoinTable(name = "hoodie_tag",
            joinColumns = @JoinColumn(name = "tag_id"),
            inverseJoinColumns = @JoinColumn(name = "hoodie_id"))
     private Set<Hoodie> hoodies = new HashSet<>();

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Set<Hoodie> getHoodies() {
        return hoodies;
    }

    public void setHoodies(Set<Hoodie> hoodies) {
        this.hoodies = hoodies;
    }


}
