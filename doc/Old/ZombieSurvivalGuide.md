---
author: hasp
version: 0.2
date: 20220701
---
# ~~Zombie Survival Guide~~

![](https://d1x7zurbps6occ.cloudfront.net/product/xlarge/422423-81200.jpg)
(c) grindstore.com

> Gotcha! Sorry, the title was just to lure you here, this is not about Zombies, but about your Diploma Thesis, so check out the recommendations below!

# DIPLOMA THESIS Survival Guide

To make your life easier, we are now switching to German...

## Projekttagebuch

Das Ausarbeiten und spätere Schreiben einer Diplomarbeit ist ein sehr zeitintensiver Prozess, daher sollte man die dafür aufgewandte Zeit möglichst effizient nutzen.
Dazu gehören auf alle Fälle folgende Punkte:

1. **ALLE zur DA (Diplomarbeit) gehörenden Tätigkeiten IMMER SOFORT in einer Markdown-Datei (Projekttagebuch) aufschreiben.** 
    - Dabei sollte 
        - die genaue Tätigkeit,
        - besuchte/durchgearbeitete Links,
        - Zeitaufwand und 
        - Datum mitgeschreiben werden.
    - Weiters sollten 
        - aufgetretene Probleme, Schwierigkeiten und Herausforderungen beschreiben, 
        - und dazugehörige Lösungsansätze möglichst genau vermerkt werden.
    > *WARUM? Spätestens 2 Monate vor Abgabe Termin muss man eine Dokumentation zu der DA erstellen, 
    > und wenn man während der Projektätigkeiten genaue Aufzeichnungen geführt hat, dann hat man bereits eine Basis für diese Dokumentation. 
    > Ohne entsprechende Aufzeichnungen muss man alle besuchten Links, den geschriebenen Code und die erledigten Tätigkeiten nochmals durchgehen - das kostet extrem VIEL Zeit!*
2. **Jedes Teammitglied hat seine EIGENEN Aufzeichnungen!** Diese sind aber natürlich alle **laufend** in diesem Repository zu speichern.
3. Sollte man z.B. ein **Tutorial oder Demo-Code** ausprobiert haben, dann ist dies im Projekttagebuch zu verzeichnen, 
   und der Code **im Repository** z.B. in einem Unterordner des `sandbox`-Ordners **abzulegen**. 
   Auf den erstellten Code wird natürlich im Tagebuch mit Hilfe eines Links verwiesen.
4. Für **jede Person** gibt es zumindest einen **eigenen Branch**, besser noch zusätzlich für **jedes größere Themengebiet**.

## Umsetzungsarbeiten während des Projektverlaufes

Neben der Erstellung eines Pflichten- und Lastenheftes zum Beginn der Projektumsetzung sind folgende Punkte UNBEDINGT durchzuführen:

1. **Projektbeschreibung im readme.md** des Repository-Root-Folders. Darin sind folgende Punkte anzuführen:
   - Erklärung worum es sich bei dem Projekt handelt,
   - eine kurzes "Benutzerhandbuch",
   - eine SETUP-Erläuterung wie das Projekt "zum Laufen" gebracht werden kann (was ist dazu alles nötig, Installationsanleitung, ...)
2. **Überblick über die zu verwendenden Technologien ausarbeiten**. 
   - Man muss zum Projekt passende unterschiedliche Technologien begutachten und vergleichen,
   - dann die Vor- und Nachteile der analysierten Technologien gegenüberstellen, 
   - und die Entscheidung für den im späteren Projektverlauf gewählten Ansatz begründen.
   - Natürlich auch immer sofort entsprechende Aufzeichnungen machen!
3. **Programming / Coding**:
   - **Kommentare** während des Programmierens **IMMER SOFORT** (nicht nachträglich) zum Code hinzugeben. Dies ist zu erledigen bei
     - algorithmisch herausforderenden Code-Teilen, und bei
     - Funktionen / Methoden / Klassen, die eine öffentliche Schnittstelle darstellen (in Java z.B. JavaDoc bei `public` Modifier).
     - Keine sinnlosen bzw. offensichtlichen Kommentare (z.B. `// the next code line is a for-loop`).
   - **Unit Tests** sind immer gleich mitzuführen (gibt es so gut wie bei jeder Programmiersprache!). TDD-Ansatz wäre ideal 
     (Unit-Test zuerst, und danach die Methode erstellen).
     > *WARUM TDD? TestDrivendevelopment hat den Vorteil, dass man bereits während der Testerstellung im Hinterkopf darüber nachdenkt, 
     > wie man die Methode auch algorithmisch umsetzen kann -> möglicherweise schon wieder Zeitersparnis! 
     > Ein weiterer Grund für Unit-Tests ist die vereinfachte Fehlerfindung während der Projektumsetzungsphase. 
     > Man finde leicht heraus wo, wann und von wem eine Code-Änderung zu Problemen geführt hat.* 
 4. **Versionsverwaltung**
    - Neben der Verwendung von **Branches**, 
    - sollte mit **Issues**, 
    - **Pull-Requests** und
    - dem **Github-Project** Tool gearbeitet werden. 

## Dokumentation

Die Erstellung der Dokumentation ist beim kontinuierlichen Einsatz der oben angeführten Schritte um einiges erleichtert. 

- Man nimmt einfach die bereits geschrieben Aufzeichnungen (readme, Protokoll,...) her, erweitert diese bzw. strukturiert
  sie neu und gibt fehlende Erläuterungen hinzu.
- Wichtig ist unter anderem auch eine entsprechende visuelle Aufbereitung: Graphiken, Bilder und Diagramme erleichtern das Verständnis der
  geschriebenen Arbeit. Im Text gibt es natürlich zu jeder Graphik eine ausführliche Erläuterung!
- "Daumen mal Pi" kann gesagt werden, dass pro Person ca. 20 bis 30 seiten zu schreiben sind (je nachdem wie kompakt bzw. "gehaltvoll" der 
  Text formuliert wurde).

## Weitere Anforderungen - HASP/HAUK/HOSU/PAMG/ZUKW

Die folgenden Punkte werden (vollständig oder zumindest teilweise) von den oben genannten Lehrkräften in die spätere Beurteilung miteinbezogen:

-  Die _Arbeitsteilung_ ist so umzusetzen, dass alle Diplomanden unabhängig voneineander, parallel arbeiten können! Dazu sind geeignete Schnittstellen zu definieren und alle Diplomanden müssen die Gegenseite ihrer Schnittstellen "simulieren" bzw. provisorisch implementieren können.
- Klare _Zuständigkeiten_: Alle Diplomanden sind genau für ihren Teilaufgabe zuständig und ergebnisverantwortlich
- Die in die Diplomarbeitsdatenbank einzutragenden Informationen sind die für die Diplomarbeit relavante Projektplanung. Vor allem die Arbeitsteilung und die mit Datum versehenen Meilensteine (3 bis 5 Stück pro Diplomand*in) sind für die Endnote relevant.
- Zumindest alle zwei Wochen wird entweder ein Status-Treffen vereinbart, oder zumindest ein kurzer Statusbericht (als Issue in github oder als Mail) an die Betreuungslehrkraft übermittelt.
  >  Dies muss **OHNE Aufforderung** des Betreuers erledigt werden! (Der Statusbericht ist natürlich einfach zu erstellen, falls man das Projekttagebuch sauber mitführt).
- _Quellenangaben_: Fremde, bereits erstellte Teillösungen SOLLEN verwendet werden ("nicht das Rad neu erfinden"). Allerdings muss ALLES (jede Zeile Code, jedes Bild, usw). das nicht von einem selbst erstellt wird, mit einer Quellenangabe versehen werden. Ebenso muss bei angepasstem Code eine Quellenangabe erfolgen: Wo findet man den ursprünglich als Vorlage verwendeten Code? Außerdem muss noch per Quellenangaben angegeben werden, wo man weiterführende Informationen zum gerade besprochenen Thema findet.
- Source Code muss **sinnvolle** Kommentare und API Beschreibungen beinhalten (z.B. JavaDoc, Doxygen, ...)
- Die einzelnen Zuständigkeiten der Teammitglieder werden möglichst genau ausgearbeitet und mit der Betreungslehrkraft abgesprochen! (Projektanfang)
- Sobald wie möglich ist über die ausgewählten Technologien zu berichten. (Projektanfang)
- Die Dokumentationsstruktur ist spätestens im Dezember vorzulegen (Aufbau und Kapiteleinteilung mit kurzer Erläuterung was darin ausgearbeitet werden soll).
- _DA-Dokumentation_: Zumindest jedes Kapitel und Unterkapitel hat einen kurzen Vermerk von welcher Person der Text bzw. die Arbeit erstellt wurde.
- Elektronische Reife-und-Diplomarbeits-Kalender verwenden: "RDP, AP TS Allgemeine Termine" sowie "RDP HIT"

### Extras HASP

- Gültig für HASP: Umfangreiche Verwendung von GitHub (Issues, Branches, Project, Pull-requests) sind **VERPFLICHTEND**. Zusätzlich wird die Verwendung von Github-Actions empfohlen.
- Gültig für HASP: Unit-Tests nicht nur empfohlen, sondern **VERPFLICHTEND** umzusetzen!

### Extras ZUKW

- Gültig für ZUKW: Weitere Projekt-Organisation (z.B. Pflichtenheft), ist bei ZUKW für die Diplomarbeitsnote nicht relevant, aber für anderen Unterricht, in dem diese Projekt-Organisation stattfindet, sehr wohl relevant.


---
> :warning: Hinweis: dieses Dokument ist im Moment erst in der Version 0.2 vorliegend, also noch nicht vollständig ausformuliert, und mit Sicherheit mit "typos" durchzogen!

