create table favorite (
    id bigint auto_increment,
    created_date timestamp,
    modified_date timestamp,
    member_id bigint,
    source_station_id bigint,
    target_station_id bigint,
    primary key (id)
);
create table line (
    id bigint auto_increment,
    created_date timestamp,
    modified_date timestamp,
    color varchar(255),
    name varchar(255),
    primary key (id)
);
create table member (
    id bigint auto_increment,
    created_date timestamp,
    modified_date timestamp,
    age integer,
    email varchar(255),
    password varchar(255),
    primary key (id)
);
create table section (
    id bigint auto_increment,
    distance integer not null,
    down_station_id bigint,
    line_id bigint,
    up_station_id bigint,
    primary key (id)
);
create table station (
    id bigint auto_increment,
    created_date timestamp,
    modified_date timestamp,
    name varchar(255),
    primary key (id)
);
alter table line
    add constraint line_name_unique unique (name);
alter table station
   add constraint station_name_unique unique (name);
alter table section
    add constraint fk_section_down_station_id
    foreign key (down_station_id)
    references station (id);
alter table section
    add constraint fk_section_line_id
    foreign key (line_id)
    references line (id);
alter table section
    add constraint fk_section_up_station_id
    foreign key (up_station_id)
    references station (id);