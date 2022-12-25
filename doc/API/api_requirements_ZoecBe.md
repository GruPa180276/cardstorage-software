# API-Requirements ZoecBe

### Cards `"/api/cards"`

- Anlegen (POST)

  ```JSON
  {
      id: 0
      name: "CardXX"
      storageid: "1"
      position: "Wird nicht übergeben, soll automatisch festgelegt werden!"
      readerdata: "Wird vom Raspi an die API übetragen"
  }
  ```
  
- Löschen (DELETE)

  ```JSON
  {
      id: xx
  }
  ```

- Bearbeiten (PUT)

  ```JSON
  {
      id: 0
      name: "CardXX"
      storageid: "1"
  }
  ```
  
- Die ReaderData wird vom Raspi übergeben und von Herrn Grubauer implementiert.



### Storages `"/api/storage-units"`

- Anlegen (POST)

  ```JSON
  {
      id: 0
      name: "StorageXX"
      ipaddress: "192.168.0.1"
      capacity: 10
      locationid: 1
  }
  ```

- Löschen (DELETE): Karten werden auch gelöscht!

  ```JSON
  {
      id: xx
  }
  ```

- Bearbeiten (PUT)

  ```JSON
  {
      id: 0
      name: "StorageXX"
      ipaddress: "192.168.0.1"
      capacity: 10
      locationid: 1
  }
  ```



### Locations `"/api/locations"`

- Anlegen (POST)

  ```JSON
  {
      id: 0
      name: "3-28"
  }
  ```



### Status Storages `"/api/storage-units/status"`

- Low Priority
- Status des Storages abfragen können, ob Online oder Offline.
- Es sollen der Status von allen Storages zurückgegben werden.



### Count Cards`"/api/cards/count"`

- Low Priority

- Counter implementieren, wie oft eine Karte ausgeborgt wurde.
- Es sollen die Werte für alle Karten zurückgegeben werden.



### Logs `"/api/logs"`

- Low Priority
- Wenn möglich, alle Events der API übetragen, wie bereits im Terminal implementiert wurde.



### Error Messages `"/api/cards | storages | location/error"`

- Low Priority
- Fehlermeldungen an die APP übergeben.
- Fhlermeldungen sollen nach cards, storages und location unterschieden werden.
- z.B: Wrong datatype, Value is already in database ...
