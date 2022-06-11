create table favorite (
    id bigint not null auto_increment,
    created_date datetime(6),
    modified_date datetime(6),
    member_id bigint,
    source_station_id bigint,
    target_station_id bigint,
    primary key (id)
);

create table line (
    id bigint not null auto_increment,
    created_date datetime(6),
    modified_date datetime(6),
    color varchar(255),
    name varchar(255),
    primary key (id),
    constraint uk_line_name unique (name)
);

create table member (
    id bigint not null auto_increment,
    created_date datetime(6),
    modified_date datetime(6),
    age integer,
    email varchar(255),
    password varchar(255),
    primary key (id)
);

create table section (
    id bigint not null auto_increment,
    distance integer not null,
    down_station_id bigint,
    line_id bigint,
    up_station_id bigint,
    primary key (id),
    constraint FK_section_up_station_to_station
       foreign key (up_station_id)
       references station (id),
    constraint FK_section_down_station_to_station
       foreign key (down_station_id)
       references station (id),
    constraint FK_section_to_line
       foreign key (line_id)
       references line (id)
);

create table station (
    id bigint not null auto_increment,
    created_date datetime(6),
    modified_date datetime(6),
    name varchar(255),
    primary key (id),
    constraint uk_station_name unique (name)
);