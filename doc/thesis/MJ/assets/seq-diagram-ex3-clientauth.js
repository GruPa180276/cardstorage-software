sequenceDiagram
    alt 
    Client->>Server: GET /api/v1/auth
    Server-->>Client: eyJhbGciOiJIUzI1NiIs... (JWT)
    else
    Client->>Server: GET /api/v1/auth/user/email/user@litec.ac.at
    Server->>DB: Does user@litec.ac.at exist?
    alt
    DB-->>Server: Yes!
    Server-->>Client: eyJhbGciOiJIUzI1NiIs... (JWT)
    else 
    DB-->>Server: No!
    Server-->>Client: Error: Not found!
    end 
    end