-- Active: 1746819443116@@127.0.0.1@3309@festivaldb

--create 10 coordinates
INSERT INTO coordinates (coordinate_id, latitude, longitude) VALUES
(1, 37.98417, 23.72806),
(2, 40.41694, -3.70333),
(3, 38.72528, -9.15000),
(4, 34.03300, -6.83300),
(5, 14.64167, -90.51333),
(6, -3.46944, 29.95694),
(7, 39.90667, 116.39750),
(8, 28.61389, 77.20889),
(9, 39.01667, 125.74750),
(10, 35.17250, 33.36500);

--create 10 locations
INSERT INTO festival_location (location_id,location_address,city,country,continent,coordinate_id) VALUES
(1,"Alexandrou Papanastasiou 2","Athens","Greece","Europe",1),
(2,"Federico Garcia Lorca 2","Madrid","Spain","Europe",2),
(3,"Cristiano Ronaldo 2","Lisbon","Portugal","Europe",3),
(4,"Hakimi 2","Athens","Rabat","Africa",4),
(5,"Guatemala Street 2","Guatemala City","North America","Central America",5),
(6,"Fuck Belgium 2","Gitega","Burundi","Africa",6),
(7,"Mao Zedong 2","Beijing","China","Asia",7),
(8,"Pakistan Street 2","New Delhi","India","Asia",8),
(9,"Kim 2","Pyongyang","North Korea","Asia",9),
(10,"Limassol Avenue 2","Nicosia","Cyprus","Europe",10);

--create 10 festivals
INSERT INTO festival (festival_year, festival_month, festival_day, duration, location_id) VALUES
(2018, 10, 2, 2, 1),
(2019, 7, 28, 3, 2),
(2020, 8, 27, 3, 3),
(2021, 9, 3, 16, 4),
(2022, 5, 4, 2, 5),
(2023, 6, 20, 3, 6),
(2024, 8, 11, 5, 7),
(2025, 9, 7 , 4, 8),
(2026, 3, 23, 1, 9),
(2027, 7, 18, 6, 10);

--create 150 artists
INSERT INTO artist (artist_id, artist_name, artist_stage_name, artist_year_of_birth, artist_website) VALUES
(1, 'Shawn Corey Carter', 'Jay-Z', 1969, 'www.jay-z.com'),
(2, 'Aubrey Drake Graham', 'Drake', 1986, 'www.drake.com'),
(3, 'Robyn Rihanna Fenty', 'Rihanna', 1988, 'www.rihanna.com'),
(4, 'Taylor Alison Swift', 'Taylor Swift', 1989, 'www.taylorswift.com'),
(5, 'Stefani Joanne Angelina Germanotta', 'Lady Gaga', 1986, 'www.ladygaga.com'),
(6, 'Marshall Bruce Mathers III', 'Eminem', 1972, 'www.eminem.com'),
(7, 'Beyoncé Giselle Knowles-Carter', 'Beyoncé', 1981, 'www.beyoncé.com'),
(8, 'Kendrick Lamar Duckworth', 'Kendrick Lamar', 1987, 'www.kendricklamar.com'),
(9, 'Olivia Isabel Rodrigo', 'Olivia Rodrigo', 2003, 'www.oliviarodrigo.com'),
(10, 'Billie Eilish Pirate Baird O''Connell', 'Billie Eilish', 2001, 'www.billieeilish.com'),
(11, 'Calvin Cordozar Broadus Jr.', 'Snoop Dogg', 1971, 'www.snoopdogg.com'),
(12, 'Onika Tanya Maraj-Petty', 'Nicki Minaj', 1982, 'www.nickiminaj.com'),
(13, 'Peter Gene Hernandez', 'Bruno Mars', 1985, 'www.brunomars.com'),
(14, 'Abel Makkonen Tesfaye', 'The Weeknd', 1990, 'www.theweeknd.com'),
(15, 'Katheryn Elizabeth Hudson', 'Katy Perry', 1984, 'www.katyperry.com'),
(16, 'Adele Laurie Blue Adkins', 'Adele', 1988, 'www.adele.com'),
(17, 'Harry Edward Styles', 'Harry Styles', 1994, 'www.harrystyles.com'),
(18, 'Miley Ray Cyrus', 'Miley Cyrus', 1992, 'www.mileycyrus.com'),
(19, 'Jacques Berman Webster II', 'Travis Scott', 1991, 'www.travisscott.com'),
(20, 'Melissa Arnette Elliott', 'Missy Elliott', 1971, 'www.missyelliott.com'),
(21, 'Curtis James Jackson III', '50 Cent', 1975, 'www.50cent.com'),
(22, 'Elizabeth Woolridge Grant', 'Lana Del Rey', 1985, 'www.lanadelrey.com'),
(23, 'Austin Richard Post', 'Post Malone', 1995, 'www.postmalone.com'),
(24, 'Belcalis Marlenis Almánzar Cephus', 'Cardi B', 1992, 'www.cardib.com'),
(25, 'Jason Joel Desrouleaux', 'Jason Derulo', 1989, 'www.jasonderulo.com'),
(26, 'Amala Ratna Zandile Dlamin', 'Doja Cat', 1995, 'www.dojacat.com'),
(27, 'Alicia Augello Cook', 'Alicia Keys', 1981, 'www.aliciakeys.com'),
(28, 'John Roger Stephens', 'John Legend', 1978, 'www.johnlegend.com'),
(29, 'Christopher Maurice Brown', 'Chris Brown', 1989, 'www.chrisbrown.com'),
(30, 'Tameka Dianne Cottle', 'Tiny Harris', 1975, 'www.tinyharris.com'),
(31, 'Park Jimin', 'Jimin', 1995, 'www.jimin.com'),
(32, 'Edward Christopher Sheeran', 'Ed Sheeran', 1991, 'www.edsheeran.com'),
(33, 'Armando Christian Pérez', 'Pitbull', 1981, 'www.pitbull.com'),
(34, 'Luis Alfonso Rodríguez López-Cepero', 'Luis Fonsi', 1978, 'www.luisfonsi.com'),
(35, 'Shakira Isabel Mebarak Ripoll', 'Shakira', 1977, 'www.shakira.com'),
(36, 'Diego Leanos', 'Lil Xan', 1996, 'www.lilxan.com'),
(37, 'Solána Imani Rowe', 'SZA', 1990, 'www.sza.com'),
(38, 'Bad Bunny', 'Bad Bunny', 1994, 'www.badbunny.com'),
(39, 'Damini Ebunoluwa Ogulu', 'Burna Boy', 1991, 'www.burnaboy.com'),
(40, 'Charlotte Emma Aitchison', 'Charli XCX', 1992, 'www.charlixcx.com'),
(41, 'Trevor Daniel Neill', 'Trevor Daniel', 1994, 'www.trevordaniel.com'),
(42, 'Alecia Beth Moore', 'P!nk', 1979, 'www.p!nk.com'),
(43, 'Jonathan Lyndale Kirk', 'DaBaby', 1991, 'www.dababy.com'),
(44, 'Tahliah Debrett Barnett', 'FKA twigs', 1988, 'www.fkatwigs.com'),
(45, 'Tyler Gregory Okonma', 'Tyler, the Creator', 1991, 'www.tylerthecreator.com'),
(46, 'Brett Eldredge', 'Brett Eldredge', 1986, 'www.bretteldredge.com'),
(47, 'Bobby Ray Simmons Jr.', 'B.o.B', 1988, 'www.bob.com'),
(48, 'Joshua Bassett', 'Joshua Bassett', 2000, 'www.joshuabassett.com'),
(49, 'Montero Lamar Hill', 'Lil Nas X', 1999, 'www.lilnasx.com'),
(50, 'Ashley Nicolette Frangipane', 'Halsey', 1994, 'www.halsey.com'),
(51, 'Nathan John Feuerstein', 'NF', 1991, 'www.nf.com'),
(52, 'Jermaine Lamarr Cole', 'J. Cole', 1985, 'www.jcole.com'),
(53, 'Dominique Armani Jones', 'Lil Baby', 1994, 'www.lilbaby.com'),
(54, 'Michael Lamar White IV', 'Trippie Redd', 1999, 'www.trippieredd.com'),
(55, 'Russell Vitale', 'Russ', 1992, 'www.russ.com'),
(56, 'Courtney Shanade Salter', 'Ari Lennox', 1991, 'www.arilennox.com'),
(57, 'Megan Jovon Ruth Pete', 'Megan Thee Stallion', 1995, 'www.megantheestallion.com'),
(58, 'Miles Parks McCollum', 'Lil Yachty', 1997, 'www.lilyachty.com'),
(59, 'Ella Marija Lani Yelich-O’Connor', 'Lorde', 1996, 'www.lorde.com'),
(60, 'Tyron Kaymone Frampton', 'slowthai', 1994, 'www.slowthai.com'),
(61, 'Noah Kahan', 'Noah Kahan', 1997, 'www.noahkahan.com'),
(62, 'Jason Thomas Mraz', 'Jason Mraz', 1977, 'www.jasonmraz.com'),
(63, 'Lesane Parish Crooks', '2Pac', 1971, 'www.2pac.com'),
(64, 'Adam Noah Levine', 'Adam Levine', 1979, 'www.adamlevine.com'),
(65, 'Benjamin Hammond Haggerty', 'Macklemore', 1983, 'www.macklemore.com'),
(66, 'James Edward Allen', 'Jimmie Allen', 1985, 'www.jimmieallen.com'),
(67, 'Karla Camila Cabello Estrabao', 'Camila Cabello', 1997, 'www.camilacabello.com'),
(68, 'Anderson Da Silva Paak', 'Anderson .Paak', 1986, 'www.andersonpaak.com'),
(69, 'Grace Martine Tandon', 'Daya', 1998, 'www.daya.com'),
(70, 'George Ezra Barnett', 'George Ezra', 1993, 'www.georgeezra.com'),
(71, 'Roderick Wayne Moore Jr.', 'Roddy Ricch', 1998, 'www.roddyricch.com'),
(72, 'Chloe Elizabeth Bailey', 'Chlöe', 1998, 'www.chlöe.com'),
(73, 'Rani Kaur', 'RANI', 1999, 'www.rani.com'),
(74, 'Aurora Aksnes', 'AURORA', 1996, 'www.aurora.com'),
(75, 'Declan Benedict McKenna', 'Declan McKenna', 1998, 'www.declanmckenna.com'),
(76, 'Brittany Howard', 'Brittany Howard', 1988, 'www.brittanyhoward.com'),
(77, 'Kali Uchis', 'Kali Uchis', 1994, 'www.kaliuchis.com'),
(78, 'Christopher Francis Ocean', 'Frank Ocean', 1987, 'www.frankocean.com'),
(79, 'Tinashe Jorgensen Kachingwe', 'Tinashe', 1993, 'www.tinashe.com'),
(80, 'Mitsuki Laycock', 'Mitski', 1990, 'www.mitski.com'),
(81, 'Tom Gregory', 'Tom Gregory', 1995, 'www.tomgregory.com'),
(82, 'Greta Kline', 'Frankie Cosmos', 1994, 'www.frankiecosmos.com'),
(83, 'Bartees Leon Cox Jr.', 'Bartees Strange', 1989, 'www.barteesstrange.com'),
(84, 'Yola Quartey', 'Yola', 1983, 'www.yola.com'),
(85, 'Annie Clark', 'St. Vincent', 1982, 'www.stvincent.com'),
(86, 'Phoebe Bridgers', 'Phoebe Bridgers', 1994, 'www.phoebebridgers.com'),
(87, 'Julien Rose Baker', 'Julien Baker', 1995, 'www.julienbaker.com'),
(88, 'Brittany Denise Parks', 'Sudan Archives', 1994, 'www.sudanarchives.com'),
(89, 'Tamino Moharam Fouad', 'Tamino', 1996, 'www.tamino.com'),
(90, 'Natalie Mering', 'Weyes Blood', 1988, 'www.weyesblood.com'),
(91, 'José Álvaro Osorio Balvín', 'J Balvin', 1985, 'www.jbalvin.com'),
(92, 'William Sami Étienne Grigahcine', 'DJ Snake', 1986, 'www.djsnake.com'),
(93, 'Isabela Yolanda Moner', 'Isabela Merced', 2001, 'www.isabelamerced.com'),
(94, 'Paul Van Haver', 'Stromae', 1985, 'www.stromae.com'),
(95, 'Tove Anna Gessler', 'Tove Lo', 1987, 'www.tovelo.com'),
(96, 'José Ángel López Martínez', 'Jay Wheeler', 1994, 'www.jaywheeler.com'),
(97, 'Eva Marisol Gutowski', 'Evamarie', 1994, 'www.evamarie.com'),
(98, 'Emmit Fenn', 'Emmit Fenn', 1995, 'www.emmitfenn.com'),
(99, 'Aurélie Hermansyah', 'Aurelie', 1998, 'www.aurelie.com'),
(100, 'Stefan Kendal Gordy', 'Redfoo', 1975, 'www.redfoo.com'),
(101, 'Miriam Makeba', 'Miriam Makeba', 1932, 'www.miriammakeba.com'),
(102, 'Ruth B', 'Ruth B', 1995, 'www.ruthb.com'),
(103, 'Lorde', 'Lorde', 1996, 'www.lorde.com'),
(104, 'Jonas Brothers', 'Jonas Brothers', 2005, 'www.jonasbrothers.com'),
(105, 'Joanna Newsom', 'Joanna Newsom', 1982, 'www.joannanewsom.com'),
(106, 'Seungri', 'Seungri', 1990, 'www.seungri.com'),
(107, 'Maxim Mikhaylovich Gorky', 'Maxim Gorky', 1987, 'www.maxim.com'),
(108, 'Idris Elba', 'Idris Elba', 1972, 'www.idriselba.com'),
(109, 'Teedra Moses', 'Teedra Moses', 1976, 'www.teedramoses.com'),
(110, 'Charlie Puth', 'Charlie Puth', 1991, 'www.charlieputh.com'),
(111, 'Lindsay Lohan', 'Lindsay Lohan', 1986, 'www.lindsaylohan.com'),
(112, 'Rico Nasty', 'Rico Nasty', 1997, 'www.riconasty.com'),
(113, 'Lana Del Rey', 'Lana Del Rey', 1985, 'www.lanadelrey.com'),
(114, 'Mitski', 'Mitski', 1990, 'www.mitski.com'),
(115, 'SZA', 'SZA', 1990, 'www.sza.com'),
(116, 'Wizkid', 'Wizkid', 1990, 'www.wizkid.com'),
(117, 'Tove Styrke', 'Tove Styrke', 1992, 'www.tovestyrke.com'),
(118, 'Shawn Mendes', 'Shawn Mendes', 1998, 'www.shawnmendes.com'),
(119, 'Poppy', 'Poppy', 1995, 'www.poppy.com'),
(120, 'Bebe Rexha', 'Bebe Rexha', 1989, 'www.beberexha.com'),
(121, 'Kimberly Denise Jones', 'Lil’ Kim', 1974, 'www.lilkim.com'),
(122, 'Megan Nicole', 'Megan Nicole', 1993, 'www.megannicole.com'),
(123, 'Omarion Grandberry', 'Omarion', 1984, 'www.omarion.com'),
(124, 'Amala Ratna Zandile Dlamini', 'Doja Cat', 1995, 'www.dojacat.com'),
(125, 'Jesse James Rutherford', 'The Neighbourhood', 1991, 'www.theneighbourhood.com'),
(126, 'Jahseh Dwayne Ricardo Onfroy', 'XXXTentacion', 1998, 'www.xxxtentacion.com'),
(127, 'Michael David Rosenberg', 'Passenger', 1984, 'www.passenger-music.com'),
(128, 'Olivia Isabel Rodrigo', 'Olivia Rodrigo', 2003, 'www.oliviarodrigo.com'),
(129, 'Selena Marie Gomez', 'Selena Gomez', 1992, 'www.selenagomez.com'),
(130, 'Louis William Tomlinson', 'Louis Tomlinson', 1991, 'www.louistomlinson.com'), /*below are independent*/
(131, 'Rihanna Fenty', 'Rihanna', 1988, 'www.rihanna.com'),
(132, 'Alice Merton', 'Alice Merton', 1993, 'www.alicemerton.com'),
(133, 'Tyler Joseph', 'Twenty One Pilots', 1988, 'www.twentyonepilots.com'),
(134, 'Victoria Monét', 'Victoria Monét', 1993, 'www.victoriamonet.com'),
(135, 'Jacob Anderson', 'Raleigh Ritchie', 1990, 'www.raleighritchie.com'),
(136, 'Brendon Urie', 'Panic! At The Disco', 1987, 'www.panicatthedisco.com'),
(137, 'Khalid Donnel Robinson', 'Khalid', 1998, 'www.khalid.com'),
(138, 'Ariana Grande-Butera', 'Ariana Grande', 1993, 'www.arianagrande.com'),
(139, 'Zayn Malik', 'Zayn', 1993, 'www.zayn.com'),
(140, 'Kesha Rose Sebert', 'Kesha', 1987, 'www.kesha.com'),
(141, 'Benjamin Walter David Haggerty', 'Macklemore', 1983, 'www.macklemore.com'),
(142, 'Nina Simone', 'Nina Simone', 1933, 'www.ninasimone.com'),
(143, 'Cameron Jibril Thomaz', 'Wiz Khalifa', 1987, 'www.wizkhalifa.com'),
(144, 'Liam Payne', 'Liam Payne', 1993, 'www.liampayne.com'),
(145, 'Kylie Minogue', 'Kylie Minogue', 1968, 'www.kylie.com'),
(146, 'Justin Drew Bieber', 'Justin Bieber', 1994, 'www.justinbieber.com'),
(147, 'Shania Twain', 'Shania Twain', 1965, 'www.shaniatwain.com'),
(148, 'Taylor Alison Swift', 'Taylor Swift', 1989, 'www.taylorswift.com'),
(149, 'Hugh Masekela', 'Hugh Masekela', 1939, 'www.hughmasakela.com'),
(150, 'John William Coltrane', 'John Coltrane', 1926, 'www.johncoltrane.com');

--create 30 bands and 20 one-man band dates of formation
INSERT INTO band_date_of_formation (band_date_of_formation_id, band_year_of_formation, band_month_of_formation, band_day_of_formation) VALUES
(1, 1993, 5, 12),
(2, 1997, 8, 25),
(3, 2001, 6, 30),
(4, 1999, 11, 17),
(5, 2003, 2, 14),
(6, 2007, 4, 22),
(7, 2011, 10, 3),
(8, 2000, 9, 8),
(9, 1995, 12, 9),
(10, 2008, 3, 27),
(11, 1996, 7, 15),
(12, 2014, 1, 25),
(13, 2004, 10, 18),
(14, 2010, 5, 2),
(15, 1994, 6, 22),
(16, 2009, 11, 5),
(17, 1998, 9, 30),
(18, 2002, 7, 19),
(19, 2016, 3, 10),
(20, 2018, 2, 23),
(21, 1992, 4, 7),
(22, 2013, 8, 13),
(23, 2005, 1, 16),
(24, 2006, 12, 3),
(25, 2017, 6, 21),
(26, 2015, 9, 11),
(27, 2001, 2, 5),
(28, 1999, 10, 11),
(29, 2007, 5, 27),
(30, 2000, 8, 17), /*under are independent artists, years of formation are birth years + 20*/
(31, 2008, 7, 21),
(32, 2013, 1, 15),
(33, 2008, 9, 4),
(34, 2013, 2, 18),
(35, 2010, 10, 6),
(36, 2007, 3, 11),
(37, 2018, 5, 23),
(38, 2013, 12, 9),
(39, 2013, 6, 27),
(40, 2007, 8, 3),
(41, 2003, 4, 14),
(42, 1953, 11, 7),
(43, 2007, 2, 19),
(44, 2013, 6, 2),
(45, 1988, 5, 30),
(46, 2014, 10, 1),
(47, 1985, 9, 12),
(48, 2009, 7, 5),
(49, 1959, 3, 22),
(50, 1946, 12, 16);



--create 30 bands and 20 one-man bands
INSERT INTO band (band_id, band_name, band_country, band_members, band_website, band_date_of_formation_id) VALUES
(1, 'Radiohead', 'United Kingdom', 3, 'www.radiohead.com', 1),
(2, 'Rammstein', 'Germany', 3, 'www.rammstein.com', 2),
(3, 'Coldplay', 'United Kingdom', 3, 'www.coldplay.com', 3),
(4, 'ABBA', 'Sweden', 3, 'www.abba.com', 4),
(5, 'Måneskin', 'Italy', 4, 'www.måneskin.com', 5),
(6, 'The Killers', 'United States', 4, 'www.thekillers.com', 6),
(7, 'Arcade Fire', 'Canada', 4, 'www.arcadefire.com', 7),
(8, 'Muse', 'United Kingdom', 4, 'www.muse.com', 8),
(9, 'Placebo', 'United Kingdom', 4, 'www.placebo.com', 9),
(10, 'Sigur Rós', 'Iceland', 5, 'www.sigurros.com', 10),
(11, 'Interpol', 'United States', 5, 'www.interpol.com', 11),
(12, 'Keane', 'United Kingdom', 5, 'www.keane.com', 12),
(13, 'Franz Ferdinand', 'United Kingdom', 5, 'www.franzferdinand.com', 13),
(14, 'The xx', 'United Kingdom', 5, 'www.thexx.com', 14),
(15, 'Phoenix', 'France', 5, 'www.phoenix.com', 15),
(16, 'Editors', 'United Kingdom', 5, 'www.editors.com', 16),
(17, 'Within Temptation', 'Netherlands', 5, 'www.withintemptation.com', 17),
(18, 'Nightwish', 'Finland', 6, 'www.nightwish.com', 18),
(19, 'Evanescence', 'United States', 6, 'www.evanescence.com', 19),
(20, 'Paramore', 'United States', 6, 'www.paramore.com', 20),
(21, 'The Cranberries', 'Ireland', 5, 'www.thecranberries.com', 21),
(22, 'Gojira', 'France', 5, 'www.gojira.com', 22),
(23, 'Opeth', 'Sweden', 5, 'www.opeth.com', 23),
(24, 'Amaranthe', 'Sweden', 6, 'www.amaranthe.com', 24),
(25, 'Bring Me The Horizon', 'United Kingdom', 6, 'www.bringmethehorizon.com', 25),
(26, 'The Hives', 'Sweden', 6, 'www.thehives.com', 26),
(27, 'Biffy Clyro', 'United Kingdom', 6, 'www.biffyclyro.com', 27),
(28, 'Ghost', 'Sweden', 7, 'www.ghost.com', 28),
(29, 'The 1975', 'United Kingdom', 7, 'www.the1975.com', 29),
(30, 'Kasabian', 'United Kingdom', 7, 'www.kasabian.com', 30), /*independent artists below*/
(31, 'Rihanna', 'Barbados', 1, 'www.rihanna.com', 31),
(32, 'Alice Merton', 'Germany', 1, 'www.alicemerton.com', 32),
(33, 'Blurry Signal', 'USA', 1, 'www.blurrysignal.com', 33),
(34, 'Victoria Monét', 'USA', 1, 'www.victoriamonet.com', 34),
(35, 'Jacob Anderson', 'United Kingdom', 1, 'www.jacobanderson.com', 35),
(36, 'Panic! At The Disco', 'USA', 1, 'www.panicatthedisco.com', 36),
(37, 'Khalid', 'USA', 1, 'www.khalid.com', 37),
(38, 'Ariana Grande', 'USA', 1, 'www.arianagrande.com', 38),
(39, 'Zayn', 'United Kingdom', 1, 'www.zayn.com', 39),
(40, 'Neon Howl', 'USA', 1, 'www.neonhowl.com', 40),
(41, 'Macklemore', 'USA', 1, 'www.macklemore.com', 41),
(42, 'Nina Simone', 'USA', 1, 'www.ninasimone.com', 42),
(43, 'Wiz Khalifa', 'USA', 1, 'www.wizkhalifa.com', 43),
(44, 'Liam Payne', 'United Kingdom', 1, 'www.liampayne.com', 44),
(45, 'Echo Mirage', 'Australia', 1, 'www.echomirage.com', 45),
(46, 'Justin Bieber', 'Canada', 1, 'www.justinbieber.com', 46),
(47, 'Shania Twain', 'Canada', 1, 'www.shaniatwain.com', 47),
(48, 'Taylor Swift', 'USA', 1, 'www.taylorswift.com', 48),
(49, 'Hugh Masekela', 'South Africa', 1, 'www.hughmasakela.com', 49),
(50, 'Coltrane Drive', 'USA', 1, 'www.coltranedrive.com', 50);

--connect the bands to the artists
INSERT INTO artist_band (artist_id, band_id) VALUES
(1, 1), (2, 1),
(3, 2), (4, 2),
(5, 3), (6, 3),
(7, 4), (8, 4),

(9, 5), (10, 5), (11, 5),
(12, 6), (13, 6), (14, 6),
(15, 7), (16, 7), (17, 7),
(18, 8), (19, 8), (20, 8),
(21, 9), (22, 9), (23, 9),

(24, 10), (25, 10), (26, 10), (27, 10),
(28, 11), (29, 11), (30, 11), (31, 11),
(32, 12), (33, 12), (34, 12), (35, 12),
(36, 13), (37, 13), (38, 13), (39, 13),
(40, 14), (41, 14), (42, 14), (43, 14),
(44, 15), (45, 15), (46, 15), (47, 15),
(48, 16), (49, 16), (50, 16), (51, 16),
(52, 17), (53, 17), (54, 17), (55, 17),

(56, 18), (57, 18), (58, 18), (59, 18), (60, 18),
(61, 19), (62, 19), (63, 19), (64, 19), (65, 19),
(66, 20), (67, 20), (68, 20), (69, 20), (70, 20),
(71, 21), (72, 21), (73, 21), (74, 21), (75, 21),
(76, 22), (77, 22), (78, 22), (79, 22), (80, 22),
(81, 23), (82, 23), (83, 23), (84, 23), (85, 23),

(86, 24), (87, 24), (88, 24), (89, 24), (90, 24), (91, 24),
(92, 25), (93, 25), (94, 25), (95, 25), (96, 25), (97, 25),
(98, 26), (99, 26), (100, 26), (101, 26), (102, 26), (103, 26),
(104, 27), (105, 27), (106, 27), (107, 27), (108, 27), (109, 27),

(110, 28), (111, 28), (112, 28), (113, 28), (114, 28), (115, 28), (116, 28),
(117, 29), (118, 29), (119, 29), (120, 29), (121, 29), (122, 29), (123, 29),
(124, 30), (125, 30), (126, 30), (127, 30), (128, 30), (129, 30), (130, 30),

(131, 31),
(132, 32),
(133, 33),
(134, 34),
(135, 35),
(136, 36),
(137, 37),
(138, 38),
(139, 39),
(140, 40),
(141, 41),
(142, 42),
(143, 43),
(144, 44),
(145, 45),
(146, 46),
(147, 47),
(148, 48),
(149, 49),
(150, 50),

(131, 1),-- Add independent artists 131–140 to bands 1–10
(132, 2),
(133, 3),
(134, 4),
(135, 5),
(136, 6),
(137, 7),
(138, 8),
(139, 9),
(140, 10),-- Add already-assigned artists 1–10 to new bands 11–20

(1, 11),
(2, 12),
(3, 13),
(4, 14),
(5, 15),
(6, 16),
(7, 17),
(8, 18),
(9, 19),
(10, 20);

--create 10 genres
INSERT INTO genre (genre_id,genre_name) VALUES
(1,"Rock"),
(2,"Pop"),
(3,"Hip Hop"),
(4,"EDM"),
(5,"Jazz"),
(6,"Country"),
(7,"R&B"),
(8,"Metal"),
(9,"Blues"),
(10,"Reggae");

--create 37 subgenres
INSERT INTO subgenre (subgenre_id, subgenre_name,genre_id) VALUES
(1, 'Classic Rock',1),
(2, 'Alternative Rock',1),
(3, 'Punk Rock',1),
(4, 'Progressive Rock',1),
(5, 'Indie Rock',1),
(6, 'Hard Rock',1),
(7, 'K-Pop',2),
(8, 'Indie Pop',2),
(9, 'Pop Rock',2),
(10, 'Pop Punk',2),
(11, 'Trap',3),
(12, 'Boom Bap',3),
(13, 'Lo-Fi Hip Hop',3),
(14, 'Drill',3),
(15, 'House',4),
(16, 'Techno',4),
(17, 'Dubstep',4),
(18, 'Trance',4),
(19, 'Bebop',5),
(20, 'Swing',5),
(21, 'Traditional Country',6),
(22, 'Country Pop',6),
(23, 'Country Rock',6),
(24, 'Soul',7),
(25, 'Funk',7),
(26, 'Dance R&B',7),
(27, 'Heavy Metal',8),
(28, 'Death Metal',8),
(29, 'Black Metal',8),
(30, 'Progressive Metal',8),
(31, 'Metalcore',8),
(32, 'Acoustic Blues',9),
(33, 'Country Blues',9),
(34, 'Rhythm and Blues',9),
(35, 'Blues Rock',9),
(36, 'Reggaeton',10),
(37, 'Dubstep Reggae',10);

--assign subgenres to bands
INSERT INTO band_subgenre (band_id, subgenre_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 8),
(10, 9),
(11, 9),
(12, 10),
(13, 10),
(14, 10),
(15, 11),
(16, 11),
(17, 11),
(18, 12),
(19, 12),
(20, 12),
(21, 12),
(22, 13),
(23, 13),
(24, 14),
(25, 14),
(26, 15),
(27, 15),
(28, 16),
(29, 16),
(30, 17),
(31, 17),
(32, 18),
(33, 18),
(34, 19),
(35, 19),
(36, 19),
(37, 19),
(38, 19),
(39, 20),
(40, 20),
(41, 20),
(42, 20),
(43, 20),
(44, 21),
(45, 21),
(46, 21),
(47, 21),
(48, 21),
(49, 22),
(50, 22),/*apo katw*/
(1, 13),
(2, 14),
(3, 15),
(4, 16),
(5, 17),
(6, 18),
(7, 19),
(8, 20),
(9, 21),
(10, 21),
(11, 21),
(12, 22),
(13, 22),
(14, 23),
(15, 24),
(16, 25),
(17, 26),
(18, 27),
(19, 28),
(20, 29),
(21, 30),/*apo katw*/
(22, 1),
(23, 1),
(24, 1),
(25, 1),
(26, 2),
(27, 2),
(28, 2),
(29, 3),
(30, 3),
(31, 4),
(32, 5),
(33, 6),
(34, 7),
(35, 8),
(36, 8),
(37, 8),
(38, 9),
(39, 9),
(40, 10),/*apo katw 5 bands paizoun 3 subgenres*/
(1, 31),
(2, 32),
(3, 33),
(4, 34),
(5, 35);

--create 33 stages with stage capacities from 15 to 30
INSERT INTO stage (stage_id, stage_name, stage_capacity) VALUES
(1, 'Odeon of Herodes Atticus', 28),
(2, 'Technopolis Gazi', 22),
(3, 'Stavros Niarchos Foundation Cultural Center (SNFCC)', 26),
(4, 'Lycabettus Theater', 30),
(5, 'Gazarte', 19),
(6, 'Fuzz Club', 24),
(7, 'Piraeus Academy 117', 21),
(8, 'Kyttaro Live', 20),
(9, 'Principal Club Theater', 29),
(10, 'Mylos Club', 17),
(11, 'Block 33', 27),
(12, 'Half Note Jazz Club', 25),
(13, 'Six d.o.g.s', 16),
(14, 'Gagarin 205 Live Music Space', 18),
(15, 'Megaron Athens Concert Hall', 30),
(16, 'Nicosia Municipal Theatre', 23),
(17, 'Pattihio Municipal Theatre', 19),
(18, 'Kourion Ancient Amphitheatre', 28),
(19, 'Markideio Theatre', 15),
(20, 'Downtown Live', 24),
(21, 'NCPA (National Centre for the Performing Arts)', 30),
(22, 'Mehboob Studio', 21),
(23, 'Shanmukhananda Hall', 18),
(24, 'Prithvi Theatre', 16),
(25, 'Jawaharlal Nehru Stadium', 30),
(26, 'Kamani Auditorium', 22),
(27, 'Indira Gandhi Indoor Stadium', 30),
(28, 'Bangalore Palace Grounds', 29),
(29, 'Hard Rock Cafe', 17),
(30, 'G.S.P', 23),
(31, 'G.S.O', 24),
(32, 'G.S.Z', 18),
(33, 'Alphamega Stadium', 20);

--create 42 events
INSERT INTO event (event_id,event_name,festival_year,stage_id,festival_day,event_start,event_end) VALUES
(1 ,"Paleolithic Era" , 2018 ,1 ,1,300 , 600), /* 2 days */
(2 ,"Neolithic Era" , 2018 ,2 ,1,650 ,800), 
(3 ,"Bronze Age" , 2018 ,3 ,2, 900 , 1000),

(4 ,"Iron Age" , 2019 ,4 ,1, 100 , 300),
(5 ,"Sumerian Period" , 2019 ,4 ,2, 350 , 500),
(6 ,"Old Kingdom (Egypt)" , 2019 ,5 ,2, 550 , 700), /* 3 days */
(7 ,"Middle Kingdom (Egypt)" , 2019 ,5 ,3, 750 , 850),
(8 ,"New Kingdom (Egypt)" , 2019 ,5 ,3, 900, 1000),

(9 ,"Mycenaean Period (Greece)" , 2020 ,6 ,1, 300 , 500),
(10 ,"Vedic Period (India)" , 2020 ,7 ,2, 600 , 800), /* 3 days */
(11 ,"Classical Greece" , 2020 ,8 ,3, 900, 1100),

(12 ,"Hellenistic Period" , 2021 ,9 ,1, 100 , 400),
(13 ,"Roman Republic" , 2021 ,10 ,1, 450 , 700),
(14 ,"Roman Empire" , 2021 ,11 ,2, 750, 900), /* 3 days */
(15 ,"Maurya Empire (India)" , 2021 ,12 ,2, 950 ,1100),
(16 ,"Gupta Empire (India)" , 2021 ,13 ,3, 1150 , 1300),

(17 ,"Han Dynasty (China)" , 2022 ,14 ,1, 10 ,250),
(18 ,"Achaemenid Empire (Persia)" , 2022 ,15 ,1, 300 , 500), /* 2 days */
(19 ,"Qin Dynasty (China)" , 2022 ,16 ,2, 550,900),
(20 ,"High Middle Ages" , 2022 ,17 ,2, 950,1300),

(21 ,"Late Middle Ages" , 2023 ,18 ,1 ,100 , 350),
(22 ,"Byzantine Empire Era" , 2023 ,19 , 1,400 , 650),
(23 ,"Islamic Golden Age" , 2023 ,20 , 2,700,900), /* 3 days */
(24 ,"Heian Period (Japan)" , 2023 ,21 , 2,950, 1000),
(25 ,"Mayan Classic Period" , 2023 ,22 , 3,1050, 1400),

(26 ,"Viking Age" , 2024 ,23 , 1,50 , 300),
(27 ,"Carolingian Renaissance" , 2024 ,23 , 2,350 , 600),
(28 ,"Chola Dynasty (India)" , 2024 ,23 , 3,650,900), /* 5 days */
(29 ,"Reformation" , 2024 ,24 , 4,950, 1100),
(30 ,"Age of Discovery" , 2024 ,24 , 5,1150 ,1400),

(31 ,"Ming Dynasty (China)" , 2025 ,25 , 1,100 ,350),
(32 ,"Mughal Empire (India)" , 2025 ,25 , 2,400, 650),
(33 ,"Scientific Revolution" , 2025 ,26 , 3,700, 900), /* 4 days */
(34 ,"Enlightenment" , 2025 ,26 , 4,950, 1100),
(35 ,"Victorian Era (UK)" , 2025 ,27 , 1,1130 ,1250),
(36 ,"Meiji Era (Japan)" , 2025 ,27 , 2,1300,1430),

(37 ,"World War I Era" , 2026 ,28 , 1,100 ,500),
(38 ,"Interwar Period" , 2026 ,29 , 1,550, 900), /* 1 day */
(39 ,"World War II Era" , 2026 ,30 , 1,950 , 1400),

(40 ,"Cold War Era" , 2027 ,31 , 1,100 , 500),
(41 ,"Postcolonial Era" , 2027 ,32 , 3,600 , 900), /* 6 days */
(42 ,"Anthropocene" , 2027 ,33 , 5,950,1400);


SET FOREIGN_KEY_CHECKS = 0;

-- Truncate the child tables first (those that reference others)
TRUNCATE TABLE performance;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

CALL insert_performance_break(1, 300, 400, 1, 1, 600);   -- Radiohead (Band 1)
CALL insert_performance_break(2, 410, 500, 1, 2, 600);   -- Rammstein (Band 2)
CALL insert_performance_break(3, 510, 550, 1, 3, 600);   -- Coldplay (Band 3)

CALL insert_performance_break(2, 650, 740, 2, 4, 900);   -- ABBA (Band 4)
CALL insert_performance_break(4, 770, 795, 2, 5, 300);   -- Måneskin (Band 5)

CALL insert_performance_break(2, 900, 950, 3, 6, 1200);  -- The Killers (Band 6)
CALL insert_performance_break(3, 970, 990, 3, 7, 600);  -- Arcade Fire (Band 7)

CALL insert_performance_break(1, 100, 220, 4, 8, 330);   -- Muse (Band 8)
CALL insert_performance_break(4, 230, 290, 4, 9, 400);   -- Placebo (Band 9)

CALL insert_performance_break(3, 350, 440, 5, 10, 1500); -- Sigur Rós (Band 10)
CALL insert_performance_break(2, 465, 480, 5, 11, 350);  -- Interpol (Band 11)

CALL insert_performance_break(1, 550, 640, 6, 12, 900);  -- Keane (Band 12)
CALL insert_performance_break(4, 655, 680, 6, 13, 300);  -- Franz Ferdinand (Band 13)

CALL insert_performance_break(3, 750, 840, 7, 14, 400); -- The xx (Band 14)

CALL insert_performance_break(1, 900, 960, 8, 15, 600);  -- Phoenix (Band 15)
CALL insert_performance_break(2, 970, 980, 8, 16, 900); -- Editors (Band 16)

CALL insert_performance_break(3, 300, 420, 9, 17, 600);  -- Within Temptation (Band 17)
CALL insert_performance_break(4, 450, 490, 9, 18, 330);  -- Nightwish (Band 18)

CALL insert_performance_break(1, 600, 720, 10, 19, 500); -- Evanescence (Band 19)
CALL insert_performance_break(2, 730, 760, 10, 20, 600);  -- Paramore (Band 20)

CALL insert_performance_break(3, 900, 1040, 11, 21, 550); -- The Cranberries (Band 21)
CALL insert_performance_break(4, 1060, 1080, 11, 22, 300);-- Gojira (Band 22)

CALL insert_performance_break(1, 100, 220, 12, 23, 600); -- Opeth (Band 23)
CALL insert_performance_break(2, 240, 380, 12, 24, 450); -- Amaranthe (Band 24)

CALL insert_performance_break(3, 450, 600, 13, 25, 1200);-- Bring Me The Horizon (Band 25)

CALL insert_performance_break(2, 750, 870, 14, 26, 600); -- The Hives (Band 26)
CALL insert_performance_break(4, 880, 890, 14, 27, 300); -- Biffy Clyro (Band 27)

CALL insert_performance_break(2, 950, 1000, 15, 28, 500);-- Ghost (Band 28)
CALL insert_performance_break(3, 1010, 1080, 15, 29, 480);-- The 1975 (Band 29)

CALL insert_performance_break(4, 1150, 1280, 16, 30, 600);-- Kasabian (Band 30)

-- Han Dynasty (Event 17)
CALL insert_performance_break(1, 10, 150, 17, 31, 600);  -- Rihanna
CALL insert_performance_break(2, 160, 240, 17, 32, 400); -- Alice Merton

-- Achaemenid Empire (Event 18)
CALL insert_performance_break(3, 300, 420, 18, 33, 700);-- Blurry Signal

-- Qin Dynasty (Event 19)
CALL insert_performance_break(1, 550, 650, 19, 35, 1600); -- Jacob Anderson
CALL insert_performance_break(2, 680, 790, 19, 36, 600); -- Panic! At The Disco

-- High Middle Ages (Event 20)
CALL insert_performance_break(3, 950, 1000,20, 38, 600);-- Ariana Grande

CALL insert_performance_break(4, 1030, 1100, 20, 37, 1200);-- Khalid


-- Late Middle Ages (Event 21)
CALL insert_performance_break(2, 100, 240, 21, 40, 600); -- Neon Howl 

-- Byzantine Empire (Event 22)
CALL insert_performance_break(3, 400, 550, 22, 41, 1200);-- Macklemore
CALL insert_performance_break(4, 570, 640, 22, 42, 600); -- Nina Simone

-- Islamic Golden Age (Event 23)
CALL insert_performance_break(1, 700, 820, 23, 43, 900); -- Wiz Khalifa
CALL insert_performance_break(2, 835, 890, 23, 44, 600);-- Liam Payne

-- Heian Period (Event 24)
CALL insert_performance_break(3, 950, 995, 24, 45, 300);-- Echo Mirage

-- Mayan Classic Period (Event 25)
CALL insert_performance_break(1, 1050, 1150, 25, 46, 600);-- Justin Bieber
CALL insert_performance_break(3, 1170, 1300, 25, 47, 900);-- Shania Twain

-- Viking Age (Event 26)
CALL insert_performance_break(2, 50, 150, 26, 48, 900);  -- Taylor Swift
CALL insert_performance_break(3, 170, 290, 26, 49, 600); -- Hugh Masekela

-- Carolingian Renaissance (Event 27)
CALL insert_performance_break(1, 350, 500, 27, 50, 1200);-- Coltrane Drive
CALL insert_performance_break(3, 520, 590, 27, 2, 600);  -- Radiohead (reappearance)

-- Chola Dynasty (Event 28)
CALL insert_performance_break(2, 650, 750, 28, 1, 900);  -- Rammstein (reappearance)
CALL insert_performance_break(3, 810, 890, 28, 3, 600);  -- Coldplay (reappearance)

-- Reformation (Event 29)
CALL insert_performance_break(1, 950, 1040, 29, 4, 900);-- ABBA (reappearance)
CALL insert_performance_break(4, 1060, 1090, 29, 5, 300);-- Måneskin (reappearance)

-- Age of Discovery (Event 30)
CALL insert_performance_break(2, 1150, 1250, 30, 6, 600);-- The Killers (reappearance)
CALL insert_performance_break(3, 1270, 1390, 30, 7, 300);-- Arcade Fire (reappearance)

-- Ming Dynasty (Event 31)
CALL insert_performance_break(2, 800, 880, 19, 9, 500);  -- Muse (reappearance)
CALL insert_performance_break(3, 260, 330, 31, 8, 600);  -- Placebo (reappearance)

-- Mughal Empire (Event 32)
CALL insert_performance_break(3, 1320, 1390, 25, 10, 600);
CALL insert_performance_break(2, 400, 530, 32, 47, 700);-- Sigur Rós (reappearance)
CALL insert_performance_break(3, 560, 640, 32, 11, 600);-- Interpol (reappearance)

-- Scientific Revolution (Event 33)
CALL insert_performance_break(1, 700, 820, 33, 13, 900);-- Keane (reappearance)
CALL insert_performance_break(4, 840, 890, 33, 12, 300);-- Franz Ferdinand (reappearance)

-- Enlightenment (Event 34)
CALL insert_performance_break(2, 950, 1020, 34, 14, 600);-- The xx (reappearance)
CALL insert_performance_break(3, 1040, 1090, 34, 15, 300);-- Phoenix (reappearance)

-- Victorian Era (Event 35)
CALL insert_performance_break(4, 1130, 1230, 35, 16, 600);-- Editors (reappearance)

-- Meiji Era (Event 36)
CALL insert_performance_break(1, 1300, 1390, 36, 17, 600);-- Within Temptation (reappearance)

-- World War I Era (Event 37)
CALL insert_performance_break(2, 100, 250, 37, 18, 900);-- Nightwish (reappearance)
CALL insert_performance_break(3, 265, 400, 37, 19, 1200);-- Evanescence (reappearance)
CALL insert_performance_break(3, 420, 490, 37, 20, 600);-- Paramore (reappearance)

-- Interwar Period (Event 38)
CALL insert_performance_break(1, 550, 700, 38, 21, 900);-- The Cranberries (reappearance)
CALL insert_performance_break(2, 720, 790, 38, 22, 300);-- Gojira (reappearance)

-- World War II Era (Event 39)
CALL insert_performance_break(2, 950, 1050, 39, 23, 900);-- Opeth (reappearance)
CALL insert_performance_break(3, 1070, 1200, 39, 24, 1800);-- Amaranthe (reappearance)

-- Cold War Era (Event 40)
CALL insert_performance_break(1, 100, 250, 40, 25, 900);-- Bring Me The Horizon (reappearance)
CALL insert_performance_break(2, 270, 400, 40, 26, 1200);-- The Hives (reappearance)
CALL insert_performance_break(3, 430, 490, 40, 27, 600);-- Biffy Clyro (reappearance)

-- Postcolonial Era (Event 41)
CALL insert_performance_break(1, 600, 700, 41, 28, 900);-- Ghost (reappearance)
CALL insert_performance_break(3, 715, 810, 41, 29, 1200);-- The 1975 (reappearance)

-- Anthropocene (Event 42)
CALL insert_performance_break(2, 950, 1100, 42, 30, 900);-- Kasabian (reappearance)
CALL insert_performance_break(3, 1120, 1200, 42, 31, 1800);-- Rihanna (reappearance)

CALL insert_performance_break(2, 820, 890, 38, 5, 600);-- Gojira (reappearance) 800 mexri 900

CALL insert_performance_break(2, 1230, 1370, 39, 19, 600);-- Amaranthe (reappearance) mexri 1400

CALL insert_performance_break(3, 1250, 1370, 42, 3, 800);-- Rihanna (reappearance) mexri 1400



INSERT INTO technical_equipment (technical_equipment_id,equipment_name,equipment_quantity) VALUES
(1,"Speakers",330),
(2,"Lights",600),
(3,"Mics",150),
(4,"Consoles",60),
(5,"Special Effects",130);

/*
INSERT INTO stage_technical_equipment (stage_id,technical_equipment_id) VALUES
()
*/

INSERT INTO technician_specialization (technician_specialization_id,technician_specialization_name,staff_role_id) VALUES
(1,"Sound Engineer",1),
(2,"Light Engineer",1),
(3,"Network Engineer" ,1),
(4,"Pyro Technician" ,1);

--insert 50 staff
INSERT INTO staff (staff_id, staff_name, staff_role_id, staff_phone, staff_email, staff_age, level_of_experience) VALUES
(1, 'Dimitrios Papadopoulos', 2, '99123456', 'papadopoulos@gmail.com', 28, 2),
(2, 'Maria Ioannou', 2, '99234567', 'ioannou@gmail.com', 24, 1),
(3, 'Andreas Georgiou', 2, '99345678', 'georgiou@gmail.com', 32, 3),
(4, 'Eleni Michael', 2, '99456789', 'michael@gmail.com', 22, 2),
(5, 'Christos Panayiotou', 2, '99567890', 'panayiotou@gmail.com', 29, 2),
(6, 'Sophia Constantinou', 2, '99678901', 'constantinou@gmail.com', 26, 1),
(7, 'Vasilis Ioannoglou', 2, '99789012', 'demetriou@gmail.com', 35, 3),
(8, 'Anna Antoniou', 2, '99890123', 'antoniou@gmail.com', 23, 2),
(9, 'Giorgos Christodoulou', 2, '99901234', 'christodoulou@gmail.com', 27, 2),
(10, 'Katerina Pavlou', 2, '99012345', 'pavlou@gmail.com', 31, 3),
(11, 'Stavros Hadjipanayiotou', 2, '99111222', 'hadjipanayiotou@gmail.com', 25, 1),
(12, 'Kostas Sloukas', 2, '99222333', 'theodorou@gmail.com', 30, 2),
(13, 'Yiannis Savva', 1, '99333444', 'savva@gmail.com', 22, 2),
(14, 'Alexandra Kouris', 1, '99444555', 'kouris@gmail.com', 24, 1),
(15, 'Michalis Louca', 1, '99555666', 'louca@gmail.com', 28, 2),
(16, 'Chrysoula Petrou', 2, '99666777', 'petrou@gmail.com', 26, 2),
(17, 'Petros Zacharia', 3, '99777888', 'zacharia@gmail.com', 33, 3),
(18, 'Despina Nicolaou', 3, '99888999', 'nicolaou@gmail.com', 21, 5),
(19, 'Costas Hadjikyriacou', 3, '99999000', 'hadjikyriacou@gmail.com', 81, 2),
(20, 'Marina Spyrou', 3, '99000111', 'spyrou@gmail.com', 27, 2),
(21, 'Andreas Charalambous', 3, '99112233', 'charalambous@gmail.com', 35, 4),
(22, 'Elena Kallis', 3, '99223344', 'kallis@gmail.com', 23, 1),
(23, 'Panayiotis Economou', 1, '99334455', 'economou@gmail.com', 40, 4),
(24, 'Fotini Andreou', 1, '99445566', 'andreou@gmail.com', 38, 3),
(25, 'George Vasiliou', 1, '99556677', 'vasiliou@gmail.com', 45, 4),
(26, 'Loukia Patsalou', 1, '99667788', 'patsalou@gmail.com', 32, 2),
(27, 'Stelios Makrides', 1, '99778899', 'makrides@gmail.com', 28, 5),
(28, 'Ioanna Hadjisavva', 1, '99889900', 'hadjisavva@gmail.com', 36, 3),
(29, 'Kyriacos Papanicolaou', 1, '99990011', 'papanicolaou@gmail.com', 42, 4),
(30, 'Evdokia Christoforou', 1, '99001122', 'christoforou@gmail.com', 39, 3),
(31, 'Panayiotis Economou', 1, '99334455', 'economou@gmail.com', 40, 4),
(32, 'Fotini Andreou', 1, '99445566', 'andreou@gmail.com', 38, 3),
(33, 'George Vasiliou', 1, '99556677', 'vasiliou@gmail.com', 45, 4),
(34, 'Loukia Patsalou', 1, '99667788', 'patsalou@gmail.com', 32, 2),
(35, 'Stelios Makrides', 2, '99778899', 'makrides@gmail.com', 28, 2),
(36, 'Ioanna Hadjisavva', 2, '99889900', 'hadjisavva@gmail.com', 36, 3),
(37, 'Kyriacos Papanicolaou', 2, '99990011', 'papanicolaou@gmail.com', 42, 4),
(38, 'Evdokia Christoforou', 2, '99001122', 'christoforou@gmail.com', 39, 3),
(39, 'Lebron James', 3, '99112233', 'savva@gmail.com', 22, 5),
(40, 'Alexandra Kouris', 3, '99223344', 'kouris@gmail.com', 24, 1),
(41, 'Aristeidis Vasilakis', 1, '99771234', 'vasilakis@gmail.com', 43, 4),
(42, 'Kalliopi Stefanidou', 1, '99237890', 'stefanidou@gmail.com', 38, 3),
(43, 'Theodoros Markou', 1, '99654321', 'markou@gmail.com', 32, 2),
(44, 'Olympia Zacharopoulou', 1, '99887654', 'zacharopoulou@gmail.com', 29, 2),
(45, 'Leonidas Papamichael', 2, '99456789', 'papamichael@gmail.com', 34, 3),
(46, 'Aikaterini Kokkinou', 2, '99321456', 'kokkinou@gmail.com', 27, 2),
(47, 'Dionysios Angelopoulos', 2, '99567890', 'angelopoulos@gmail.com', 24, 1),
(48, 'Persefoni Vlachou', 2, '99123478', 'vlachou@gmail.com', 22, 1),
(49, 'Stamatis Karagiannis', 2, '99987654', 'karagiannis@gmail.com', 45, 4),
(50, 'Eirini Liaskou', 2, '992234567', 'liaskou@gmail.com', 40, 3);


--make the 16 technicians one of four specializations
INSERT INTO staff_specialization (staff_id,technician_specialization_id) VALUES
(23,1),
(24,1),
(25,1),
(26,1),
(27,1),
(28,1),
(29,1),
(30,2),
(31,2),
(32,2),
(33,2),
(34,2),
(41,3),
(42,3),
(43,4),
(44,4);

/*
--assign the 50 staff to stages
INSERT INTO stage_staff (stage_id,staff_id) VALUES
(1,1),(1,23), / 2018 /
(2,1),(2,23),
(3,2),(3,24),
(1,17),(2,18),


(4,2),(4,24), / 2019 /
(4,3),(4,25),
(5,4),(5,26),
(5,2),(5,24),
(5,3),(5,25),
(5,18),(5,19),

(6,2),(6,24), / 2020 /
(7,5),(7,27),
(8,5),(8,27),
(6,19),(7,20),

(9,6),(9,28), / 2021 /
(10,7),(10,29),
(11,8),(11,30),
(12,6),(12,28),
(13,7),(13,29),
(10,20),(11,21),(12,21),

(14,7),(14,29), / 2022 /
(15,9),(15,30),
(16,10),(16,30),
(17,10),(17,31),
(15,21),(16,22),

(18,11),(18,32), / 2023 /
(19,12),(19,32),
(20,6),(20,33),
(21,6),(21,33),
(22,12),(22,29),
(20,21),(21,22),(22,39),

(23,35),(23,33), / 2024 /
(23,36),(23,29),
(23,11),(23,34),
(24,36),(24,29),
(24,11),(24,34),
(23,39),

(25,16),(25,13), / 2025 /
(25,37),(25,14),
(26,37),(26,14),
(26,45),(26,15),
(27,38),(27,15), 
(27,45),(27,14), 
(25,22),(26,39),(27,40),

(28,46),(28,41), / 2026 /
(29,47),(29,42),
(30,48),(30,42),
(29,17),(30,18),

(31,49),(31,43), / 2027 /
(32,50),(32,44),
(33,50),(33,44),
(32,39),(33,40);
*/

INSERT INTO ticket_price (ticket_price_id, ticket_type_id, event_id, ticket_price_price) VALUES
/* 2018 Day 1*/
(1, 1, 1, 60.0),   /* VIP */
(2, 2, 1, 20.0),   /* Regular */
(3, 3, 1, 10.0),   /* Student */
(4, 4, 1, 5.0),    /* Senior Citizen */
(5, 5, 1, 100.0),  /* Backstage */

(6, 1, 2, 60.0),
(7, 2, 2, 20.0),
(8, 3, 2, 10.0),
(9, 4, 2, 5.0),
(10, 5, 2, 100.0),


(11, 1, 3, 65.0),/* 2018 Day 2*/
(12, 2, 3, 25.0),
(13, 3, 3, 15.0),
(14, 4, 3, 10.0),
(15, 5, 3, 105.0),


(16, 1, 4, 65.0),/* 2019 Day 1 */
(17, 2, 4, 25.0),
(18, 3, 4, 15.0),
(19, 4, 4, 10.0),
(20, 5, 4, 105.0),


(21, 1, 5, 60.0),/* 2019 Day 2 */
(22, 2, 5, 20.0),
(23, 3, 5, 10.0),
(24, 4, 5, 5.0),
(25, 5, 5, 100.0),

(26, 1, 6, 60.0),
(27, 2, 6, 20.0),
(28, 3, 6, 10.0),
(29, 4, 6, 5.0),
(30, 5, 6, 100.0),


(31, 1, 7, 70.0),/* 2019 Day 3 */
(32, 2, 7, 30.0),
(33, 3, 7, 20.0),
(34, 4, 7, 15.0),
(35, 5, 7, 110.0),

(36, 1, 8, 70.0),
(37, 2, 8, 30.0),
(38, 3, 8, 20.0),
(39, 4, 8, 15.0),
(40, 5, 8, 110.0),

(41, 1, 9, 65.0),  /* 2020 Day 1 */
(42, 2, 9, 25.0),
(43, 3, 9, 15.0),
(44, 4, 9, 10.0),
(45, 5, 9, 105.0),

(46, 1, 10, 67.0),  /* 2020 Day 2 */
(47, 2, 10, 27.0),
(48, 3, 10, 17.0),
(49, 4, 10, 12.0),
(50, 5, 10, 107.0),

(51, 1, 11, 70.0),  /* 2020 Day 3 */
(52, 2, 11, 30.0),
(53, 3, 11, 20.0),
(54, 4, 11, 15.0),
(55, 5, 11, 110.0),

(56, 1, 12, 65.0),  /* 2021 Day 1 */
(57, 2, 12, 25.0),
(58, 3, 12, 15.0),
(59, 4, 12, 10.0),
(60, 5, 12, 105.0),

(61, 1, 13, 65.0),
(62, 2, 13, 25.0),
(63, 3, 13, 15.0),
(64, 4, 13, 10.0),
(65, 5, 13, 105.0),

(66, 1, 14, 67.0),  /* 2021 Day 2 */
(67, 2, 14, 27.0),
(68, 3, 14, 17.0),
(69, 4, 14, 12.0),
(70, 5, 14, 107.0),

(71, 1, 15, 67.0),
(72, 2, 15, 27.0),
(73, 3, 15, 17.0),
(74, 4, 15, 12.0),
(75, 5, 15, 107.0),

(76, 1, 16, 67.0),  /* 2021 Day 3 */
(77, 2, 16, 27.0),
(78, 3, 16, 17.0),
(79, 4, 16, 12.0),
(80, 5, 16, 107.0),

(81, 1, 17, 62.0),  /* 2022 Day 1 */
(82, 2, 17, 22.0),
(83, 3, 17, 12.0),
(84, 4, 17, 7.0),
(85, 5, 17, 102.0),

(86, 1, 18, 62.0),
(87, 2, 18, 22.0),
(88, 3, 18, 12.0),
(89, 4, 18, 7.0),
(90, 5, 18, 102.0),

(91, 1, 19, 69.0),  /* 2022 Day 2 */
(92, 2, 19, 29.0),
(93, 3, 19, 19.0),
(94, 4, 19, 14.0),
(95, 5, 19, 109.0),

(96, 1, 20, 69.0),
(97, 2, 20, 29.0),
(98, 3, 20, 19.0),
(99, 4, 20, 14.0),
(100, 5, 20, 109.0),

(101, 1, 21, 69.0),  /* 2023 Day 1 */
(102, 2, 21, 29.0),
(103, 3, 21, 19.0),
(104, 4, 21, 14.0),
(105, 5, 21, 109.0),

(106, 1, 22, 69.0),
(107, 2, 22, 29.0),
(108, 3, 22, 19.0),
(109, 4, 22, 14.0),
(110, 5, 22, 109.0),

(111, 1, 23, 68.0),  /* 2023 Day 2 */
(112, 2, 23, 28.0),
(113, 3, 23, 18.0),
(114, 4, 23, 13.0),
(115, 5, 23, 108.0),

(116, 1, 24, 68.0),
(117, 2, 24, 28.0),
(118, 3, 24, 18.0),
(119, 4, 24, 13.0),
(120, 5, 24, 108.0),

(121, 1, 25, 70.0),  /* 2023 Day 3 */
(122, 2, 25, 30.0),
(123, 3, 25, 20.0),
(124, 4, 25, 15.0),
(125, 5, 25, 110.0),

(126, 1, 26, 65.0),  /* 2024 Day 1 */
(127, 2, 26, 25.0),
(128, 3, 26, 15.0),
(129, 4, 26, 10.0),
(130, 5, 26, 105.0),

(131, 1, 27, 65.0),  /* 2024 Day 2 */
(132, 2, 27, 25.0),
(133, 3, 27, 15.0),
(134, 4, 27, 10.0),
(135, 5, 27, 105.0),

(136, 1, 28, 70.0),  /* 2024 Day 3 */
(137, 2, 28, 30.0),
(138, 3, 28, 20.0),
(139, 4, 28, 15.0),
(140, 5, 28, 110.0),

(141, 1, 29, 70.0),  /* 2024 Day 4 */
(142, 2, 29, 30.0),
(143, 3, 29, 20.0),
(144, 4, 29, 15.0),
(145, 5, 29, 110.0),

(146, 1, 30, 70.0),  /* 2024 Day 5 */
(147, 2, 30, 30.0),
(148, 3, 30, 20.0),
(149, 4, 30, 15.0),
(150, 5, 30, 110.0),

(151, 1, 31, 65.0),  /* 2025 Day 1 */
(152, 2, 31, 25.0),
(153, 3, 31, 15.0),
(154, 4, 31, 10.0),
(155, 5, 31, 105.0),

(156, 1, 35, 65.0),
(157, 2, 35, 25.0),
(158, 3, 35, 15.0),
(159, 4, 35, 10.0),
(160, 5, 35, 105.0),

(161, 1, 32, 65.0),  /* 2025 Day 2 */
(162, 2, 32, 25.0),
(163, 3, 32, 15.0),
(164, 4, 32, 10.0),
(165, 5, 32, 105.0),

(166, 1, 36, 65.0),
(167, 2, 36, 25.0),
(168, 3, 36, 15.0),
(169, 4, 36, 10.0),
(170, 5, 36, 105.0),

(171, 1, 33, 70.0),  /* 2025 Day 3 */
(172, 2, 33, 30.0),
(173, 3, 33, 20.0),
(174, 4, 33, 15.0),
(175, 5, 33, 110.0),

(176, 1, 34, 70.0),  /* 2025 Day 4 */
(177, 2, 34, 30.0),
(178, 3, 34, 20.0),
(179, 4, 34, 15.0),
(180, 5, 34, 110.0),

(181, 1, 37, 75.0),  /* 2026 Day 1 */
(182, 2, 37, 35.0),
(183, 3, 37, 25.0),
(184, 4, 37, 20.0),
(185, 5, 37, 115.0),

(186, 1, 38, 75.0),
(187, 2, 38, 35.0),
(188, 3, 38, 25.0),
(189, 4, 38, 20.0),
(190, 5, 38, 115.0),

(191, 1, 39, 80.0),
(192, 2, 39, 40.0),
(193, 3, 39, 30.0),
(194, 4, 39, 25.0),
(195, 5, 39, 120.0),

(196, 1, 40, 60.0),  /* 2027 Day 1 */
(197, 2, 40, 20.0),
(198, 3, 40, 10.0),
(199, 4, 40, 5.0),
(200, 5, 40, 100.0),

(201, 1, 41, 65.0),  /* 2027 Day 2 */
(202, 2, 41, 25.0),
(203, 3, 41, 15.0),
(204, 4, 41, 10.0),
(205, 5, 41, 105.0),

(206, 1, 42, 70.0),  /* 2027 Day 3 */
(207, 2, 42, 30.0),
(208, 3, 42, 20.0),
(209, 4, 42, 15.0),
(210, 5, 42, 110.0);


-- YEAR 1 (Event IDs 1-3)
CALL insert_visitor_with_ticket('Kylian', 'Mbappé', 24, 'mbappe@psg.com', '6912345678', '1000000000009', 'VIP', 1, 2, @result);
CALL insert_visitor_with_ticket('Erling', 'Haaland', 22, 'haaland@mancity.com', '6912345679', '1000000000016', 'VIP', 1, 1, @result);
CALL insert_visitor_with_ticket('Jude', 'Bellingham', 20, 'bellingham@realmadrid.com', '6912345680', '1000000000023', 'Regular', 2, 2, @result);
CALL insert_visitor_with_ticket('Vinícius', 'Júnior', 23, 'junior@realmadrid.com', '6912345681', '1000000000030', 'Regular', 2, 2, @result);
CALL insert_visitor_with_ticket('Bukayo', 'Saka', 21, 'saka@arsenal.com', '6912345682', '1000000000047', 'Regular', 3, 1, @result);
CALL insert_visitor_with_ticket('Phil', 'Foden', 23, 'foden@mancity.com', '6912345683', '1000000000054', 'Regular', 3, 2, @result);
CALL insert_visitor_with_ticket('Jamal', 'Musiala', 40, 'musiala@bayern.com', '6912345684', '1000000000061', 'Regular', 1, 2, @result);
CALL insert_visitor_with_ticket('Pedri', 'González', 20, 'gonzalez@barcelona.com', '6912345685', '1000000000078', 'Regular', 2, 1, @result);
CALL insert_visitor_with_ticket('Gavi', 'Paez', 19, 'paez@barcelona.com', '6912345686', '1000000000085', 'Student', 3, 2, @result);
CALL insert_visitor_with_ticket('Rodrygo', 'Goes', 21, 'goes@realmadrid.com', '6912345687', '1000000000092', 'Student', 1, 2, @result);
CALL insert_visitor_with_ticket('Federico', 'Valverde', 24, 'valverde@realmadrid.com', '6912345688', '1000000000108', 'Student', 2, 2, @result);
CALL insert_visitor_with_ticket('Aurélien', 'Tchouaméni', 33, 'tchouameni@realmadrid.com', '6912345689', '1000000000115', 'Student', 3, 1, @result);
CALL insert_visitor_with_ticket('Declan', 'Rice', 24, 'rice@arsenal.com', '6912345690', '1000000000122', 'Student', 1, 2, @result);
CALL insert_visitor_with_ticket('Khvicha', 'Kvaratskhelia', 22, 'kvaratskhelia@napoli.com', '6912345691', '1000000000139', 'Student', 2, 2, @result);
CALL insert_visitor_with_ticket('Martin', 'Ødegaard', 24, 'odegaard@arsenal.com', '6912345692', '1000000000146', 'Student', 3, 1, @result);
CALL insert_visitor_with_ticket('Rafael', 'Leão', 43, 'leao@milan.com', '6912345693', '1000000000153', 'Student', 1, 2, @result);
CALL insert_visitor_with_ticket('Josko', 'Gvardiol', 21, 'gvardiol@mancity.com', '6912345694', '1000000000160', 'Student', 2, 2, @result);
CALL insert_visitor_with_ticket('Markos', 'Markoglou', 21, 'oglou@mark.com', '6912341234', '1000000000597', 'Student', 2, 1, @result);
CALL insert_visitor_with_ticket('Lionel', 'Messi', 67, 'messi@intermiami.com', '6912345695', '1000000000177', 'Senior Citizen', 3, 3, @result);
CALL insert_visitor_with_ticket('Kevin', 'De Bruyne', 32, 'debruyne@mancity.com', '6912345696', '1000000000184', 'Backstage', 1, 4, @result);

-- YEAR 2 (Event IDs 4-7)
CALL insert_visitor_with_ticket('Harry', 'Kane', 30, 'kane@bayern.com', '6912345697', '1000000000191', 'VIP', 4, 1, @result);
CALL insert_visitor_with_ticket('Victor', 'Osimhen', 24, 'osimhen@napoli.com', '6912345698', '1000000000207', 'VIP', 5, 2, @result);
CALL insert_visitor_with_ticket('Bernardo', 'Silva', 29, 'silva@mancity.com', '6912345699', '1000000000214', 'Regular', 6, 2, @result);
CALL insert_visitor_with_ticket('Bruno', 'Fernandes', 29, 'fernandes@manutd.com', '6912345700', '1000000000221', 'Regular', 7, 1, @result);
CALL insert_visitor_with_ticket('Christopher', 'Nkunku', 25, 'nkunku@chelsea.com', '6912345701', '1000000000238', 'Regular', 4, 2, @result);
CALL insert_visitor_with_ticket('Rúben', 'Dias', 26, 'dias@mancity.com', '6912345702', '1000000000245', 'Regular', 5, 2, @result);
CALL insert_visitor_with_ticket('Lautaro', 'Martínez', 46, 'martinez@inter.com', '6912345703', '1000000000252', 'Regular', 6, 1, @result);
CALL insert_visitor_with_ticket('Frenkie', 'de Jong', 26, 'jong@barcelona.com', '6912345704', '1000000000269', 'Regular', 7, 2, @result);
CALL insert_visitor_with_ticket('Julian', 'Alvarez', 23, 'alvarez@mancity.com', '6912345705', '1000000000276', 'Student', 4, 2, @result);
CALL insert_visitor_with_ticket('Marcus', 'Rashford', 25, 'rashford@manutd.com', '6912345706', '1000000000283', 'Student', 5, 2, @result);
CALL insert_visitor_with_ticket('Mason', 'Mount', 64, 'mount@manutd.com', '6912345707', '1000000000290', 'Student', 6, 1, @result);
CALL insert_visitor_with_ticket('Antonio', 'Rüdiger', 30, 'rudiger@realmadrid.com', '6912345708', '1000000000306', 'Student', 7, 2, @result);
CALL insert_visitor_with_ticket('Nicolò', 'Barella', 26, 'barella@inter.com', '6912345709', '1000000000313', 'Student', 4, 2, @result);
CALL insert_visitor_with_ticket('Ederson', 'Moraes', 30, 'moraes@mancity.com', '6912345710', '1000000000320', 'Student', 5, 1, @result);
CALL insert_visitor_with_ticket('Ronald', 'Araújo', 34, 'araujo@barcelona.com', '6912345711', '1000000000337', 'Student', 6, 2, @result);
CALL insert_visitor_with_ticket('Achraf', 'Hakimi', 24, 'hakimi@psg.com', '6912345712', '1000000000344', 'Student', 7, 2, @result);
CALL insert_visitor_with_ticket('Serge', 'Gnabry', 38, 'gnabry@bayern.com', '6912345713', '1000000000351', 'Student', 4, 1, @result);
CALL insert_visitor_with_ticket('Loukas', 'Stylianou', 38, 'stylianou@omonia.com', '6978512355', '1000000000566', 'Student', 4, 2, @result);
CALL insert_visitor_with_ticket('Robert', 'Lewandowski', 80, 'lewandowski@barcelona.com', '6912345714', '1000000000368', 'Senior Citizen', 5, 3, @result);
CALL insert_visitor_with_ticket('Mohamed', 'Salah', 31, 'salah@liverpool.com', '6912345715', '1000000000375', 'Backstage', 6, 4, @result);

-- YEAR 3 (Event IDs 8-11)
CALL insert_visitor_with_ticket('Enzo', 'Fernández', 22, 'fernandez@chelsea.com', '6912345716', '1000000000382', 'VIP', 8, 2, @result);
CALL insert_visitor_with_ticket('João', 'Félix', 43, 'felix@barcelona.com', '6912345717', '1000000000399', 'VIP', 9, 1, @result);
CALL insert_visitor_with_ticket('Luis', 'Díaz', 26, 'diaz@liverpool.com', '6912345718', '1000000000405', 'Regular', 10, 2, @result);
CALL insert_visitor_with_ticket('Darwin', 'Núñez', 24, 'nunez@liverpool.com', '6912345719', '1000000000412', 'Regular', 11, 2, @result);
CALL insert_visitor_with_ticket('Jack', 'Grealish', 28, 'grealish@mancity.com', '6912345720', '1000000000429', 'Regular', 8, 1, @result);
CALL insert_visitor_with_ticket('Kai', 'Havertz', 34, 'havertz@arsenal.com', '6912345721', '1000000000436', 'Regular', 9, 2, @result);
CALL insert_visitor_with_ticket('Mikel', 'Oyarzabal', 26, 'oyarzabal@realsociedad.com', '6912345722', '1000000000443', 'Regular', 10, 2, @result);
CALL insert_visitor_with_ticket('Dayot', 'Upamecano', 24, 'upamecano@bayern.com', '6912345723', '1000000000450', 'Regular', 11, 1, @result);
CALL insert_visitor_with_ticket('Takefusa', 'Kubo', 22, 'kubo@realsociedad.com', '6912345724', '1000000000467', 'Student', 8, 2, @result);
CALL insert_visitor_with_ticket('Jeremy', 'Doku', 21, 'doku@mancity.com', '6912345725', '1000000000474', 'Student', 9, 2, @result);
CALL insert_visitor_with_ticket('Evan', 'Ferguson', 18, 'ferguson@brighton.com', '6912345726', '1000000000481', 'Student', 10, 1, @result);
CALL insert_visitor_with_ticket('Xavi', 'Simons', 20, 'simons@leipzig.com', '6912345727', '1000000000498', 'Student', 11, 2, @result);
CALL insert_visitor_with_ticket('Alejandro', 'Balde', 20, 'balde@barcelona.com', '6912345728', '1000000000504', 'Student', 8, 2, @result);
CALL insert_visitor_with_ticket('Ansu', 'Fati', 20, 'fati@brighton.com', '6912345729', '1000000000511', 'Student', 9, 1, @result);
CALL insert_visitor_with_ticket('Nuno', 'Mendes', 51, 'mendes@psg.com', '6912345730', '1000000000528', 'Student', 10, 2, @result);
CALL insert_visitor_with_ticket('Rasmus', 'Højlund', 20, 'hojlund@manutd.com', '6912345731', '1000000000535', 'Student', 11, 1, @result);
CALL insert_visitor_with_ticket('Fotis', 'Ioannidis', 38, 'ioannidis@sporting.com', '6932354812', '1000000000573', 'Student', 10, 2, @result);
CALL insert_visitor_with_ticket('Zeca', 'Rodrigues', 26, 'zeca@panathinaikos.com', '6912355531', '1000000000580', 'Student', 11, 3, @result);
CALL insert_visitor_with_ticket('Manuel', 'Neuer', 79, 'neuer@bayern.com', '6912345732', '1000000000542', 'Senior Citizen', 8, 3, @result);
CALL insert_visitor_with_ticket('Karim', 'Benzema', 36, 'benzema@alittihad.com', '6912345733', '1000000000559', 'Backstage', 9, 4, @result);

-- YEAR 4 (Events 12-15)
CALL insert_visitor_with_ticket('Lionel', 'Messi', 24, 'messi@barcelona.com', '6912345601', '1000000000603', 'VIP', 12, 2, @result);
CALL insert_visitor_with_ticket('Cristiano', 'Ronaldo', 23, 'ronaldo@realmadrid.com', '6912345602', '1000000000610', 'VIP', 12, 1, @result);
CALL insert_visitor_with_ticket('Xavi', 'Hernández', 25, 'hernandez@barcelona.com', '6912345603', '1000000000627', 'Regular', 13, 2, @result);
CALL insert_visitor_with_ticket('Andrés', 'Iniesta', 24, 'iniesta@barcelona.com', '6912345604', '1000000000634', 'Regular', 13, 2, @result);
CALL insert_visitor_with_ticket('Wayne', 'Rooney', 22, 'rooney@manutd.com', '6912345605', '1000000000641', 'Regular', 14, 1, @result);
CALL insert_visitor_with_ticket('Didier', 'Drogba', 27, 'drogba@chelsea.com', '6912345606', '1000000000658', 'Regular', 14, 2, @result);
CALL insert_visitor_with_ticket('Steven', 'Gerrard', 26, 'gerrard@liverpool.com', '6912345607', '1000000000665', 'Regular', 15, 2, @result);
CALL insert_visitor_with_ticket('Frank', 'Lampard', 28, 'lampard@chelsea.com', '6912345608', '1000000000672', 'Regular', 15, 1, @result);
CALL insert_visitor_with_ticket('Zlatan', 'Ibrahimović', 21, 'ibrahimovic@acmilan.com', '6912345609', '1000000000689', 'Student', 12, 2, @result);
CALL insert_visitor_with_ticket('Fernando', 'Torres', 22, 'torres@liverpool.com', '6912345610', '1000000000696', 'Student', 13, 2, @result);
CALL insert_visitor_with_ticket('Kaká', 'Santos', 33, 'santos@realmadrid.com', '6912345611', '1000000000702', 'Student', 14, 1, @result);
CALL insert_visitor_with_ticket('Samuel', 'Eto''o', 24, 'etoo@inter.com', '6912345612', '1000000000719', 'Student', 15, 2, @result);
CALL insert_visitor_with_ticket('Gianluigi', 'Buffon', 20, 'buffon@juventus.com', '6912345613', '1000000000726', 'Student', 12, 2, @result);
CALL insert_visitor_with_ticket('Carles', 'Puyol', 45, 'puyol@barcelona.com', '6912345614', '1000000000733', 'Student', 13, 2, @result);
CALL insert_visitor_with_ticket('Iker', 'Casillas', 22, 'casillas@realmadrid.com', '6912345615', '1000000000740', 'Student', 14, 1, @result);
CALL insert_visitor_with_ticket('Thierry', 'Henry', 54, 'henry@barcelona.com', '6912345616', '1000000000757', 'Student', 15, 2, @result);
CALL insert_visitor_with_ticket('David', 'Villa', 23, 'villa@barcelona.com', '6912345617', '1000000000764', 'Student', 12, 2, @result);
CALL insert_visitor_with_ticket('Thodoris', 'Zagorakis', 50, 'zagorakis@ellas.com', '6988885617', '1000000001174', 'Student', 12, 2, @result);
CALL insert_visitor_with_ticket('Paolo', 'Maldini', 68, 'maldini@acmilan.com', '6912345618', '1000000000771', 'Senior Citizen', 13, 3, @result);
CALL insert_visitor_with_ticket('Ronaldinho', 'Gaúcho', 29, 'gaucho@acmilan.com', '6912345619', '1000000000788', 'Backstage', 14, 4, @result);

-- YEAR 5 (Events 16-19)
CALL insert_visitor_with_ticket('Arjen', 'Robben', 24, 'robben@bayern.com', '6912345620', '1000000000795', 'VIP', 16, 1, @result);
CALL insert_visitor_with_ticket('Wesley', 'Sneijder', 23, 'sneijder@inter.com', '6912345621', '1000000000801', 'VIP', 17, 2, @result);
CALL insert_visitor_with_ticket('Andrea', 'Pirlo', 26, 'pirlo@juventus.com', '6912345622', '1000000000818', 'Regular', 18, 2, @result);
CALL insert_visitor_with_ticket('John', 'Terry', 27, 'terry@chelsea.com', '6912345623', '1000000000825', 'Regular', 19, 1, @result);
CALL insert_visitor_with_ticket('Rio', 'Ferdinand', 28, 'ferdinand@manutd.com', '6912345624', '1000000000832', 'Regular', 16, 2, @result);
CALL insert_visitor_with_ticket('Sergio', 'Agüero', 20, 'aguero@mancity.com', '6912345625', '1000000000849', 'Regular', 17, 2, @result);
CALL insert_visitor_with_ticket('Nemanja', 'Vidić', 25, 'vidic@manutd.com', '6912345626', '1000000000856', 'Regular', 18, 1, @result);
CALL insert_visitor_with_ticket('Bastian', 'Schweinsteiger', 24, 'schweinsteiger@bayern.com', '6912345627', '1000000000863', 'Regular', 19, 2, @result);
CALL insert_visitor_with_ticket('Francesco', 'Totti', 22, 'totti@roma.com', '6912345628', '1000000000870', 'Student', 16, 2, @result);
CALL insert_visitor_with_ticket('Raúl', 'González', 23, 'gonzalez@realmadrid.com', '6912345629', '1000000000887', 'Student', 17, 2, @result);
CALL insert_visitor_with_ticket('Ryan', 'Giggs', 21, 'giggs@manutd.com', '6912345630', '1000000000894', 'Student', 18, 1, @result);
CALL insert_visitor_with_ticket('Michael', 'Essien', 24, 'essien@chelsea.com', '6912345631', '1000000000900', 'Student', 19, 2, @result);
CALL insert_visitor_with_ticket('Clarence', 'Seedorf', 20, 'seedorf@acmilan.com', '6912345632', '1000000000917', 'Student', 16, 2, @result);
CALL insert_visitor_with_ticket('Luís', 'Figo', 25, 'figo@inter.com', '6912345633', '1000000000924', 'Student', 17, 2, @result);
CALL insert_visitor_with_ticket('Alessandro', 'Del Piero', 22, 'delpiero@juventus.com', '6912345634', '1000000000931', 'Student', 18, 1, @result);
CALL insert_visitor_with_ticket('Patrick', 'Vieira', 24, 'vieira@inter.com', '6912345635', '1000000000948', 'Student', 19, 2, @result);
CALL insert_visitor_with_ticket('Paul', 'Scholes', 23, 'scholes@manutd.com', '6912345636', '1000000000955', 'Student', 16, 2, @result);
CALL insert_visitor_with_ticket('Fanis', 'Gkekas', 43, 'gkekas@penalty.com', '6912348836', '1000000001181', 'Student', 16, 2, @result);
CALL insert_visitor_with_ticket('Fabio', 'Cannavaro', 67, 'cannavaro@juventus.com', '6912345637', '1000000000962', 'Senior Citizen', 17, 3, @result);
CALL insert_visitor_with_ticket('Ruud', 'van Nistelrooy', 28, 'nistelrooy@realmadrid.com', '6912345638', '1000000000979', 'Backstage', 18, 4, @result);

-- YEAR 6 (Events 20-25)
CALL insert_visitor_with_ticket('David', 'Beckham', 25, 'beckham@acmilan.com', '6912345639', '1000000000986', 'VIP', 20, 2, @result);
CALL insert_visitor_with_ticket('Roberto', 'Carlos', 24, 'carlos@fenerbahce.com', '6912345640', '1000000000993', 'VIP', 21, 1, @result);
CALL insert_visitor_with_ticket('Michael', 'Ballack', 27, 'ballack@chelsea.com', '6912345641', '1000000001006', 'Regular', 22, 2, @result);
CALL insert_visitor_with_ticket('Javier', 'Zanetti', 28, 'zanetti@inter.com', '6912345642', '1000000001013', 'Regular', 23, 2, @result);
CALL insert_visitor_with_ticket('Pavel', 'Nedvěd', 26, 'nedved@juventus.com', '6912345643', '1000000001020', 'Regular', 24, 1, @result);
CALL insert_visitor_with_ticket('Gennaro', 'Gattuso', 25, 'gattuso@acmilan.com', '6912345644', '1000000001037', 'Regular', 25, 2, @result);
CALL insert_visitor_with_ticket('Claude', 'Makélélé', 24, 'makelele@psg.com', '6912345645', '1000000001044', 'Regular', 20, 2, @result);
CALL insert_visitor_with_ticket('Luca', 'Toni', 27, 'toni@bayern.com', '6912345646', '1000000001051', 'Regular', 21, 1, @result);
CALL insert_visitor_with_ticket('Rivaldo', 'Vítor', 22, 'vitor@olympiacos.com', '6912345647', '1000000001068', 'Student', 22, 2, @result);
CALL insert_visitor_with_ticket('Alessandro', 'Nesta', 23, 'nesta@acmilan.com', '6912345648', '1000000001075', 'Student', 23, 2, @result);
CALL insert_visitor_with_ticket('Marcos', 'Cafú', 21, 'cafu@acmilan.com', '6912345649', '1000000001082', 'Student', 24, 1, @result);
CALL insert_visitor_with_ticket('Hernán', 'Crespo', 24, 'crespo@inter.com', '6912345650', '1000000001099', 'Student', 25, 2, @result);
CALL insert_visitor_with_ticket('Juan', 'Verón', 20, 'veron@estudiantes.com', '6912345651', '1000000001105', 'Student', 20, 2, @result);
CALL insert_visitor_with_ticket('Gabriel', 'Batistuta', 25, 'batistuta@fiorentina.com', '6912345652', '1000000001112', 'Student', 21, 2, @result);
CALL insert_visitor_with_ticket('Rui', 'Costa', 22, 'costa@benfica.com', '6912345653', '1000000001129', 'Student', 22, 1, @result);
CALL insert_visitor_with_ticket('Roy', 'Keane', 24, 'keane@celtic.com', '6912345654', '1000000001136', 'Student', 23, 2, @result);
CALL insert_visitor_with_ticket('Dennis', 'Bergkamp', 23, 'bergkamp@arsenal.com', '6912345655', '1000000001143', 'Student', 24, 2, @result);
CALL insert_visitor_with_ticket('Angelos', 'Charisteas', 37, 'charisteas@head.com', '6912345715', '1000000001198', 'Student', 24, 2, @result);
CALL insert_visitor_with_ticket('Oliver', 'Kahn', 69, 'kahn@bayern.com', '6912345656', '1000000001150', 'Senior Citizen', 25, 3, @result);
CALL insert_visitor_with_ticket('Roberto', 'Baggio', 28, 'baggio@brescia.com', '6912345657', '1000000001167', 'Backstage', 20, 4, @result);

-- YEAR 7 (Events 26-30)
CALL insert_visitor_with_ticket('Chris', 'Hemsworth', 24, 'hemsworth@yahoo.com', '+34 612 345 678', 0100000001202, 'VIP', 26, 2 , @result);
CALL insert_visitor_with_ticket('Tom', 'Holland', 22, 'holland@yahoo.com', '+34 623 456 789', 0100000001219, 'VIP', 27, 1 , @result);
CALL insert_visitor_with_ticket('Pedro', 'Pascal', 23, 'pascal@yahoo.com', '+34 634 567 890', 0100000001226, 'Regular', 28, 2 , @result);
CALL insert_visitor_with_ticket('Ryan', 'Gosling', 51, 'gosling@yahoo.com', '+34 645 678 901', 0100000001233, 'Regular', 29, 2 , @result);
CALL insert_visitor_with_ticket('Bill', 'Murray', 25, 'murray@yahoo.com', '+34 656 789 012', 0100000001240, 'Regular', 30, 1 , @result);
CALL insert_visitor_with_ticket('Joseph', 'Quinn', 36, 'quinn@yahoo.com', '+34 667 890 123', 0100000001257, 'Regular', 26, 2 , @result);
CALL insert_visitor_with_ticket('Bill', 'Skarsgård', 34, 'skarsgård@yahoo.com', '+34 678 901 234', 0100000001264, 'Regular', 27, 2 , @result);
CALL insert_visitor_with_ticket('Glen', 'Powell', 22, 'powell@yahoo.com', '+34 689 012 345', 0100000001271, 'Regular', 28, 1 , @result);
CALL insert_visitor_with_ticket('Mason', 'Gooding', 20, 'gooding@yahoo.com', '+34 690 123 456', 0100000001288, 'Student', 29, 2 , @result);
CALL insert_visitor_with_ticket('Dua', 'Lipa', 19, 'lipa@yahoo.com', '+34 691 234 567', 0100000001295, 'Student', 30, 2 , @result);
CALL insert_visitor_with_ticket('Ariana', 'Greenblatt', 21, 'greenblatt@yahoo.com', '+34 692 345 678', 0100000001301, 'Student', 26, 2 , @result);
CALL insert_visitor_with_ticket('Denzel', 'Washington', 23, 'washington@yahoo.com', '+34 693 456 789', 0100000001318, 'Student', 27, 2 , @result);
CALL insert_visitor_with_ticket('Sydney', 'Sweeney', 32, 'sweeney@yahoo.com', '+34 694 567 890', 0100000001325, 'Student', 28, 2 , @result);
CALL insert_visitor_with_ticket('Zendaya', 'Coleman', 20, 'coleman@yahoo.com', '+34 695 678 901', 0100000001332, 'Student', 29, 1 , @result);
CALL insert_visitor_with_ticket('Danielle', 'Brooks', 44, 'brooks@yahoo.com', '+34 696 789 012', 0100000001349, 'Student', 30, 2 , @result);
CALL insert_visitor_with_ticket('Catherine', 'O\'Hara', 23, 'o\'hara@yahoo.com', '+34 697 890 123', 0100000001356, 'Student', 26, 2 , @result);
CALL insert_visitor_with_ticket('Jason', 'Statham', 22, 'statham@yahoo.com', '+34 698 901 234', 0100000001363, 'Student', 27, 2 , @result);
CALL insert_visitor_with_ticket('Simu', 'Liu', 21, 'liu@yahoo.com', '+34 699 012 345', 0100000001370, 'Student', 28, 2 , @result);
CALL insert_visitor_with_ticket('Ryan', 'Reynolds', 66, 'reynolds@yahoo.com', '+34 600 123 456', 0100000001387, 'Senior Citizen', 29, 2 , @result);
CALL insert_visitor_with_ticket('Cailee', 'Spaeny', 25, 'spaeny@yahoo.com', '+34 601 234 567', 0100000001394, 'Backstage', 30, 1 , @result);

-- YEAR 8 (Events 31-36)
CALL insert_visitor_with_ticket('Tom', 'Cruise', 28, 'cruise@yahoo.com', '0612345678', 0100000001417, 'VIP', 31, 2 , @result);
CALL insert_visitor_with_ticket('Dwayne', 'Johnson', 25, 'johnson@yahoo.com', '0612345679', 0100000001424, 'VIP', 32, 1 , @result);
CALL insert_visitor_with_ticket('Leonardo', 'DiCaprio', 22, 'dicaprio@yahoo.com', '0612345680', 0100000001431, 'Regular', 33, 2 , @result);
CALL insert_visitor_with_ticket('Brad', 'Pitt', 53, 'pitt@yahoo.com', '0612345681', 0100000001448, 'Regular', 34, 2 , @result);
CALL insert_visitor_with_ticket('Will', 'Smith', 53, 'smith@yahoo.com', '0612345682', 0100000001455, 'Regular', 35, 1 , @result);
CALL insert_visitor_with_ticket('Chris', 'Hemsworth', 26, 'hemsworth@yahoo.com', '0612345683', 0100000001462, 'Regular', 36, 2 , @result);
CALL insert_visitor_with_ticket('Ryan', 'Reynolds', 21, 'reynolds@yahoo.com', '0612345684', 0100000001479, 'Regular', 31, 2 , @result);
CALL insert_visitor_with_ticket('Robert', 'Downey', 27, 'downey@yahoo.com', '0612345685', 0100000001486, 'Regular', 32, 1 , @result);
CALL insert_visitor_with_ticket('Chris', 'Evans', 28, 'evans@yahoo.com', '0612345686', 0100000001493, 'Student', 33, 2 , @result);
CALL insert_visitor_with_ticket('Mark', 'Wahlberg', 19, 'wahlberg@yahoo.com', '0612345687', 0100000001509, 'Student', 34, 2 , @result);
CALL insert_visitor_with_ticket('Matt', 'Damon', 22, 'damon@yahoo.com', '0612345688', 0100000001516, 'Student', 35, 2 , @result);
CALL insert_visitor_with_ticket('Christian', 'Bale', 24, 'bale@yahoo.com', '0612345689', 0100000001523, 'Student', 36, 1 , @result);
CALL insert_visitor_with_ticket('Hugh', 'Jackman', 27, 'jackman@yahoo.com', '0612345690', 0100000001530, 'Student', 31, 2 , @result);
CALL insert_visitor_with_ticket('Keanu', 'Reeves', 25, 'reeves@yahoo.com', '0612345691', 0100000001547, 'Student', 32, 2 , @result);
CALL insert_visitor_with_ticket('Tom', 'Hanks', 21, 'hanks@yahoo.com', '0612345692', 0100000001554, 'Student', 33, 1 , @result);
CALL insert_visitor_with_ticket('Johnny', 'Depp', 40, 'depp@yahoo.com', '0612345693', 0100000001561, 'Student', 34, 2 , @result);
CALL insert_visitor_with_ticket('George', 'Clooney', 22, 'clooney@yahoo.com', '0612345694', 0100000001578, 'Student', 35, 2 , @result);
CALL insert_visitor_with_ticket('Robert', 'DeNiro', 27, 'deniro@yahoo.com', '0612345695', 0100000001585, 'Student', 36, 1 , @result);
CALL insert_visitor_with_ticket('Morgan', 'Freeman', 68, 'freeman@yahoo.com', '0612345696', 0100000001592, 'Senior Citizen', 31, 2 , @result);
CALL insert_visitor_with_ticket('Samuel', 'Jackson', 30, 'jackson@yahoo.com', '0612345697', 0100000001608, 'Backstage', 32, 2 , @result);

-- YEAR 9 (Events 37-39)

CALL insert_visitor_with_ticket('Max', 'Verstappen', 24, 'verstappen@yahoo.com', '07123456789', 0100000001806, 'VIP', 37, 2 , @result);
CALL insert_visitor_with_ticket('Lewis', 'Hamilton', 29, 'hamilton@yahoo.com', '07234567890', 0100000001615, 'VIP', 37, 1 , @result);
CALL insert_visitor_with_ticket('Charles', 'Leclerc', 32, 'leclerc@yahoo.com', '07345678901', 0100000001622, 'Regular', 37, 2 , @result);
CALL insert_visitor_with_ticket('George', 'Russell', 35, 'russell@yahoo.com', '07456789012', 0100000001639, 'Regular', 37, 2 , @result);
CALL insert_visitor_with_ticket('Lando', 'Norris', 43, 'norris@yahoo.com', '07567890123', 0100000001646, 'Regular', 38, 2 , @result);
CALL insert_visitor_with_ticket('Oscar', 'Piastri', 21, 'piastri@yahoo.com', '07678901234', 0100000001653, 'Regular', 38, 1 , @result);
CALL insert_visitor_with_ticket('Carlos', 'Sainz', 36, 'sainz@yahoo.com', '07789012345', 0100000001660, 'Regular', 38, 2 , @result);
CALL insert_visitor_with_ticket('Sergio', 'Perez', 28, 'perez@yahoo.com', '07890123456', 0100000001677, 'Regular', 38, 2 , @result);
CALL insert_visitor_with_ticket('Fernando', 'Alonso', 27, 'alonso@yahoo.com', '07901234567', 0100000001684, 'Student', 38, 2 , @result);
CALL insert_visitor_with_ticket('Sebastian', 'Vettel', 30, 'vettel@yahoo.com', '07012345678', 0100000001691, 'Student', 39, 2 , @result);
CALL insert_visitor_with_ticket('Valtteri', 'Bottas', 44, 'bottas@yahoo.com', '07123456780', 0100000001707, 'Student', 39, 2 , @result);
CALL insert_visitor_with_ticket('Esteban', 'Ocon', 22, 'ocon@yahoo.com', '07234567891', 0100000001714, 'Student', 39, 1 , @result);
CALL insert_visitor_with_ticket('Pierre', 'Gasly', 23, 'gasly@yahoo.com', '07345678902', 0100000001721, 'Student', 39, 2 , @result);
CALL insert_visitor_with_ticket('Kimi', 'Raikkonen', 20, 'raikkonen@yahoo.com', '07456789013', 0100000001738, 'Student', 39, 2 , @result);
CALL insert_visitor_with_ticket('Daniel', 'Ricciardo', 21, 'ricciardo@yahoo.com', '07567890124', 0100000001745, 'Student', 39, 2 , @result);
CALL insert_visitor_with_ticket('Yuki', 'Tsunoda', 19, 'tsunoda@yahoo.com', '07678901235', 0100000001752, 'Student', 39, 1 , @result);
CALL insert_visitor_with_ticket('Nico', 'Hulkenberg', 18, 'hulkenberg@yahoo.com', '07789012346', 0100000001769, 'Student', 39, 2 , @result);
CALL insert_visitor_with_ticket('Robert', 'Kubica', 90, 'kubica@yahoo.com', '07890123457', 0100000001776, 'Senior Citizen', 39, 2 , @result);
CALL insert_visitor_with_ticket('Kevin', 'Magnussen', 28, 'magnussen@yahoo.com', '07901234568', 0100000001783, 'Backstage', 39, 3 , @result);
CALL insert_visitor_with_ticket('Mick', 'Schumacher', 23, 'schumacher@yahoo.com', '07012345679', 0100000001790, 'Regular', 39, 4 , @result);

-- YEAR 10 (Events 40-42)

CALL insert_visitor_with_ticket('Kyriakos', 'Mitsotakis', 28, 'mitsotakis@yahoo.com', '+351912345678', 0100000001813, 'VIP', 40, 2 , @result);
CALL insert_visitor_with_ticket('Alexis', 'Tsipras', 22, 'tsipras@yahoo.com', '+49 15123456789', 0100000001820, 'VIP', 40, 1 , @result);
CALL insert_visitor_with_ticket('Nikos', 'Androulakis', 24, 'androulakis@yahoo.com', '+31 612345678', 0100000001837, 'Regular', 40, 2 , @result);
CALL insert_visitor_with_ticket('Dora', 'Bakoyannis', 26, 'bakoyannis@yahoo.com', '+351912345679', 0100000001844, 'Regular', 40, 2 , @result);
CALL insert_visitor_with_ticket('Katerina', 'Sakellaropoulou', 23, 'sakellaropoulou@yahoo.com', '+49 15123456780', 0100000001851, 'Regular', 40, 1 , @result);
CALL insert_visitor_with_ticket('Antonis', 'Samaras', 25, 'samaras@yahoo.com', '+31 612345679', 0100000001868, 'Regular', 41, 2 , @result);
CALL insert_visitor_with_ticket('George', 'Papandreou', 27, 'papandreou@yahoo.com', '+351912345680', 0100000001875, 'Regular', 41, 2 , @result);
CALL insert_visitor_with_ticket('Evangelos', 'Venizelos', 29, 'venizelos@yahoo.com', '+49 15123456781', 0100000001882, 'Regular', 41, 1 , @result);
CALL insert_visitor_with_ticket('Kostas', 'Karamanlis', 28, 'karamanlis@yahoo.com', '+31 612345680', 0100000001899, 'Student', 41, 2 , @result);
CALL insert_visitor_with_ticket('Prokopis', 'Pavlopoulos', 27, 'pavlopoulos@yahoo.com', '+351912345681', 0100000001905, 'Student', 41, 2 , @result);
CALL insert_visitor_with_ticket('Dimitris', 'Avramopoulos', 43, 'avramopoulos@yahoo.com', '+49 15123456782', 0100000001912, 'Student', 42, 2 , @result);
CALL insert_visitor_with_ticket('Nikos', 'Dendias', 34, 'dendias@yahoo.com', '+31 612345681', 0100000001929, 'Student', 42, 2 , @result);
CALL insert_visitor_with_ticket('Fotis', 'Kouvelis', 30, 'kouvelis@yahoo.com', '+351912345682', 0100000001936, 'Student', 42, 2 , @result);
CALL insert_visitor_with_ticket('Kostis', 'Hatzidakis', 26, 'hatzidakis@yahoo.com', '+49 15123456783', 0100000001943, 'Student', 42, 2 , @result);
CALL insert_visitor_with_ticket('Stavros', 'Dimas', 27, 'dimas@yahoo.com', '+31 612345682', 0100000001950, 'Student', 42, 2 , @result);
CALL insert_visitor_with_ticket('Maria', 'Damanaki', 28, 'damanaki@yahoo.com', '+351912345683', 0100000001967, 'Student', 41, 2 , @result);
CALL insert_visitor_with_ticket('Yanis', 'Varoufakis', 42, 'varoufakis@yahoo.com', '+49 15123456784', 0100000001974, 'Student', 41, 2 , @result);
CALL insert_visitor_with_ticket('Panagiotis', 'Pikrammenos', 55, 'pikrammenos@yahoo.com', '+31 612345683', 0100000001981, 'Student', 41, 1 , @result);
CALL insert_visitor_with_ticket('Makis', 'Voridis', 30, 'voridis@yahoo.com', '+351912345684', 0100000001998, 'Backstage', 40, 1 , @result);
CALL insert_visitor_with_ticket('Kyriakos', 'Pierrakakis', 100, 'pierrakakis@yahoo.com', '+49 15123456785', 0100000002001, 'Senior Citizen', 40, 2 , @result);

-- Insert 20 future buyers
CALL insert_buyer_visitor('Pedro', 'Sánchez', 29, 'sanchez@gmail.com', '+8613601234567');
CALL insert_buyer_visitor('Pablo', 'Iglesias', 34, 'iglesias@gmail.com', '+97577345612');
CALL insert_buyer_visitor('Inés', 'Arrimadas', 27, 'arrimadas@gmail.com', '+8210209876543');
CALL insert_buyer_visitor('Santiago', 'Abascal', 41, 'abascal@gmail.com', '+8618809876543');
CALL insert_buyer_visitor('Yolanda', 'Díaz', 30, 'diaz@gmail.com', '+8210754321987');
CALL insert_buyer_visitor('Alberto', 'Feijóo', 45, 'feijoo@gmail.com', '+8613704567890');
CALL insert_buyer_visitor('Irene', 'Montero', 26, 'montero@gmail.com', '+97577723456');
CALL insert_buyer_visitor('Ada', 'Colau', 39, 'colau@gmail.com', '+8613803456123');
CALL insert_buyer_visitor('Manuela', 'Carmena', 68, 'carmena@gmail.com', '+8210156765432');
CALL insert_buyer_visitor('José', 'Zarzalejos', 33, 'zarzalejos@gmail.com', '+8613912347890');
CALL insert_buyer_visitor('Mariano', 'Rajoy', 52, 'rajoy@gmail.com', '+8210201234567');
CALL insert_buyer_visitor('Soraya', 'Sáenz', 44, 'saenz@gmail.com', '+97577123456');
CALL insert_buyer_visitor('José', 'Borrell', 38, 'borrell@gmail.com', '+8613509871234');
CALL insert_buyer_visitor('Teresa', 'Ribera', 31, 'ribera@gmail.com', '+8210801234567');
CALL insert_buyer_visitor('Cristina', 'Narbonne', 36, 'narbonne@gmail.com', '+97577567890');
CALL insert_buyer_visitor('Arancha', 'González', 28, 'gonzalez@gmail.com', '+8613608765432');
CALL insert_buyer_visitor('Carme', 'Chacón', 87, 'chacon@gmail.com', '+8210304567891');
CALL insert_buyer_visitor('Joaquín', 'Almunia', 54, 'almunia@gmail.com', '+97577876543');
CALL insert_buyer_visitor('Miguel', 'Arias', 42, 'arias@gmail.com', '+8613903456781');
CALL insert_buyer_visitor('Pilar', 'Delgado', 23, 'delgado@gmail.com', '+8210509876543');

-- validate tickets for festivals before 2025
UPDATE ticket
SET validated = 1
WHERE event_id < 31;

--10 eisitiria pou poulaei o kosmos
INSERT INTO date_issued(year_issued,month_issued,day_issued) VALUES
(2017,10,4),
(2018,7,25),
(2019,1,31),
(2020,5,6),
(2021,3,5),
(2022,12,18),
(2023,11,25),
(2024,3,17),
(2025,3,28),
(2026,5,3);

--one ticket for every year
INSERT INTO reselling_tickets(reselling_ticket_id,`EAN_13`) VALUES
(1,1000000000009),
(2,1000000000191),
(3,1000000000382),
(4,1000000000603),
(5,1000000000795),
(6,1000000000986),
(7,0100000001202),
(8,0100000001417),
(9,0100000001806),
(10,0100000001813);

--10 alla eisitiria pou thelei o kosmos pou chattoun me to poupanw insert 
INSERT INTO desired_ticket_by_event(buyer_id,ticket_type_id,event_id,date_issued_id) VALUES
(1,1,2,1),
(2,2,5,1),
(3,2,9,1),
(4,3,13,1),
(5,3,17,1),
(6,3,21,1),
(7,3,27,1),
(8,3,32,1),
(9,1,38,1),
(10,1,41,1);

--insert about 10 reviews per year for 7 years
INSERT INTO reviews(reviews_id,visitor_id,performance_id) VALUES
(1,13,1), /*2018*/
(2,13,2),
(3,7,3),
(4,4,4),
(5,18,5),
(6,5,6),
(7,9,7),

(8,21,8), /*2019*/
(9,25,9),
(10,33,9),
(11,22,10),
(12,26,10),
(13,26,11),
(14,30,11),
(15,36,14),
(16,49,15),
(17,53,16),

(18,42,17), /*2020*/
(19,46,18),
(20,60,18),
(21,42,18),
(22,47,19),
(23,51,20),


(24,61,23), /*2021*/
(25,62,23),
(26,73,24),
(27,63,25),
(28,64,25),
(29,75,26),
(30,80,26),

(31,86,31), /*2022*/
(32,90,31),
(33,90,32),
(34,83,33),
(35,87,33),
(36,92,34),
(37,96,35),
(38,101,36),
(39,120,37),

(40,102,38), /*2023*/
(41,108,38),
(42,103,40),
(43,109,40),
(44,110,41),
(45,106,44),
(46,112,44),
(47,119,44),

(48,121,46), /*2024*/
(49,121,47),
(50,126,46),
(51,126,47),
(52,131,46),
(53,131,47),
(54,136,47),
(55,128,50),
(56,133,50),
(57,133,51),
(58,125,54),
(59,125,55),
(60,130,55),
(61,135,55);

-- enter them into likert scale table
INSERT INTO likert_scale(likert_scale_id,reviews_id,performance_score,sound_light_quality_score,stage_presence_score,organization_score,total_impression_score) VALUES
(1, 1, 4, 3, 4, 3, 4),
(2, 2, 4, 3, 4, 5, 4),
(3, 3, 4, 4, 4, 4, 4),
(4, 4, 5, 5, 4, 4, 5),
(5, 5, 3, 4, 3, 4, 3),
(6, 6, 4, 4, 4, 4, 4),
(7, 7, 2, 3, 4, 3, 3),
(8, 8, 4, 4, 4, 4, 4),
(9, 9, 4, 4, 5, 4, 5),
(10, 10, 4, 5, 2, 3, 4),
(11, 11, 4, 3, 4, 4, 5),
(12, 12, 5, 5, 5, 5, 5),
(13, 13, 4, 3, 4, 3, 4),
(14, 14, 3, 4, 4, 4, 4),
(15, 15, 4, 3, 4, 3, 4),
(16, 16, 1, 2, 2, 2, 2),
(17, 17, 4, 4, 4, 4, 4),
(18, 18, 4, 4, 3, 4, 4),
(19, 19, 4, 5, 4, 1, 4),
(20, 20, 2, 3, 2, 2, 2),
(21, 21, 5, 5, 5, 5, 5),
(22, 22, 4, 3, 4, 4, 4),
(23, 23, 4, 4, 5, 4, 4),
(24, 24, 1, 2, 4, 3, 3),
(25, 25, 5, 4, 4, 4, 5),
(26, 26, 4, 4, 4, 4, 4),
(27, 27, 4, 3, 4, 4, 3),
(28, 28, 3, 4, 3, 3, 3),
(29, 29, 1, 1, 1, 1, 1),
(30, 30, 5, 5, 5, 5, 5),
(31, 31, 4, 5, 4, 5, 5),
(32, 32, 5, 5, 5, 4, 5),
(33, 33, 2, 2, 3, 2, 2),
(34, 34, 4, 4, 4, 4, 4),
(35, 35, 4, 4, 3, 4, 4),
(36, 36, 5, 5, 4, 5, 5),
(37, 37, 4, 4, 4, 4, 4),
(38, 38, 4, 4, 3, 4, 4),
(39, 39, 4, 4, 5, 4, 5),
(40, 40, 3, 3, 4, 3, 3),
(41, 41, 4, 4, 4, 4, 4),
(42, 42, 3, 3, 4, 3, 3),
(43, 43, 1, 1, 1, 1, 1),
(44, 44, 1, 1, 1, 1, 1),
(45, 45, 1, 4, 2, 2, 3),
(46, 46, 4, 4, 4, 4, 4),
(47, 47, 4, 3, 4, 3, 4),
(48, 48, 3, 3, 3, 3, 3),
(49, 49, 4, 4, 4, 4, 4),
(50, 50, 4, 4, 5, 4, 5),
(51, 51, 4, 4, 4, 4, 4),
(52, 52, 1, 1, 1, 1, 1),
(53, 53, 4, 4, 4, 4, 4),
(54, 54, 3, 3, 4, 3, 3),
(55, 55, 4, 4, 2, 4, 4),
(56, 56, 5, 2, 2, 4, 3),
(57, 57, 4, 4, 4, 4, 4),
(58, 58, 4, 4, 4, 3, 4),
(59, 59, 4, 3, 4, 3, 4),
(60, 60, 4, 2, 4, 4, 4),
(61, 61, 4, 5, 4, 1, 4);
