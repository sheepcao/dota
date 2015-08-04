CREATE TABLE IF NOT EXISTS userinfo (
  id int(11) NOT NULL AUTO_INCREMENT,
  unique_id varchar(64) CHARACTER SET utf8 NOT NULL,
  email varchar(100) CHARACTER SET utf8 NOT NULL,
  password varchar(64) CHARACTER SET utf8 NOT NULL,
  age varchar(64) CHARACTER SET utf8 NOT NULL,
  sex varchar(64) CHARACTER SET utf8 NOT NULL,
  isReviewed varchar(64) CHARACTER SET utf8 NOT NULL,
  gameID varchar(128) CHARACTER SET utf8 DEFAULT NULL,
  gameName varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  rank varchar(128) CHARACTER SET utf8 DEFAULT NULL,
  created_at datetime NOT NULL,
  updated_at datetime DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY (unique_id)
);

