CREATE TABLE favorite
(
    id                BIGINT AUTO_INCREMENT PRIMARY KEY,
    created_date      DATETIME(6) NULL,
    modified_date     DATETIME(6) NULL,
    member_id         BIGINT NULL,
    source_station_id BIGINT NULL,
    target_station_id BIGINT NULL
);

CREATE TABLE line
(
    id            BIGINT AUTO_INCREMENT PRIMARY KEY,
    created_date  DATETIME(6) NULL,
    modified_date DATETIME(6) NULL,
    color         VARCHAR(255) NULL,
    name          VARCHAR(255) NULL,
    CONSTRAINT UK_9ney9davbulf79nmn9vg6k7tn UNIQUE (name)
);

CREATE TABLE member
(
    id            BIGINT AUTO_INCREMENT PRIMARY KEY,
    created_date  DATETIME(6) NULL,
    modified_date DATETIME(6) NULL,
    age           INT NULL,
    email         VARCHAR(255) NULL,
    password      VARCHAR(255) NULL
);

CREATE TABLE station
(
    id            BIGINT AUTO_INCREMENT PRIMARY KEY,
    created_date  DATETIME(6) NULL,
    modified_date DATETIME(6) NULL,
    name          VARCHAR(255) NULL,
    CONSTRAINT UK_gnneuc0peq2qi08yftdjhy7ok UNIQUE (name)
);

CREATE TABLE section
(
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    distance        INT NOT NULL,
    down_station_id BIGINT NULL,
    line_id         BIGINT NULL,
    up_station_id   BIGINT NULL,
    CONSTRAINT FK18bw17tb86fh1igov96s9i6he FOREIGN KEY (up_station_id) REFERENCES station (id),
    CONSTRAINT FKlfhpg8lrvyr948juittt221ux FOREIGN KEY (line_id) REFERENCES line (id),
    CONSTRAINT FKtecjgrtoxbeeqpymapva62xfw FOREIGN KEY (down_station_id) REFERENCES station (id)
);