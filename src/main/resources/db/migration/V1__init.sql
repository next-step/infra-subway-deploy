create table favorite
(
    id                bigint not null auto_increment,
    created_date      datetime,
    modified_date     datetime NULL DEFAULT NULL,
    member_id         bigint,
    source_station_id bigint,
    target_station_id bigint,
    primary key (id)
);

create table line
(
    id            bigint not null auto_increment,
    created_date  datetime,
    modified_date datetime NULL DEFAULT NULL,
    color         varchar(255),
    name          varchar(255),
    primary key (id)
);

create table member
(
    id            bigint not null auto_increment,
    created_date  datetime,
    modified_date datetime NULL DEFAULT NULL,
    age           integer,
    email         varchar(255),
    password      varchar(255),
    primary key (id)
);

create table section
(
    id              bigint not null auto_increment,
    distance        integer not null,
    down_station_id bigint,
    line_id         bigint,
    up_station_id   bigint,
    primary key (id)
);

create table station
(
    id            bigint not null auto_increment,
    created_date  datetime,
    modified_date datetime NULL DEFAULT NULL,
    name          varchar(255),
    primary key (id)
);
