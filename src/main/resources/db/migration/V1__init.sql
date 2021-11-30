create table favorite (
    id bigint auto_increment primary key,
    created_date      datetime(6) null,
    modified_date     datetime(6) null,
    member_id         bigint null,
    source_station_id bigint null,
    target_station_id bigint null
);

create table line (
   id bigint auto_increment primary key,
    created_date datetime(6) null,
    modified_date datetime(6) null,
    color varchar(255) null,
    name varchar(255) null
);

create table member (
   id bigint auto_increment primary key,
    created_date datetime(6) null,
    modified_date datetime(6) null,
    age int default 0,
    email varchar(255) null,
    password varchar(255) null
);

create table section (
   id bigint auto_increment primary key,
    distance integer not null,
    down_station_id bigint null,
    line_id bigint null,
    up_station_id bigint null
);

create table station (
   id bigint auto_increment primary key,
    created_date datetime(6) null,
    modified_date datetime(6) null,
    name varchar(255) null
);

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