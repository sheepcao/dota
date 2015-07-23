CREATE TABLE IF NOT EXISTS levelinfo (
  id int(11) NOT NULL AUTO_INCREMENT,
  username varchar(64) CHARACTER SET utf8 NOT NULL,
  gameID varchar(64) CHARACTER SET utf8,
  isReviewed varchar(64) CHARACTER SET utf8 NOT NULL,
  JJCscore varchar(64) CHARACTER SET utf8,
  TTscore varchar(64) CHARACTER SET utf8,
  WinRatio varchar(64) CHARACTER SET utf8,
  soldier varchar(64) CHARACTER SET utf8,
  heroFirst varchar(64) CHARACTER SET utf8,
  heroSecond varchar(64) CHARACTER SET utf8,
  heroThird varchar(64) CHARACTER SET utf8,
  created_Time datetime NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY (username)
);

