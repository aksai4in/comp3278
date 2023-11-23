-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: localhost    Database: face
-- ------------------------------------------------------
-- Server version	8.0.34

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `class`
--

DROP TABLE IF EXISTS `class`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `class` (
  `class_id` int NOT NULL,
  `start_time` text NOT NULL,
  `end_time` text NOT NULL,
  `day_of_the_week` int NOT NULL,
  `address` text NOT NULL,
  `course_id` varchar(20) NOT NULL,
  PRIMARY KEY (`class_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `class`
--

LOCK TABLES `class` WRITE;
/*!40000 ALTER TABLE `class` DISABLE KEYS */;
INSERT INTO `class` VALUES (1,'09:30:00','11:20:00',1,'Meng Wah Complex MWT2','COMP3322'),(2,'14:30:00','15:20:00',1,'Meng Wah Complex MWT1','COMP3278'),(3,'10:30:00','12:20:00',2,'Chong Yuet Ming Chemistry CYCP1','COMP3230'),(4,'12:30:00','13:20:00',2,'Main Building MB167','COMP3314'),(5,'16:30:00','18:20:00',2,'Knowles Building KB223','COMP3297'),(6,'10:30:00','12:20:00',4,'Chong Yuet Ming Chemistry CYCP1','COMP3230'),(7,'13:30:00','15:20:00',4,'Meng Wah Complex MWT1','COMP3278'),(8,'09:30:00','11:20:00',5,'Meng Wah Complex MWT2','COMP3322'),(9,'12:30:00','14:20:00',5,'Main Building MB167','COMP3314'),(10,'17:30:00','18:20:00',5,'Knowles Building KB223','COMP3297');
/*!40000 ALTER TABLE `class` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course`
--

DROP TABLE IF EXISTS `course`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course` (
  `course_id` varchar(20) NOT NULL,
  `subclass` varchar(20) NOT NULL,
  `name` text NOT NULL,
  `description` text,
  `professor_message` text,
  `zoom_link` text,
  PRIMARY KEY (`course_id`,`subclass`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course`
--

LOCK TABLES `course` WRITE;
/*!40000 ALTER TABLE `course` DISABLE KEYS */;
INSERT INTO `course` VALUES ('COMP3230','1A','Principles of operating systems',NULL,NULL,NULL),('COMP3278','1A','Introduction to database Introduction to database management systems',NULL,NULL,'https://hku.zoom.us/j/98307568693?pwd=QmlqZERWeDdWRVZ3SGdqWG51YUtndz09'),('COMP3297','1A','Software engineering',NULL,NULL,NULL),('COMP3314','1A','Machine learning',NULL,NULL,NULL),('COMP3322','1A','Modern Technologies on World Wide Web','c',NULL,NULL);
/*!40000 ALTER TABLE `course` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `istaking`
--

DROP TABLE IF EXISTS `istaking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `istaking` (
  `student_id` int NOT NULL,
  `course_id` varchar(20) NOT NULL,
  PRIMARY KEY (`student_id`,`course_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `istaking`
--

LOCK TABLES `istaking` WRITE;
/*!40000 ALTER TABLE `istaking` DISABLE KEYS */;
INSERT INTO `istaking` VALUES (1,'COMP3230'),(1,'COMP3278'),(1,'COMP3297'),(1,'COMP3314'),(1,'COMP3322');
/*!40000 ALTER TABLE `istaking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login`
--

DROP TABLE IF EXISTS `login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `login` (
  `login_id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `login_date` date NOT NULL,
  `login_time` text NOT NULL,
  PRIMARY KEY (`login_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login`
--

LOCK TABLES `login` WRITE;
/*!40000 ALTER TABLE `login` DISABLE KEYS */;
INSERT INTO `login` VALUES (1,1,'2023-11-22','20:16:00'),(2,1,'2023-11-22','20:17:01'),(3,1,'2023-11-23','12:13:58'),(4,1,'2023-11-23','17:24:31'),(5,1,'2023-11-23','17:26:48'),(6,1,'2023-11-23','17:32:48'),(7,1,'2023-11-23','17:38:24'),(8,1,'2023-11-23','20:12:49'),(9,1,'2023-11-23','20:14:03'),(10,1,'2023-11-23','20:15:39'),(11,1,'2023-11-23','20:16:47'),(12,1,'2023-11-23','20:20:56');
/*!40000 ALTER TABLE `login` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `note`
--

DROP TABLE IF EXISTS `note`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `note` (
  `note_id` int NOT NULL AUTO_INCREMENT,
  `note_type` enum('lecture','tutorial') NOT NULL,
  `link` text NOT NULL,
  `course_id` varchar(20) NOT NULL,
  `note_number` int NOT NULL,
  `name` text NOT NULL,
  PRIMARY KEY (`note_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `note`
--

LOCK TABLES `note` WRITE;
/*!40000 ALTER TABLE `note` DISABLE KEYS */;
INSERT INTO `note` VALUES (1,'lecture','https://moodle.hku.hk/mod/resource/view.php?id=3081895','COMP3278',1,'Lecture_1_Introduction'),(2,'lecture','https://moodle.hku.hk/mod/resource/view.php?id=3081960','COMP3278',2,'Lecture 2 ER model'),(3,'tutorial','https://moodle.hku.hk/mod/resource/view.php?id=3089691','COMP3278',1,'tutorial1_MySQL_2023');
/*!40000 ALTER TABLE `note` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student`
--

DROP TABLE IF EXISTS `student`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student` (
  `student_id` int NOT NULL,
  `name` varchar(50) CHARACTER SET latin1 NOT NULL,
  `login_time` text NOT NULL,
  `login_date` date NOT NULL,
  `username` varchar(50) CHARACTER SET latin1 NOT NULL,
  `password` varchar(50) CHARACTER SET latin1 NOT NULL,
  `email` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student`
--

LOCK TABLES `student` WRITE;
/*!40000 ALTER TABLE `student` DISABLE KEYS */;
INSERT INTO `student` VALUES (1,'Aidar','20:12:12','2023-11-23','aksai4in','123456789','ak290802@connect.hku.hk');
/*!40000 ALTER TABLE `student` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teacher`
--

DROP TABLE IF EXISTS `teacher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `teacher` (
  `teacher_id` int NOT NULL AUTO_INCREMENT,
  `role` enum('instructor','ta') NOT NULL,
  `name` varchar(45) NOT NULL,
  `email` varchar(45) NOT NULL,
  `office` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`teacher_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teacher`
--

LOCK TABLES `teacher` WRITE;
/*!40000 ALTER TABLE `teacher` DISABLE KEYS */;
INSERT INTO `teacher` VALUES (2,'instructor','Dr. Ping Luo','pluo@cs.hku.hk','CB326'),(3,'ta','Zhixuan Liang ','liangzx@connect.hku.hk',NULL);
/*!40000 ALTER TABLE `teacher` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teaching`
--

DROP TABLE IF EXISTS `teaching`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `teaching` (
  `course_id` varchar(20) NOT NULL,
  `teacher_id` int NOT NULL,
  PRIMARY KEY (`course_id`,`teacher_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teaching`
--

LOCK TABLES `teaching` WRITE;
/*!40000 ALTER TABLE `teaching` DISABLE KEYS */;
INSERT INTO `teaching` VALUES ('COMP3278',2),('COMP3278',3);
/*!40000 ALTER TABLE `teaching` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-11-23 21:41:02
