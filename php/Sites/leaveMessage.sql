CREATE TABLE IF NOT EXISTS noteinfo (
  id int(11) NOT NULL AUTO_INCREMENT,
  username varchar(64) CHARACTER SET utf8 NOT NULL,
  visitor varchar(64) CHARACTER SET utf8 NOT NULL,
  note_content varchar(1024) CHARACTER SET utf8 NOT NULL,
  createdAt datetime NOT NULL,
  PRIMARY KEY (id)
);

