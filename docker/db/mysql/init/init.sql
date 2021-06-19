ALTER DATABASE migration DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

insert into testtable (created_date, modified_date, age, name) values (sysdate, sysdate, 25, abc);