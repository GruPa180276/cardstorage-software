DROP DATABASE IF EXISTS `CardStorageManagement`;
CREATE DATABASE IF NOT EXISTS `CardStorageManagement`;

USE `CardStorageManagement`;

CREATE TABLE IF NOT EXISTS `Storages` (
    `id`                INT          PRIMARY KEY AUTO_INCREMENT,
    `location`          VARCHAR(32)  NOT NULL,
    `name`              VARCHAR(128) NOT NULL UNIQUE,
    `ipaddr`            CHAR(15)     NOT NULL,
    `capacity`          INT          NOT NULL DEFAULT 10
);

CREATE TABLE IF NOT EXISTS `Users` (
    `id`                INT          PRIMARY KEY AUTO_INCREMENT,
    `email`             VARCHAR(64)  UNIQUE NOT NULL,
    `readerdata`        VARCHAR(128) UNIQUE DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS `Administrators` (
    `fk_userid`         INT UNIQUE,

    CONSTRAINT `fkAdministratorsUsersUserid` FOREIGN KEY (`fk_userid`) REFERENCES `Users`(`id`)
);

CREATE TABLE IF NOT EXISTS `Cards` (
    `id`                INT          PRIMARY KEY AUTO_INCREMENT,
    `fk_storageid`      INT          NOT NULL,
    `position`          INT          NOT NULL,
    `name`              VARCHAR(64)  NOT NULL UNIQUE,
    `readerdata`        VARCHAR(128) DEFAULT NULL,
    `accesscount`       INT          DEFAULT 0,
    `iscardavailable`   BOOLEAN      NOT NULL DEFAULT TRUE,

    CONSTRAINT `fkCardsStoragesStorageId` FOREIGN KEY (`fk_storageid`) REFERENCES `Storages`(`id`)
);

CREATE TABLE IF NOT EXISTS `CardsQueue` (
    `id`                INT     PRIMARY KEY AUTO_INCREMENT,
    `fk_cardid`         INT     NOT NULL,
    `fk_userid`         INT     NOT NULL,
    `since`             INT     NOT NULL,
    `until`             INT     NULL,
    `returned`          BOOLEAN DEFAULT FALSE,
    `reserved`          BOOLEAN DEFAULT FALSE,

    CONSTRAINT `fkCardsQueueUsersUserid` FOREIGN KEY (`fk_userid`) REFERENCES `Users`(`id`),
    CONSTRAINT `fkCardsQueueCardsCardid` FOREIGN KEY (`fk_cardid`) REFERENCES `Cards`(`id`)
);

ALTER TABLE `Cards`          AUTO_INCREMENT = 1;
ALTER TABLE `CardsQueue`     AUTO_INCREMENT = 1;
ALTER TABLE `Storages`       AUTO_INCREMENT = 1;
ALTER TABLE `Users`          AUTO_INCREMENT = 1;