create table account (
    id bigint AUTO_INCREMENT not null,
    name varchar(255) not null,
    primary key (id)
);
CREATE TABLE favorite (
  id bigint(20) NOT NULL AUTO_INCREMENT,
  created_date datetime(6) DEFAULT NULL,
  modified_date datetime(6) DEFAULT NULL,
  member_id bigint(20) DEFAULT NULL,
  source_station_id bigint(20) DEFAULT NULL,
  target_station_id bigint(20) DEFAULT NULL,
  PRIMARY KEY (id)
);
CREATE TABLE line (
  id bigint(20) NOT NULL AUTO_INCREMENT,
  created_date datetime(6) DEFAULT NULL,
  modified_date datetime(6) DEFAULT NULL,
  color varchar(255) DEFAULT NULL,
  name varchar(255) DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY UK_9ney9davbulf79nmn9vg6k7tn (name)
);
CREATE TABLE member (
  id bigint(20) NOT NULL AUTO_INCREMENT,
  created_date datetime(6) DEFAULT NULL,
  modified_date datetime(6) DEFAULT NULL,
  age int(11) DEFAULT NULL,
  email varchar(255) DEFAULT NULL,
  password varchar(255) DEFAULT NULL,
  PRIMARY KEY (id)
);
CREATE TABLE station (
  id bigint(20) NOT NULL AUTO_INCREMENT,
  created_date datetime(6) DEFAULT NULL,
  modified_date datetime(6) DEFAULT NULL,
  name varchar(255) DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY UK_gnneuc0peq2qi08yftdjhy7ok (name)
);
CREATE TABLE section (
  id bigint(20) NOT NULL AUTO_INCREMENT,
  distance int(11) NOT NULL,
  down_station_id bigint(20) DEFAULT NULL,
  line_id bigint(20) DEFAULT NULL,
  up_station_id bigint(20) DEFAULT NULL,
  PRIMARY KEY (id),
  CONSTRAINT FK18bw17tb86fh1igov96s9i6he FOREIGN KEY (up_station_id) REFERENCES station (id),
  CONSTRAINT FKlfhpg8lrvyr948juittt221ux FOREIGN KEY (line_id) REFERENCES line (id),
  CONSTRAINT FKtecjgrtoxbeeqpymapva62xfw FOREIGN KEY (down_station_id) REFERENCES station (id)
);

