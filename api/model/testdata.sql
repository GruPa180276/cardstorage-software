USE `CardStorageManagement`;

/**
 * https://arche.webuntis.com/timetable-contact-hours
 * ```js
 * const t = document.querySelector(
 *   `#dijit_layout__LayoutWidget_0 > section > div > div > div.un-flex-pane.un-master-page__grid > div > div:nth-child(3) > div > div.un-flex-pane.un-flex-pane--scroll > table`);
 * const rooms = new Set();
 * for (const teacher of t.children[0].children) {
 *     const room = teacher.children[5].innerText;
 *     if (room == "" || room == undefined || room == null) continue;
 *     rooms.add(room);
 * }
 * console.log(JSON.stringify(Array.from(rooms)).replaceAll(`"`, `'`).replace(`[`, `(`).replace(`]`, `)`).replaceAll(`',`, `'),`).replaceAll(`,'`, `,('`) + ";");
 * ```
 */
INSERT INTO `Locations` (`location`) VALUES
     ('3-28'),
     ('3-29'),
     ('0-01'),
     ('3-05');

-- -- data generated with https://generatedata.com/generator

-- INSERT INTO `Users` (`email`, `readerdata`) VALUES
--     ("in.at@outlook.com","CCEFA364-4194-9365-84E2-76A411A99375"),
--     ("netus.et@hotmail.net","0C8DF6C9-1117-7A22-5CF8-5A2EF48A1249"),
--     ("mauris.morbi@yahoo.net","8129EFC0-2A89-1C2E-5595-FACC38516F1F"),
--     ("quis.diam@yahoo.edu","8862ADDE-8483-449E-A43E-03AF39D968EE"),
--     ("ultrices.duis@google.couk","7C4D0227-E5E4-8118-257F-0A9A625A5E84"),
--     ("nibh.quisque@icloud.edu","85182312-86AE-7991-AC82-1C3CEE58D106"),
--     ("posuere@icloud.net","1330FAD8-868A-1E82-2ED3-1F5869BAC455"),
--     ("neque.sed.dictum@google.org","42B88FE1-2D73-19B5-9570-77455E4A5634"),
--     ("tempor.lorem@outlook.ca","B88A7D21-DE83-1FD0-1449-8834E41545A0"),
--     ("amet@protonmail.org","E65FE9A2-A2A8-88DE-6292-3AD9DBC88CDE"),
--     ("lectus.sit.amet@aol.edu","1B1BEAA8-35D3-79D4-1CC5-6160D9044A21"),
--     ("lorem.ac@google.couk","5CE59DB7-7DBF-2D4C-B843-9F72A737D329"),
--     ("massa@google.couk","CCD276E9-37B8-74C4-B699-A686DDB30BA3"),
--     ("enim.consequat@yahoo.couk","647A54B8-57CB-2FCC-3DD1-CCE6AB8DEED0"),
--     ("nec.euismod@outlook.org","BA8566E2-CEB6-C9FD-C2CC-A5DAA3944C14"),
--     ("malesuada.augue@icloud.ca","58A3C4EB-08BC-CC56-32FB-6BC3B86988F2"),
--     ("felis@google.net","B5EBF62E-AE6E-1DB7-A991-1CE8182DA5F8"),
--     ("eu.enim@yahoo.org","1ED7D8F6-FDCF-67CC-794F-B1351CE56648"),
--     ("tellus.justo@yahoo.com","F2811313-FB7C-64C0-E392-C678CEA6939C"),
--     ("non@yahoo.com","B90A7BFD-11FC-505C-48A8-7B45DE6105F2"),
--     ("egestas.ligula@icloud.net","DE6185D8-DEE4-3CE2-55F6-8DDE41F442B1"),
--     ("feugiat@icloud.org","9814047C-5AF3-48FA-1D01-FBEF2362D127"),
--     ("iaculis.quis@hotmail.edu","3AD42998-80A5-B9C6-93CE-A82C13E43B1C"),
--     ("velit.aliquam@icloud.couk","DE561911-AC63-8EE9-7993-D4CD66943893"),
--     ("accumsan@hotmail.org","006327C5-81CF-B591-6CE0-4E8DCAC64D87"),
--     ("nunc@protonmail.couk","DACEE47B-F4D8-DE98-7BAE-99AC8A12C9E7"),
--     ("nunc.mauris.sapien@protonmail.edu","44124BA3-DD88-D181-914E-7114DB6F7C5A"),
--     ("non.lobortis@google.couk","75E965D6-0C21-EA37-7943-38A4225B9A94"),
--     ("nonummy.ultricies.ornare@icloud.edu","F97BAB52-B6ED-D8EC-CB95-7DABE04B35AE"),
--     ("adipiscing.ligula.aenean@google.edu","4EDD4ADB-60C4-E2EB-58B3-E24D8B77585D"),
--     ("phasellus.vitae.mauris@aol.couk","B382BC64-622D-F5C5-4B21-C8DE21713852"),
--     ("aliquam.auctor@icloud.net","78DB49AD-A3DA-DC33-1962-EE90CF4574F2"),
--     ("sapien.molestie@outlook.ca","FBC59BE2-8393-1611-9775-8B9A8B173D1A"),
--     ("sed@outlook.ca","A9D8B286-C385-73AA-28A2-5B907FF78CF7"),
--     ("egestas.duis.ac@outlook.edu","5186E839-DAF2-424C-16A1-91ED533A2EB9"),
--     ("metus.aenean.sed@icloud.com","B2FEDEA1-7195-611B-4B5A-580ECD576D28"),
--     ("dictum@yahoo.ca","C71B84AB-CE63-5B7C-8C07-BBFC2D25582C"),
--     ("malesuada@hotmail.couk","B69A343E-D4C1-4B22-C71F-210980A68ECA"),
--     ("est.arcu.ac@aol.net","CAD2E9A4-68D8-CE3E-BF12-2BD1ED55C425"),
--     ("sapien@protonmail.org","AEC17A7D-1F81-9AD1-2ABB-5FD3C7920A1A"),
--     ("volutpat.nunc.sit@protonmail.net","E0CCA886-C71F-6523-1982-B47BBD3DD2FE"),
--     ("nunc@icloud.com","4CA3AF99-2A8B-9A29-3FB2-F1FC9DEEA33B"),
--     ("scelerisque.dui.suspendisse@hotmail.ca","CDBF0741-12D1-60DD-A685-2C1C58240E67"),
--     ("donec.dignissim@google.edu","71F91355-560E-D68B-CF8B-0071DC4A3F18"),
--     ("bibendum.donec.felis@outlook.com","DE151E3A-9CBE-1BCB-65AE-ECD489DCF469"),
--     ("penatibus.et.magnis@protonmail.org","2756FB3A-4FBB-E16C-69F9-BDC54ACF0993"),
--     ("donec.est.nunc@icloud.org","CE43E4D3-F599-7DB9-88F0-8EB26E6B1B64"),
--     ("vulputate.risus@icloud.couk","2D76B8E2-5916-9579-1808-D43E7EE8C255"),
--     ("neque.nullam@google.ca","1C7DB320-0AA7-7197-3FFA-1264B7B83223"),
--     ("pellentesque.tincidunt@yahoo.com","FDBAAF6B-96B8-870A-4DC6-C6A1CBC42DCE");

-- INSERT INTO `Administrators` (`fk_userid`) VALUES
--     ((SELECT `id` FROM `Users` WHERE `email` = "in.at@outlook.com"));

INSERT INTO `Storages` (`storagename`, `fk_locid`, `ipaddr`, `capacity`) VALUES
        ("storage-unit-1" ,(SELECT `id` from `Locations` WHERE `location` = "3-28"), "192.168.54.3", 10),
        ("storage-unit-2" ,(SELECT `id` from `Locations` WHERE `location` = "3-29"), "192.168.54.4", 10);
--     ("CS_UNIT_3",(SELECT `id` from `Locations` WHERE `location` = "2-13"),"192.168.54.145",10),
--     ("CS_UNIT_4",(SELECT `id` from `Locations` WHERE `location` = "0-01"),"192.168.54.143",20);


-- INSERT INTO `Cards` (`fk_storageid`, `cardname`, `reservationstotal`) VALUES
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_1"),"CARD_1" ,5),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_1"),"CARD_2" ,6),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_1"),"CARD_3" ,13),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_1"),"CARD_4" ,10),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_1"),"CARD_5" ,10),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_1"),"CARD_6" ,4),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_1"),"CARD_7" ,4),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_1"),"CARD_8" ,1),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_1"),"CARD_9" ,12),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_1"),"CARD_10",14),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_2"),"CARD_11",0),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_2"),"CARD_12",1),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_2"),"CARD_13",14),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_2"),"CARD_14",7),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_2"),"CARD_15",6),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_2"),"CARD_16",10),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_2"),"CARD_17",6),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_2"),"CARD_18",6),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_2"),"CARD_19",13),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_2"),"CARD_20",10),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_3"),"CARD_21",0),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_3"),"CARD_22",2),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_3"),"CARD_23",4),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_3"),"CARD_24",4),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_3"),"CARD_25",1),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_3"),"CARD_26",10),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_3"),"CARD_27",5),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_3"),"CARD_28",14),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_3"),"CARD_29",14),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_3"),"CARD_30",15),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_4"),"CARD_31",4),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_4"),"CARD_32",15),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_4"),"CARD_33",14),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_4"),"CARD_34",3),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_4"),"CARD_35",15),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_4"),"CARD_36",5),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_4"),"CARD_37",17),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_4"),"CARD_38",7),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_4"),"CARD_39",9),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_4"),"CARD_40",10),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_4"),"CARD_41",5),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_4"),"CARD_42",15),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_4"),"CARD_43",14),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_4"),"CARD_44",3),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_4"),"CARD_45",15),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_4"),"CARD_46",5),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_4"),"CARD_47",0),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_4"),"CARD_48",7),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_4"),"CARD_49",2),
--     ((SELECT `id` FROM `Storages` WHERE `storagename` = "CS_UNIT_4"),"CARD_50",11);

-- INSERT INTO `CardsReservationQueue` (`fk_userid`, `reservedsince`, `reserveduntil`) VALUES
-- ();

-- INSERT INTO `CardsStatus` (`fk_cardid`, `fk_reservationid`, `iscardavailable`) VALUES
-- ();

-- INSERT INTO `UserSession` (`fk_userid`, `office365token`, `apiaccesstoken`) VALUES
-- ();