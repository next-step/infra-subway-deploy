CREATE TABLE line
(
    id            bigint(20) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    created_date  datetime(6),
    modified_date datetime(6),
    color         varchar(255),
    name          varchar(255) UNIQUE
);

CREATE TABLE member
(
    id            bigint(20) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    created_date  datetime(6),
    modified_date datetime(6),
    age           int(11),
    email         varchar(255),
    password      varchar(255)
);

CREATE TABLE section
(
    `id`              bigint(20) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `distance`        int(11) NOT NULL,
    `down_station_id` bigint(20),
    `line_id`         bigint(20),
    `up_station_id`   bigint(20)
);

CREATE TABLE station
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `created_date`  datetime(6),
    `modified_date` datetime(6),
    `name`          varchar(255) UNIQUE KEY,
);

CREATE TABLE favorite
(
    `id`                bigint(20) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `created_date`      datetime(6),
    `modified_date`     datetime(6),
    `member_id`         bigint(20),
    `source_station_id` bigint(20),
    `target_station_id` bigint(20)
);

ALTER TABLE section
    ADD CONSTRAINT fk_down_station_id
        FOREIGN KEY (down_station_id)
            REFERENCES station;

ALTER TABLE section
    ADD CONSTRAINT fk_up_station_id
        FOREIGN KEY (up_station_id)
            REFERENCES station;

ALTER TABLE section
    ADD CONSTRAINT fk_station_id
        FOREIGN KEY (down_station_id)
            REFERENCES station;

