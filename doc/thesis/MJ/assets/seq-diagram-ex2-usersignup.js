sequenceDiagram
    Client->>Server: POST /api/v1/users <br> Authorization: Bearer <Token> <br> {"email": "user@litec.ac.at", "storage": "S1"}
    Server->>DB: Location of S1 = ?
    DB-->>Server: Location of S1 = R1
    Server->>DB: Create User user@litec.ac.at
    DB-->>Server: Created user@litec.ac.at
    Server-)S1@R1/1: MQTT: {"action": "user-signup", email: "user@litec.ac.at", "reader": ""}
    Server-->>Client: 200 OK (Anfrage wird bearbeitet)
    Server--)Client: Websocket: Create Timer for User registration <br> {"action": "user-signup", email: "user@litec.ac.at", "storage": "S1"}
    S1@R1/1--)Server: MQTT: {"action": "user-signup", email: "user@litec.ac.at", "reader": "XYZ", "successful": true}
    Server->>DB: Update user@litec.ac.at Reader = XYZ
    DB-->>Server: Updated user@litec.ac.at
    Server--)Client: Websocket: User created successfully <br> {"action": "user-signup", email: "user@litec.ac.at", "sucessful": true}