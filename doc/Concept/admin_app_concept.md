## Admin-App

#### Generelle Spezifikation

- Die Admin App soll dazu verwendet werden können, direkt am Display am Automaten, administrative Aufgaben erledigen zu können z.B: Karten hinzufügen, Benutzer anlegen... Diese Anwendung soll auch als Webseite zur Verfügung stehen, um solche Einstellungen nicht direkt Vorort machen zu müssen. Die Admin App wird ebenfalls mit Flutter erstellt. Um die Admin App benutzen können, wird es bestimmte Benutzer geben die sich als Admin anmelden können. 

  - In der App soll der User sich in einer Grafik ansehen können, welche Karten gerade verfügbar sind und welche nicht. Diese kann pro Automaten oder mit allen Karten gemachte werden. 

  - Weiters soll man in der App einen neuen Automaten hinzufügen können, dazu muss man einige Parameter angeben wie Name, IP-Adresse, Anzahl Karten, Ort. Danach werden diese in einer Datenbank im Hintergrund eingepflegt. 

  - In der App sollen auch neue Karten hinzugefügt werden können oder Karten getauscht werden, dazu wird, wenn das Fenster geöffnet wird am Automaten angezeigt, dass die Karten zum Lesegerät gehalten werden soll, damit die Karte im System gespeichert werden kann.

  - Eine weitere Option ist, dass man auch neue Benutzer anlegen können soll, oder auch verwalten kann.

  - Als letzten soll sich der Admin auch Statistiken erstellen können, damit die Auslastung im Auge behalten werden kann.

    

#### Funktionen:

- Ansicht, welche Karten Verfügbar sind
- Neuen Automaten anlegen
- Neue Karten hinzufügen / tauschen können, gleichzeitig Anzeige am Display, das die Karte gescannt werden soll
- Benutzer anlegen, Passwort ändern
- Statistik / Auswertungen erstellen