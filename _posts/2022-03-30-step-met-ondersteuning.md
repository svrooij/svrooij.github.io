---
title: "Elektrische steps in Nederland"
published: true
categories:
  - Frustration
tags:
  - Rijksoverheid
  - Elektrische step
twitter_image: /assets/images/2022/03/e-step-verboden.png
---

Nederland roept al jaren dat het technologisch voor wil lopen op de rest. We hebben enorm veel dingen uitgevonden in Nederland, Videobanden, bluetooth, enzovoort. Maar op het gebied van vervoersmiddelen lopen we echt enorm achter. In heel Europa zie je overal elektrische steps, in mijn ogen een super goede manier om mensen uit hun auto te krijgen.

![Elektrische step... levensgevaarlijk...](/assets/images/2022/03/e-step-verboden.png)

<!--more-->

## Waar ging het mis

Ik weet natuurlijk niet precies waar het mis ging, maar hier wat ik ervan denk. Er is ooit door de Minister van Infrastructuur en waterstaat (waar verkeer onder valt), besloten om een elektrische bolderkar waar 12 kleine kinderen in passen, goed te keuren als een "bijzondere bromfiets". De minister heeft daar een bevoegdheid voor, net als hij/zij dat zou kunnen doen voor een elektrische step.

Helaas is er toen een tragisch ongeval voorgevallen waarbij zo'n bolderkar in botsing kwam met een trein, na dit voorval heeft de minister haar/zijn bevoegdheid niet meer gebruikt om te oordelen over het toelaten van elektrische voertuigen.

### Elektrische step is geen bolderkar

Een elektrische step is in geen geval te vergelijken met een bolderkar. Je kan er geen passagiers op vervoeren of spullen op meenemen. In heel veel landen in Europa kan je al dan niet met een helm en/of verzekeringsplaatje, gewoon de weg op met een elektrische step. Het verbaasd mij dat er in Nederland nog geen regels over zijn en dat er al jaren stug wordt vastgehouden aan het "NIET TOEGESTAAN"-beleid.

## Wat mag wel

Die goedkeuring die de minister kan verlenen aan "bijzondere bromfietsen", is wel verleend voor de volgende voertuigen. Dus een **E-One** (wat een gedrocht), mag wel op de openbare weg en moet als bromfiets zelfs op het fietspad, maar een elektrische step is echt te gevaarlijk?

- [E-One](https://zoek.officielebekendmakingen.nl/stcrt-2014-15896.html)
- [Qugo Runner](https://zoek.officielebekendmakingen.nl/stcrt-2018-25460.html)

## Step met "trapondersteuning"

In Nederland heb je wel elektrische fietsen, die maar [beperkte voorwaarden](https://www.rijksoverheid.nl/onderwerpen/fiets/vraag-en-antwoord/welke-regels-gelden-voor-mijn-elektrische-fiets-e-bike) hebben. Er is in ieder geval geen kenteken voor verplicht en geen helm.

Leverancier **Micro** heeft een oplossing gevonden voor de Nederlandse markt, namelijk de [Micro M1 Colibri NL](https://www.micro-step.nl/nl/emicro-m1-colibri-nl.html). Met deze step mag je op de openbare weg omdat:

> De Micro Colibri NL is een elektrische step die speciaal voor de Nederlandse markt is aangepast. Hij heeft alleen trapondersteuning, waardoor hij onder de fietswetgeving valt. Hij hoeft dus ook niet apart gekeurd te worden door de RDW en heeft geen verzekeringsplaatje nodig. De Colibri NL mag worden gebruikt op het fietspad.

De Nederlandse regering heeft bevestigd dat deze step onder dezelfde regels als een elektrische fiets op de weg mag. Ze hadden er zelfs een artikel aan besteed op [rijksoverheid.nl](https://rijksoverheid.nl) `Verkeer en vervoer` -> `Bijzondere voertuigen` -> `Elektrische step met trapondersteuning`, op 8 juli 2021 kwam onderstaande pagina online, na iets meer dan een maand (rond 18 augustus 2021) is deze pagina helaas weer [verwijderd](https://www.rijksoverheid.nl/onderwerpen/bijzondere-voertuigen/e-step-met-trapondersteuning).

![Elektrische step met ondersteuning](/assets/images/2022/03/e-step-pagina.png)

Het is andere mensen ook opgevallen dat deze pagina is verwijderd, zij hebben daar vragen over gesteld bij het ministerie en het volgende antwoord gekregen. "We hebben informatie gestroomlijnd en daarom deze pagina met kraakheldere informatie verwijderd"...

![Elektrische step pagina verwijderd](/assets/images/2022/03/e-step-pagina-verwijderd.png)

## Step ombouwen

Er is dus in ieder geval 1 model step toegelaten op de openbare weg, zouden die regels dan niet voor alle vergelijkbare apparaten moeten gelden?

De Micro M1, is **softwarematig** aangepast om enkel step-ondersteuning (trapondersteuning tijdens het steppen) te geven, dit apparaat heeft nog wel een gashendel maar die is softwarematig uitgeschakeld.

Van mijn elektrische step is de gashendel **verwijderd**, waar de gashendel zat aangesloten (in het frame), zit nu een Arduino. Die meet of je stept (door het signaal van de motorcontroller uit te lezen en de snelheid te vergelijken met de vorige waardes), bij een gedetecteerde snelheidsverhoging wordt er maximaal 5 seconden "gas" gegeven.
Daarna moet je weer steppen anders rolt die uit en sta je daarna stil. In mijn specifieke geval heb ik zelf een snelheidslimiet van 22 km/u ingesteld, dat vind ik snel genoeg en is tevens onder de maximale snelheid van 25 km/u die geldt voor elektrische fietsen.

Het ombouwen van een elektrische step naar een step met step-ondersteuning is een kwestie van een paar componenten, wat gereedschap en 15 minuten werk (voor de gevorderde ombouwer).

## Boete en waarschuwing

Gisteren werd ik in Eindhoven in de buurt van het Videolab op Strijp-S (je weet wel, waar de videoband is uitgevonden) aangehouden door een motoragent. Vervolgens moest ik hem volgen en werd ik naar een plek geloodst waar nog veel meer agenten stonden. De motoragent zei tegen een collega, "handel jij dit even af?", waarop de andere agent zegt "ik weet niet wat ik hiermee moet, kan je dat niet zelf even doen".

Vervolgens begint de licht geïrriteerde motoragent direct een boete uit te schrijven en geeft mij ook een waarschuwing dat ze de volgende keer mijn step met ondersteuning afpakken. Mijn uitleg over de "trapondersteuning" werd compleet genegeerd, "nee dit is een elektrische step en die wordt **NOOIT** toegelaten op de Nederlandse weg". Geen probleem als een al wat oudere agent, niet op de hoogte is van alle nieuwe regels en de (verwijderde) uitleg daarover. Toen hij zijn diploma haalde waren er waarschijnlijk nog niet eens elektrische fietsen, dus hij kan onmogelijk toen al die regels hebben moeten leren.

Bij het geven van een verklaring heb ik dan ook verklaart: "het is een step met step-ondersteuning en valt daarmee onder dezelfde regels als een elektrische fiets. Er zit geen gashendel op en ik wil dat jullie dat ook vastleggen". Ze wilde eigenlijk alleen foto's maken van de onderkant en van de model sticker, ik heb expliciet gevraagd of ze ook een foto van het stuur konden maken, om aan de officier van justitie aan te tonen dat er **geen** gashendel op zat ten tijde van de staande houding.

Is een gashendel/gaspedaal niet een vereiste om iets een elektrische step te kunnen noemen?

Score: een **waarschuwing**, de volgende keer pakken ze hem af en een **boete**. Ze weten nog niet hoe hoog die boete wordt, dat bepaald de officier van justitie.

## WOB verzoek

Dit is allemaal heel recent gebeurt, dus ik heb de boete nog niet binnen, maar ik heb wel alvast een [WOB verzoek](/assets/images/2022/03/wob-verzoek.pdf) ingediend om het hele proces rondom het ontstaan en het verwijderen van het artikel over steps met trapondersteuning boven tafel te krijgen.

Ik vraag het ministerie om de volgende gegevens en zal het resultaat hier ook plaatsten:

1. Alle interne communicatie over de totstandkoming van het bewuste artikel.
2. De complete tekst van het (per abuis) verwijderde artikel.
3. Alle interne/externe communicatie die heeft geleid tot de verwijdering van dit artikel op rijksoverheid.nl
4. Alle interne/externe communicatie die heeft geleid tot het verwijderen van dit artikel uit het officiële sitearchief.
5. Officiële beleid rondom een step met trapondersteuning.

## Conclusie, stop met achter de feiten aanlopen

De Nederlandse regering is het het prutsen met regels rondom elektrische steps. De kraakheldere informatie over steps met ondersteuning die op de website van de Nederlandse overheid stond, is verwijderd (oke, gek, maar kan gebeuren). Maar daarna is deze informatie ook actief uit het sitearchief gegooid, dat is raar. Binnenkort meer informatie hierover.

Als je als overheid [afgepakte steps verkoopt](https://www.rtlnieuws.nl/tech/artikel/5032031/overheid-verkoopt-elektrische-steps-die-de-weg-niet-op-mogen) dan vind ik dat ronduit crimineel. Ik weet niet zo goed hoe je daar op kan reageren. Maar het lijkt me dat je zo'n step dus moet markeren met je eigen naam en daarna de website van de bekende boedel veiling sites in de gaten moet houden.

Men is nu van plan om dit ergens in 2023 te gaan reguleren. Ze zijn daarin erg geïnspireerd door de Duitse regels rondom elektrische steps (verplicht helm en brommerverzekering).

Aan de ene kant ben ik blij dat er eigenlijk iets gaat gebeuren op dit gebied, de voorgestelde regels vind ik erg pamperend maar goed iets is beter dan niets. Ik ben teleurgesteld in de vorige minister (die de stint heeft goedgekeurd) en teleurgesteld in de nieuwe minster omdat er op dit punt nog steeds niks is veranderd. Er ligt zelfs een [voorstel](https://nieuwestep.nl/wetgeving/deelsteps-rotterdam/) om eerst een jaar met deel-steps te gaan experimenteren, alvorens eigen steps toe te staan. Dat is wat mij betreft de omgedraaide wereld.

Misschien zijn mensen boven de 50 met een elektrische fiets wel gevaarlijker dan iemand op een elektrische step?
Soms zoeven elektrische fietsen echt met hoge snelheid voorbij, ik heb er nog nooit een op een rollerbank zien staan. (Lijkt me ook best lastig, trouwens)

Heb je vergelijkbare ervaringen of wil je hier iets over kwijt? Stuur me even een bericht op [twitter @svrooij](https://twitter.com/svrooij).
