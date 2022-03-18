DROP TABLE IF EXISTS `member`;

CREATE TABLE `member` (
                          `id` bigint(20) NOT NULL AUTO_INCREMENT,
                          `created_date` datetime(6) DEFAULT NULL,
                          `modified_date` datetime(6) DEFAULT NULL,
                          `age` int(11) DEFAULT NULL,
                          `email` varchar(255) DEFAULT NULL,
                          `password` varchar(255) DEFAULT NULL,
                          PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

INSERT INTO `member` (`created_date`, `modified_date`, `age`, `email`, `password`)
VALUES('220319', '220319', 35, 'admin@gmail.com', '1234');