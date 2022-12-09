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
INSERT INTO Locations (location) VALUES
    ('3-28'),
    ('3-29'),
    ('0-01'),
    ('3-05'),
    ('9-27'),
    ('2-51'),
    ('3-13');

INSERT INTO Storages (fk_locid, storagename, ipaddr) VALUES
    ((SELECT id FROM Locations WHERE location = '3-28'), 'storage-unit-1', '192.168.5.5'),
    ((SELECT id FROM Locations WHERE location = '3-29'), 'storage-unit-2', '192.168.6.5'),
    ((SELECT id FROM Locations WHERE location = '3-05'), 'storage-unit-3', '192.168.7.5'),
    ((SELECT id FROM Locations WHERE location = '3-13'), 'storage-unit-4', '192.168.8.5');

INSERT INTO Users (mail, readerdata) VALUES
    ('a.b@litec.ac.at', '1'),
    ('c.d@litec.ac.at', '2'),
    ('d.e@litec.ac.at', '3');

INSERT INTO Administrators (fk_userid) VALUES ((SELECT id FROM Users WHERE mail LIKE 'a.b%'));