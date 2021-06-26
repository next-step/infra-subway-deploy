create table favorite (
    id bigint not null auto_increment,
    created_date datetime,
    modified_date datetime,
    member_id bigint,
    source_station_id bigint,
    target_station_id bigint,
    primary key (id)
) engine=InnoDB;

create table line (
    id bigint not null auto_increment,
    created_date datetime,
    modified_date datetime,
    color varchar(255),
    name varchar(255),
    primary key (id)
) engine=InnoDB;

create table member (
    id bigint not null auto_increment,
    created_date datetime,
    modified_date datetime,
    age integer,
    email varchar(255),
    password varchar(255),
    primary key (id)
) engine=InnoDB;

create table section (
    id bigint not null auto_increment,
    distance integer not null,
    down_station_id bigint,
    line_id bigint,
    up_station_id bigint,
    primary key (id)
) engine=InnoDB;

create table station (
    id bigint not null auto_increment,
    created_date datetime,
    modified_date datetime,
    name varchar(255),
    primary key (id)
) engine=InnoDB;

alter table line
    add constraint UK_LINE_NAME unique (name);

alter table station
    add constraint UK_STATION_NAME unique (name);

alter table section
    add constraint FK_DOWN_STATION_ID
        foreign key (down_station_id)
            references station (id);

alter table section
    add constraint FK_LINE_ID
        foreign key (line_id)
            references line (id);

alter table section
    add constraint FK_UP_STATION_ID
        foreign key (up_station_id)
            references station (id);
