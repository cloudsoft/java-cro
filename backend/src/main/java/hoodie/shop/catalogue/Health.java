package hoodie.shop.catalogue;

import java.io.Serializable;
import java.time.Instant;

/**
 * type Health struct {
 * 	Service string `json:"service"`
 * 	Status  string `json:"status"`
 * 	Time    string `json:"time"`
 * }
 *
 * 	app := Health{"catalogue", "OK", time.Now().String()}
 * 	db := Health{"catalogue-db", dbstatus, time.Now().String()}
 */
public class Health implements Serializable {
    private String service;
    private String status;
    private Instant time;

    public Health() {
    }

    public static Health ofService(final String name, final String status){
        Health h = new Health();
        h.setService(name);
        h.setStatus(status);
        h.setTime(Instant.now());
        return h;
    }

    public String getService() {
        return service;
    }

    public void setService(String service) {
        this.service = service;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Instant getTime() {
        return time;
    }

    public void setTime(Instant time) {
        this.time = time;
    }
}
