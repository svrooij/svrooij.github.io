---
id: 308
title: Professioneel online presenteren
date: 2020-04-07T15:37:47+01:00


guid: http://svrooij.nl/?p=308
old_permalink: /2020/04/professioneel-online-presenteren/
spay_email:
  - ""
twitter_image: /assets/images/2020/04/obs_screenshot.png
categories:
  - Lifehack
tags:
  - lesgeven
  - presenteren
  - streamen
---
Iedereen is steeds meer online aan het communiceren op dit moment, dat is heel begrijpelijk in de huidige situatie. Hier zal ik in het kort proberen uit te leggen hoe je redelijk eenvoudig een professionele presentatie kan geven.<figure class="wp-block-gallery columns-2 is-cropped">

<!--more-->

Normaal webcam beeld

![normaal presenteren](/assets/images/2020/04/webcam.png)

**Iets professioneler?**

![professioneel presenteren](/assets/images/2020/04/webcam_software.png)

## Benodigdheden

Wat je nodig hebt hangt een beetje af van hoe ver je wil gaan met de presentatie kwaliteit, dus laat ik beginnen met de gratis software.

* Een windows laptop (op mac heb je helaas geen virtuele webcam)
* <a rel="noreferrer noopener" aria-label="OBS Studio (opens in a new tab)" href="https://obsproject.com/" target="_blank">OBS Studio</a>
* <a rel="noreferrer noopener" aria-label="NDI Tools (opens in a new tab)" href="https://ndi.tv/tools/" target="_blank">NDI Tools</a> (eigenlijk het je alleen Virtual input nodig)
* <a href="https://obsproject.com/forum/resources/obs-ndi-newtek-ndi%E2%84%A2-integration-into-obs-studio.528/" target="_blank" rel="noreferrer noopener" aria-label="OBS-ndi (opens in a new tab)">OBS-ndi</a> 

## Open broadcast studio

Open broadcast studio is een gratis programma dat heel veel wordt gebruikt door streamers. Je kan er verschillende scenes in maken en (vloeiend) overschakelen tussen verschillende scenes. Zelf heb ik een scene gemaakt met de webcam en een logo en daarnaast een scene met een browser scherm en de webcam daar overheen. <a rel="noreferrer noopener" aria-label="Kijk hier een filmpje (opens in a new tab)" href="https://www.youtube.com/watch?v=tmfDSzOcJ8E" target="_blank">Kijk hier een filmpje</a> hoe scenes werken in OBS.

## NDI Tools

NDI tools is een verzameling van tools voor distributie van digitale video over het netwerk. Wij gaan de virtuele input gebruiken om de output van OBS te kunnen gebruiken als webcam in andere software (zoals Microsoft Teams, Google meets en <a rel="noreferrer noopener" aria-label="Jitsi (opens in a new tab)" href="https://jitsi.org/jitsi-meet/" target="_blank">Jitsi</a>).

## OBS-ndi

OBS-ndi is een plugin voor OBS, deze plugin zorgt ervoor dat OBS een NDI bron maakt van de output van OBS Studio. Deze bron koppelen we aan de virtuele input van NDI tools &#8211; virtual input.

## Alles instellen

Installeer bovenstaande tools in deze volgorde, <a rel="noreferrer noopener" aria-label="Scott Hanselmann (opens in a new tab)" href="https://twitter.com/shanselman" target="_blank">Scott Hanselmann</a> heeft hier een goede <a rel="noreferrer noopener" aria-label="handleiding  (opens in a new tab)" href="https://www.hanselman.com/blog/TakeRemoteWorkerEducatorWebcamVideoCallsToTheNextLevelWithOBSNDIToolsAndElgatoStreamDeck.aspx" target="_blank">handleiding </a>over geschreven.  
Uiteindelijk koppel je alles aan elkaar.  
In OBS ga je naar **Tools -> NDI Output settings**. Daar selecteer je **Main Output**.  
Vervolgens open je **NDI Virtual Input** en selecteer **je computer naam** -> **OBS.**  
En kies in je vergader programma naar keuze de **NewTek NDI Video** als webcam, zo ziet dat er in teams uit:<figure class="wp-block-image size-large">

![select NDI](/assets/images/2020/04/teams_selecteer_ndi.png)

## Extra: softwarematig green screen

Tot zover de gratis tools. Mocht je over een echt green screen beschikken dan heb je in OBS ook de mogelijkheid om de groene achtergrond weg te toveren. Als je nu thuis geen green screen hebt, kan je misschien eens kijken naar <a rel="noreferrer noopener" aria-label="XSplit Vcam (opens in a new tab)" href="https://www.xsplit.com/vcam" target="_blank">XSplit Vcam</a>, deze software werkt perfect in combinatie met OBS en is in staat om je achtergrond bijna feilloos weg te halen.  
Een standaard licentie kost normaal $49,95 maar via <a rel="noreferrer noopener" aria-label="deze link (opens in a new tab)" href="https://shop.mashable.com/sales/xsplit-vcam-lifetime-subscription?rid=5730100" target="_blank">deze link</a> kan je hem kopen voor **$19,95**.  
Zelf ben ik erg enthousiast over XSplit VCam waar ik dan ook graag voor heb betaald (gelukkig was die in de aanbieding bij Mashable).

## Hardware: Speciale microfoon

Naast software kan je je presentatie ook echt upgraden door het aanschaffen van een losse microfoon. Ik wilde zelf niet teveel uitgeven dus ik ben gegaan voor de <a rel="noreferrer noopener" aria-label="Trust GXT 232 (opens in a new tab)" href="https://www.trust.com/en/product/22656-gxt-232-mantis-streaming-microphone" target="_blank">Trust GXT 232</a>, kostte €39,95 bij de lokale media markt.

**Ik raad deze microfoon af, is al 2 keer kapot gegaan en werkt maar half.**

Deze microfoon zorgt ervoor dat mijn stem nu ineens kraakhelder is en dat ik veel beter te verstaan ben in alle meetings. Via de USB kabel kan je deze microfoon direct op je laptop aansluiten. Er verschijnt dan een extra microfoon in de microfoon-keuze-lijst in je vergader programma. Ik heb bewust voor een microfoon met USB aansluiting gekozen omdat het geluid dan digitaal binnenkomt op een manier die precies is afgestemd op de microfoon zelf. Je hebt ook microfoons met een microfoon aansluiting, maar dan moet je laptop maar net zo'n aansluiting hebben.

![Trust mic](/assets/images/2020/04/trust-gxt-232-mantis-streaming-microphone.jpg)

## Hardware: Losse webcam

Mijn laptop (Dell XPS 15) heeft op zich een redelijke webcam, echter is de positie (aan de onderkant van het scherm) totaal verkeerd voor een goede presentatie. Op dit moment zijn er maar weinig webcams niet uitverkocht, dus deze extra optie moet je misschien tot later uitstellen.  
Een losse webcam geeft over het algemeen (als je er niet eentje van 10 euro hebt gekocht) al meteen een veel beter beeld dan een ingebouwde webcam. Deze kan je ook veel beter richten, mijne staat bijvoorbeeld op mijn losse monitor en daar kijk ik dus ook echt in als ik aan het presenteren ben.  
Zelf ben ik heel erg te spreken over de <a rel="noreferrer noopener" aria-label="Logitech C920 HD Pro webcam (opens in a new tab)" href="https://www.logitech.com/nl-nl/product/hd-pro-webcam-c920" target="_blank">Logitech C920 HD Pro webcam</a>, maar ik kan op dit moment geen leverancier vinden waar je deze kan bestellen.

## Conslusie

Gratis kan je je presentatie al een hele upgrade geven door gebruik te maken van de combinatie van de gratis tools beschreven op deze pagina. Door een beetje geld uit te geven aan XSplit Vcam heb je een softwarematig green screen die echt best goed werkt. En voor een echte upgrade kan je overwegen om een losse webcam en/of een losse microfoon aan te schaffen.  
Ik ben benieuwd naar jullie meest gebruikte scenes, dus plaats er een screenshot van op twitter en zet er @svrooij bij.

![OBS screenshot](/assets/images/2020/04/obs_screenshot.png)
