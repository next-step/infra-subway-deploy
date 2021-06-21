-- MySQL dump 10.13  Distrib 8.0.16, for macos10.14 (x86_64)
--
-- Host: 127.0.0.1    Database: subway
-- ------------------------------------------------------
-- Server version	8.0.25

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
SET NAMES utf8 ;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `favorite`
--

DROP TABLE IF EXISTS `favorite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
SET character_set_client = utf8mb4 ;
CREATE TABLE `favorite` (
                            `id` bigint NOT NULL AUTO_INCREMENT,
                            `created_date` datetime(6) DEFAULT NULL,
                            `modified_date` datetime(6) DEFAULT NULL,
                            `member_id` bigint DEFAULT NULL,
                            `source_station_id` bigint DEFAULT NULL,
                            `target_station_id` bigint DEFAULT NULL,
                            PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `line`
--

DROP TABLE IF EXISTS `line`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
SET character_set_client = utf8mb4 ;
CREATE TABLE `line` (
                        `id` bigint NOT NULL AUTO_INCREMENT,
                        `created_date` datetime(6) DEFAULT NULL,
                        `modified_date` datetime(6) DEFAULT NULL,
                        `color` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                        `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                        PRIMARY KEY (`id`),
                        UNIQUE KEY `UK_9ney9davbulf79nmn9vg6k7tn` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `member`
--

DROP TABLE IF EXISTS `member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
SET character_set_client = utf8mb4 ;
CREATE TABLE `member` (
                          `id` bigint NOT NULL AUTO_INCREMENT,
                          `created_date` datetime(6) DEFAULT NULL,
                          `modified_date` datetime(6) DEFAULT NULL,
                          `age` int DEFAULT NULL,
                          `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                          `password` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                          PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `section`
--

DROP TABLE IF EXISTS `section`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
SET character_set_client = utf8mb4 ;
CREATE TABLE `section` (
                           `id` bigint NOT NULL AUTO_INCREMENT,
                           `distance` int NOT NULL,
                           `down_station_id` bigint DEFAULT NULL,
                           `line_id` bigint DEFAULT NULL,
                           `up_station_id` bigint DEFAULT NULL,
                           PRIMARY KEY (`id`),
                           KEY `FKtecjgrtoxbeeqpymapva62xfw` (`down_station_id`),
                           KEY `FKlfhpg8lrvyr948juittt221ux` (`line_id`),
                           KEY `FK18bw17tb86fh1igov96s9i6he` (`up_station_id`),
                           CONSTRAINT `FK18bw17tb86fh1igov96s9i6he` FOREIGN KEY (`up_station_id`) REFERENCES `station` (`id`),
                           CONSTRAINT `FKlfhpg8lrvyr948juittt221ux` FOREIGN KEY (`line_id`) REFERENCES `line` (`id`),
                           CONSTRAINT `FKtecjgrtoxbeeqpymapva62xfw` FOREIGN KEY (`down_station_id`) REFERENCES `station` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `station`
--

DROP TABLE IF EXISTS `station`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
SET character_set_client = utf8mb4 ;
CREATE TABLE `station` (
                           `id` bigint NOT NULL AUTO_INCREMENT,
                           `created_date` datetime(6) DEFAULT NULL,
                           `modified_date` datetime(6) DEFAULT NULL,
                           `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                           PRIMARY KEY (`id`),
                           UNIQUE KEY `UK_gnneuc0peq2qi08yftdjhy7ok` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-06-21 13:54:09
