create table favorite (
   id bigint not null auto_increment,
    created_date datetime,
    modified_date datetime,
    member_id bigint,
    source_station_id bigint,
    target_station_id bigint,
    primary key (id)
);

create table line (
   id bigint not null auto_increment,
    created_date datetime,
    modified_date datetime,
    color varchar(255),
    name varchar(255),
    primary key (id)
);

create table member (
   id bigint not null auto_increment,
    created_date datetime,
    modified_date datetime,
    age int,
    email varchar(255),
    password varchar(255),
    primary key (id)
);

create table section (
   id bigint not null auto_increment,
    distance int not null,
    down_station_id bigint,
    line_id bigint,
    up_station_id bigint,
    primary key (id)
);

create table station (
   id bigint not null auto_increment,
    created_date datetime,
    modified_date datetime,
    name varchar(255),
    primary key (id)
);

alter table line
   add constraint uk_line_name unique (name);

alter table station
   add constraint uk_station_name unique (name);

alter table section
   add constraint fk_section_down_station
   foreign key (down_station_id)
   references station(id);

alter table section
   add constraint fk_line
   foreign key (line_id)
   references line(id);

alter table section
   add constraint fk_section_up_station
   foreign key (up_station_id)
   references station(id);
