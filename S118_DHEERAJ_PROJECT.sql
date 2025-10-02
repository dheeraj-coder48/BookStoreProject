-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: S118_DheerajSingh_Project
-- ------------------------------------------------------
-- Server version	8.0.43

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `books`
--

DROP TABLE IF EXISTS `books`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `books` (
  `book_id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `author` varchar(255) NOT NULL,
  `category` varchar(100) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `stock_quantity` int NOT NULL,
  `description` text,
  `image_url` varchar(500) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`book_id`),
  KEY `idx_books_category` (`category`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books`
--

LOCK TABLES `books` WRITE;
/*!40000 ALTER TABLE `books` DISABLE KEYS */;
INSERT INTO `books` VALUES (1,'The God of Small Things','Arundhati Roy','Indian Fiction',499.00,25,'Booker Prize winning novel about fraternal twins in Kerala.','https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1318966691i/37819.jpg','2025-10-01 12:11:10'),(2,'A Suitable Boy','Vikram Seth','Indian Fiction',899.00,18,'Monumental novel about post-independence India.','https://m.media-amazon.com/images/I/71MQpt0wCkL._UF1000,1000_QL80_.jpg','2025-10-01 12:11:10'),(3,'The White Tiger','Aravind Adiga','Indian Fiction',399.00,30,'Man Booker Prize winner about class struggle in modern India.','https://img.perlego.com/book-covers/1209365/9781416562733_300_450.webp','2025-10-01 12:11:10'),(4,'The Palace of Illusions','Chitra Banerjee Divakaruni','Indian Mythology',449.00,22,'Mahabharata retold from Draupadi\'s perspective.','https://m.media-amazon.com/images/I/91v35eCW-mL._UF1000,1000_QL80_.jpg','2025-10-01 12:11:10'),(5,'The Immortals of Meluha','Amish Tripathi','Indian Mythology',349.00,35,'First book in Shiva Trilogy reimagining Lord Shiva.','https://m.media-amazon.com/images/I/818bGgNn0EL._UF1000,1000_QL80_.jpg','2025-10-01 12:11:10'),(6,'Train to Pakistan','Khushwant Singh','Indian History',299.00,20,'Classic novel about Partition of India.','https://m.media-amazon.com/images/I/915ojTuXD+L.jpg','2025-10-01 12:11:10'),(7,'India After Gandhi','Ramachandra Guha','Indian History',799.00,13,'Comprehensive history of modern India.','https://m.media-amazon.com/images/I/71cXEAsmnjL._UF1000,1000_QL80_.jpg','2025-10-01 12:11:10'),(8,'The Discovery of India','Jawaharlal Nehru','Indian History',599.00,12,'Classic work on Indian history and culture.','https://m.media-amazon.com/images/I/61UuEWBDlVL._UF1000,1000_QL80_.jpg','2025-10-01 12:11:10'),(9,'Malgudi Days','R.K. Narayan','Indian Fiction',249.00,40,'Classic collection of short stories set in fictional Malgudi.','https://m.media-amazon.com/images/I/81V009r2EkL.jpg','2025-10-01 12:11:10'),(10,'The Guide','R.K. Narayan','Indian Fiction',329.00,28,'Novel about a tour guide who becomes a spiritual guide.','https://upload.wikimedia.org/wikipedia/en/a/a4/TheGuide.jpg','2025-10-01 12:11:10'),(11,'Midnight\'s Children','Salman Rushdie','Indian Fiction',549.00,16,'Booker Prize winner about children born at midnight of India\'s independence.','https://m.media-amazon.com/images/I/91guqbWJEQL._UF1000,1000_QL80_.jpg','2025-10-01 12:11:10'),(12,'The Namesake','Jhumpa Lahiri','Indian Fiction',399.00,24,'Story of Indian immigrants and their American-born children.','https://m.media-amazon.com/images/I/81GnIQ0xFlL.jpg','2025-10-01 12:11:10'),(13,'Interpreter of Maladies','Jhumpa Lahiri','Indian Fiction',379.00,32,'Pulitzer Prize winning collection of short stories.','https://m.media-amazon.com/images/I/81fJiVNmx6L._UF1000,1000_QL80_.jpg','2025-10-01 12:11:10'),(14,'The Inheritance of Loss','Kiran Desai','Indian Fiction',429.00,19,'Man Booker Prize winner exploring globalization and migration.','https://m.media-amazon.com/images/I/81gLGsizwxL._UF1000,1000_QL80_.jpg','2025-10-01 12:11:10'),(15,'The Shadow Lines','Amitav Ghosh','Indian Fiction',449.00,21,'Novel exploring national and personal boundaries.','https://images-na.ssl-images-amazon.com/images/P/0143066560.01.LZZZZZZZ.jpg','2025-10-01 12:11:10'),(16,'The Glass Palace','Amitav Ghosh','Indian Fiction',599.00,13,'Sweeping historical novel spanning India and Burma.','https://m.media-amazon.com/images/I/71ZFrpShpCL.jpg','2025-10-01 12:11:10'),(17,'Sacred Games','Vikram Chandra','Indian Fiction',799.00,11,'Epic crime novel set in Mumbai.','https://m.media-amazon.com/images/I/91MCWisDhQL._UF1000,1000_QL80_.jpg','2025-10-01 12:11:10'),(18,'The Great Indian Novel','Shashi Tharoor','Indian Politics',499.00,17,'Mahabharata retold as satirical political novel.','https://m.media-amazon.com/images/I/81Lfw-skUsL.jpg','2025-10-01 12:11:10'),(19,'Why I Am a Hindu','Shashi Tharoor','Indian Politics',449.00,23,'Exploration of Hinduism and its place in modern India.','https://www.hurstpublishers.com/wp-content/uploads/2018/03/Tharoor-%E2%80%93-Why-I-Am-A-Hindu-RGB-WEB.jpg','2025-10-01 12:11:10'),(20,'The Difficulty of Being Good','Gurcharan Das','Indian Politics',529.00,13,'On the subtle art of dharma using Mahabharata.','https://archive.org/services/img/isbn_9780143418979/full/pct:200/0/default.jpg','2025-10-01 12:11:10'),(21,'Mahanayaka','S.L. Bhyrappa','Hindi Literature',399.00,26,'Classic Hindi novel exploring human relationships.','https://upload.wikimedia.org/wikipedia/en/9/92/Mahanayak_%28novel%29.jpg','2025-10-01 12:11:10'),(22,'Raag Darbari','Shrilal Shukla','Hindi Literature',349.00,29,'Satirical novel about Indian village politics.','https://m.media-amazon.com/images/I/91lTTaDHHAS.jpg','2025-10-01 12:11:10'),(23,'Gunahon Ka Devta','Dharamvir Bharati','Hindi Literature',279.00,33,'Classic Hindi romance novel.','https://m.media-amazon.com/images/I/71hemS2gvNL.jpg','2025-10-01 12:11:10'),(24,'Madhushala','Harivansh Rai Bachchan','Indian Poetry',199.00,43,'Classic Hindi poetry collection.','https://m.media-amazon.com/images/I/71VVm4pMYvL._UF1000,1000_QL80_.jpg','2025-10-01 12:11:10'),(25,'The Room on the Roof','Ruskin Bond','Indian Fiction',229.00,38,'Classic coming-of-age story set in Dehradun.','https://m.media-amazon.com/images/I/81kvQ92hrcL.jpg','2025-10-01 12:11:10'),(26,'Wings of Fire','A.P.J. Abdul Kalam','Indian Biographies',299.00,27,'Autobiography of India\'s Missile Man.','https://www.hindueshop.com/wp-content/uploads/2019/05/Wings-of-Fire.jpeg','2025-10-01 12:11:10'),(27,'My Experiments with Truth','Mahatma Gandhi','Indian Biographies',249.00,31,'Autobiography of Mahatma Gandhi.','https://m.media-amazon.com/images/I/61Q3PvMKEkL.jpg','2025-10-01 12:11:10'),(28,'The Art of Indian Vegetarian Cooking','Yamuna Devi','Indian Cookbooks',699.00,8,'Classic Indian vegetarian cookbook.','https://m.media-amazon.com/images/I/71GKVcrI3yL._UF1000,1000_QL80_.jpg','2025-10-01 12:11:10');
/*!40000 ALTER TABLE `books` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `category_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `image_url` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Hindi Literature','https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400'),(2,'Indian Fiction','https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400'),(3,'Indian History','https://images.unsplash.com/photo-1553729459-efe14ef6055d?w=400'),(4,'Indian Mythology','https://images.unsplash.com/photo-1604594849809-dfedbc827105?w=400'),(5,'Indian Politics','https://images.unsplash.com/photo-1581833971358-2c8b550f87b3?w=400'),(6,'Indian Cookbooks','https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400'),(7,'Indian Biographies','https://images.unsplash.com/photo-1512820790803-83ca734da794?w=400'),(8,'Indian Poetry','https://images.unsplash.com/photo-1516979187457-637abb4f9353?w=400');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `order_item_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `book_id` int NOT NULL,
  `quantity` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  PRIMARY KEY (`order_item_id`),
  KEY `idx_order_items_order_id` (`order_id`),
  KEY `idx_order_items_book_id` (`book_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `books` (`book_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (1,1,7,2,799.00),(2,1,16,1,599.00),(3,2,24,2,199.00);
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `order_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `total_amount` decimal(10,2) NOT NULL,
  `status` enum('pending','confirmed','shipped','delivered','cancelled') DEFAULT 'pending',
  `shipping_address` text,
  `payment_method` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  KEY `idx_orders_user_id` (`user_id`),
  KEY `idx_orders_status` (`status`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,1,'2025-10-01 15:32:23',2197.00,'delivered','f','Cash on Delivery'),(2,1,'2025-10-02 07:24:03',398.00,'delivered','MVLU COLLEGE , Dr. S. Radhakrisnan, A S Marg, Andheri East, Mumbai, Maharashtra 400069','Cash on Delivery');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','user') DEFAULT 'user',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'dheeraj_admin','dheeraj_admin@gmail.com','password123','admin','2025-09-25 04:00:02'),(2,'Manya','manya@gmail.com','password123','user','2025-09-25 04:00:02'),(3,'jerry','jerry@gmail.com','password123','user','2025-09-25 04:00:02'),(4,'dheeraj','dheeraj@gmail.com','password123','user','2025-09-25 04:02:18'),(5,'admin','admin@bookhaven.com','password123','admin','2025-10-01 12:00:53'),(6,'john_doe','john@example.com','password123','user','2025-10-01 12:00:53'),(7,'priya_sharma','priya@example.com','password123','user','2025-10-01 12:00:53'),(8,'rahul_kumar','rahul@example.com','password123','user','2025-10-01 12:00:53'),(9,'neha_gupta','neha@example.com','password123','user','2025-10-01 12:00:53'),(11,'Mvlu_college','mvlu@gmail.com','password','user','2025-10-02 07:28:31');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-10-02 15:47:45
