# Protocol

**2022-07-03: 8.40 -> 11.40**

Heute habe ich den Tag genutzt, um mir ein allgemeines Verständnis vom Framework "Flutter" zu erschaffen. Hierbei schaute ich mir verschiedene Dokumentationen bzw. Videos an, um die Grundstruktur von Flutter zu verstehen. Schlussendlich kam ich zu dem Punkt mir das Framework herunterzuladen, allerdings blieb ich bei der Installation bei einem Punkt hängen und entscheid mich die Installation erst morgen anzugehen.

**2022-07-04: 11.20 -> 14.20**

Heute wurde das Framework Flutter installiert. Allerdings war es zunächst nicht möglich die Flutter-App im VsCode zu compilen. Zum Glück fand ich in einem Forum eine Lösung und konnte somit die Vorzeige App compilen. Danach musste ich verschiedene Extension herunterladen und den Editor für Flutter richtig einstellen. Der restliche Tag wurde noch damit verbracht sich Videos über Flutter anzusehen

**2022-07-05: 7.00 -> 12.00**

Den heuten Tag habe ich damit verbracht die Programmiersprache Dart zu verstehen und wie man diese mit dem Framework Flutter verwendet. Zunächst habe ich verschiedene Widgets erstellt und diese mit einer Logik in Dart getestet. Überraschenderweise tat ich mir leicht und "programmierte" schon eine Testversion des Logins. Es funktionierte alles super. Abends hatten meine Kollegen und ich noch ein Gespräch, wie wir das Projekt angehen bzw. wer was macht.

**2022-07-06: 12.00 -> 18.00**

Heute habe ich mir verschiedene Videos angeschaut, wie man Passwörter verschlüsselt am Smartphone speichern kann (Login „Remember me“ Funktion). Allerdings trat ich auf ein Problem da ich verschiedene Funktionen in Dart nicht verstand, die dazu benötigt waren. Schließlich verstand ich diese nach lesen von Dokus und schauen von Videos. Danach nutzte ich die Zeit, um den Zugriff auf Rest-APIs in Flutter zu verstehen. Am Abend hatte ich mit meinen Kollegen noch ein Meeting, um ein Konzept für unser Projekt zu gestalten. Zunächst wurde ein allgemeines yuml-File entworfen, welches den Lifecycle des Projekts darstellen soll. Danach schrieb jeder, was sein Teilbereich überhaupt alles implementieren soll

**2022-07-07: 7.00 -> 11.00** 

Heute schrieb ich eine Test-App die zu jeder ID (z.B Tresor Karte) von einem JSON File (welches man über eine REST-API bekommt) eine dementsprechende Widget-Card erstellen soll. Zunächst überlegte ich mir einen Algorithmus und zeichnete diesen auf einem Blatt Papier auf. Nach zahlreichen Denkfehlern schaffte ich es allerdings den Parser zum Laufen zu bekommen. Danach nutzte ich die Zeit und schaute mir verschiedene Videos, wie meine größeren Projekte mit Flutter strukturieren soll. Dementsprechend erstellte ich eine angepasste Struktur für unser Projekt und teilte es Ben mit wie diese funktioniert.

**2022-07-07: 11.00 -> 13.00** 

Es wurde eine Mockup fuer die kommende Anwendung erstellt

**2022-08-16: 7.40 -> 13.10** 

Nach einmonatiger Pause aufgrund eines Praktikums hatte ich heute mit Herrn  Zoechmann ein Meeting um ueber den aktuellen Stand des Projekt zu reden. Es wurden Aenderungen bei der Ordnerstruktur durchgefuehrt und eine Fehlerbehandlung umgesetzt. Da ich ca. ein Monat nicht beim Projekt weiterarbeiten konnte, musste ich mich bei meinem akutellen Fortschritt wieder einlesen. Danach fing ich mit der Registrierungsseite an. Ich entschied mich eine Progressbar zu programmieren, die das eingegebene Passwort bewertet. Da ich kein Paket aufgrund der Sicherheit verwenden wollte, programmierte ich die Logik selbst. Allerdings hatte ich kleine Komplikationen (Regex), die mir etwas Zeit kosteten. Schlussendlich funktionierte dann der Passwortbewerter

**2022-08-16: 15.00 -> 16.00** 

Am Nachmittag wurde eine Stunde bei der Registrierungsseite weitergearbetet. Es wurden Fehler ausgebessert und es wurde ein "Passwort wiederholen" Textfeld hinzugefuegt. Weiters wurde bei der Gesamtlogik etwas geaendert

**2022-08-17: 9.00 -> 11.15** 

Am Vormittag hatte mit Herrn Zoechmann ein Meeting um zu was fuer Daten die API uns zur verfuegung stellen soll. Es wurde ein Markdwon erstellt. Danach habe meine Task beim bereits erstellen git project hinzugefuegt und angepasst.
 
**2022-08-17: 12.00 -> 14.00** 

Danach habe ich bei meiner Registrierungsseite weitergearbeitet (Validator) und fertiggestellt. Danach fiel mir auf, dass der Dark bzw. Light Theme sehr kompliziert von mir implementiert wurde. Ich entschied mich diesen zu aendern um Komplikationen bei groesseren Projektfortschritt vermeiden zu koennen. Die restliche Zei schaute ich noch ein Video, was die beste Methode um dies zu programmieren 

**2022-08-17: 20:00 -> 23.00** 

Nach Rechere habe ich damit begonnen einen moeglichst schnelle und kurze Variante zu bauen um das Theme zu aendern. Nach 1,5 Stund ging dieser auch. Allerdings habe ich danach versuch verschiedene Werte in eine lokale Db zu speichern, was sich leider als ein Problem darstellte.

**2022-08-18: 12:30 -> 16.30** 

Nach etwas Rechere stellte sich mein Fehler heraus, den ich bei der lokalen Datenbank gemacht habe. Danach habe ich etwas bei der Ordnerstrukutur umgeaendert, um eine moeglichst gute Performance zu erreichen. Ebenfalls habe ich mit der Homepage angefangen und mir die Dokus zu Menu navigation durchgelesen. Spaeter hatte ich ein Meeting mit Herrn Mayrhofer, um ueber den aktuellen Projektfortschirtt zu reden. Danach zeigte mir Herr Mayrhofer noch sein go Programm, um automatisch die Arbeitsstunden zaehlen zu koennen.

**2022-08-18 : 19:00 -> 21:04** 

Es wurde der Drawer fuer den ClientLogin erstellt um auf verschiedene Seiten zju wechseln. Dieser hat etwas Zeit gekostet, da ich diesen moeglich "open-closed" programmieren wollte, um Erweiterungen einfach zu machen. Schlussendlich funktionierete dann alles. Danach wurden noch verschiedene Design Ideen gaendert.

**2022-08-19: 9:20 -> 11:20** 

Am Vormittag hatte ich ein Meeting mit Herrn zoechmann um uber dcen aktuellen projektfortschritt bzw aufteilung zu reden. Weiters haben wir noch ueber eine vereinheitlichung des Design geredet und uns fuer ein gleiches entschieden. Allerdings trat ein Problem mit der Helligkeit der Farben auf, wenn man den dark und lightmode aenderte was etwas zeit raubte. Danach haben wir unsere RegEx geandert und etwas angepasst

**2022-08-19: 11:45 -> 14:08** 

Danach habe ich begonnen die Seite fuer die Karten zu erstellen. Zum Testen der  Karten wurde eine public API verwendet. Um eine moeglichst gute Erweiterbarkeit zu ermoeglichen versuchte ich ein Konzept zu erstellen. Allerdings stellte sich die Umsetzung als Problem sehr sonderbar ist in Sachen OOP. Als Unterstuetzung half mir Herr Mayrhofer. Allerdings hat er auch keine Loesung gefunden.

**2022-08-19: 17:00 -> 19:00** 

Nach etwas Pause versuchte ich erneut einen allgemeinen Handler fuer Get Api Anfrage zu schreiben und automatisch Widget davon in der App zu erstellen. Nach etwas genauerer Ueberlegung fand ich das Problem und schaffte den Handler erfolgreich zu erstellen. 


**2022-08-22: 9:00 -> 12:08** 

Heute habe ich bei der Kartenansicht weitergearbeitet. Es werden nun alle Karten je nachdem ob sie reserviert sind oder derzeit benutzt werden angzeigt. Allerdings hatte ich ein paar Probleme bekommen, da der DateTimepicker nicht ordentlich funktionierte. Schlussendlich hat dann alles funktioniert. Weiters habe ich mir aufgeschrieben, wie das Reservierungssystem aufgebaut werden soll.

**2022-08-22: 14:30 -> 16:30** 

Am Nachmittag habe ich beim reservierungsystem weitergearbetet. Nach Fertigstellung eines Pop ups (Zum Auswaehlen der Reservierungszeit (von,bis)) bekam ich eine Fehlermeldung, zu der ich keine Loesungfand. Nach etwas Probieren konnte ich allerdings das Problem loesen. Danach habe ich das Pop up Fenster zum NFC scannen geschrieben

**2022-08-22: 21:00 -> 22:13** 

Abends versuchte ich dann die Kartenansich, damit sie auch auf anderen Geraeten gleich aussieht. Allerdings stellte sich das als Problem dar, da Flutter angesichts dieses Themas sehr komisch ist. Auch nach zahlreichen Besuchen in Foren fand ich keine saubere Loesung sondern nur Workarrounds. Morgen habe ich vor, eine saubere Implementaton zu finden

 **2022-08-23: 09:50 -> 12:50** 

Am Vormittag habe ich versucht die Cards Page mit Constraints auf allen gereaten gleich aufzuloesen. Allerdings hat dies wieder nicht funktioniert. Danach habe ich die komplette CardsPage neu strukturiert und refactort, da mir die Ordnerstruktur nicht mehr gefiel. Danach habe ich mit der Reservierungseite begonnen, die die Reservierten Karten pro person anzeigt.

 **2022-08-23: 16:50 -> 18:00** 

Am Nachmittag hatte ich ein einstuendiges Meeting mit Herrn Mayrhofer, um die von ihm erstellte Api zu testen. Anfangs hatten wir noch Probleme, da wir den localhost des emulators mit der IP adresse vom computer verwechselt haben. Danach konnte ich erfolgreich daten von der API gettten. Danach hatten wir noch ein Gespraech ueber die Aufteilung und Funktionsweise des Projekts. Es wurde auch ueber die Datenbankstruktur disskutiert

 **2022-08-23: 21:15 -> 22:35** 

Abends habe ichn dann das Design der Kartenansich voellig ueberarbeitet, nun wird die Seite, egal wie gross das Display gleich angezeigt. Ebenfalls wurde der Login ueberarbeitet, damit er auch respopnsive ist
 
 **2022-08-24: 10:20 -> 12:53** 
 
Gegen Mittag habe ich die Reservierungseite erstellt und beim Code, der die Wildcards generiert dementsprechend etwas umgeaendert, sodass er schoen erweiterbar ist. D.h je nach seite (reservierung od Karten) werden die Karten automatisch generiert und angepasst a. Beim Testen ist mir dann ein Fehler bei der API aufgefallen, den ich dann Johannes erklaert habe.  Gegen habe ich dann noch die ausgebesserte API von Johannes erfolgreich testen koennen

 **2022-08-24: 14:10 -> 15:50** 
 
Am Nachmittag habe ich dann noch die Funktion hinzugefuegt um DAten senden zu koennen. Allerdings hatte ich verschiedene Probleme, da das encodieren meiner dAten nicht richtig funktionierte. Ebenfalls habe ich mir die Flutter Docu durchegelesen, damit ich besser weiss, wie man Flutter Projekte besser aufbaut

 **2022-08-24: 19:40 -> 21:15** 
Am Abend habe ich dann ncoph die post, put, delete Rest Api befehle hinzugefuegt und getestet. Danach wurde die Business Logic fuer die Reservierungsseite programmiert. Es koennen jetzt ganz einfach Reservierungen aufgehoben, bearbeitet werden. Um das open closed Prinzip einhalten zu koennen, habe ich mir ebenfalls dafuer einen guten aufbau ueberlegt
 
**2022-08-25: 9:00 -> 11:30** 

Am Vormittag hatte ich ein Meeting mit Ben. Am Anfang half ich ihm bei seinem Issue, und loeste ihn mit einer Callbackfunction (delegate). Danach erklaerte ich ihm unsere Ordnerstruktur. Weiters habe ich ihm erklaerte wie mein API Visualizer funktioniert. Danach zeigte ich ihm, wie man die API von Herrn Mayrhofer startet und damit kommuniziert. Danach brachte ich ihm bei,wie man die Zaehlstunden app von Herrn Mj nutzt. Ebenfalls haben wir noch darueber geredet, wie unser git merge ablaufen wird

**2022-08-25: 15:00 -> 18:00** 

Am Nachmittag habe ich bei Reservierungs und Kartenseite weitergearbeitet. Ich habe nun fuer das Reservierungssystem den put Api call programmiert. Danach habe ich eine Neue page erstellt, um die Benuzterdaten zu aendern. Allerdings hat mir ein problem mit Flutter (Ordnernamen umbennen) etwas Zeitgeraubt, da dies  nicht richtig funktioniert und Flutter die neuen Namen nicht finden konnte

**2022-08-25: 20:30 -> 00:02** 

Am Abend habe ich aufgrund eines Gespraechs mit Herrn Zoechmann meinen Drawer voellig entfernt und Tabs eingebaut. Dazue ueberlegt ich mir wieder ein Konzept, damit es schoen erweiterbar ist. Danach habe ich eine Seite Settings erstellt und dort verschiedene Verlinkungen eingebunden. Auserdem habe ich das komplette Colorscheme der App veraender, was etwas zeit kostete.

**2022-08-26: 8:45 -> 10:45** 

Am Vormittag hatte ich ein Meeting mit Herrn Zoechmann bezueglich des Designs der App. Ebenfalls implementierten wir eine Standard Font. Danach habe ich bei der Settings Seite etwas weitergearbetet

**2022-08-26: 13:30 -> 16:07** 

Am Nachmittag wollte ich beim Reservierungs Pop up die validation hinzufuegen. Dies stellte sich allerdings als problem dar, da ein POP up kein statefull widget ist. Deshalb ueberlegte ich mir ein konzept, um den automatisch generierten Pop up auch eine ueberpruefung zu geben. Dies benoetigte etwas zeit. Als ich fertig war, uebte ich dann noch kleine Verbesserungen bei der App aus.,

**2022-08-29: 9:00 -> 12:15** 

Am Vormittag fuegte und aenderte ich verscheidene tasks im Git Project. Danach entschied ich mich die einen Notificataion service zu schreiben, der sowohl auf iOs als auch Android funktioniert, wennn die App geschlossen ist. Das Problem war, dass ich kein Package dafuer finden konnte. Einige Zeit speater fand ich ein tutorial, dass ich nachmachen wollte, aber dann nicht funktioniert. Schlussendlich entsdchied ich mich, eine fertige Version von Gitrhub runterzuloaden, und diese an mein Projekt dann anzupassen

**2022-08-29: 13:00 -> 15:11 Uhr** 

Nach dem Mittagessen implementierte ich den Notification Service in meine App. Zunaechst funktionierte es, allerdings trat dann ein Problem auf, da die Reservierungszeiten, einen anderen Timestamp verwenden als der Service. Um dies zu begreifen, benoetigte es etwas Zeit. Schlussendlich konnte ich das Problem, behen und somit erfolgreich das Reservierungssystem vervollstaendingen

**2022-08-30: 9:00 -> 12:00** 

Am Vormittag habe ich mir als Zielgenommen einen EmnailBt zu schreiben, der die Bestaetungn der Anmeldung und das Zuruecksetzen des Passworts uebernimmt. Dazu habe ioch mir ein Tutorial angeschaut und dementsprechend im Code angepasst. Zwischendurch hatte ich ncoh ein Meeting mit Herrn Zoechmann, um uns uber den aktuellen Projektstatus auszutaiuschen. Ebenfalls haben wir gemeinsam bei mir ein Error beim Compilen beseitigt, da ein verwendetes Package einen Fehler beim Code hatte. 

**2022-08-30: 12:30 -> 14:00** 

Nach dem Mittagessen, habe ich ein neues Scaffold zum Zuruecksetzten des Passworts erstellt, welches den Informationsaustausch zwischen User und UI ermoeglich. Zwischendruch, kam ich dan auf die Idee das es gut weare, die Strukur an das DRY Princip anzupassen. Allerdings, habe ich mich nur informiert, wie dieses zum Umsetzen ist und habe mir ein Konzept ueberlegt, wie ich dieses einbauen moechte 

**2022-08-30: 15:30 -> 18:10** 

Gegen Abend hin habe ich dann mein Konzept was ich mir ueberlegt habe um das DRY Prinzip zu implementieren umgesetzt. Und getestet. Danach habe ich beim Login noch etwas gaendert, sodass er wenn remember me aktiviert ist sich automatisch anmeldet und habe ein template erstellt, welches ueberprueft ob die LoginDaten uebereinstimmen. 

**2022-08-31: 10:00 -> 12:00** 

Heute in der frueh hatte ich ein Meeting mit Heern Zoechmann, um ueber die Konstruktionskonzepte des anderen Teams zu reden. Danach habe ich Zoechamnn mein Konzept gezeigt, um das DRY principle umzusetzen. Danach habe ich noch ein paar Bugfixes bei der Apop ausgefuehrt

**2022-08-31: 13:00 -> 16:00** 

Am Nachmittag habe beim Email Bot (Passwort reset) weitergeschrieben. Als der Bot erfolgreich die Mails and den User schicken konnte, wollte ich einen Link erstellen, der in der Mail ist um die App zu oeffen und ein neues Passwort einfuegen zu koennen. Allerdings stellte sich dies als ein Problem dar da Flutter keinen suport fuer Deeplinks aufweist. Nach sehr sehr langer Suche fand ich allerdgins ein package, welches ein einem Forum empfohlen wurde. Dezeit bin ich noch dabei dieses zu implentieren, was sich als grosse herrausforderung herrausstellt.

**2022-08-31: 18:30 -> 19:30** 

Am Abend versuchte dan Herr Zoechmann mir dann noch mit den deep links zu helfen. Allerdings schafften wir es zu weit auch nicht.

**2022-09-01: 9:30 -> 11:35** 

Am Vormittag habe ich die Suchleiste bei den Karten eingefuegt. Beim Einbauen ist mir aufgefallen, dass ich bei der Struktur etwas vereinfachen kann. Nachdem ich es vereinfacht habe wurde die Suchleist hinzugefuegt und getestet. Danach wurde noch etwas bei der AccountSeite umgeaendert um sie performanter zu machen

**2022-09-01: 13:00 -> 15:00** 

Am Nachmittag habe ich mich damit beschaeft die Ordner und Filename der Konvention anzupassen. Dies stellte sich als ueberraschung als Herrausforderung dar, da ich nicht wusste, dass Flutter die Ordner bzw. Filename in einen eigenen Ordner speichert. Nach zahlreichen Versuchen, asuchte ich mir die Loesung in einem Forum raus.


**2022-09-02: 9:00 -> 12:40** 

Am Vormittag habe ich bei der app das Dry Prinzip fuer die Buttonsgeschrieben, um Zeilen sparen und eine bnessere Lesbarkeit zu ermoeglichen. Danach habe cih einen Inent geschrieben, um die Einstellungen vom Betriebssystem oeffnen zu koennen, damit die Notificationssetting geaendert werden koenne. Danach habe ich noch ein paar Bugs behoben. Allerdings war die App soweit fertig, aber ich musste noch auf die Fertigstellen von MJs Api warten. Deshalb habe ich begonnen, den NFC Write beim handy zu implementieren, was sich als herrausforderung darstellt, da es keine packages dafuer gibt. Alelrdings hatte ich beim raspberry ein problem, da ih mich mit ssh nicht anmelden konnte. Nach zahrleichen neuinstalltionen, habe ich im internet gelese, dass raspberry vor kruzem, den standardnutzer entfertn. Somit musste ih ein usder config erstellen und alles funktionierte dann.

**2022-09-06: 8:00 -> 11:15** 

Am Vormittag hatte ich ein Meeting mit Herrn Zoechmann, um ueber den aktuellen Projektstand zu reden. Danach habe ich das Programm fuer den NFC reader am raspi geschrieben. Nach langem suchen in zahlreichen Foren, stellt sich raus, das mein Konzept mit dem NFC lesen nicht moeglich ist da sich die UID laufend aendert. Danach habe ich mir ein neues Konzept ueberlegt und ahtte anschliessend wieder ein  Meeting mit Herrn Zoechmann. 

**2022-09-06: 13:00 -> 15:00** 

Am Nachmittag habe ich mich damit beschaeftigt einen Filter hinzuzufuegen. Zuerst uyeblergte ich mir ein Konzept, um eine moeglichst gute Implementierung zu haben. Danachn wurde der Filter erfolgreich einprogrammiert. Allerdings muss ich noch auf die Fertifgstellung von MJ seiner API warten umd den Filter fertigzustellen.

**2022-09-06: 21:00 -> 23:30** 

Abends habe ich dann noch versucht den Filter fertigzustellen. Allerdings stoss ich auf ein Problem, da ich leider bei meinem Konzept die flasche Liste verwendet habe. nach etwas debuugen konte ich allerdings den Fehler finden und behebe. Danach wurde noch etwas am deisgin umgeaendert

**2022-09-08: 8:00 -> 9:10** 

Am Vormittag hatte ich ein Meeting mit herrn zoechmann, da er hilfe beim Refactorn benoetigt hat. Ebenfalls wurden zahlreiche organisatorische Sachen bzgl der Diplomarbeit besprochen.


**2022-09-08: 13:30 -> 15:30** 

Am Nachmittag habe ich mit dem Errorhandling begonnen. Ich durchsuchte zahlreiche Foren um die beste Methode zufinden. Allerdings hatte ich ein Problem um fuer den Futurebuilder ein Errorhandling zu machen. nach etwas probieren schaffte ih es dann. Danach habe ich es Herrn Zoechmann gezeigt und um Ubereinstimmmung gebeten. Ebenfalls habe ich noch mein Git Project aktualisiert da ich darauf vergessen habe

**2022-09-16: 08:15 -> 12:30** 

Am Freitag in der ITP Stunde mussten wir auf der Diplomarbeitsdatenbank einen Projektantrag erstellen. Danach hatten wir eine Besprechungsstunde mit Frau Hofer bezgl. der Diplomarbeit. Es wurden viel Sachen aufgeklaert. Danach habe ich eine kurze Zusammenfassung fuer ein Pflcihtenheft geschrieben und eine Artikelliste erstellt. Danach wollte ich bei der App weiterarbeiten, allerdings hatte ich zahlreiche kuriose Probleme bei der Installation. Die Vm wollte nicht laufen.

**2022-09-17: 8:00 -> 11:30** 
Heute hatten wir ein Teammeeting da wir unser Konzept ueberarbeiten wollten  und ein Pflichtenheft erstellen wollten. Es wurde alles erledigt

**2022-09-19: 10:30 -> 14:30**
Habe heute versucht Flutter auf meinem Laptop zum Laufen zu bekommen. Allerdings hatte ich zahlreiche Probleme bei der installation. Die IDE wurde mehrmals neu runter geladen allerdings hat das nicht geholfen. Auch nach den Besuch vopn zahlreichen Foren konnte ich keine Loesung findnen die VM zu starten. Zuhause habe ich mich dann entschieden eine ältere Version von Android studio zu verwenden, was dan schlussendlich das Problem löste. Dnach habe ich noch verschiedene Buttons neu erstellen müssen, da diese in der neuen Flutter Version nicht mehr verfuegbar sind

**2022-09-22: 11:30 -> 14:30**
Heute habe ich bei der App neue Validations hinzugefügt. Danach habe ich die Passwort create Option in ein eigenes File ausgelagert um es genereisch generieren zu lassen. Danach habe ich mir eine neue lOgik überlegt ohne intentions das passwort zurückzusetzten. Lösung war ein ode der mittels Mail geschrieben wurde. Ebenfalls wurde eine Klasser erzeugt die diesen COde automatisch erzeugt


**2022-09-28: 15:30 -> 20:30**
Habe heute die Homeseite erstellt. Diese wird als FavoritenSeite fuer die Karten benutzt. Ebenfalls wurde auch die Prefernces hinzugefuegt wo ich zunaechst etwas probleme hatte. Das ganze wurde so erstellt, dass es keine Problem darstellen soll, wenn man den Karten Reminder implentieren soll. Danach habe ich im Internet etwas nach eine loesung gesucht den Login via Microsoft zu erledigen. Nach zahlreichen gescheiterten Versuchen, kam ich zu den Entschluss Firebase zu verwenden. Was sich als gute Idee herrausstelle, da ich Firebase auch fuer die Notifcation benoetige falls sich ein Wert bei der API aendert

**2022-09-29: 11:15 -> 14:15**
Habe heute bei der Favouriten Seite weitergearbeitet bzw. Refactort. Es wurde eine Klasse erstelle die es ermögliche automatisch die Buttons fuer eine Karten zu erstellen. Danach wurden noch ein paar Bugs gefixed und nach der Firebase impl. gesucht


**2022-09-30: 8:15 -> 11:55**
In dieser Stunde hatte ich eine heisse diskussion mit meinen Kollegen aufgrund der Authentifizierung mittel Microsoft. Ebenfalls hatten wir eine Meeting aufgrund dessen mit Frau Hofer. Danach wurde bei der App noch etwas noch am Design gaendert und eine Notify Funktion eingebaut falls die Karte wieder frei ist.


**2022-09-30: 16:00 -> 18:00**
Das UC wurde ueberarbeitet

**2022-09-30: 16:00 -> 18:00**
Das UC wurde ueberarbeitet

**2022-10-05: 12:00-> 16:00
Es wurde ein Seite erstellt um Mails an andere Benutzer zu senden, die gerade eine Karte verwenden, die sie benötigen. Allerdings bemerekte ich dann, dass diese  Implementation falsch ist und erstellte eine Intention, die automatisch eine Liste von installierten MailApps anzeigt und, welches ausählen kann, die automatishc eine Compose erstellt. 

**2022-10-08: 09:00-> 11:30
Heute wurde eine Probebeispiel zu dem Microsoft Login erstellt. Dazu verwendete ich die DOku, die mir Hasp schickte. Ich las mir diese durch und erstellte ein Projekt, welches als Beispiel diente. Es funktionierte alles perfekt

**2022-10-08: 08:15 -> 10:00**
Heute habe ich ben etwas geholfen, eine notifaciton mittels api zu erstellen. Danach habe ich den login und .env bei der rfid app hinzugefuegt

**2022-10-08: 13:45 -> 15:15**
AM nachmittag habe ich dann noch versucht, den user mittel redirect uris zu bekommen. Allerdings weiss ich immer noch nicht wie ich die email eines users bekommen


**2022-10-27: 10:00 -> 13:00**
Wie mit Herrn Haslinger besprochen, habe ich mir die Doku von Microsoft Graph durchgelesen, um an die User Daten zu kommen. Danach verwendten ich den Graph explorer um die Daten von meinem eigenen AccessToken zu bekommen, was auch funktionierte. Danach wollte ich mit einer Api diese Daten holen, wo ich allerdings auf ein Problem trat. Ich hatte keine Rechte mich anzumelden. Nach zahlreichen Foren und einer Mail ans Herrn Haslinger funktionierte es immer noch noch nicht. Am Nachmittag habe ich es dann nochamls probiert und lustigerweiser hat es dann funktioneirt



**2022-10-29: 22:00 -> 24:00**
Heute habe ich die Json Respone die bei der Api zurueckgegeben wird geparsed. Dazu habe ich einen bereites von mir erstellten Parser verwendeten (Cards). Allerding shat dies dann nicht auf Anhieb funktioniert. Nach langer Zeit und debuggen habe ich mitbekommen, dass ich in meinen Json einen rechtschreibfehler hatte. Danach hat alles funktioniert

**2022-10-30: 21:00 -> 22:15**
Es wurden aenderung am User Type (json class) gemacht und die account Seite ueberarbeitet, der den eingeloggten user anzeigt


**2022-11-12: 10:00 -> 14:25**
Heute habe ich die rememberme funktion fuer den neuen Login mittel Micrsoft implementiert. Allerdings konnte ich im initState mich nicht automatisch anmelden, deshalb suchte ich im internet nach einer loesung. Nach langer probiererei schaffte ich es alerdings nicht und loeste das problem mit einem Workarround. Nun funktioniert alles bis auf die Firebase api notification


**2022-11-12: 10:00 -> 12:00**
Es wurde eine Login seite für den Admin und User erstellt. Der User Login wurde überarbeitet. Weiters wurde für das Email Pop up eine generische Klasse geschrieben

**2022-11-18: 15:00 -> 16:00**
Es wurde für den Rfid Scanner die Halterung getestet.

**2022-11-19: 09:00 -> 13:00**
Es wurde fuer das Display die App erstellt und angepasst. Es wurde ebenfalls versucht eine APp auf Windows und nich tueber den Browser zu debuggen, allerdings ohne erfolg. Bei der Card visualiserung im browser kan ich aus irgendwelchen gruend nicht auf den localhost zugreifen. Es wrude dazu eine Frage auf Stackoverlow gestellt. Danach half ich Herrn Zoechmann bei seiner App.

**2022-11-19: 10:00 -> 17:15**
Es wurde fuer die DisplayApp eine Pop Up erstellt welches einen Timer visualisert fuer die Zeit di9e man hat um eine Karte an den Reader zu legen. Es wurde bereits ein "Raum" fuer die zukuenftige APi erstellt

**2022-11-21: 9:50 -> 13:50**
Tutorial zu Threading wurde angesehen. Und ein Besipeil Programm wurde erzeugt. Hatte ein paar Probleme hat allerdings dann alles funktioniert. Danach wurde der Thread im Hautpprogramm implementiert und es wurde ein freier Code block fuer das Mqtt Protokoll gefertigt
<!-- { "progress": true } -->
- 8:40  bis 11:40 Uhr
- 11:20 bis 14:20 Uhr
- 7:00  bis 12:00 Uhr
- 12:00 bis 18:00 Uhr
- 7:00  bis 11:00 Uhr
- 11:00 bis 13:00 Uhr
- 7:40  bis 13:00 Uhr
- 15:00 bis 16:00 Uhr   
- 9:00  bis 11:15 Uhr
- 12:00 bis 14:00 Uhr
- 20:00 bis 23:00 Uhr
- 12:30 bis 16:30 Uhr
- 19:00 bis 21:04 Uhr
- 9:20  bis 11:16 Uhr  
- 11:45 bis 14:08 Uhr
- 17:00 bis 19:00 Uhr
- 9:00 bis 12:08 Uhr
- 14:30 bis 16:30 Uhr 
- 21:00 bis 22:13 Uhr
- 09:50 bis 12:50 Uhr
- 16:15 bis 18:00 Uhr
- 21:15 bis 22:35 Uhr
- 10:20 bis 12:53 Uhr 
- 14:10 bis 15:50 Uhr
- 19:40 bis 21:15 Uhr
- 9:00 bis 11:30 Uhr
- 15:00 bis 18:00 Uhr
- 20:30 bis 00:02 Uhr
- 8:45 bis 10:45 Uhr
- 14:30 bis 16:10  Uhr
- 9:00 bis 12:15 Uhr
- 13:00 bis 15:11 Uhr
- 9:00 bis 12:00 Uhr
- 12:30 bis 14:00 Uhr
- 15:30 bis 18:10 Uhr
- 10:00 bis 12:00 Uhr 
- 13:00 bis 16:00 Uhr 
- 18:30 bis 19:30 Uhr
- 9:30 bis 11:35 Uhr
- 13:00 bis 15:00 Uhr
- 9:00 bis 12:40 Uhr
- 8:00 bis 11:15 Uhr
- 8:00 bis 11:15 Uhr
- 13:00 bis 15:00 Uhr
- 21:00 bis 23:30 Uhr
- 8:00 bis 9:10 Uhr
- 13:30 bis 15:30 Uhr
- 08:15 bis 12:30 Uhr
- 08:00 bis 11:30 Uhr
- 10:30 bis 14:30 Uhr
- 11:30 bis 14:30 Uhr
- 15:30 bis 20:30 Uhr
- 11:15 bis 14:15 Uhr
- 08:15 bis 11:55 Uhr
- 16:00 bis 18:00 Uhr
- 12:00 bis 16:00 Uhr
- 09:00 bis 11:30 Uhr
- 08:15 bis 10:00 Uhr
- 13:45 bis 15:15 Uhr
- 10:00 bis 12:00 Uhr
- 22:00 bis 24:00 Uhr
- 21:00 bis 22:15 Uhr
- 10:00 bis 14:25 Uhr
- 10:00 bis 12:00 Uhr
- 15:00 bis 16:00 Uhr
- 09:00 bis 13:00 Uhr
- 10:00 bis 17:15 Uhr
- 09:50 bis 13:50 Uhr
<!-- { "progress": false } -->

