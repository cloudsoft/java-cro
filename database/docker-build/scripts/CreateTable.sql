CREATE TABLE IF NOT EXISTS hoodie (
    hoodie_id varchar(40) NOT NULL,
    name varchar(20),
    description varchar(200),
    price float,
    count int,
    image_url_1 varchar(40),
    image_url_2 varchar(40),
    PRIMARY KEY(hoodie_id)
    );

CREATE TABLE IF NOT EXISTS tag (
                                   tag_id MEDIUMINT NOT NULL AUTO_INCREMENT,
                                   name varchar(20),
    PRIMARY KEY(tag_id)
    );

CREATE TABLE IF NOT EXISTS dimension (
                                         size_id MEDIUMINT NOT NULL AUTO_INCREMENT,
                                         name varchar(20),
    label varchar(20),
    PRIMARY KEY(size_id)
    );

CREATE TABLE IF NOT EXISTS hoodie_tag (
    hoodie_id varchar(40),
    tag_id MEDIUMINT NOT NULL,
    FOREIGN KEY (hoodie_id)
    REFERENCES hoodie(hoodie_id),
    FOREIGN KEY(tag_id)
    REFERENCES tag(tag_id)
    );

CREATE TABLE IF NOT EXISTS hoodie_size (
    hoodie_id varchar(40),
    size_id MEDIUMINT NOT NULL,
    FOREIGN KEY (hoodie_id)
    REFERENCES hoodie(hoodie_id),
    FOREIGN KEY(size_id)
    REFERENCES dimension(size_id)
    );

CREATE TABLE IF NOT EXISTS cart_item (
    cart_id MEDIUMINT NOT NULL AUTO_INCREMENT,
    order_id varchar(40) NOT NULL,
    hoodie_id varchar(40),
    dimension varchar(20),
    quantity int,
    price float,
    status varchar(40) NOT NULL,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    completed_at timestamp DEFAULT CURRENT_TIMESTAMP,
    expires_at timestamp DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(cart_id),
    FOREIGN KEY (hoodie_id)
    REFERENCES hoodie(hoodie_id)
    );

