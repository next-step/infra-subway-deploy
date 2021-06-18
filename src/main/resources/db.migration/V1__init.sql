CREATE TABLE `favorite`
(
    `id`                bigint(20) NOT NULL AUTO_INCREMENT,
    `created_date`      datetime(6) DEFAULT NULL,
    `modified_date`     datetime(6) DEFAULT NULL,
    `member_id`         bigint(20) DEFAULT NULL,
    `source_station_id` bigint(20) DEFAULT NULL,
    `target_station_id` bigint(20) DEFAULT NULL,
    PRIMARY KEY (`id`)
)

CREATE TABLE `line`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT,
    `created_date`  datetime(6) DEFAULT NULL,
    `modified_date` datetime(6) DEFAULT NULL,
    `color`         varchar(255) DEFAULT NULL,
    `name`          varchar(255) DEFAULT NULL,
    PRIMARY KEY (`id`)
)

CREATE TABLE `member`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT,
    `created_date`  datetime(6) DEFAULT NULL,
    `modified_date` datetime(6) DEFAULT NULL,
    `age`           int(11) DEFAULT NULL,
    `email`         varchar(255) DEFAULT NULL,
    `password`      varchar(255) DEFAULT NULL,
    PRIMARY KEY (`id`)
)

CREATE TABLE `section`
(
    `id`              bigint(20) NOT NULL AUTO_INCREMENT,
    `distance`        int(11) NOT NULL,
    `down_station_id` bigint(20) DEFAULT NULL,
    `line_id`         bigint(20) DEFAULT NULL,
    `up_station_id`   bigint(20) DEFAULT NULL,
    PRIMARY KEY (`id`)
)

CREATE TABLE `station`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT,
    `created_date`  datetime(6) DEFAULT NULL,
    `modified_date` datetime(6) DEFAULT NULL,
    `name`          varchar(255) DEFAULT NULL,
    PRIMARY KEY (`id`)
)
