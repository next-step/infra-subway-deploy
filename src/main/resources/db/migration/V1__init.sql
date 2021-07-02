drop table flyway_test if exists;
drop sequence if exists hibernate_sequence;
create sequence hibernate_sequence start with 1 increment by 1;
create table flyway_test (id bigint not null, email varchar(255), password varchar(255), username varchar(255), primary key (id));
