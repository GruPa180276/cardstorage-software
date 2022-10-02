DROP DATABASE IF EXISTS `CardStorageManagement`; 

CREATE DATABASE IF NOT EXISTS `CardStorageManagement`;

USE `CardStorageManagement`;

CREATE TABLE IF NOT EXISTS `Cards` (
    `id`                INT PRIMARY KEY AUTO_INCREMENT,
    `fk_storageid`      INT,
    `cardname`          VARCHAR(64) NOT NULL UNIQUE,
    `reservationstotal` INT
);

CREATE TABLE IF NOT EXISTS `Storages` (
    `id`          INT PRIMARY KEY AUTO_INCREMENT,
    `fk_locid`    INT,
    `storagename` VARCHAR(128) NOT NULL UNIQUE,
    `ipaddr`      CHAR(15) NOT NULL,
    `capacity`    INT NOT NULL
);

CREATE TABLE IF NOT EXISTS `Locations` (
    `id`       INT PRIMARY KEY AUTO_INCREMENT,
    `location` VARCHAR(32) NOT NULL
);

CREATE TABLE IF NOT EXISTS `CardsStatus` (
    `id`               INT PRIMARY KEY AUTO_INCREMENT,
    `fk_cardid`        INT,
    `fk_reservationid` INT NULL, -- If NULL then card not reserved
    `iscardavailable`  BOOLEAN NOT NULL
);

CREATE TABLE IF NOT EXISTS `CardsReservationQueue` (
    `id`            INT PRIMARY KEY AUTO_INCREMENT,
    `fk_userid`     INT,
    `reservedsince` DATE NULL,
    `reserveduntil` DATE NULL,
    `returned`      BOOLEAN DEFAULT FALSE
 -- `isoverdue`     BOOLEAN GENERATED ALWAYS AS (UNIX_TIMESTAMP(NOW()) > UNIX_TIMESTAMP(`reserveduntil`)) 
);

CREATE TABLE IF NOT EXISTS `Users` (
    `id`         INT PRIMARY KEY AUTO_INCREMENT,
 -- `firstname`  TEXT NULL,
 -- `lastname`   TEXT NULL,
    `email`      TEXT NULL,
 -- `passwd`     TEXT NULL,  
    `readerdata` TEXT NOT NULL, 
    `isadmin`    BOOLEAN NOT NULL
);

CREATE TABLE IF NOT EXISTS `UserSession` (
    `id`             INT PRIMARY KEY AUTO_INCREMENT,
    `fk_userid`      INT,
    `office365token` VARCHAR(256) UNIQUE NOT NULL,
    `apiaccesstoken` VARCHAR(256) UNIQUE NOT NULL
);

ALTER TABLE `Cards`                 ADD CONSTRAINT `fkCardsStoragesStorageid`                        FOREIGN KEY (`fk_storageid`)     REFERENCES `Storages`(`id`);
ALTER TABLE `Storages`              ADD CONSTRAINT `fkStoragesLocationsLocid`                        FOREIGN KEY (`fk_locid`)         REFERENCES `Locations`(`id`);
ALTER TABLE `CardsStatus`           ADD CONSTRAINT `fkCardsStatusCardsCardid`                        FOREIGN KEY (`fk_cardid`)        REFERENCES `Cards`(`id`);
-- ALTER TABLE `CardsStatus`           ADD CONSTRAINT `fkCardsStatusStoragesStorageid`                  FOREIGN KEY (`fk_storageid`)     REFERENCES `Storages`(`id`);
ALTER TABLE `CardsStatus`           ADD CONSTRAINT `fkCardsStatusCardsReservationQueueReservationid` FOREIGN KEY (`fk_reservationid`) REFERENCES `CardsReservationQueue`(`id`);
ALTER TABLE `CardsReservationQueue` ADD CONSTRAINT `fkCardsReservationQueueUsersUserid`              FOREIGN KEY (`fk_userid`)        REFERENCES `Users`(`id`);
ALTER TABLE `UserSession`           ADD CONSTRAINT `fkUserSessionUsersUserid`                        FOREIGN KEY (`fk_userid`)        REFERENCES `Users`(`id`);

ALTER TABLE `Cards`                 AUTO_INCREMENT = 1;
ALTER TABLE `Storages`              AUTO_INCREMENT = 1;
ALTER TABLE `CardsStatus`           AUTO_INCREMENT = 1;
ALTER TABLE `CardsStatus`           AUTO_INCREMENT = 1;
ALTER TABLE `CardsStatus`           AUTO_INCREMENT = 1;
ALTER TABLE `CardsReservationQueue` AUTO_INCREMENT = 1;
ALTER TABLE `UserSession`           AUTO_INCREMENT = 1;