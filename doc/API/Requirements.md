# API Template

## Benutzer

### POST

- User anlegen :\[Vorname,Nachname, Email,Passwort,Access Privilges(optional)] (Email ist Unique)

### PUT

- User bearbeiten :\[Vorname,Nachname, Email,Passwort,Access Privilges(optional)] (Email ist Unique)

### DELETE

- User loeschen: [Email]

### GET

- :question: **send Email: get all meta-datas** :question:

- getAll Users

  

## Karten

### POST

- Karte anlegen :\[Name, StorageID, KartenID] 

### PUT

- Karte bearbeiten :\[Name, StorageID, KartenID] 

### DELETE

- Karte loeschen: [KartenID]

### GET

- get all Cards 
- get all Cards per Card Storage [StorageId] (wird uebergeben)



## Automat 

### POST

- Automat anlegen :\[Name,IP-Adress,Capacity, Location] (Name Unique)

### PUT

- Automat bearbeiten :\[Name,IP-Adress,Capacity, Location] (Name Unique)

### DELETE

- Automat loeschen: [Name]

### GET

- get all CardStorages 

  

## Rechte (Optional)

### POST

- Rechte anlegen :\[Name, Cardgroup] (Name Unique)

### PUT

- Rechte anlegen/bearbeiten :\[Name, Cardgroup] (Name Unique)

### DELETE

- Rechte loeschen: [Name]

### GET

- get all Rightsgroup per User (Email uebergeben)
