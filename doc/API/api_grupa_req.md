# API-Requirements GruPa

### Client -> API Kommunikation



- **Phone**

  - <u>Registrieren</u>:

    - Phone postet an API ( "/api/users/sign-up",)

      {
      "source": "phone"
      "storageid": "storageid" (wird beim phone ausgewählt)
      "email": mustermann@gmail.com
      }
      
    - Server sendet Mqtt message and "Storageid@location"
    
     {
     id:msgid
     action: "sign-up-user"
     }
    
    - User haltet Karte an Sensor ->Raspberry sendet MQTT message an server
    
      id:msgid
    
      action: "read-token"
    
      token:"xxx-111...."
    
    - Server erhät token und tragt ihn in DB ein:
    
    - App muss nun wissen ob alles erflogreich war: Websockets oder einfach alle paar sekunden get 

  - Karte Holen: 

    User Token muss nicht überprüft werden am Raspberry, da er in der App schon fix angemedlet is

    1. App senden an "/api/users/get-card"

    {

    "source":"phone"

    "information":

    ​	{

    ​		"email":"mustermann@gmail.com"

    ​		"cardname":"Card79"

    ​		"storageid":"example"

    ​	}

    }

    2. Server sendet Mqtt Message an storageid@location

       id:msgid

       action: "get-card-phone"

       Card:

       ​	{

       ​		name:"Card76"

       ​		position:2

       ​	}

    3.Karte droppt raspberry sendet an server

    {

    ​	id:msgid

    ​	action: "card-drop-successful"

    ​	successful: true/false

    }

    4.Server ändert isavailable auf false (Websockets oder App schaut alle paar sekunden nach ob isavailable anders ist)

    

  - Karte reservieren: "/api/users/reservate-card"

    {

    "source":"phone"

    "information":

    ​	{

    ​		"email":"mustermann@gmail.com"

    ​		"cardname":"Card79"

    ​		"from": unixtimestamp

    ​		"to": unixtimestamp

    ​	}

    }

    

- **Terminal**

  

  User Token muss überprüft werden am Raspberry, da Benutzer unbekannt.

  Folgender Ablauf erfolgt:

  <u>1.Terminal postet Json an API: /api/users/get-card</u>

  {

  "source":"terminal"

  "information":

  ​	{

  ​		"cardname":"Card79"

  ​		"storageid": "example"

  ​		"position": 2

  ​	}

  }

  <u>2.Server sendet MQTT message an Topic "storageid@location"</u> 

  id:msgid

  action: "get-card-terminal"

  Card:

  ​	{

  ​		name:"Card76"

  ​		position:2

  ​	}

  3.Raspberry fordert Druckerkarte von Benutzer ("da man nicht weiss ob er registriert ist)

  - Druckerkarte wird eingelesen

    

  4.Rasberry sendet an MQTT Nachricht um zu wissen ob USer angemeldet ist topic:"storageid@location"

  ​	{

  ​		id:msgid ("MUSS GLEICH SEIN")

  ​		action: "check-user-registered" 

  ​		token: "xxxx-1111-xxxasdas"

  ​	}

  5.Server schaut nach ob User registiert ist und sendet nachricht zurück: (Problem: Pop up am Terminal-> Terminal muss irgendwie wissen, dass User noch nicht registiert ist: Implementation offen evntl. mit Websockets) 

  ​	{

  ​		id:msgid ("MUSS GLEICH SEIN")

  ​		action: "is-user-registered" 

  ​		successful: true/false

  ​	}

  6.Raspberry wertet successful und arbeitet weiter wenn true-> Karte droppt 

  ​	{

  ​		id:msgid ("MUSS GLEICH SEIN")

  ​		action: "card-drop-successful" 

  ​		successful: true/false

  ​	}

  

- Wenn Karte abgeholt werden möchte



## Admin Program

- Karte anlegen 

  1. Admin App sendet an "/api/cards", dass neue Karte angelegt wird

  ​	{

  ​	alle felder für eine Karte 

  ​	}

  

  ​	2.Server sendet an MQTT "Storageid@location"

  ​	{

  ​		id:msgid ("MUSS GLEICH SEIN")

  ​		action: "scan-new-card" 

  ​	}

  ​	3. Raspberry scannt Karte und sendet Token an Server

  ​	{

  ​		id:msgid ("MUSS GLEICH SEIN")

  ​		action: "new-card 

  ​		token:"xxx-111"

  ​	}

  4. Server legt Karte an

  

# 	

 

