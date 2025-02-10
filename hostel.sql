-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 04, 2025 at 03:02 PM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.0.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `hostel`
--

-- --------------------------------------------------------

--
-- Table structure for table `booking`
--

CREATE TABLE `booking` (
  `booking_id` int(11) NOT NULL,
  `booking_date` date NOT NULL,
  `checkin_date` date NOT NULL,
  `checkout_date` date NOT NULL,
  `pax` int(11) NOT NULL,
  `price` double NOT NULL,
  `status` varchar(255) NOT NULL,
  `user_id` int(11) NOT NULL,
  `hostel_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `booking`
--

INSERT INTO `booking` (`booking_id`, `booking_date`, `checkin_date`, `checkout_date`, `pax`, `price`, `status`, `user_id`, `hostel_id`) VALUES
(10, '2024-12-31', '2025-01-03', '2025-01-05', 3, 300, 'Confirmed', 9, 21),
(13, '2025-01-03', '2025-01-06', '2025-01-07', 1, 29, 'Confirmed', 10, 18),
(14, '2025-01-31', '2025-02-07', '2025-02-09', 3, 174, 'Pending', 9, 18),
(16, '2025-02-03', '2025-02-05', '2025-02-06', 5, 145, 'Confirmed', 11, 18),
(17, '2025-02-03', '2025-02-07', '2025-02-08', 3, 150, 'Confirmed', 11, 21),
(20, '2025-02-03', '2025-02-15', '2025-02-16', 1, 29, 'Cancel', 8, 18),
(21, '2025-02-04', '2025-02-21', '2025-02-22', 3, 87, 'Pending', 11, 18);

-- --------------------------------------------------------

--
-- Table structure for table `hostel`
--

CREATE TABLE `hostel` (
  `hostel_id` int(11) NOT NULL,
  `hostel_name` varchar(255) NOT NULL,
  `hostel_address` varchar(255) NOT NULL,
  `hostel_price` double NOT NULL,
  `pax` int(11) NOT NULL,
  `description` varchar(255) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hostel`
--

INSERT INTO `hostel` (`hostel_id`, `hostel_name`, `hostel_address`, `hostel_price`, `pax`, `description`, `user_id`) VALUES
(18, 'Khai Hostel Melaka', '52 Jalan Parameswara, Bandar Hilir, Melaka, Malaysia', 29, 5, 'Basic 5 Bed Mixed Dorm', 1),
(19, 'Khai Hostel Melaka', '52 Jalan Parameswara, Bandar Hilir, Melaka, Malaysia', 29, 5, 'Basic 5 Bed Female Dorm', 1),
(21, 'Poolside By Hazim', '31 Jalan Pudu Lama, Kuala Lumpur, Malaysia', 50, 12, 'Standard 12 Bed Mixed Dorm', 8);

-- --------------------------------------------------------

--
-- Table structure for table `review`
--

CREATE TABLE `review` (
  `review_id` int(11) NOT NULL,
  `rating` int(11) NOT NULL,
  `comment` varchar(255) NOT NULL,
  `booking_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `review`
--

INSERT INTO `review` (`review_id`, `rating`, `comment`, `booking_id`) VALUES
(6, 2, 'OK', 17),
(7, 5, 'Amazing Hostel', 16);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `user_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`user_id`, `name`, `email`, `password`, `role`) VALUES
(1, 'Khairil', 'khai@gmail.com', 'abc123', 2),
(8, 'Hazim', 'haz@gmail.com', 'haz123', 2),
(9, 'Nazmi', 'naz@gmail.com', 'naz123', 1),
(10, 'Dahari', 'ari@gmail.com', 'qwe123', 1),
(11, 'Nazmi', 'nazmi@gmail.com', 'nazmi1234', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `booking`
--
ALTER TABLE `booking`
  ADD PRIMARY KEY (`booking_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `hostel_id` (`hostel_id`);

--
-- Indexes for table `hostel`
--
ALTER TABLE `hostel`
  ADD PRIMARY KEY (`hostel_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `review`
--
ALTER TABLE `review`
  ADD PRIMARY KEY (`review_id`),
  ADD KEY `booking_id` (`booking_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `booking`
--
ALTER TABLE `booking`
  MODIFY `booking_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `hostel`
--
ALTER TABLE `hostel`
  MODIFY `hostel_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `review`
--
ALTER TABLE `review`
  MODIFY `review_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `booking`
--
ALTER TABLE `booking`
  ADD CONSTRAINT `booking_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `booking_ibfk_2` FOREIGN KEY (`hostel_id`) REFERENCES `hostel` (`hostel_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `hostel`
--
ALTER TABLE `hostel`
  ADD CONSTRAINT `hostel_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `review`
--
ALTER TABLE `review`
  ADD CONSTRAINT `review_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `booking` (`booking_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
