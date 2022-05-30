create table favorite (
      id bigint not null auto_increment,
      created_date datetime(6),
      modified_date datetime(6),
      member_id bigint,
      source_station_id bigint,
      target_station_id bigint,
      primary key (id)
) engine=InnoDB;

create table line (
      id bigint not null auto_increment,
      created_date datetime(6),
      modified_date datetime(6),
      color varchar(255),
      name varchar(255),
      primary key (id)
) engine=InnoDB;

create table member (
      id bigint not null auto_increment,
      created_date datetime(6),
      modified_date datetime(6),
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
     created_date datetime(6),
     modified_date datetime(6),
     name varchar(255),
     primary key (id)
) engine=InnoDB;

alter table line add constraint UK_9ney9davbulf79nmn9vg6k7tn unique (name);

alter table station add constraint UK_gnneuc0peq2qi08yftdjhy7ok unique (name);

alter table section add constraint FKtecjgrtoxbeeqpymapva62xfw foreign key (down_station_id) references station (id);

alter table section add constraint FKlfhpg8lrvyr948juittt221ux foreign key (line_id) references line (id);

alter table section add constraint FK18bw17tb86fh1igov96s9i6he foreign key (up_station_id) references station (id);
