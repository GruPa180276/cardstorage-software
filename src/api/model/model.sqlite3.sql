PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS Cards (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    fk_storageid INTEGER,
    cardname     TEXT NOT NULL UNIQUE,

    FOREIGN KEY (fk_storageid) REFERENCES Storages(id)
);

CREATE TABLE IF NOT EXISTS Storages (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    fk_locid    INTEGER,
    storagename TEXT NOT NULL UNIQUE,
    ipaddr      TEXT NOT NULL,
    cap         INTEGER NOT NULL,

    FOREIGN KEY (fk_locid) REFERENCES Locations(id)
);

CREATE TABLE IF NOT EXISTS Locations (
    id  INTEGER PRIMARY KEY AUTOINCREMENT,
    loc TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS CardsStatus (
    id               INTEGER PRIMARY KEY AUTOINCREMENT,
    fk_cardid        INTEGER,
    fk_storageid     INTEGER,
    fk_reservationid INTEGER NULL, -- If NULL then card not reserved
    iscardavailable  BIT NOT NULL,

    FOREIGN KEY (fk_cardid)        REFERENCES Cards(id),
    FOREIGN KEY (fk_storageid)     REFERENCES Storages(id),
    FOREIGN KEY (fk_reservationid) REFERENCES CardsReservationQueue(id)
);

CREATE TABLE IF NOT EXISTS CardsReservationQueue (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    -- fk_cardid     INTEGER,
    -- fk_storageid  INTEGER,
    fk_userid     INTEGER,
    reservedsince TIME NULL,
    reserveduntil TIME NULL,

    FOREIGN KEY (fk_userid)    REFERENCES Users(id)
);

CREATE TABLE IF NOT EXISTS User (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    firstname  TEXT NULL,
    lastname   TEXT NULL,
    email      TEXT NULL,
    readerdata TEXT NOT NULL, -- base64 encode byte string and store as TEXT
    isadmin    BIT NOT NULL
);

CREATE TABLE IF NOT EXISTS Session (
    id                INTEGER PRIMARY KEY AUTOINCREMENT,
    fk_userid         INTEGER,
    office365loginjwt TEXT UNIQUE NOT NULL, -- base64 encode byte string and store as TEXT

    FOREIGN KEY (fk_userid) REFERENCES Users(id)
);