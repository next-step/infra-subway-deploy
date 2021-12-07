    create table test (
       id bigint not null auto_increment,
        created_date datetime(6),
        modified_date datetime(6),
        member_id bigint,
        source_station_id bigint,
        target_station_id bigint,
        primary key (id)
    ) engine=InnoDB