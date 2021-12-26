create table if not exists favorite
(
    id                bigint not null auto_increment,
    created_date      datetime,
    modified_date     datetime,
    member_id         bigint,
    source_station_id bigint,
    target_station_id bigint,
    primary key (id)
) engine = InnoDB;

create table if not exists line
(
    id            bigint not null auto_increment,
    created_date  datetime,
    modified_date datetime,
    color         varchar(255),
    name          varchar(255),
    primary key (id)
) engine = InnoDB;

create table if not exists member
(
    id            bigint not null auto_increment,
    created_date  datetime,
    modified_date datetime,
    age           integer,
    email         varchar(255),
    password      varchar(255),
    primary key (id)
) engine = InnoDB;

create table if not exists section
(
    id              bigint  not null auto_increment,
    distance        integer not null,
    down_station_id bigint,
    line_id         bigint,
    up_station_id   bigint,
    primary key (id)
) engine = InnoDB;

create table if not exists station
(
    id            bigint not null auto_increment,
    created_date  datetime,
    modified_date datetime,
    name          varchar(255),
    primary key (id)
) engine = InnoDB;
