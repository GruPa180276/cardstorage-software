DROP DATABASE IF EXISTS `CardStorageManagement`; 

CREATE DATABASE IF NOT EXISTS `CardStorageManagement`;

USE `CardStorageManagement`;

CREATE TABLE IF NOT EXISTS `Cards` (
    `id`                INT PRIMARY KEY AUTO_INCREMENT,
    `fk_storageid`      INT,
    `position`          INT, -- position in storage unit
    `cardname`          VARCHAR(64) NOT NULL UNIQUE,
    `readerdata`        VARCHAR(128) UNIQUE DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS `Storages` (
    `id`                INT PRIMARY KEY AUTO_INCREMENT,
    `fk_locid`          INT,
    `storagename`       VARCHAR(128) NOT NULL UNIQUE,
    `ipaddr`            CHAR(15) NOT NULL,
    `capacity`          INT NOT NULL
);

CREATE TABLE IF NOT EXISTS `Locations` (
    `id`                INT PRIMARY KEY AUTO_INCREMENT,
    `location`          VARCHAR(32) NOT NULL
);

CREATE TABLE IF NOT EXISTS `CardsStatus` (
    `id`                INT PRIMARY KEY AUTO_INCREMENT,
    `fk_cardid`         INT,
    `fk_reservationid`  INT NULL, -- If NULL then card not reserved
    `iscardavailable`   BOOLEAN NOT NULL,
    `reservationstotal` INT
);

CREATE TABLE IF NOT EXISTS `CardsQueue` (
    `id`                INT PRIMARY KEY AUTO_INCREMENT,
    `fk_userid`         INT,
    `since`             INT NOT NULL,
    `until`             INT NULL, -- if NULL, then the card might be currently borrowed but not necessarily reserved, check `reserved` flag to distinguish between already returned cards and reserved cards, `reserved` will automatically be set for reservations
    `returned`          BOOLEAN DEFAULT FALSE,
    `reserved`          BOOLEAN DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS `Users` (
    `id`                INT PRIMARY KEY AUTO_INCREMENT,
    `email`             VARCHAR(64) UNIQUE NOT NULL,
    `readerdata`        VARCHAR(128) NOT NULL
);

CREATE TABLE IF NOT EXISTS `Administrators` (
    `fk_userid`         INT
);

CREATE TABLE IF NOT EXISTS `UserSession` (
    `id`                INT PRIMARY KEY AUTO_INCREMENT,
    `fk_userid`         INT,
    `office365token`    VARCHAR(256) UNIQUE NOT NULL,
    `apiaccesstoken`    VARCHAR(256) UNIQUE NOT NULL
);

ALTER TABLE `Cards`          ADD CONSTRAINT `fkCardsStoragesStorageid`             FOREIGN KEY (`fk_storageid`)     REFERENCES `Storages`(`id`);
ALTER TABLE `Storages`       ADD CONSTRAINT `fkStoragesLocationsLocid`             FOREIGN KEY (`fk_locid`)         REFERENCES `Locations`(`id`);
ALTER TABLE `CardsStatus`    ADD CONSTRAINT `fkCardsStatusCardsCardid`             FOREIGN KEY (`fk_cardid`)        REFERENCES `Cards`(`id`);
ALTER TABLE `CardsStatus`    ADD CONSTRAINT `fkCardsStatusCardsQueueReservationid` FOREIGN KEY (`fk_reservationid`) REFERENCES `CardsQueue`(`id`);
ALTER TABLE `CardsQueue`     ADD CONSTRAINT `fkCardsQueueUsersUserid`              FOREIGN KEY (`fk_userid`)        REFERENCES `Users`(`id`);
ALTER TABLE `UserSession`    ADD CONSTRAINT `fkUserSessionUsersUserid`             FOREIGN KEY (`fk_userid`)        REFERENCES `Users`(`id`);
ALTER TABLE `Administrators` ADD CONSTRAINT `fkAdministratorsUsersUserid`          FOREIGN KEY (`fk_userid`)        REFERENCES `Users`(`id`);

ALTER TABLE `Cards`          AUTO_INCREMENT = 1;
ALTER TABLE `Storages`       AUTO_INCREMENT = 1;
ALTER TABLE `CardsStatus`    AUTO_INCREMENT = 1;
ALTER TABLE `CardsQueue`     AUTO_INCREMENT = 1;
ALTER TABLE `UserSession`    AUTO_INCREMENT = 1;