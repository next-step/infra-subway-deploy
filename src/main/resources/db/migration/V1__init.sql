drop table if exists favorite
CREATE TABLE `favorite` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `created_date` datetime(6) DEFAULT NULL,
  `modified_date` datetime(6) DEFAULT NULL,
  `member_id` bigint(20) DEFAULT NULL,
  `source_station_id` bigint(20) DEFAULT NULL,
  `target_station_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
)

drop table if exists line
CREATE TABLE `line` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `created_date` datetime(6) DEFAULT NULL,
  `modified_date` datetime(6) DEFAULT NULL,
  `color` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_9ney9davbulf79nmn9vg6k7tn` (`name`)
)

drop table if exists member
CREATE TABLE `member` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `created_date` datetime(6) DEFAULT NULL,
  `modified_date` datetime(6) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
)

drop table if exists section
CREATE TABLE `section` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `distance` int(11) NOT NULL,
  `down_station_id` bigint(20) DEFAULT NULL,
  `line_id` bigint(20) DEFAULT NULL,
  `up_station_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKtecjgrtoxbeeqpymapva62xfw` (`down_station_id`),
  KEY `FKlfhpg8lrvyr948juittt221ux` (`line_id`),
  KEY `FK18bw17tb86fh1igov96s9i6he` (`up_station_id`),
  CONSTRAINT `FK18bw17tb86fh1igov96s9i6he` FOREIGN KEY (`up_station_id`) REFERENCES `station` (`id`),
  CONSTRAINT `FKlfhpg8lrvyr948juittt221ux` FOREIGN KEY (`line_id`) REFERENCES `line` (`id`),
  CONSTRAINT `FKtecjgrtoxbeeqpymapva62xfw` FOREIGN KEY (`down_station_id`) REFERENCES `station` (`id`)
)

drop table if exists station
CREATE TABLE `station` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `created_date` datetime(6) DEFAULT NULL,
  `modified_date` datetime(6) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_gnneuc0peq2qi08yftdjhy7ok` (`name`)
)