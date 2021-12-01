ALTER DATABASE migration DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

INSERT INTO station(name) VALUE ('강남역');
INSERT INTO station (name) VALUE ('광교역');

INSERT INTO line (color, name) VALUE ('bg-red-600', '신분당선');
INSERT INTO section (distance, up_station_id, down_station_id) VALUE (10, 1, 2);