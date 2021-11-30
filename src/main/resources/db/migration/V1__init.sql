create table `station` (
    id bigint(20) NOT NULL AUTO_INCREMENT,
    created_date datetime,
    modified_date datetime,
    name varchar(255) NOT NULL,
    primary key (id),
    unique (name)
) ENGINE=InnoDB;

create table `line` (
    id bigint(20) NOT NULL AUTO_INCREMENT,
    created_date datetime,
    modified_date datetime,
    color varchar(255),
    name varchar(255),
    primary key (id),
    unique (name)
) ENGINE=InnoDB;

create table `section` (
    id bigint(20) NOT NULL AUTO_INCREMENT,
    distance int(11) not null,
    line_id bigint,
    up_station_id bigint,
    down_station_id bigint,
    primary key (id),
    foreign key (line_id) references `line` (id),
    foreign key (up_station_id) references `station` (id),
    foreign key (down_station_id) references `station` (id)
) ENGINE=InnoDB;

create table `member` (
    id bigint(20) NOT NULL AUTO_INCREMENT,
    created_date datetime,
    modified_date datetime,
    age int(11),
    email varchar(255),
    password varchar(255),
    primary key (id)
) ENGINE=InnoDB;

create table `favorite` (
    id bigint(20) NOT NULL AUTO_INCREMENT,
    created_date datetime,
    modified_date datetime,
    member_id bigint,
    source_station_id bigint,
    target_station_id bigint,
    primary key (id)
) ENGINE=InnoDB;
