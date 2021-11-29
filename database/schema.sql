
SET check_function_bodies = false;

CREATE TABLE products(
  id integer NOT NULL,
  "name" text,
  slogan text,
  description text,
  category text,
  default_price integer,
  PRIMARY KEY(id)
);

CREATE TABLE styles(
  style_id integer NOT NULL,
  "name" text NOT NULL,
  original_price text NOT NULL,
  sale_price text,
  "default?" boolean NOT NULL,
  product_id integer NOT NULL,
  PRIMARY KEY(style_id)
);

CREATE TABLE photos(
  id integer NOT NULL,
  thumbnail_url text NOT NULL,
  url text NOT NULL,
  style_id integer NOT NULL,
  PRIMARY KEY(id)
);

CREATE TABLE skus(
  id integer NOT NULL,
  quantity integer NOT NULL,
  size text NOT NULL,
  style_id integer NOT NULL,
  PRIMARY KEY(id)
);

CREATE TABLE features(
  id integer NOT NULL,
  feature text,
  "value" text,
  product_id integer NOT NULL,
  PRIMARY KEY(id)
);

CREATE TABLE related(
  id integer NOT NULL,
  product_id integer NOT NULL,
  related_product_id integer NOT NULL,
  PRIMARY KEY(id)
);

ALTER TABLE features
  ADD CONSTRAINT products_features
    FOREIGN KEY (product_id) REFERENCES products (id);

ALTER TABLE related
  ADD CONSTRAINT products_styles FOREIGN KEY (product_id) REFERENCES products (id)
  ;

ALTER TABLE photos
  ADD CONSTRAINT style_photos FOREIGN KEY (style_id) REFERENCES styles (style_id);

ALTER TABLE skus
  ADD CONSTRAINT style_skus FOREIGN KEY (style_id) REFERENCES styles (style_id);

ALTER TABLE styles
  ADD CONSTRAINT products_style FOREIGN KEY (product_id) REFERENCES products (id);

CREATE INDEX s_idndx
  ON photos (style_id);

CREATE INDEX skus_idndx
  ON skus (style_id);

CREATE INDEX sty_idndx
  ON styles (product_id, style_id);

CREATE INDEX feat_idndx
  ON features (product_id);

CREATE INDEX related_idndx
  ON related (product_id);

COPY photos(id, style_id, url, thumbnail_url)
FROM '/home/ubuntu/product-info-api/csv/photos.csv'
DELIMITER ','
CSV HEADER;


/*
COPY styles(style_id, product_id, name, sale_price, original_price, "default?")
FROM '/home/ubuntu/product-info-api/csv/styles.csv'
DELIMITER ','
CSV HEADER;

COPY features(id, product_id, feature, value)
FROM '/home/ubuntu/product-info-api/csv/features.csv'
DELIMITER ','
CSV HEADER;

COPY related(id, product_id, related_product_id)
FROM '/home/ubuntu/product-info-api/csv/related.csv'
DELIMITER ','
CSV HEADER;

COPY products(id, name, slogan, description, category, default_price)
FROM '/home/ubuntu/product-info-api/csv/product.csv'
DELIMITER ','
CSV HEADER;

COPY skus(id, style_id, size, quantity)
FROM '/home/ubuntu/product-info-api/csv/skus.csv'
DELIMITER ','
CSV HEADER;

*/