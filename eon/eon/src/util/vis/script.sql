
USE snapper_turtles;

--
-- Table structure for table `GPS`
--

DROP TABLE IF EXISTS `GPS`;
CREATE TABLE `GPS` (
  `baseID` int,
  `datasrc` int,
  `sequence` int,
  `timeinvalid` int,
  `timest` bigint,
  `local_stamp` DATETIME,
  `email_time` DATETIME,
  `gpsvalid` int,
  `ns` int,
  `ew` int,
  `alt` int,
  `toofewsats` int, 
  `sats` int,
  `hdil` int,
  `lat_d` double(12,9),
  `lat_m` double(12,9),
  `lat_dec` double(12,9),
  `lon_d` double(12,9),
  `lon_m` double(12,9),
  `lon_dec` double(12,9)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `RT_PATH`
-- 

DROP TABLE IF EXISTS `RT_PATH`;
CREATE TABLE `RT_PATH` (
  `baseID` int,
  `datasrc` int NOT NULL default '0',
  `sequence` int NOT NULL default '0',
  `timeinvalid` int,
  `timest` bigint,
  `local_stamp` DATETIME,
  `email_time` DATETIME,
  `path_id` int default NULL,
  `count` int default NULL,
  `energy` bigint default NULL,
  `probability` double(12,9) default NULL,
  `source_probability` double(12,9) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `RT_STATE`
-- 

DROP TABLE IF EXISTS `RT_STATE`;
CREATE TABLE `RT_STATE` (
  `baseID` int,
  `datasrc` smallint(5) NOT NULL default '0',
  `sequence` smallint(5) NOT NULL default '0',
  `timeinvalid` int,
  `timest` bigint,  
  `local_stamp` DATETIME,
  `email_time` DATETIME, 
  `energy_in` int(10) default NULL,
  `energy_out` int(10) default NULL,
  `batt_volts` double(12,9) default NULL,
  `batt_energy_est` int(10) default NULL,
  `temperature` int(5) default NULL,
  `current_state` int(2) default NULL,
  `current_grade` int(2) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `CONN`
-- 

DROP TABLE IF EXISTS `CONN`;
CREATE TABLE `CONN` (
  `baseID` int,
  `datasrc` int(5) NOT NULL default '0',
  `sequence` int(5) NOT NULL default '0',
  `timeinvalid` int, 
  `timest` bigint,
  `local_stamp` DATETIME,
  `email_time` DATETIME,
  `address` int(5) default NULL,
  `duration` int(5) default NULL,
  `quality` int(3) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

---
--- Table structure for table `DEPLOYMENT`
---

DROP TABLE IF EXISTS `DEPLOYMENT` ;
CREATE TABLE `DEPLOYMENT` (
  `depID` varchar(75),
  `node` int DEFAULT NULL,
  `baseID` varchar(15) DEFAULT NULL,
  `NS` double(12,9) DEFAULT NULL,
  `EW` double(12,9) DEFAULT NULL,
  `progID` varchar(75),
  `start_date` DATE,
  `end_date` DATE 
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

---
---Table structure for table `BASESTATION`
---
DROP TABLE IF EXISTS `BASESTATION`;
CREATE TABLE `BASESTATION` (
  `baseID` varchar(75),
  `batt_voltage` double(12,9),
  `enrg_harvest` bigint,
  `enrg_expend` bigint,
  `temp` double(12,9),
  `email_time` DATETIME,
  `packets` int
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
