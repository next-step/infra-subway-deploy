create table if not exists favorite (
                          id bigint not null auto_increment,
                          created_date datetime,
                          modified_date datetime,
                          member_id bigint,
                          source_station_id bigint,
                          target_station_id bigint,
                          primary key (id)
) engine=InnoDB;

create table if not exists line (
                      id bigint not null auto_increment,
                      created_date datetime,
                      modified_date datetime,
                      color varchar(255),
                      name varchar(255),
                      primary key (id)
) engine=InnoDB;

create table if not exists member (
                        id bigint not null auto_increment,
                        created_date datetime,
                        modified_date datetime,
                        age integer,
                        email varchar(255),
                        password varchar(255),
                        primary key (id)
) engine=InnoDB;

create table if not exists section (
                         id bigint not null auto_increment,
                         distance integer not null,
                         down_station_id bigint,
                         line_id bigint,
                         up_station_id bigint,
                         primary key (id)
) engine=InnoDB;

create table if not exists station (
                         id bigint not null auto_increment,
                         created_date datetime,
                         modified_date datetime,
                         name varchar(255),
                         primary key (id)
) engine=InnoDB;

alter table line
    add constraint UK_9ney9davbulf79nmn9vg6k7tn unique (name);

alter table station
    add constraint UK_gnneuc0peq2qi08yftdjhy7ok unique (name);

alter table section
    add constraint FKtecjgrtoxbeeqpymapva62xfw
        foreign key (down_station_id)
            references station (id);

alter table section
    add constraint FKlfhpg8lrvyr948juittt221ux
        foreign key (line_id)
            references line (id);

alter table section
    add constraint FK18bw17tb86fh1igov96s9i6he
        foreign key (up_station_id)
            references station (id);
