sequenceDiagram
    Client->>Server: GET /api/v1/storages/cards/name/{name} 
    Server->>Middleware: HTTP Origin Check (CORS)
    Server->>Middleware: HTTP Method Check
    Server->>Middleware: HTTP Header Check
    Server->>Middleware: Meridian HTTP Authorization
    critical
    Middleware->>Resource Handler: Handle Client Request
    option
    Resource Handler-->>Middleware: Merdian.Okay (Request Successful)
    Middleware-->>Client: Request Response 
    option
    Resource Handler-->>Middleware: Error != NULL (Request Failed)
    Middleware-->>Client: Request Failed
    Middleware--)Client: Websocket: Request Failure due to... 
    end
    Middleware-->>Server: Merdian Request Logging