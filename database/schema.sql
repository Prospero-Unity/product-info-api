SET check_function_bodies = false;

/* Table 'products' */
CREATE TABLE products(
  id integer NOT NULL,
  "name" text,
  slogan text,
  description text,
  category text,
  default_price integer,
  PRIMARY KEY(id)
);

/* Table 'styles' */
CREATE TABLE styles(
  style_id integer NOT NULL,
  "name" text NOT NULL,
  original_price text NOT NULL,
  sale_price text,
  "default?" boolean NOT NULL,
  product_id integer NOT NULL,
  PRIMARY KEY(style_id)
);

/* Table 'photos' */
CREATE TABLE photos(
  id integer NOT NULL,
  thumbnail_url text NOT NULL,
  url text NOT NULL,
  style_id integer NOT NULL,
  PRIMARY KEY(id)
);

/* Table 'skus' */
CREATE TABLE skus(
  id integer NOT NULL,
  quantity integer NOT NULL,
  size text NOT NULL,
  style_id integer NOT NULL,
  PRIMARY KEY(id)
);

/* Table 'features' */
CREATE TABLE features(
  id integer NOT NULL,
  feature text,
  "value" text,
  product_id integer NOT NULL,
  PRIMARY KEY(id)
);

/* Table 'related' */
CREATE TABLE related(
  id integer NOT NULL,
  product_id integer NOT NULL,
  related_product_id integer NOT NULL,
  PRIMARY KEY(id)
);

/* Relation 'products_features' */
ALTER TABLE features
  ADD CONSTRAINT products_features
    FOREIGN KEY (product_id) REFERENCES products (id);

/* Relation 'products_styles' */
ALTER TABLE related
  ADD CONSTRAINT products_styles FOREIGN KEY (product_id) REFERENCES products (id)
  ;

/* Relation 'style_photos' */
ALTER TABLE photos
  ADD CONSTRAINT style_photos FOREIGN KEY (style_id) REFERENCES styles (style_id);

/* Relation 'style_skus' */
ALTER TABLE skus
  ADD CONSTRAINT style_skus FOREIGN KEY (style_id) REFERENCES styles (style_id);

/* Relation 'products_style' */
ALTER TABLE styles
  ADD CONSTRAINT products_style FOREIGN KEY (product_id) REFERENCES products (id);

/* index 'photos' */
CREATE INDEX s_idndx
  ON photos (style_id);

/* index 'skus' */
CREATE INDEX skus_idndx
  ON skus (style_id);

/* index 'styles' */
CREATE INDEX sty_idndx
  ON styles (product_id, style_id);

/* index 'features' */
CREATE INDEX feat_idndx
  ON features (product_id);

/* index 'related' */
CREATE INDEX related_idndx
  ON related (product_id);

/* COPY to 'products' */
COPY products(id, name, slogan, description, category, default_price)
FROM '/var/csv/product.csv'
DELIMITER ','
CSV HEADER;

COPY styles(style_id, product_id, name, sale_price, original_price, "default?")
FROM '/var/csv/styles.csv'
DELIMITER ','
CSV HEADER;

COPY features(id, product_id, feature, value)
FROM '/var/csv/features.csv'
DELIMITER ','
CSV HEADER;

COPY related(id, product_id, related_product_id)
FROM '/var/csv/related.csv'
DELIMITER ','
CSV HEADER;

COPY photos(id, style_id, url, thumbnail_url)
FROM '/var/csv/photos.csv'
DELIMITER ','
CSV HEADER;

COPY skus(id, style_id, size, quantity)
FROM '/var/csv/skus.csv'
DELIMITER ','
CSV HEADER;