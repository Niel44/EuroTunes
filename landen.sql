-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Gegenereerd op: 01 dec 2025 om 09:31
-- Serverversie: 10.4.32-MariaDB
-- PHP-versie: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `eurotunes`
--

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `landen`
--

CREATE TABLE `landen` (
  `id` int(11) NOT NULL,
  `land_code` varchar(3) NOT NULL,
  `naam` varchar(100) NOT NULL,
  `hoofdstad` varchar(100) DEFAULT NULL,
  `vlag_url` varchar(255) DEFAULT NULL,
  `info_tekst` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `landen`
--

INSERT INTO `landen` (`id`, `land_code`, `naam`, `hoofdstad`, `vlag_url`, `info_tekst`) VALUES
(1, 'NL', 'Nederland', 'Amsterdam', 'https://upload.wikimedia.org/wikipedia/commons/2/20/Flag_of_the_Netherlands.svg', 'Nederland heeft meer fietsen (ongeveer 23 miljoen) dan inwoners (ongeveer 17,8 miljoen). Een kwart van het land ligt onder zeeniveau.'),
(2, 'DE', 'Duitsland', 'Berlijn', 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/ba/Flag_of_Germany.svg/1920px-Flag_of_Germany.svg.png', 'Fanta is uitgevonden in Duitsland tijdens de Tweede Wereldoorlog, als gevolg van een tekort aan Coca-Cola siroop.'),
(3, 'BE', 'België', 'Brussel', 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Flag_of_Belgium.svg/250px-Flag_of_Belgium.svg.png', 'België is de bakermat van het stripverhaal; iconen als Kuifje, Suske en Wiske, en De Smurfen komen allemaal hier vandaan.'),
(4, 'FR', 'Frankrijk', 'Parijs', 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c3/Flag_of_France.svg/250px-Flag_of_France.svg.png', 'De Tour de France, \'s werelds beroemdste wielerwedstrijd, wordt al sinds 1903 (met onderbrekingen) in Frankrijk gehouden.'),
(5, 'LU', 'Luxemburg', 'Luxemburg', 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/da/Flag_of_Luxembourg.svg/250px-Flag_of_Luxembourg.svg.png', 'Luxemburg was in 2020 het eerste land ter wereld dat al het openbaar vervoer (bussen, treinen en trams) volledig gratis maakte.'),
(6, 'SE', 'Zweden', 'Stockholm', 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4c/Flag_of_Sweden.svg/250px-Flag_of_Sweden.svg.png', '\'Fika\' is een essentieel onderdeel van de Zweedse cultuur. Het is een pauze voor koffie en gebak met collega\'s of vrienden, en wordt gezien als een belangrijk sociaal ritueel.'),
(7, 'IT', 'Italië', 'Rome', 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/03/Flag_of_Italy.svg/250px-Flag_of_Italy.svg.png', 'Italië heeft (samen met China) de meeste UNESCO Werelderfgoedlocaties ter wereld.'),
(8, 'ES', 'Spanje', 'Madrid', 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/Flag_of_Spain.svg/330px-Flag_of_Spain.svg.png', 'Spanje is de enige bananenproducent in Europa. De bananen worden verbouwd op de Canarische Eilanden, die een subtropisch klimaat hebben.'),
(9, 'GB', 'Verenigd Koninkrijk', 'London', 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/83/Flag_of_the_United_Kingdom_%283-5%29.svg/250px-Flag_of_the_United_Kingdom_%283-5%29.svg.png', 'Windsor Castle is het oudste en grootste bewoonde kasteel ter wereld. Het is al bijna 1000 jaar de thuisbasis van de Britse monarchie.'),
(10, 'DK', 'Denemarken', 'Kopenhagen', 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9c/Flag_of_Denmark.svg/250px-Flag_of_Denmark.svg.png', 'De wereldberoemde Legosteentjes zijn uitgevonden in Denemarken. De naam \'Lego\' is een afkorting van het Deense \'leg godt\', wat \'speel goed\' betekent.'),
(11, 'NO', 'Noorwegen', 'Oslo', 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Flag_of_Norway.svg/250px-Flag_of_Norway.svg.png', 'De kaasschaaf (Ostehøvel) is een Noorse uitvinding, gepatenteerd in 1925 door Thor Bjørklund.'),
(12, 'FI', 'Finland', 'Helsinki', 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/bc/Flag_of_Finland.svg/250px-Flag_of_Finland.svg.png', 'Finland staat bekend als het \'Land van de Duizend Meren\', maar telt er in werkelijkheid bijna 188.000. Er zijn ook meer sauna\'s dan auto\'s in het land.'),
(13, 'CH', 'Zwitserland', 'Bern', 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/08/Flag_of_Switzerland_%28Pantone%29.svg/250px-Flag_of_Switzerland_%28Pantone%29.svg.png', 'Hoewel cacao uit Zuid-Amerika komt, werd de melkchocolade in 1875 in Zwitserland uitgevonden door Daniel Peter, die melkpoeder (uitgevonden door Henri Nestlé) toevoegde.'),
(14, 'AT', 'Oostenrijk', 'Wenen', 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/41/Flag_of_Austria.svg/250px-Flag_of_Austria.svg.png', 'De Tiergarten Schönbrunn in Wenen is de oudste dierentuin ter wereld die nog steeds in gebruik is, geopend in 1752.'),
(15, 'AL', 'Albanië', 'Tirana', 'https://upload.wikimedia.org/wikipedia/commons/3/36/Flag_of_Albania.svg', 'Albanië heeft meer dan 170.000 bunkers, gebouwd tijdens het communistische bewind van Enver Hoxha.'),
(16, 'AD', 'Andorra', 'Andorra la Vella', 'https://upload.wikimedia.org/wikipedia/commons/1/19/Flag_of_Andorra.svg', 'Andorra is het enige \'co-vorstendom\' ter wereld, geleid door twee vorsten: de bisschop van Urgell in Spanje en de president van Frankrijk.'),
(17, 'AM', 'Armenië', 'Jerevan', 'https://upload.wikimedia.org/wikipedia/commons/2/2f/Flag_of_Armenia.svg', 'Armenië was het eerste land ter wereld dat het christendom als staatsreligie aannam, in 301 na Christus.'),
(18, 'AZ', 'Azerbeidzjan', 'Bakoe', 'https://upload.wikimedia.org/wikipedia/commons/d/dd/Flag_of_Azerbaijan.svg', 'Azerbeidzjan staat bekend als het \'Land van Vuur\', mede dankzij de Yanar Dag, een heuvel die al duizenden jaren constant brandt door natuurlijk aardgas.'),
(19, 'BA', 'Bosnië en Herzegovina', 'Sarajevo', 'https://upload.wikimedia.org/wikipedia/commons/b/bf/Flag_of_Bosnia_and_Herzegovina.svg', 'Het land heeft de bijnaam \'het hartvormige land\' (Zemlja u obliku srca) vanwege de vage hartvorm op de kaart.'),
(20, 'BG', 'Bulgarije', 'Sofia', 'https://upload.wikimedia.org/wikipedia/commons/9/9a/Flag_of_Bulgaria.svg', 'Bulgarije is het thuisland van het Cyrillische alfabet, dat in de 9e eeuw in het Eerste Bulgaarse Rijk werd ontwikkeld.'),
(21, 'CY', 'Cyprus', 'Nicosia', 'https://upload.wikimedia.org/wikipedia/commons/d/d4/Flag_of_Cyprus.svg', 'Volgens de Griekse mythologie is Cyprus de geboorteplaats van Aphrodite, de godin van de liefde en schoonheid.'),
(22, 'EE', 'Estland', 'Tallinn', 'https://upload.wikimedia.org/wikipedia/commons/8/8f/Flag_of_Estonia.svg', 'Estland heeft de meeste start-ups per hoofd van de bevolking in Europa en was het eerste land ter wereld dat online stemmen (i-Voting) invoerde.'),
(23, 'GE', 'Georgië', 'Tbilisi', 'https://upload.wikimedia.org/wikipedia/commons/0/0f/Flag_of_Georgia.svg', 'Georgië wordt beschouwd als de \'bakermat van de wijn\'. Archeologen hebben bewijs gevonden van wijnproductie die 8.000 jaar teruggaat.'),
(24, 'GR', 'Griekenland', 'Athene', 'https://upload.wikimedia.org/wikipedia/commons/5/5c/Flag_of_Greece.svg', 'De Olympische Spelen vinden hun oorsprong in Griekenland en werden voor het eerst gehouden in Olympia in 776 v.Chr.'),
(25, 'HU', 'Hongarije', 'Boedapest', 'https://upload.wikimedia.org/wikipedia/commons/c/c1/Flag_of_Hungary.svg', 'De Rubiks Kubus is uitgevonden in 1974 door de Hongaarse architect en professor Ernő Rubik.'),
(26, 'IE', 'Ierland', 'Dublin', 'https://upload.wikimedia.org/wikipedia/commons/4/45/Flag_of_Ireland.svg', 'Halloween vindt zijn oorsprong in het oude Keltische festival \'Samhain\', dat in Ierland werd gevierd.'),
(27, 'IS', 'IJsland', 'Reykjavik', 'https://upload.wikimedia.org/wikipedia/commons/c/ce/Flag_of_Iceland.svg', 'IJsland is een van de weinige landen ter wereld waar geen muggen voorkomen. Het heeft ook \'s werelds oudste, nog bestaande parlement, de Alþingi (gesticht in 930 n.Chr.).'),
(28, 'KZ', 'Kazachstan', 'Astana', 'https://upload.wikimedia.org/wikipedia/commons/d/d3/Flag_of_Kazakhstan.svg', 'Kazachstan is het grootste \'landlocked\' (volledig door land ingesloten) land ter wereld.'),
(29, 'XK', 'Kosovo', 'Pristina', 'https://upload.wikimedia.org/wikipedia/commons/1/1f/Flag_of_Kosovo.svg', 'Kosovo is het jongste land van Europa en riep in 2008 de onafhankelijkheid uit van Servië.'),
(30, 'HR', 'Kroatië', 'Zagreb', 'https://upload.wikimedia.org/wikipedia/commons/1/1b/Flag_of_Croatia.svg', 'De stropdas (krawat) is een Kroatische uitvinding, oorspronkelijk gedragen door Kroatische huurlingen in de 17e eeuw.'),
(31, 'LV', 'Letland', 'Riga', 'https://upload.wikimedia.org/wikipedia/commons/8/84/Flag_of_Latvia.svg', 'In Letland bevindt zich de \'Ventas Rumba\', de breedste waterval van Europa (ongeveer 249 meter breed).'),
(32, 'LI', 'Liechtenstein', 'Vaduz', 'https://upload.wikimedia.org/wikipedia/commons/4/47/Flag_of_Liechtenstein.svg', 'Liechtenstein is een van de slechts twee \'dubbel ingesloten\' landen ter wereld (samen met Oezbekistan), wat betekent dat het wordt ingesloten door landen die zelf ook ingesloten zijn.'),
(33, 'LT', 'Litouwen', 'Vilnius', 'https://upload.wikimedia.org/wikipedia/commons/1/11/Flag_of_Lithuania.svg', 'Litouwen heeft een officiële nationale geur, genaamd \'de Geur van Litouwen\' (Lietuvos kvapas), bedoeld om het land te promoten.'),
(34, 'MT', 'Malta', 'Valletta', 'https://upload.wikimedia.org/wikipedia/commons/7/73/Flag_of_Malta.svg', 'In Malta rijdt men links, een overblijfsel van de 164 jaar Britse heerschappij. Het eiland diende ook als filmlocatie voor \'Game of Thrones\'.'),
(35, 'MK', 'Noord-Macedonië', 'Skopje', 'https://upload.wikimedia.org/wikipedia/commons/7/79/Flag_of_North_Macedonia.svg', 'Het Meer van Ohrid in Noord-Macedonië is een van de oudste en diepste meren van Europa, met een geschatte leeftijd van 2-3 miljoen jaar.'),
(36, 'MD', 'Moldavië', 'Chisinau', 'https://upload.wikimedia.org/wikipedia/commons/2/27/Flag_of_Moldova.svg', 'Moldavië herbergt \'s werelds grootste wijnkelder, Mileștii Mici, met een ondergronds gangenstelsel van 200 km en bijna 2 miljoen flessen wijn.'),
(37, 'MC', 'Monaco', 'Monaco', 'https://upload.wikimedia.org/wikipedia/commons/e/ea/Flag_of_Monaco.svg', 'Monaco is kleiner dan Central Park in New York, maar heeft de hoogste bevolkingsdichtheid ter wereld. De eigen burgers (Monegasken) mogen niet gokken in het beroemde Monte Carlo Casino.'),
(38, 'ME', 'Montenegro', 'Podgorica', 'https://upload.wikimedia.org/wikipedia/commons/6/64/Flag_of_Montenegro.svg', 'De naam \'Montenegro\' (afgeleid van het Venetiaans) betekent \'Zwarte Berg\', verwijzend naar de donkere bossen die de berg Lovćen bedekten.'),
(39, 'UA', 'Oekraïne', 'Kiev', 'https://upload.wikimedia.org/wikipedia/commons/4/49/Flag_of_Ukraine.svg', 'Oekraïne staat bekend als de \'graanschuur van Europa\' vanwege zijn uitgestrekte en vruchtbare zwarte aarde (tsjernozem), ideaal voor de landbouw.'),
(40, 'PL', 'Polen', 'Warschau', 'https://upload.wikimedia.org/wikipedia/commons/1/12/Flag_of_Poland.svg', 'Het Kasteel van Malbork in Polen wordt beschouwd als het grootste kasteel ter wereld qua landoppervlakte, oorspronkelijk gebouwd door de Duitse Orde.'),
(41, 'PT', 'Portugal', 'Lissabon', 'https://upload.wikimedia.org/wikipedia/commons/5/5c/Flag_of_Portugal.svg', 'De Livraria Bertrand in Lissabon is (volgens Guinness World Records) de oudste boekwinkel ter wereld die nog steeds in bedrijf is, geopend in 1732.'),
(42, 'RO', 'Roemenië', 'Boekarest', 'https://upload.wikimedia.org/wikipedia/commons/7/73/Flag_of_Romania.svg', 'In Boekarest staat het Paleis van het Parlement, het zwaarste gebouw ter wereld (gebouwd van marmer en staal) en het op een na grootste administratieve gebouw (na het Pentagon).'),
(43, 'RU', 'Rusland', 'Moskou', 'https://upload.wikimedia.org/wikipedia/commons/f/f3/Flag_of_Russia.svg', 'Rusland is het grootste land ter wereld en beslaat 11 tijdzones. Het Europese deel van Rusland is nog steeds groter dan enig ander Europees land.'),
(44, 'SM', 'San Marino', 'San Marino', 'https://upload.wikimedia.org/wikipedia/commons/b/b1/Flag_of_San_Marino.svg', 'San Marino is de oudste nog bestaande republiek ter wereld, opgericht in het jaar 301 na Christus.'),
(45, 'RS', 'Servië', 'Belgrado', 'https://upload.wikimedia.org/wikipedia/commons/f/ff/Flag_of_Serbia.svg', 'Servië is een van \'s werelds grootste exporteurs van frambozen. De vrucht wordt lokaal ook wel het \'rode goud\' genoemd.'),
(46, 'SI', 'Slovenië', 'Ljubljana', 'https://upload.wikimedia.org/wikipedia/commons/f/f0/Flag_of_Slovenia.svg', 'Slovenië is het thuisland van de Lipizzaner paarden, het beroemde ras dat gefokt werd voor de Spaanse Rijschool in Wenen. De oorspronkelijke stoeterij bevindt zich in Lipica.'),
(47, 'SK', 'Slowakije', 'Bratislava', 'https://upload.wikimedia.org/wikipedia/commons/e/e6/Flag_of_Slovakia.svg', 'Slowakije heeft het hoogste aantal kastelen en burchten per hoofd van de bevolking ter wereld.'),
(48, 'CZ', 'Tsjechië', 'Praag', 'https://upload.wikimedia.org/wikipedia/commons/c/cb/Flag_of_the_Czech_Republic.svg', 'Tsjechië heeft het hoogste bierverbruik per hoofd van de bevolking ter wereld.'),
(49, 'TR', 'Turkije', 'Ankara', 'https://upload.wikimedia.org/wikipedia/commons/b/b4/Flag_of_Turkey.svg', 'Istanbul is de enige stad ter wereld die op twee continenten ligt (Europa en Azië), gescheiden door de Bosporus-zeestraat.'),
(50, 'VA', 'Vaticaanstad', 'Vaticaanstad', 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/Flag_of_Vatican_City_%282023%E2%80%93present%29.svg/250px-Flag_of_Vatican_City_%282023%E2%80%93present%29.svg.png', 'Vaticaanstad is het kleinste onafhankelijke land ter wereld, zowel qua oppervlakte (slechts 44 hectare) als qua bevolking.'),
(51, 'BY', 'Wit-Rusland', 'Minsk', 'https://upload.wikimedia.org/wikipedia/commons/8/85/Flag_of_Belarus.svg', 'Wit-Rusland wordt vaak de \'longen van Europa\' genoemd vanwege zijn uitgestrekte, oeroude bossen, zoals het Białowieża-woud.'),
(52, 'EU', 'Europa', 'Brussel (Europese Unie)', 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c6/Europe_%28orthographic_projection%29.svg/500px-Europe_%28orthographic_projection%29.svg.png', 'Het continent telt meer dan 700 miljoen inwoners, wat het het op twee na grootste continent ter wereld maakt qua bevolking, na Azië en Afrika.');

--
-- Indexen voor geëxporteerde tabellen
--

--
-- Indexen voor tabel `landen`
--
ALTER TABLE `landen`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT voor geëxporteerde tabellen
--

--
-- AUTO_INCREMENT voor een tabel `landen`
--
ALTER TABLE `landen`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
