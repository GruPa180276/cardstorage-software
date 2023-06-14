# API-Requirements ZoecBe

### Logs Page

- Wie besprochen, als Websocket umsetzten.

- z.b: Wenn neue Karte angelegt wird, glöscht, geändert ... Wie bereits im Terminal implementiert

  ​       Selbiges auch für Storages und Locations.



### Errors

- Auch als Websockets umsetzten
- z.b: Wenn Karte nicht herausgegeben werden kann ...



### Info Page`"/api/status"`

- Get

  ```JSON
  {
      lastPing: 20221216
      errorCount: 10
      cardsOverTime: 5
      cardsInStorage: 7 / 10
  }
  ```

- LastPing: Bitte die Zeit übermitteln, wann letzter Ping statt fand.
- errorCount: Wie viele Errors aktuell vorhanden sind.
- cardsOverTime: Wie viele Karten über der Zeit sind. Welche schon zurückgegeben werden müssten
- cardsInStorage: Wie viele Karten aktuell im Storage sind.
