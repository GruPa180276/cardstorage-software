sequenceDiagram
    Client->>Server: PUT <br> /api/v1/storages/cards/name/K1/fetch
    Server->>DB: Zu welchem <br> Schließfach <br> gehört K1?
    DB-->>Server: S1
    Server->>DB: Zu welcher <br> Location <br> gehört S1?
    DB-->>Server: R1
    Server->>DB: Position von <br> K1 in S1?
    DB-->>Server: 4
    Server->>S1@R1/1: {"action": "storage-unit-fetch-card-source-terminal", <br> "position": 4, "card-name": K1}
    Server->>Client: Websocket: Timer für Benutzer <br> auf Bildschirm anzeigen <br> {"action": "storage-unit-fetch-card-source-mobile", <br> "position": 4, "card-name": "K1"}
    S1@R1/1--)Server: {"action": "storage-unit-fetch-card-source-terminal", <br> "position": 4, "reader": "<XYZ>"}
    Server->>DB: Zu welchem Benutzer <br> gehören die <br> Kartendaten <XYZ> ?
    alt
    DB-->>Server: Zu Benutzer <br> user@litec.ac.at
    Server->>S1@R1/1: {"action": "storage-unit-fetch-card-source-terminal", <br> "position": 4, "card-name": K1, <br> "email": "user@litec.ac.at"}
    S1@R1/1--)Server: {"action": "storage-unit-fetch-card-source-terminal", <br> "email": "user@litec.ac.at", "successful": true}
    Server->>DB: Setzte K1 <br> auf unverfügbar, <br> Access Count +1
    DB-->>Server: K1 aktualisiert
    Server->>DB: Reservierung für <br> user@litec.ac.at von K1
    DB-->>Server: Reservierung erstellt
    Server-->>Client: Websocket: <br> {"action": "storage-unit-fetch-card-source-terminal", <br> "successful": true, "card-name": "K1"}
    else
    DB-->>Server: Benutzer mit Kartendaten <XYZ> gibt es nicht
    Server-->>Client: Websocket: <br> {"action": "storage-unit-fetch-card-source-terminal", <br> "successful": false, "card-name": "K1"}
    end