CREATE TABLE IF NOT EXISTS signatureinfo (
  id int(11) NOT NULL AUTO_INCREMENT,
  username varchar(64) CHARACTER SET utf8 NOT NULL,
  content varchar(100) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY (username)
);

