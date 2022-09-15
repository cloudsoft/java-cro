package hoodie.shop.catalogue.repo;

import hoodie.shop.catalogue.model.Hoodie;
import org.springframework.data.repository.CrudRepository;

public interface HoodieRepo extends CrudRepository<Hoodie, String> {

}
