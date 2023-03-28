sequenceDiagram
    Client->>Server: PUT <br> /api/v1/storages/cards/<br>name/K1/fetch/<br>user/email/user@litec.ac.at 
    Server->>DB: Zu welchem <br> Schließfach <br> gehört K1?
    DB-->>Server: S1
    Server->>DB: Zu welcher <br> Location <br> gehört S1?
    DB-->>Server: R1
    Server->>DB: Position von <br> K1 in S1?
    DB-->>Server: 4
    %% Server->>DB: Setze K1 <br> auf unverfügbar
    %% DB-->>Server:  K1 ist unverfügbar
    Server->>S1@R1/1: {"action": "storage-unit-fetch-card-source-mobile", <br> "position": 4, "card-name": K1, <br> "email": "user@litec.ac.at"}
    Server->>Client: Websocket: Timer für Benutzer <br> auf Bildschirm anzeigen <br> {"action": "storage-unit-fetch-card-source-mobile", <br> "position": 4, "card-name": "K1"}
    S1@R1/1--)Server: {"action": "storage-unit-fetch-card-source-mobile", <br> "successful": true, <br> "email": "user@litec.ac.at"}
    Server->>DB: Setzte K1 <br> auf unverfügbar, <br> Access Count +1
    DB-->>Server: K1 aktualisiert
    Server->>DB: Reservierung für <br> user@litec.ac.at von K1
    DB-->>Server: Reservierung erstellt
    Server-->>Client: Websocket: <br> {"action": "storage-unit-fetch-card-source-mobile", <br> "successful": true, "card-name": "K1"}
