**Project Flight Data - DOCUMENTATION**



1. CSV-Datei in Excel importieren



**Tool:** Excel



* Die CSV-Datei "airlines\_flights\_data" importiert mit > Daten > Daten abrufen und transformieren > Aus Text/CSV
* Die Spalten im Power Query-Editor angesehen und auf die Datentypen geachtet
* bei Duration (in Hours) wurde der Float in ein Integer umgewandelt -> Spalte in Text umwandeln, und später wieder in ein FLOAT umwandeln.
* Schließen und Daten laden







2. Daten verstehen



* Airline: Name der Airlines
* flight: besteht aus dem Flight-Code der Airline und einer Zahl (z.B. Flight-Code: SG (für die Airline SpiceJet) und die Zahl: 8709 -> SG-8709
* source\_city: Wo das Flugzeug startet
* Departure time: Wann das Flugzeug startet
* stops: wieviele Zwischenstops das Flugzeug bis zum Ziel hatte
* Arrival\_time: wann das Flugzeug am Ziel ankommt
* Destination\_city: Das Ziel
* class: Welche Klasse (Economy oder Business)
* Duration: Flugdauer in Stunden
* days\_left: Anzahl der Tage, die übrig sind bevor der Flug startet
* Price: Preis der Tickets







3. Data Cleaning



**Tool:** Excel



*  **Spalte "airline"**

Die Leerzeichen wurden bei zwei Airlines mit "\_" ersetzt, daher habe ich diese mit einem Leerzeichen ersetzt (mit STRG + H)



*  **Spalte "flight"**

Hier habe ich eine neue Spalte hinzugefügt: "flight\_code" -> jede Airline hat ihren eigenen code und es sollten genauso viele flight\_codes wie Airlines geben.

Habe in einem separaten Register ("flight\_code") die Anzahl der einzigartigen Airlines und die Anzahl der einzigartigen flight\_codes ausgerechnet -> Das Ergebnis: es gibt mehr flight\_codes als Airlines. Mit einer Pivot-Tabelle habe ich herausgefunden, dass die Airline "Indigo" drei verschiedene flight\_codes hat. Um herauszufinden, welche der drei flight\_codes von Indigo die Richtige ist, habe ich die Anzahl der flight\_codes ausgegeben, die im Dataset vorkommen. 6E kommt am meisten vor und ist der richtige flight\_code (auch nach kurzer recherche stellte es sich als der richtige flight\_code heraus).



Um die falschen flight\_codes besser zu filtern, habe ich eine neue Spalte ("flight\_code\_test") mit einer Funktion erstellt, die "stimmt" oder "stimmt nicht" ausgibt, je nachdem, ob der flight\_code mit der Airline übereinstimmt oder nicht. Ich habe die 6.00 mit 6,00 ersetzt und die Werte in Text umgewandelt.



* Spalte "Index"

Die Spalte Index habe ich in "ID" umbenannt.

 

* Spalte "source\_city"

Mit der Rechtschreibungsfunktion überprüft.



*  Spalte "departure\_time"

"\_" mit Leerzeichen ersetzt und mit Rechtschreibungsfunktion überprüft.



*  Spalte "stops"

"\_" mit Leerzeichen ersetzt und mit Rechtschreibungsfunktion überprüft.



*  Spalte "arrival\_time"

"\_" mit Leerzeichen ersetzt und mit Rechtschreibungsfunktion überprüft.



*  Spalte "destination\_city"

Mit der Rechtschreibungsfunktion überprüft.



*  Spalte "class"

Mit der Rechtschreibungsfunktion überprüft.



*  Spalte "duration"

Zuerst "." durch "," ersetzt. Werte in dieser Spalte in Zahlen umgewandelt (statt text).



*  Spalte "days\_left"

kurzer Blick in den Filter reicht, um zu sehen, dass diese Spalte passt.



*  Spalte "price"

kurzer Blick in den Filter reicht, um zu sehen, dass diese Spalte passt.







4\. Data Cleaning und EDA (Exploratory Data Analysis)



**Tool:** MySQL





* Database in MySQL hochladen

Zuerst ein neues Schema anlegen ("airline\_flight"). Dann mit CREATE TABLE die Tabelle mit den entsprechenden Datatypes erstellen und mit LOAD DATA INFILE die Daten hochladen. (mit dem Import Wizard geht es nicht, da es große Mengen an Daten sind).





* Data cleaning und oberflächliche EDA

1.  die Spalten flight\_code, flight\_number, id und flight\_code\_test löschen, da ich sie für die Analyse nicht benötige. Die id wird gelöscht, weil es nur eine Tabelle gibt, die Spalte ist somit überflüssig, wenn man eine weitere Tabelle hätte bräuchte man auch für die Analyse die ID (für Joins)
2. Mit einem CTE die Duplikate ausgeben: Neben dem "0.00E+00" gibt es bei vielen flight-codes mehrere Duplikate. Die flight-codes könnten im Zusammenhang mit der Flugroute stehen. -> Habe herausgefunden, dass zwar die ersten zwei Ziffern (z.B. SG) für die Airline stehen, aber die Nummern die danach kommen, weder mit der Flugroute, noch mit anderen (in dieser Database) Daten im Zusammenhang steht. -> Daher wird auch diese Spalte gelöscht (nicht wichtig für EDA).
3. Frage beantworten "wieviele Flüge hat jede Airline hinter sich?" bzw. "Welche der Airlines ist die beliebteste in Indien?": Vistara hat mit Abstand die meisten Flüge gefolgt von Air India und Indigo. Vistara macht 42,60% der Flüge aus, Air India macht 26,95% aus und Indigo macht 14,37% der Flüge aus. Vistara ist somit die beliebteste Airline in Indien.
4. in welcher Stadt starten die meisten Flüge?: 1.Delhi 2.Mumbai 3.Bangalore
5. in welcher Stadt landen die meisten Flieger: 1.Mumbai 2.Delhi 3.Bangalore -> Delhi, Mumbai und Bangalore sind bei beiden in den Top 3
6. Welche Airline ist in welchen Städten am meisten vertreten?: Da Vistara auch mit Abstand die meisten Flüge hinter sich hat, ist Vistara auch in jeder Stadt am meisten vertreten. Nochmal eine Bestätigung, dass Vistara die beliebteste Airline Indiens ist.
7. Welche Flugrouten sind am beliebteste?: 1.Delhi -> Mumbai 2. Mumbai -> Delhi 3. Delhi -> Bangalore
8. Wann starten die Flüge am meisten: 23,70% der Flüge starten morgens, 22,25% starten am frühen Morgen und 21,69% starten am Abend
9. Wann landen die Flieger am häufigsten?: 30.5% nachts, 26,09% abends und 20,90% morgens
10. weiviele stops werden gemacht (von jeder Airline)?: 1.ein stop - 83,58% 2. keine stops - 12% 3. zwei oder mehr stops - 4,43%
11. Welche Klasse wird am meisten gewählt?: zu 68,85 % wird die Klasse Economy gewählt statt der Business-Klasse - da die Economy-Klasse billiger ist. (die Airlines AirAsia, GO FIRST, Indigo und SpiceJet bieten nur Flüge mit Economy-class an, aber auch wenn man sich die Airlines ansieht, die sowohl Economy als auch Business anbieten, wählen Menschen öfter die Economy-Klasse)
12. Welche lange dauern die kürzesten bzw. längsten Flüge und welche Flugrouten wären das?:
    kürzesten Flüge: 1.Delhi <-> Bangalore - 10,07h 2.Mumbai <-> Delhi - 10,1h 3.Mumbai <-> Bangalore 11,26h
13. herausfinden, ob die Dauer des Flugs von der Airline abhängt: habe herausgefunden, dass die Airline Indigo von 30 Routen 22 davon (im Durchschnitt) die schnellste Airline ist.
14. hängt die Dauer des Flugs von der Klasse ab?: 29 von den 30 Flugrouten ist die Economy class schneller unterwegs.
15. wie lange dauern die Flüge mit 0, 1 und 2 oder mehreren stops?: 1.0 stops dauern durchschnittlich 2.19h, 2.1 stop dauert durchschnittlich 13,5h 3.2 oder mehrere stops dauern durchschnittlich 15,32h -> Flüge mit 0 Stops sind ungefähr 6-7x schneller als Flüge mit 1 oder mehreren stops.
16. welche Airline hat den höchsten, niedrigsten Preis und welcher Ticket-Preis ist im Durchschnitt am niedrigsten?: Den höchsten Ticket-Preis mit 123.071 hat die Airline Vistara erzielt, den niedrigsten Preis mit 1.105 teilen sich die drei Airlines AirAsia, Indigo und GO FIRST, und mit 4.091,07 hat die Airline AirAsia durchschnittlich den niedrigsten Preis.
17. Wie sieht der Preis bei den beiden Klassen (Economy und Business) aus?: wenn man sich die durchschnittlichen Economy- und Business-Preise der einzelnen Airlines ansieht, sieht man, dass der Business-Preis viel höher ist als der Economy-Preis, wenn man aber alle Airlines miteinbezieht ist der durchschnittliche Economy-Preis höher als der Business-Preis
18. Welche Flugroute ist die billigste/teuerste im Durchschnitt?: teuerste: Chennai <-> Bangalore mit 25.081,85 und billigste: Hyderabad <-> Delhi mit 17.298,00
19. wie hängt der Preis mit der Anzahl an Tagen, die bis zum Start verbleiben, ab?: Grundsätzlich gilt: je mehr Tage verbleiben, desto billiger die Tickets (es gibt ein paar Ausnahmen, aber grundsätzlich gilt dies.
20. Wie hängt der Preis von der Stadt ab, in dem der Flieger startet?: billigste: Delhi (18.951,33), teuerste: Chennai (21.995,34)
21. wie hängt der Preis vom Start-Zeitraum ab?: billigste: Late Night (9.295,30), teuerste: Night (23.062,15)





Data Visualization 



Tool: **Power BI**



1. Daten auf Power BI hochgeladen
2. Übersicht gestaltet: man sieht auf einer Karte alle Städte, die in der Database drinnen sind, dann sieht man die Anzahl der Flüge der einzelnen Airlines (Vistara ist rot gekennzeichnet, da es die meisten Flüge hinter sich hat), dann sieht man den durchschnittlichen Preis pro Airline, um sich einen Überblich zu verschaffen, welche Airline tendenziell billiger ist (AirAsia bietet durchschnittliche billigere Tickets an, daher rot gekennzeichnet, dann zwei Filter mit allen Airlines und den beiden Klassen, unter der Indien-Karte sieht man den allgemeinen durchschnittlichen Preis und die durchschnittliche Flugdauer aller Airlines (außer man wählt etwas aus in den Filtern) -> mein Ziel war es auf einen Blick zu erkennen um was es geht, welche Städte, airines und Klassen es gibt, und zu erkennen, welche die beliebteste Airline ist und welche Airline am billigsten ist, wenn man möchte kann man die Visualisierungen und Karten (durchschnittlicher Preis und durchschnittliche Flugdauer) filtern, indem man entweder eine oder mehrere Airlines und/oder eine der beiden Klassen auswählt.
3. dann habe ich paar neue Seiten erstellt, um Visualisierungen zu erstellen, um danach Gemeinsamkeiten zu erkennen (z.B. Trends
