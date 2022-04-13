---
title: "UPDATE: Elektrische steps in Nederland"
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

**Update** Deze pagina sprak over een pagina die is verwijderd van `rijksoverheid.nl`, dat is inmiddels rechtgezet zie [update WOB Verzoek](#update-wob-verzoek).

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

**Op 6 april 2022, is deze verwijderde pagina weer teruggeplaatst**, naar aanleiding van mijn [WOB Verzoek](#wob-verzoek). De informatie over steps met stepondersteuning, of de "meestepstep" zoals de overheid het noemt is te vinden op [deze pagina](https://www.rijksoverheid.nl/onderwerpen/voertuigen-op-de-weg/e-step-met-trapondersteuning).

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

### UPDATE WOB Verzoek

Binnen een week na het versturen van mijn WOB verzoek, werd ik gebeld door een medewerker van het Ministerie van Infrastructuur en Waterstaat.
We hebben de kern van mijn WOB verzoek besproken, namelijk dat er een agent mij een boete heeft uitgeschreven.
Hij heeft mij ook uitgelegd wat er met die pagina is gebeurt en dat het beleid **nog** niet is aangepast.

De belofte dat die pagina op zeer korte termijn terug zou komen (dat inmiddels ook is [gebeurt](https://www.rijksoverheid.nl/onderwerpen/voertuigen-op-de-weg/e-step-met-trapondersteuning)), is voor mij voldoende reden om af te zien van het boven tafel krijgen van alle informatie rondom het tot stand komen en verwijderen van deze pagina.

> In uw verzoek vroeg u ook om informatie over de totstandkoming van het beleid te aanzien van de meestepstep. De huidige status van de meestepstep is eigenlijk het gevolg van een interpretatie van de step (zonder motor) in relatie tot de fiets. In enkele burgervragen (sinds 2017) is het ministerie is gevraagd of een step moet worden gezien als een fiets en (indien ja) of een step met elektrische ondersteuning dan ook moet worden gezien als een fiets met elektrische ondersteuning. In de beantwoording op deze vragen is daarbij steeds de lijn gehanteerd dat een step moet worden gezien als een fiets en (daarmee) een step met ondersteuning moet worden gezien als een fiets met ondersteuning. De totstandkoming van het beleid is dus de (consequente) beantwoording van burgervragen met bovenstaande interpretatie van de step in relatie tot de fiets. Aangezien er nadien geen andere regelgeving is gekomen die iets anders regelt over de meestepstep, is bovenstaande interpretatie dus het beleid ten aanzien van de meestepstep.
>
> In de beantwoording is wel steeds gezegd dat de regels voor de fiets met ondersteuning dan ook wel allemaal gelden. Er moet dus sprake zijn van een ondersteunende motor die de stepbeweging versterkt, de ondersteuning neemt bij hogere snelheden geleidelijk aan af en stopt geheel bij 25 km/u en de ondersteunende motor heeft een vermogen van ten hoogste 250 Watt. Alleen wanneer aan al deze voorwaarden is voldaan geldt bovenstaande interpretatie **fiets-met-ondersteuning = step-met-ondersteuning**.
>
> -- Ambtenaar Ministerie Infrastructuur en Waterstaat

## Conclusie, stop met achter de feiten aanlopen

De Nederlandse regering is het het prutsen met regels rondom elektrische steps. ~~De kraakheldere informatie over steps met ondersteuning die op de website van de Nederlandse overheid stond, is verwijderd (oke, gek, maar kan gebeuren). Maar daarna is deze informatie ook actief uit het sitearchief gegooid, dat is raar. Binnenkort meer informatie hierover.~~

Schijnbaar worden er door de overheid [afgepakte steps verkocht](https://www.rtlnieuws.nl/tech/artikel/5032031/overheid-verkoopt-elektrische-steps-die-de-weg-niet-op-mogen), dat vind ik ronduit crimineel. Ik raad iedereen daarom strek aan zijn/haar step te markeren met stickers of door je naam erin te krassen. Stel dat die dan wordt afgepakt en je komt hem op een veiligsite tegen dan kan je de overheid daar op aanspreken.

Op "korte termijn" gaan ze elektrische steps reguleren, lees ergens in 2023.
Ze zijn daarin erg geïnspireerd door de Duitse regels rondom elektrische steps (verplicht helm en brommerverzekering).
Ik ben nog niet bijzonder enthousiast over de plannen die er liggen rondom LEV's, maar goed er gebeurt is, dat is beter dan jaren niks doen.

~~Er ligt zelfs een [voorstel](https://nieuwestep.nl/wetgeving/deelsteps-rotterdam/) om eerst een jaar met deel-steps te gaan experimenteren, alvorens eigen steps toe te staan. Dat is wat mij betreft de omgedraaide wereld.~~

> Er mag pas met deelsteps worden geëxperimenteerd als dat model step officieel de weg op mag. Het is niet zo dat een gemeente hier een uitzondering op kan maken. Wellicht is dat specifieke model niet verkrijgbaar voor particulieren, dat kunnen we op voorhand niet zeggen.
>
> -- Ambtenaar Ministerie Infrastructuur en Waterstaat

Als laatste de vraag of een elektrische step nu echt zoveel gevaarlijker is dan een elektrische fiets. Ligt dat niet ook voor een groot deel aan de berijder van de fiets/step? Iemand die nog nooit op een elektrische fiets heeft gezeten en ineens met 30 km/u voorbij zoeft hoeft ook niet perse heel veilig te zijn.
Ik heb ook nog nooit gezien dat er een elektrische fiets op een rollerbank staat (is ook erg lastig), maar ik betwijfel of ze allemaal wel echt zijn gelimiteerd op 25 km/u.

Heb je vergelijkbare ervaringen of wil je hier iets over kwijt? Stuur me even een bericht op [twitter @svrooij](https://twitter.com/svrooij).
