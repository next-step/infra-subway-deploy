create table test (
     id bigint not null auto_increment,
     created_date datetime,
     modified_date datetime,
     name varchar(255),
     primary key (id)
) engine=InnoDB;