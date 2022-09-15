package hoodie.shop.catalogue;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;
import org.springframework.scheduling.annotation.EnableScheduling;

import javax.sql.DataSource;
import java.sql.SQLException;

@EnableScheduling
@SpringBootApplication
public class CatalogueApplication {
	private static final Logger LOG = LoggerFactory.getLogger(CatalogueApplication.class);

	public static void main(String... args) throws SQLException {
		ApplicationContext ctx = SpringApplication.run(CatalogueApplication.class, args);

		LOG.info(" .... ->> Getting data from {} ", (ctx.getBean(DataSource.class)).getConnection().getMetaData().getURL());
		LOG.info(" .... ->> App is up, enjoy! ");
	}

}
