create table testtable
(
    id            bigint not null auto_increment,
    created_date  datetime(6),
    modified_date datetime(6),
    age           varchar(255),
    name          varchar(255),
    primary key (id)
);
