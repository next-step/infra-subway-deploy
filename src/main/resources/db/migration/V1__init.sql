create table favorite (
    id bigint auto_increment primary key,
    created_date      datetime(6) null,
    modified_date     datetime(6) null,
    member_id         bigint null,
    source_station_id bigint null,
    target_station_id bigint null
);