sequenceDiagram
    actor Benutzer
    Benutzer->>S1@R1/1: wirft unbekannte <br> Karte ein
    S1@R1/1->>RFID-Lesegerät: lese eingeworfene <br> Karte ein
    RFID-Lesegerät-->>S1@R1/1: gibt <DATEN> <br>zurück
    S1@R1/1-)Server: Zu welchem Schließfach gehört diese Karte? <br> {"action": "storage-unit-deposit-card", "reader": "<DATEN>"}
    Server->>DB: Schließfach von <br> Karte mit <br>Datenfeld = <DATEN> ?
    alt Karte gehört zu S1 an pos. 3
    DB-->>Server: S1
    Server--)S1@R1/1: {"action": "storage-unit-deposit-card", <br> "successful": true, "position": 3, "client-id": "server", <br> "reader": "<DATEN>"} <br> Karte wird im Schließfach positioniert
    S1@R1/1->>Server: {"action": "storage-unit-deposit-card", <br> "successful": true, "client-id": "S1", <br> "reader": "<DATEN>"}
    Server->>DB: Karte mit <br> Kartenfeld <DATEN> <br> wieder aktiv stellen und <br> Access-Count + 1
    else Karte gehört zu Sx
    DB-->>Server: Sx
    Server--)S1@R1/1: {"action": "storage-unit-deposit-card", <br> "successful": false, "reason-for-failure": "Sx"}
    S1@R1/1-->>Benutzer: Geben Sie die <br> Karte in Sx zurück
    end 