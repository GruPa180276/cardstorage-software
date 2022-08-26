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
- 14:00 bis 16:10  Uhr
<!-- { "progress": false } -->

