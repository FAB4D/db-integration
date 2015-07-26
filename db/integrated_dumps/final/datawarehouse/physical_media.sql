-- phpMyAdmin SQL Dump
-- version 3.5.8.1deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Erstellungszeit: 07. Mai 2013 um 20:47
-- Server Version: 5.5.31-0ubuntu0.13.04.1
-- PHP-Version: 5.4.9-4ubuntu2

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Datenbank: `datawarehouse`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `physical_media`
--

CREATE TABLE IF NOT EXISTS `physical_media` (
  `id` int(11) NOT NULL,
  `price` double NOT NULL,
  `type` varchar(50) NOT NULL,
  `bought_date` date NOT NULL,
  `bought_price` double NOT NULL,
  `mid` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `mid` (`mid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Constraints der exportierten Tabellen
--

--
-- Constraints der Tabelle `physical_media`
--
ALTER TABLE `physical_media`
  ADD CONSTRAINT `physical_media_ibfk_1` FOREIGN KEY (`mid`) REFERENCES `movie` (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
