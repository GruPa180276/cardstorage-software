%% sequenceDiagram
%%     %%actor Client
%%     %%actor Server
%%     %%actor Controller
%%     Client->Server: A
%%     Client-->Server: B
%%     Client->>Server: C
%%     Client-->>Server: D
%%     Client-xServer: E
%%     Client--xServer: F
%%     Client-)Server: G
%%     Client--)Server: H

sequenceDiagram 
    critical Anfrage per REST-Endpunkt
    Client->>Server: PUT /api/v1/storages/ping/name/S1
    option HTTP 200 OK
    critical Raum des Schließfaches S1 finden 
    Server->>DB: Location of S1 = ?
    option Raum gefunden
    DB-->>Server: Location of S1 = R1
    option Raum nicht gefunden
    DB-->>Server: Location of S1 = ??
    Server-->>Client: 400 Bad Request 
    end
    Server->>S1@R1/1: {... "action": "storage-unit-ping" ...}
    Server-->>Client: 200 OK
    S1@R1/1--)Server: {... "status": {... "successful": true ...} ...}
    Server--)Client: Websocket /api/v1/controller/log
    option HTTP 401 Unauthorized
    Server-->>Client: Nicht authorisiert
    end