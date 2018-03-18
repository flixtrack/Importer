SET NAMES 'utf8' COLLATE 'utf8_general_ci';
USE `flixtrack`;
SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Agency
-- ----------------------------
DROP TABLE IF EXISTS `agency`;

CREATE TABLE `agency` (
  `agency_id` varchar(255) NOT NULL,
  `agency_name` varchar(255) NOT NULL,
  `agency_url` varchar(255) NOT NULL,
  `agency_timezone` varchar(100) NOT NULL,
  `agency_lang` varchar(10) DEFAULT NULL,
  `agency_phone` varchar(100) DEFAULT NULL,
  `agency_fare_url` varchar(255) DEFAULT NULL,
  `agency_email` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`agency_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Calendar
-- ----------------------------
DROP TABLE IF EXISTS `calendar`;

CREATE TABLE `calendar` (
  `service_id` varchar(255) NOT NULL,
  `monday` enum('0','1') DEFAULT NULL,
  `tuesday` enum('0','1') DEFAULT NULL,
  `wednesday` enum('0','1') DEFAULT NULL,
  `thursday` enum('0','1') DEFAULT NULL,
  `friday` enum('0','1') DEFAULT NULL,
  `saturday` enum('0','1') DEFAULT NULL,
  `sunday` enum('0','1') DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  PRIMARY KEY (`service_id`),
  KEY `service_id` (`service_id`),
  CONSTRAINT `calendar_service_id` FOREIGN KEY (`service_id`) REFERENCES `trips` (`service_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Calendar Dates
-- ----------------------------
DROP TABLE IF EXISTS `calendar_dates`;

CREATE TABLE `calendar_dates` (
  `service_id` varchar(255) NOT NULL,
  `date` date DEFAULT NULL,
  `exception_type` enum('1','2') DEFAULT NULL,
  KEY `service_id` (`service_id`),
  KEY `exception_type` (`exception_type`),
  CONSTRAINT `calendar_dates_service_id` FOREIGN KEY (`service_id`) REFERENCES `trips` (`service_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Fare Attributes
-- ----------------------------
DROP TABLE IF EXISTS `fare_attributes`;

CREATE TABLE `fare_attributes` (
  `fare_id` varchar(255) DEFAULT NULL,
  `price` varchar(50) NOT NULL,
  `currency_type` varchar(50) NOT NULL,
  `payment_method` enum('0','1') DEFAULT NULL,
  `transfers` enum('','0','1','2') DEFAULT NULL,
  `agency_id` varchar(255) DEFAULT NULL,
  KEY `fare_id` (`fare_id`),
  KEY `fare_attributes_agency_id` (`agency_id`),
  CONSTRAINT `fare_attributes_agency_id` FOREIGN KEY (`agency_id`) REFERENCES `agency` (`agency_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Fare Rules
-- ----------------------------
DROP TABLE IF EXISTS `fare_rules`;

CREATE TABLE `fare_rules` (
  `fare_id` varchar(100) DEFAULT NULL,
  `route_id` varchar(100) DEFAULT NULL,
  `origin_id` varchar(100) DEFAULT NULL,
  `destination_id` varchar(100) DEFAULT NULL,
  `contains_id` varchar(100) DEFAULT NULL,
  KEY `fare_id` (`fare_id`),
  KEY `route_id` (`route_id`),
  KEY `origin_zone_id` (`origin_id`),
  KEY `destination_zone_id` (`destination_id`),
  CONSTRAINT `destination_zone_id` FOREIGN KEY (`destination_id`) REFERENCES `stops` (`zone_id`),
  CONSTRAINT `fare_rules_fare_id` FOREIGN KEY (`fare_id`) REFERENCES `fare_attributes` (`fare_id`),
  CONSTRAINT `fare_rules_route_id` FOREIGN KEY (`route_id`) REFERENCES `routes` (`route_id`),
  CONSTRAINT `origin_zone_id` FOREIGN KEY (`origin_id`) REFERENCES `stops` (`zone_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Feed Info
-- ----------------------------
DROP TABLE IF EXISTS `feed_info`;

CREATE TABLE `feed_info` (
  `feed_publisher_name` varchar(255) DEFAULT NULL,
  `feed_publisher_url` varchar(255) NOT NULL,
  `feed_lang` varchar(255) NOT NULL,
  `feed_start_date` varchar(255) DEFAULT NULL,
  `feed_end_date` varchar(255) DEFAULT NULL,
  `feed_version` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Frequencies
-- ----------------------------
DROP TABLE IF EXISTS `frequencies`;

CREATE TABLE `frequencies` (
  `trip_id` varchar(255) NOT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `headway_secs` varchar(255) NOT NULL,
  `exact_times` enum('0','1') DEFAULT NULL,
  KEY `trip_id` (`trip_id`),
  CONSTRAINT `trip_id_trip_id` FOREIGN KEY (`trip_id`) REFERENCES `trips` (`trip_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Routes
-- ----------------------------
DROP TABLE IF EXISTS `routes`;

CREATE TABLE `routes` (
  `route_id` varchar(255) NOT NULL,
  `agency_id` varchar(255) DEFAULT NULL,
  `route_short_name` varchar(255) NOT NULL,
  `route_long_name` varchar(255) NOT NULL,
  `route_desc` varchar(255) DEFAULT NULL,
  `route_type` enum('0','1','2','3','4','5','6','7') DEFAULT NULL,
  `route_url` varchar(255) DEFAULT NULL,
  `route_color` varchar(255) DEFAULT NULL,
  `route_text_color` varchar(255) DEFAULT NULL,
  `route_sort_order` int(11) DEFAULT NULL,
  PRIMARY KEY (`route_id`),
  KEY `agency_id` (`agency_id`),
  KEY `route_type` (`route_type`),
  CONSTRAINT `routes_agency_id` FOREIGN KEY (`agency_id`) REFERENCES `agency` (`agency_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Shapes
-- ----------------------------
DROP TABLE IF EXISTS `shapes`;

CREATE TABLE `shapes` (
  `shape_id` varchar(255) NOT NULL,
  `shape_pt_lat` decimal(8,6) NOT NULL,
  `shape_pt_lon` decimal(8,6) NOT NULL,
  `shape_pt_sequence` varchar(255) NOT NULL,
  `shape_dist_traveled` varchar(255) DEFAULT NULL,
  KEY `shape_id` (`shape_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Stop Times
-- ----------------------------
DROP TABLE IF EXISTS `stop_times`;

CREATE TABLE `stop_times` (
  `trip_id` varchar(255) NOT NULL,
  `arrival_time` time DEFAULT NULL,
  `departure_time` time DEFAULT NULL,
  `stop_id` varchar(255) NOT NULL,
  `stop_sequence` varchar(100) NOT NULL,
  `stop_headsign` varchar(255) DEFAULT NULL,
  `pickup_type` enum('0','1','2','3') DEFAULT NULL,
  `drop_off_type` enum('0','1','2','3') DEFAULT NULL,
  `shape_dist_traveled` varchar(50) DEFAULT NULL,
  `timepoint` enum('','0','1') DEFAULT NULL,
  KEY `trip_id` (`trip_id`),
  KEY `stop_id` (`stop_id`),
  KEY `stop_sequence` (`stop_sequence`),
  KEY `pickup_type` (`pickup_type`),
  KEY `drop_off_type` (`drop_off_type`),
  CONSTRAINT `stop_times_stop_id` FOREIGN KEY (`stop_id`) REFERENCES `stops` (`stop_id`),
  CONSTRAINT `stop_times_trip_id` FOREIGN KEY (`trip_id`) REFERENCES `trips` (`trip_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Stops
-- ----------------------------
DROP TABLE IF EXISTS `stops`;

CREATE TABLE `stops` (
  `stop_id` varchar(255) DEFAULT NULL,
  `stop_code` varchar(50) DEFAULT NULL,
  `stop_name` varchar(255) NOT NULL,
  `stop_desc` varchar(255) DEFAULT NULL,
  `stop_lat` decimal(10,6) NOT NULL,
  `stop_lon` decimal(10,6) NOT NULL,
  `zone_id` varchar(255) DEFAULT NULL,
  `stop_url` varchar(255) DEFAULT NULL,
  `location_type` enum('0','1','2') DEFAULT NULL,
  `parent_station` varchar(100) DEFAULT NULL,
  `stop_timezone` varchar(50) DEFAULT NULL,
  `wheelchair_boarding` enum('','0','1','2') DEFAULT NULL,
  `platform_code` varchar(100) DEFAULT NULL,
  KEY `zone_id` (`zone_id`),
  KEY `stop_lat` (`stop_lat`),
  KEY `stop_lon` (`stop_lon`),
  KEY `location_type` (`location_type`),
  KEY `parent_station` (`parent_station`),
  KEY `stop_id` (`stop_id`),
  KEY `stop_id_2` (`stop_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Transfers
-- ----------------------------
DROP TABLE IF EXISTS `transfers`;

CREATE TABLE `transfers` (
  `from_stop_id` varchar(255) NOT NULL,
  `to_stop_id` varchar(255) NOT NULL,
  `transfer_type` enum('0','1','2','3') DEFAULT NULL,
  `min_transfer_time` varchar(100) DEFAULT NULL,
  `from_route_id` varchar(255) NOT NULL,
  `to_route_id` varchar(255) NOT NULL,
  `from_trip_id` varchar(255) NOT NULL,
  `to_trip_id` varchar(255) NOT NULL,
  KEY `transfers_from_stop_id` (`from_stop_id`),
  KEY `transfers_to_stop_id` (`to_stop_id`),
  KEY `transfers_from_route_id` (`from_route_id`),
  KEY `transfers_to_route_id` (`to_route_id`),
  CONSTRAINT `transfers_from_route_id` FOREIGN KEY (`from_route_id`) REFERENCES `routes` (`route_id`),
  CONSTRAINT `transfers_from_stop_id` FOREIGN KEY (`from_stop_id`) REFERENCES `stops` (`stop_id`),
  CONSTRAINT `transfers_to_route_id` FOREIGN KEY (`to_route_id`) REFERENCES `routes` (`route_id`),
  CONSTRAINT `transfers_to_stop_id` FOREIGN KEY (`to_stop_id`) REFERENCES `stops` (`stop_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Translations
-- ----------------------------
DROP TABLE IF EXISTS `translations`;

CREATE TABLE `translations` (
  `trans_id` varchar(8) NOT NULL,
  `lang` varchar(8) NOT NULL,
  `translation` varchar(8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Trips
-- ----------------------------
DROP TABLE IF EXISTS `trips`;

CREATE TABLE `trips` (
  `route_id` varchar(255) NOT NULL,
  `service_id` varchar(255) NOT NULL,
  `trip_id` varchar(255) DEFAULT NULL,
  `trip_headsign` varchar(255) DEFAULT NULL,
  `trip_short_name` varchar(255) DEFAULT NULL,
  `direction_id` enum('0','1') DEFAULT NULL,
  `block_id` varchar(255) DEFAULT NULL,
  `shape_id` varchar(255) DEFAULT NULL,
  `wheelchair_accessible` enum('','0','1','2') DEFAULT NULL,
  `bikes_allowed` enum('','0','1','2') DEFAULT NULL,
  KEY `route_id` (`route_id`),
  KEY `service_id` (`service_id`),
  KEY `direction_id` (`direction_id`),
  KEY `block_id` (`block_id`),
  KEY `shape_id` (`shape_id`),
  KEY `trip_id` (`trip_id`),
  KEY `trip_id_2` (`trip_id`),
  CONSTRAINT `trips_route_id` FOREIGN KEY (`route_id`) REFERENCES `routes` (`route_id`),
  CONSTRAINT `trips_shape_id` FOREIGN KEY (`shape_id`) REFERENCES `shapes` (`shape_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

SET FOREIGN_KEY_CHECKS=1;
