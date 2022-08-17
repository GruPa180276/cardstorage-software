# API Template

## Benutzer

### Post

- User anlegen/bearbeiten :\[Vorname,Nachname, Email,Passwort,Access Privilges(optional)] (Email ist Unique)
- User loeschen: [Email]

### Get

- send Email: get all meta-datas

- getAll Users

  

## Karten

### Post

- Karte anlegen/bearbeiten :\[Name, StorageID, KartenID] 
- Karte loeschen: [KartenID]

### Get

- get all Cards 
- get all Cards per Card Storage [StorageId] (wird uebergeben)



## Automat 

### Post

- Automat anlegen/bearbeiten :\[Name,IP-Adress,Capacity, Location] (Name Unique)
- Automat loeschen: [Name]

### Get

- get all CardStorages 

  

## Rechte (Optional)

### Post

- Rechte anlegen/bearbeiten :\[Name, Cardgroup] (Name Unique)
- Rechte loeschen: [Name]

### Get

- get all Rightsgroup per User (Email uebergeben)