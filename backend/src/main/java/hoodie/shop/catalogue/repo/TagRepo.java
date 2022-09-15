package hoodie.shop.catalogue.repo;

import hoodie.shop.catalogue.model.Tag;
import org.springframework.data.repository.CrudRepository;

public interface TagRepo extends CrudRepository<Tag, Integer> {
}
