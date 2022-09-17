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

  
### Admin User
Bitte einen Amdin User anlegen!!!!!!

### Logs
Bitte Logs bereitstellen
