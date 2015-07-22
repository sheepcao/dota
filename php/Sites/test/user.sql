CREATE TABLE IF NOT EXISTS users (
  id int(11) NOT NULL AUTO_INCREMENT,
  unique_id varchar(64) CHARACTER SET utf8 NOT NULL,
  name varchar(50) CHARACTER SET utf8 NOT NULL,
  email varchar(100) CHARACTER SET utf8 NOT NULL,
  encrypted_password varchar(64) CHARACTER SET utf8 NOT NULL,
  salt varchar(16) CHARACTER SET utf8 NOT NULL,
  created_at datetime NOT NULL,
  updated_at datetime DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY (unique_id)
);

