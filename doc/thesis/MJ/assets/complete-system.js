---
title: Zusammenspiel der Komponenten des Systems
---
flowchart LR
    subgraph APP["Anwendungen"]
        BA["Benutzer Anwendung<br>fas:fa-users"]
        AA["Administrator Anwendung<br>fas:fa-user-cog"]
    end
    subgraph ZS["Zentrale Schnittstelle"]
        direction LR
        SRV["Server<br>fas:fa-server"]
        DB[(Datenbank<br>fas:fa-database)]
        SRV<-->DB
    end
    APP<-->|HTTP|ZS
    ZS-->|WebSocket|APP
    subgraph CS["Schließfach"]
        DP["Display<br>fas:fa-tv"]
        CTRL["Controller<br>fab:fa-raspberry-pi"]
        CRDS["Karten-<br>Sortiment<br>fas:fa-credit-card fas:fa-credit-card<br>fas:fa-credit-card fas:fa-credit-card"]
    end
    CTRL<-->|MQTT|ZS
    DP<-->BA