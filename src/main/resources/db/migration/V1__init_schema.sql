CREATE TABLE favorite (
                          id                  BIGINT       NOT NULL PRIMARY KEY AUTO_INCREMENT,
                          created_date        DATETIME(6),
                          modified_date       DATETIME(6),
                          member_id           BIGINT,
                          source_station_id   BIGINT,
                          target_station_id   BIGINT
);

CREATE TABLE line (
                      id              BIGINT       NOT NULL PRIMARY KEY AUTO_INCREMENT,
                      created_date    DATETIME(6),
                      modified_date   DATETIME(6),
                      color           VARCHAR(255),
                      name            VARCHAR(255)
);

CREATE TABLE member (
                        id              BIGINT       NOT NULL PRIMARY KEY AUTO_INCREMENT,
                        created_date    DATETIME(6),
                        modified_date   DATETIME(6),
                        age             INT,
                        email           VARCHAR(255),
                        password        VARCHAR(255)
);

CREATE TABLE section (
                         id              BIGINT  NOT NULL PRIMARY KEY AUTO_INCREMENT,
                         distance        INT     NOT NULL,
                         down_station_id BIGINT,
                         line_id         BIGINT,
                         up_station_id   BIGINT
);

CREATE TABLE station (
                         id              BIGINT       NOT NULL PRIMARY KEY AUTO_INCREMENT,
                         created_date    DATETIME(6),
                         modified_date   DATETIME(6),
                         name            VARCHAR(255)
);

ALTER TABLE line ADD CONSTRAINT UK_9ney9davbulf79nmn9vg6k7tn UNIQUE (name);
ALTER TABLE station ADD CONSTRAINT UK_gnneuc0peq2qi08yftdjhy7ok UNIQUE (name);
ALTER TABLE section ADD CONSTRAINT FKtecjgrtoxbeeqpymapva62xfw FOREIGN KEY (down_station_id) REFERENCES station(id);
ALTER TABLE section ADD CONSTRAINT FKlfhpg8lrvyr948juittt221ux FOREIGN KEY (line_id) REFERENCES line(id);
ALTER TABLE section ADD CONSTRAINT FK18bw17tb86fh1igov96s9i6he FOREIGN KEY (up_station_id) REFERENCES station(id);