CREATE TABLE IF NOT EXISTS JJCinfo (
  JJCid int(11) NOT NULL AUTO_INCREMENT,
  JJCusername varchar(64) CHARACTER SET utf8 NOT NULL,
  JJCscore varchar(64) CHARACTER SET utf8,
  JJCtotal varchar(64) CHARACTER SET utf8,
  JJCoffline varchar(64) CHARACTER SET utf8,
  JJCmvp varchar(64) CHARACTER SET utf8,
  JJCPianJiang varchar(64) CHARACTER SET utf8,
  JJCPoDi varchar(64) CHARACTER SET utf8,
  JJCPoJun varchar(64) CHARACTER SET utf8,
  JJCYingHun varchar(64) CHARACTER SET utf8,
  JJCBuWang varchar(64) CHARACTER SET utf8,
  JJCFuHao varchar(64) CHARACTER SET utf8,
  JJCDoubleKill varchar(64) CHARACTER SET utf8,
  JJCTripleKill varchar(64) CHARACTER SET utf8,
  JJCWinRatio varchar(64) CHARACTER SET utf8,
  JJCheroFirst varchar(64) CHARACTER SET utf8,
  JJCheroSecond varchar(64) CHARACTER SET utf8,
  JJCheroThird varchar(64) CHARACTER SET utf8,
  JJCcreated_Time datetime NOT NULL,
  PRIMARY KEY (JJCid),
  UNIQUE KEY (JJCusername)
);



CREATE TABLE IF NOT EXISTS TTinfo (
  TTid int(11) NOT NULL AUTO_INCREMENT,
  TTusername varchar(64) CHARACTER SET utf8 NOT NULL,
  TTscore varchar(64) CHARACTER SET utf8,
  TTtotal varchar(64) CHARACTER SET utf8,
  TToffline varchar(64) CHARACTER SET utf8,
  TTmvp varchar(64) CHARACTER SET utf8,
  TTPianJiang varchar(64) CHARACTER SET utf8,
  TTPoDi varchar(64) CHARACTER SET utf8,
  TTPoJun varchar(64) CHARACTER SET utf8,
  TTYingHun varchar(64) CHARACTER SET utf8,
  TTBuWang varchar(64) CHARACTER SET utf8,
  TTFuHao varchar(64) CHARACTER SET utf8,
  TTDoubleKill varchar(64) CHARACTER SET utf8,
  TTTripleKill varchar(64) CHARACTER SET utf8,
  TTWinRatio varchar(64) CHARACTER SET utf8,
  TTheroFirst varchar(64) CHARACTER SET utf8,
  TTheroSecond varchar(64) CHARACTER SET utf8,
  TTheroThird varchar(64) CHARACTER SET utf8,
  TTcreated_Time datetime NOT NULL,
  PRIMARY KEY (TTid),
  UNIQUE KEY (TTusername)
);



CREATE TABLE IF NOT EXISTS MJinfo (
  MJid int(11) NOT NULL AUTO_INCREMENT,
  MJusername varchar(64) CHARACTER SET utf8 NOT NULL,
  MJscore varchar(64) CHARACTER SET utf8,
  MJtotal varchar(64) CHARACTER SET utf8,
  MJoffline varchar(64) CHARACTER SET utf8,
  MJmvp varchar(64) CHARACTER SET utf8,
  MJPianJiang varchar(64) CHARACTER SET utf8,
  MJPoDi varchar(64) CHARACTER SET utf8,
  MJPoJun varchar(64) CHARACTER SET utf8,
  MJYingHun varchar(64) CHARACTER SET utf8,
  MJBuWang varchar(64) CHARACTER SET utf8,
  MJFuHao varchar(64) CHARACTER SET utf8,
  MJDoubleKill varchar(64) CHARACTER SET utf8,
  MJTripleKill varchar(64) CHARACTER SET utf8,
  MJWinRatio varchar(64) CHARACTER SET utf8,
  MJheroFirst varchar(64) CHARACTER SET utf8,
  MJheroSecond varchar(64) CHARACTER SET utf8,
  MJheroThird varchar(64) CHARACTER SET utf8,
  MJcreated_Time datetime NOT NULL,
  PRIMARY KEY (MJid),
  UNIQUE KEY (MJusername)
);
