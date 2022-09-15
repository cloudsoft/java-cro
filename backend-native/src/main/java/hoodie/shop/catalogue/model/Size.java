package hoodie.shop.catalogue.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "dimension")
public class Size {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO, generator="native")
    @GenericGenerator(name = "native", strategy = "native")
    @Column(name="size_id")
    private Integer id;

    private String name;

    private String label;

    public Size() {
    }

    @JsonIgnore
    @ManyToMany
    @JoinTable(name = "hoodie_size",
            joinColumns = @JoinColumn(name = "size_id"),
            inverseJoinColumns = @JoinColumn(name = "hoodie_id"))
    private Set<Hoodie> hoodies = new HashSet<>();

    public Set<Hoodie> getHoodies() {
        return hoodies;
    }

    public void setHoodies(Set<Hoodie> hoodies) {
        this.hoodies = hoodies;
    }

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

    public String getLabel() {
        return label;
    }

    public void setLabel(String description) {
        this.label = description;
    }
}
