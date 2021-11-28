drop table if exists favorite;
drop table if exists line;
drop table if exists member;
drop table if exists section;
drop table if exists station;

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
    primary key (id)
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
     primary key (id)
);

create table station (
     id bigint not null auto_increment,
     created_date datetime(6),
     modified_date datetime(6),
     name varchar(255),
     primary key (id)
);

alter table section
    add constraint 'section_station_down_fk'
        foreign key (down_station_id)
            references station (id);

alter table section
    add constraint 'section_station_up_fk'
        foreign key (up_station_id)
            references station (id);

alter table section
    add constraint 'section_line_fk'
        foreign key (line_id)
            references line (id);