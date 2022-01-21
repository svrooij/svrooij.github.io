---
id: 167
title: XS4All glasvezel met eigen router
date: 2017-08-04T13:46:58+01:00


guid: https://svrooij.nl/?p=167
old_permalink: /2017/08/xs4all-glasvezel-met-eigen-router/
twitter_image: /assets/images/2017/08/xs4all_glasvezel_eigen_router.png
categories:
  - Geen categorie
tags:
  - interactieve TV
  - kpn
  - netwerk
  - xs4all
---
**UPDATE**: XS4ALL drukt de laatste tijd zijn routed IPTV bij iedereen door de strot. Deze handleiding ging over bridged IPTV, dat is niet meer mogelijk. De reacties zijn daarom ook gesloten.

Standaard krijg je bij XS4All glasvezel tegenwoordig een <a href="https://nl.hardware.info/product/358976/avm-fritzbox-5490/specificaties" target="_blank" rel="noopener noreferrer">Fritz!Box 5490</a>. Dit is een consumenten router met een rechtstreekse glasvezel aansluiting. Vanuit XS4All gezien een slimme keuze, want dat scheelt een kastje in de meterkast dat ook kapot kan gaan.

Maar er zijn ook andere mogelijkheden, met een beetje technische kennis en wat extra apparatuur is het ook mogelijk om gewoon je oude router te blijven gebruiken. En nog steeds TV te kunnen kijken.

<!--more-->

## VLANS

XS4All maakt gebruik van de infrastructuur van KPN (het is namelijk een dochter maatschappij van KPN). KPN biedt op zijn glasvezel netwerk 3 VLAN's aan, waarschijnlijk omdat dat netwerk technisch makkelijker te beheren is.

  * VLAN 4, dit is het televisie vlan.
  * VLAN 6, dit is het internet vlan.
  * VLAN 7, dit is het telefonie vlan.

De Fritzbox kan deze VLAN's automatisch uitsplitsen voor de verschillende soorten doelen. Niet alle routers kunnen hier (zonder extra configuratie) mee omgaan. Daarnaast heb je een kastje nodig om de glasvezel aansluiting om te zetten naar een Ethernet aansluiting, hiervoor gebruik je een zogenoemde NTU.

### Boodschappenlijst:

  * Een kastje om glasvezel om te zetten naar Ethernet, veel gebruikt is de **ZTE F3100**. Deze is soms te koop op marktplaats, als het goed is kan je deze ook via XS4All aanvragen, maar dan moet je waarschijnlijk je Fritzbox terugsturen.
  * Een kleine **Managed** switch met ondersteuning voor **IGMP Snooping** en **VLANS**. Succesvol getest met TP-Link <a href="https://tweakers.net/pricewatch/411190/tp-link-tl-sg105e-gigabit-easy-smart-switch-met-5-aansluitingen.html" target="_blank" rel="noopener noreferrer">TL-SG105E</a>.
  * Eigen router die snel genoeg is voor je abonnement.

## Huidige configuratie:

![Eigen router](/assets/images/2017/08/xs4all_glasvezel_eigen_router.png)

Dit plaatje is een weergave ons onze huidige configuratie, ik kan helaas geen garantie geven dat KPN overal dezelfde configuratie hanteerd.

  * Glasvezel wordt opgezet naar Ethernet, via een ZTE F3100 media converter (soms ook wel NTU genoemd).
  * Via ethernet gaat het signaal naar een TP-Link smart switch, die het verkeer uitsplitst. 
      * Een poort (1) is geconfigureerd op VLAN 4 en 6 (beide tagged) deze is aangesloten op de ZTE
      * Een poort (2) is geconfigureerd op VLAN 6 (tagged of untagged afhankelijk van je router configuratie) deze gaat naar de router.
      * Twee poorten (3 & 4) zijn geconfigureerd op VLAN 4 (untagged, erg belangrijk) en deze zijn met een kabel verbonden met de tv kastjes.

Dit heeft als voordeel dat het TV verkeer wordt afgesplitst voordat het door de router gaat. De router hoeft dus niks te doen voor het TV verkeer. En wordt hier dus ook niet door belast.

## Configuratie TP-Link TL-SG105e

Bij het instellen van de switch zijn twee dingen heel belangrijk, je moet IGMP snooping aanzetten. En je moet de VLANS configureren via 802.1Q VLAN instellingen.

![sg105e](/assets/images/2017/08/tl-sg105e_xs4all_igmp.png)

Ga naar Switching => IGMP Snooping en zorg dat het op Enabled staat.

![VLANS](/assets/images/2017/08/tl-sg105e_xs4all_vlans.png)

Ga naar VLAN => 802.1Q VLAN en neem de instellingen over.

## Conclusie

Het is ook met XS4All mogelijk om gebruik te blijven maken van je eigen router, met mogelijk meer functionaliteit. Je hebt er alleen wel wat technische kennis voor nodig. En het kost in ieder geval €30 voor deze extra switch, ervan uitgaande dat je de benodigde Media Converter rechtstreeks van XS4All krijgt (tip: vraag de monteur, misschien heeft die er nog eentje die over was van een andere klant).