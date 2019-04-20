CREATE DATABASE  IF NOT EXISTS `banking` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `banking`;
-- MySQL dump 10.13  Distrib 8.0.12, for Win64 (x86_64)
--
-- Host: localhost    Database: banking
-- ------------------------------------------------------
-- Server version	8.0.12

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
-- Table structure for table `acc_transaction`
--

DROP TABLE IF EXISTS `acc_transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `acc_transaction` (
  `TXN_ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `AMOUNT` float NOT NULL,
  `FUNDS_AVAIL_DATE` datetime NOT NULL,
  `TXN_DATE` datetime NOT NULL,
  `TXN_TYPE_CD` varchar(10) DEFAULT NULL,
  `ACCOUNT_ID` int(11) DEFAULT NULL,
  `EXECUTION_BRANCH_ID` int(11) DEFAULT NULL,
  `TELLER_EMP_ID` int(11) DEFAULT NULL,
  PRIMARY KEY (`TXN_ID`),
  KEY `ACC_TRANSACTION_ACCOUNT_FK` (`ACCOUNT_ID`),
  KEY `ACC_TRANSACTION_BRANCH_FK` (`EXECUTION_BRANCH_ID`),
  KEY `ACC_TRANSACTION_EMPLOYEE_FK` (`TELLER_EMP_ID`),
  CONSTRAINT `ACC_TRANSACTION_ACCOUNT_FK` FOREIGN KEY (`ACCOUNT_ID`) REFERENCES `account` (`account_id`),
  CONSTRAINT `ACC_TRANSACTION_BRANCH_FK` FOREIGN KEY (`EXECUTION_BRANCH_ID`) REFERENCES `branch` (`branch_id`),
  CONSTRAINT `ACC_TRANSACTION_EMPLOYEE_FK` FOREIGN KEY (`TELLER_EMP_ID`) REFERENCES `employee` (`emp_id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `acc_transaction`
--

LOCK TABLES `acc_transaction` WRITE;
/*!40000 ALTER TABLE `acc_transaction` DISABLE KEYS */;
INSERT INTO `acc_transaction` VALUES (1,100,'2000-01-15 00:00:00','2000-01-15 00:00:00','CDT',1,2,11),(2,100,'2000-01-15 00:00:00','2000-01-15 00:00:00','CDT',2,3,14),(3,100,'2004-06-30 00:00:00','2004-06-30 00:00:00','CDT',3,4,17),(4,100,'2001-03-12 00:00:00','2001-03-12 00:00:00','CDT',4,2,12),(5,100,'2001-03-12 00:00:00','2001-03-12 00:00:00','CDT',5,3,15),(6,100,'2002-11-23 00:00:00','2002-11-23 00:00:00','CDT',7,4,18),(7,100,'2002-12-15 00:00:00','2002-12-15 00:00:00','CDT',8,2,13),(8,100,'2003-09-12 00:00:00','2003-09-12 00:00:00','CDT',10,3,15),(9,100,'2000-01-15 00:00:00','2000-01-15 00:00:00','CDT',11,4,18),(10,100,'2004-09-30 00:00:00','2004-09-30 00:00:00','CDT',12,2,12),(11,100,'2004-01-27 00:00:00','2004-01-27 00:00:00','CDT',13,3,14),(12,100,'2002-08-24 00:00:00','2002-08-24 00:00:00','CDT',14,4,17),(13,100,'2004-12-28 00:00:00','2004-12-28 00:00:00','CDT',15,2,11),(14,100,'2004-01-12 00:00:00','2004-01-12 00:00:00','CDT',17,3,14),(15,100,'2001-05-23 00:00:00','2001-05-23 00:00:00','CDT',18,4,18),(16,100,'2001-05-23 00:00:00','2001-05-23 00:00:00','CDT',19,1,7),(17,100,'2003-07-30 00:00:00','2003-07-30 00:00:00','CDT',21,1,8),(18,100,'2004-10-28 00:00:00','2004-10-28 00:00:00','CDT',22,1,9),(19,100,'2004-06-30 00:00:00','2004-06-30 00:00:00','CDT',23,1,7),(20,100,'2002-09-30 00:00:00','2002-09-30 00:00:00','CDT',24,1,8),(21,100,'2003-07-30 00:00:00','2003-07-30 00:00:00','CDT',28,1,NULL);
/*!40000 ALTER TABLE `acc_transaction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `account`
--

DROP TABLE IF EXISTS `account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `account` (
  `ACCOUNT_ID` int(11) NOT NULL AUTO_INCREMENT,
  `AVAIL_BALANCE` float DEFAULT NULL,
  `CLOSE_DATE` date DEFAULT NULL,
  `LAST_ACTIVITY_DATE` date DEFAULT NULL,
  `OPEN_DATE` date NOT NULL,
  `PENDING_BALANCE` float DEFAULT NULL,
  `STATUS` varchar(10) DEFAULT NULL,
  `CUST_ID` int(11) DEFAULT NULL,
  `OPEN_BRANCH_ID` int(11) NOT NULL,
  `OPEN_EMP_ID` int(11) NOT NULL,
  `PRODUCT_CD` varchar(10) NOT NULL,
  PRIMARY KEY (`ACCOUNT_ID`),
  KEY `ACCOUNT_CUSTOMER_FK` (`CUST_ID`),
  KEY `ACCOUNT_BRANCH_FK` (`OPEN_BRANCH_ID`),
  KEY `ACCOUNT_EMPLOYEE_FK` (`OPEN_EMP_ID`),
  KEY `ACCOUNT_PRODUCT_FK` (`PRODUCT_CD`),
  CONSTRAINT `ACCOUNT_BRANCH_FK` FOREIGN KEY (`OPEN_BRANCH_ID`) REFERENCES `branch` (`branch_id`),
  CONSTRAINT `ACCOUNT_CUSTOMER_FK` FOREIGN KEY (`CUST_ID`) REFERENCES `customer` (`cust_id`),
  CONSTRAINT `ACCOUNT_EMPLOYEE_FK` FOREIGN KEY (`OPEN_EMP_ID`) REFERENCES `employee` (`emp_id`),
  CONSTRAINT `ACCOUNT_PRODUCT_FK` FOREIGN KEY (`PRODUCT_CD`) REFERENCES `product` (`product_cd`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account`
--

LOCK TABLES `account` WRITE;
/*!40000 ALTER TABLE `account` DISABLE KEYS */;
INSERT INTO `account` VALUES (1,1057.75,'2007-01-06','2005-01-04','2000-01-15',1057.75,'INACTIVE',1,2,10,'CHK'),(2,500,NULL,'2004-12-19','2000-01-15',500,'ACTIVE',1,2,10,'SAV'),(3,3000,NULL,'2004-06-30','2004-06-30',3000,'ACTIVE',1,2,10,'CD'),(4,2258.02,NULL,'2004-12-27','2001-03-12',2258.02,'ACTIVE',2,2,10,'CHK'),(5,200,NULL,'2004-12-11','2001-03-12',200,'ACTIVE',2,2,10,'SAV'),(7,1057.75,NULL,'2004-11-30','2002-11-23',1057.75,'ACTIVE',3,3,13,'CHK'),(8,2212.5,NULL,'2004-12-05','2002-12-15',2212.5,'ACTIVE',3,3,13,'MM'),(10,534.12,NULL,'2005-01-03','2003-09-12',534.12,'ACTIVE',4,1,1,'CHK'),(11,767.77,NULL,'2004-10-24','2000-01-15',767.77,'ACTIVE',4,1,1,'SAV'),(12,5487.09,NULL,'2004-11-11','2004-09-30',5487.09,'ACTIVE',4,1,1,'MM'),(13,2237.97,NULL,'2005-01-05','2004-01-27',2897.97,'ACTIVE',5,4,16,'CHK'),(14,122.37,NULL,'2004-11-29','2002-08-24',122.37,'ACTIVE',6,1,1,'CHK'),(15,10000,'2008-02-08','2004-12-28','2004-12-28',10000,'INACTIVE',6,1,1,'CD'),(17,5000,NULL,'2004-01-12','2004-01-12',5000,'ACTIVE',7,2,10,'CD'),(18,3487.19,NULL,'2005-01-03','2001-05-23',3487.19,'ACTIVE',8,4,16,'CHK'),(19,387.99,NULL,'2004-10-12','2001-05-23',387.99,'ACTIVE',8,4,16,'SAV'),(21,125.67,NULL,'2004-12-15','2003-07-30',125.67,'ACTIVE',9,1,1,'CHK'),(22,9345.55,NULL,'2004-10-28','2004-10-28',9845.55,'ACTIVE',9,1,1,'MM'),(23,1500,NULL,'2004-06-30','2004-06-30',1500,'ACTIVE',9,1,1,'CD'),(24,23575.1,NULL,'2004-12-15','2002-09-30',23575.1,'ACTIVE',10,4,16,'CHK'),(25,0,'2007-02-05','2004-08-28','2002-10-01',0,'ACTIVE',10,4,16,'BUS'),(27,9345.55,NULL,'2004-11-14','2004-03-22',9345.55,'ACTIVE',11,2,10,'BUS'),(28,38552.1,NULL,'2004-12-15','2003-07-30',38552.1,'ACTIVE',12,4,16,'CHK'),(29,50000,NULL,'2004-12-17','2004-02-22',50000,'ACTIVE',13,3,13,'SBL');
/*!40000 ALTER TABLE `account` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `branch`
--

DROP TABLE IF EXISTS `branch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `branch` (
  `BRANCH_ID` int(11) NOT NULL AUTO_INCREMENT,
  `ADDRESS` varchar(30) DEFAULT NULL,
  `CITY` varchar(20) DEFAULT NULL,
  `NAME` varchar(20) NOT NULL,
  `STATE` varchar(10) DEFAULT NULL,
  `ZIP_CODE` varchar(12) DEFAULT NULL,
  PRIMARY KEY (`BRANCH_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `branch`
--

LOCK TABLES `branch` WRITE;
/*!40000 ALTER TABLE `branch` DISABLE KEYS */;
INSERT INTO `branch` VALUES (1,'3882 Main St.','Waltham','Headquarters','MA','02451'),(2,'422 Maple St.','Woburn','Woburn Branch','MA','01801'),(3,'125 Presidential Way','Quincy','Quincy Branch','MA','02169'),(4,'378 Maynard Ln.','Salem','So. NH Branch','NH','03079');
/*!40000 ALTER TABLE `branch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `business`
--

DROP TABLE IF EXISTS `business`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `business` (
  `INCORP_DATE` date DEFAULT NULL,
  `NAME` varchar(255) NOT NULL,
  `STATE_ID` varchar(10) NOT NULL,
  `CUST_ID` int(11) NOT NULL,
  PRIMARY KEY (`CUST_ID`),
  CONSTRAINT `BUSINESS_EMPLOYEE_FK` FOREIGN KEY (`CUST_ID`) REFERENCES `customer` (`cust_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `business`
--

LOCK TABLES `business` WRITE;
/*!40000 ALTER TABLE `business` DISABLE KEYS */;
INSERT INTO `business` VALUES ('1995-05-01','Chilton Engineering','12-345-678',10),('2001-01-01','Northeast Cooling Inc.','23-456-789',11),('2002-06-30','Superior Auto Body','34-567-890',12),('1999-05-01','AAA Insurance Inc.','45-678-901',13);
/*!40000 ALTER TABLE `business` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `customer` (
  `CUST_ID` int(11) NOT NULL AUTO_INCREMENT,
  `ADDRESS` varchar(30) DEFAULT NULL,
  `CITY` varchar(20) DEFAULT NULL,
  `CUST_TYPE_CD` varchar(1) NOT NULL,
  `FED_ID` varchar(12) NOT NULL,
  `POSTAL_CODE` varchar(10) DEFAULT NULL,
  `STATE` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`CUST_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (1,'47 Mockingbird Ln','Lynnfield','I','111-11-1111','01940','MA'),(2,'372 Clearwater Blvd','Woburn','I','222-22-2222','01801','MA'),(3,'18 Jessup Rd','Quincy','I','333-33-3333','02169','MA'),(4,'12 Buchanan Ln','Waltham','I','444-44-4444','02451','MA'),(5,'2341 Main St','Salem','I','555-55-5555','03079','NH'),(6,'12 Blaylock Ln','Waltham','I','666-66-6666','02451','MA'),(7,'29 Admiral Ln','Wilmington','I','777-77-7777','01887','MA'),(8,'472 Freedom Rd','Salem','I','888-88-8888','03079','NH'),(9,'29 Maple St','Newton','I','999-99-9999','02458','MA'),(10,'7 Industrial Way','Salem','B','04-1111111','03079','NH'),(11,'287A Corporate Ave','Wilmington','B','04-2222222','01887','MA'),(12,'789 Main St','Salem','B','04-3333333','03079','NH'),(13,'4772 Presidential Way','Quincy','B','04-4444444','02169','MA');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department`
--

DROP TABLE IF EXISTS `department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `department` (
  `DEPT_ID` int(11) NOT NULL AUTO_INCREMENT,
  `NAME` varchar(20) NOT NULL,
  PRIMARY KEY (`DEPT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department`
--

LOCK TABLES `department` WRITE;
/*!40000 ALTER TABLE `department` DISABLE KEYS */;
INSERT INTO `department` VALUES (1,'Operations'),(2,'Loans'),(3,'Administration'),(4,'IT');
/*!40000 ALTER TABLE `department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `employee` (
  `EMP_ID` int(11) NOT NULL AUTO_INCREMENT,
  `END_DATE` date DEFAULT NULL,
  `FIRST_NAME` varchar(20) NOT NULL,
  `LAST_NAME` varchar(20) NOT NULL,
  `START_DATE` date NOT NULL,
  `TITLE` varchar(20) DEFAULT NULL,
  `ASSIGNED_BRANCH_ID` int(11) DEFAULT NULL,
  `DEPT_ID` int(11) DEFAULT NULL,
  `SUPERIOR_EMP_ID` int(11) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`),
  KEY `EMPLOYEE_BRANCH_FK` (`ASSIGNED_BRANCH_ID`),
  KEY `EMPLOYEE_DEPARTMENT_FK` (`DEPT_ID`),
  KEY `EMPLOYEE_EMPLOYEE_FK` (`SUPERIOR_EMP_ID`),
  CONSTRAINT `EMPLOYEE_BRANCH_FK` FOREIGN KEY (`ASSIGNED_BRANCH_ID`) REFERENCES `branch` (`branch_id`),
  CONSTRAINT `EMPLOYEE_DEPARTMENT_FK` FOREIGN KEY (`DEPT_ID`) REFERENCES `department` (`dept_id`),
  CONSTRAINT `EMPLOYEE_EMPLOYEE_FK` FOREIGN KEY (`SUPERIOR_EMP_ID`) REFERENCES `employee` (`emp_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee`
--

LOCK TABLES `employee` WRITE;
/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
INSERT INTO `employee` VALUES (1,NULL,'Michael','Smith','2001-06-22','President',1,3,NULL),(2,NULL,'Susan','Barker','2002-09-12','Vice President',1,3,1),(3,NULL,'Robert','Tyler','2000-02-09','Treasurer',1,3,1),(4,NULL,'Susan','Hawthorne','2002-04-24','Operations Manager',1,1,3),(5,NULL,'John','Gooding','2003-11-14','Loan Manager',1,2,4),(6,NULL,'Helen','Fleming','2004-03-17','Head Teller',1,1,4),(7,NULL,'Chris','Tucker','2004-09-15','Teller',1,1,6),(8,NULL,'Sarah','Parker','2002-12-02','Teller',1,1,6),(9,NULL,'Jane','Grossman','2002-05-03','Teller',1,1,6),(10,NULL,'Paula','Roberts','2002-07-27','Head Teller',2,1,4),(11,NULL,'Thomas','Ziegler','2000-10-23','Teller',2,1,10),(12,NULL,'Samantha','Jameson','2003-01-08','Teller',2,1,10),(13,NULL,'John','Blake','2000-05-11','Head Teller',3,1,4),(14,NULL,'Cindy','Mason','2002-08-09','Teller',3,1,13),(15,NULL,'Frank','Portman','2003-04-01','Teller',3,1,13),(16,NULL,'Theresa','Markham','2001-03-15','Head Teller',4,1,4),(17,NULL,'Beth','Fowler','2002-06-29','Teller',4,1,16),(18,NULL,'Rick','Tulman','2002-12-12','Teller',4,1,16);
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `individual`
--

DROP TABLE IF EXISTS `individual`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `individual` (
  `BIRTH_DATE` date DEFAULT NULL,
  `FIRST_NAME` varchar(30) NOT NULL,
  `LAST_NAME` varchar(30) NOT NULL,
  `CUST_ID` int(11) NOT NULL,
  PRIMARY KEY (`CUST_ID`),
  CONSTRAINT `INDIVIDUAL_CUSTOMER_FK` FOREIGN KEY (`CUST_ID`) REFERENCES `customer` (`cust_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `individual`
--

LOCK TABLES `individual` WRITE;
/*!40000 ALTER TABLE `individual` DISABLE KEYS */;
INSERT INTO `individual` VALUES ('1972-04-22','James','Hadley',1),('1968-08-15','Susan','Tingley',2),('1958-02-06','Frank','Tucker',3),('1966-12-22','John','Hayward',4),('1971-08-25','Charles','Frasier',5),('1962-09-14','John','Spencer',6),('1947-03-19','Margaret','Young',7),('1977-07-01','Louis','Blake',8),('1968-06-16','Richard','Farley',9);
/*!40000 ALTER TABLE `individual` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `officer`
--

DROP TABLE IF EXISTS `officer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `officer` (
  `OFFICER_ID` int(11) NOT NULL AUTO_INCREMENT,
  `END_DATE` date DEFAULT NULL,
  `FIRST_NAME` varchar(30) NOT NULL,
  `LAST_NAME` varchar(30) NOT NULL,
  `START_DATE` date NOT NULL,
  `TITLE` varchar(20) DEFAULT NULL,
  `CUST_ID` int(11) DEFAULT NULL,
  PRIMARY KEY (`OFFICER_ID`),
  KEY `OFFICER_CUSTOMER_FK` (`CUST_ID`),
  CONSTRAINT `OFFICER_CUSTOMER_FK` FOREIGN KEY (`CUST_ID`) REFERENCES `customer` (`cust_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `officer`
--

LOCK TABLES `officer` WRITE;
/*!40000 ALTER TABLE `officer` DISABLE KEYS */;
INSERT INTO `officer` VALUES (1,NULL,'John','Chilton','1995-05-01','President',10),(2,NULL,'Paul','Hardy','2001-01-01','President',11),(3,NULL,'Carl','Lutz','2002-06-30','President',12),(4,NULL,'Stanley','Cheswick','1999-05-01','President',13);
/*!40000 ALTER TABLE `officer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `product` (
  `PRODUCT_CD` varchar(10) NOT NULL,
  `DATE_OFFERED` date DEFAULT NULL,
  `DATE_RETIRED` date DEFAULT NULL,
  `NAME` varchar(50) NOT NULL,
  `PRODUCT_TYPE_CD` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_CD`),
  KEY `PRODUCT_PRODUCT_TYPE_FK` (`PRODUCT_TYPE_CD`),
  CONSTRAINT `PRODUCT_PRODUCT_TYPE_FK` FOREIGN KEY (`PRODUCT_TYPE_CD`) REFERENCES `product_type` (`product_type_cd`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES ('AUT','2000-01-01',NULL,'auto loan','LOAN'),('BUS','2000-01-01',NULL,'business line of credit','LOAN'),('CD','2000-01-01',NULL,'certificate of deposit','ACCOUNT'),('CHK','2000-01-01',NULL,'checking account','ACCOUNT'),('MM','2000-01-01',NULL,'money market account','ACCOUNT'),('MRT','2000-01-01',NULL,'home mortgage','LOAN'),('SAV','2000-01-01',NULL,'savings account','ACCOUNT'),('SBL','2000-01-01',NULL,'small business loan','LOAN');
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_type`
--

DROP TABLE IF EXISTS `product_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `product_type` (
  `PRODUCT_TYPE_CD` varchar(255) NOT NULL,
  `NAME` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_TYPE_CD`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_type`
--

LOCK TABLES `product_type` WRITE;
/*!40000 ALTER TABLE `product_type` DISABLE KEYS */;
INSERT INTO `product_type` VALUES ('ACCOUNT','Customer Accounts'),('INSURANCE','Insurance Offerings'),('LOAN','Individual and Business Loans');
/*!40000 ALTER TABLE `product_type` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-02-11 13:34:34
