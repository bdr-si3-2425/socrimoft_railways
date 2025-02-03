/* Louis DUBAN SI3 FISE

7. Quels incidents ont le plus grand impact sur la ponctualité globale du réseau ferroviaire ?

Description : Insère les données nécessaires avant d'exécuter q7requete.sql

Si l'exécution ne fonctionne pas, lancer clear.sql situé dans le dossier antérieur "questions".
*/

INSERT INTO type_train (id_type_train, nom, capacite_max, vitesse_max) VALUES 
(1, 'TER', 10, 120),
(2, 'TGV', 15, 370);

INSERT INTO type_gare (id_type_gare, nom) VALUES (1, 'gare voyageur');

INSERT INTO type_wagon (id_type_wagon, nom) VALUES 
(1, 'Locomotive'),
(2, 'Voyageur');

-- Insertion de 4 gares
INSERT INTO gare (id_gare, nom, adresse, id_type_gare) VALUES 
(1,'gare1', 'impasse 4 vents',1),
(2,'gare2', 'rue 3 vents',1),
(3,'gare3', 'impasse 2 oiseaux',1),
(4,'gare4', 'rue 1 oiseau',1);

-- Insertion des trajets entre les gares
INSERT INTO trajet(id_trajet, gare_depart, gare_arrive) VALUES 
-- gare 1 -> gare 4
(1,1,2),
(2,2,3),
(3,3,4),
-- gare 4 -> gare 1
(4,4,3),
(5,3,2),
(6,2,1),
-- gare 2 -> gare 4
(7,2,4),
-- gare 4 -> gare 2
(8,4,2);

-- Insertion des trains
-- Trains 1 à 4 rattachés à des trajets, trains 5 à 9 stationnés en gare
INSERT INTO train (id_train, heures_fonctionnement, gare_actuelle, id_type_train, trajet_actuel, ligne_habituelle) VALUES 
(1, 1000, NULL, 1, 1, NULL),
(2, 1000, NULL, 1, 2, NULL),
(3, 1000, NULL, 1, 3, NULL),
(4, 1000, NULL, 2, 4, NULL),
(5, 1000, 1, 2, NULL, NULL),
(6, 1000, 2, 2, NULL, NULL),
(7, 1000, 3, 2, NULL, NULL),
(8, 1000, 4, 1, NULL, NULL),
(9,  800, 2, 1, NULL, NULL);

-- Insertion des wagons
INSERT INTO wagon(id_wagon, capacite_max, num_voiture, id_type_wagon, id_train) VALUES 
(1, 50, 1, 1, 1),
(2, 100, 2, 2, 1),
(3, 100, 3, 2, 2),
(4, 50, 1, 1, 3);

-- Insertion des types d'incidents
INSERT INTO type_incident (id_type_incident, nom) VALUES 
(1, 'Ampoule grillée'),
(2, 'Roues endommagées'),
(3, 'Caténaire défectueux'),
(4, 'Panne moteur'),
(5, 'Freins défectueux');

-- Insertion des niveaux de risque différents (de 1 à 3)
INSERT INTO niveau_risque (id_niveau_risque, nom, niveau) VALUES 
(1, 'léger', 1),
(2, 'moyen', 2),
(3, 'important', 3);

-- Insertion des incidents
-- Permet de tester q7view.sql de manière unitaire
INSERT INTO incident (id_incident, date_incident, retard, cout, resolu, id_type_incident, id_niveau_risque, id_gare) VALUES 
(10, '2025-02-01 10:00:00', '01:00:00', 50, false, 4, 2, NULL),
(11, '2025-02-02 11:15:00', '03:30:00', 200, false, 5, 3, NULL),
(12, '2025-02-01 10:00:00', '00:00:00', 1, true, 1, 1, NULL),
(13, '2025-05-01 10:30:00', '10:00:00', 1000, false, 3, 3, NULL),
(14, '2025-06-01 11:00:00', '05:30:00', 1000, true, 3, 3, NULL),
(15, '2025-02-03 09:00:00', '01:00:00', 50, false, 4, 2, NULL),
(16, '2025-02-20 10:00:00', '01:00:00', 50, true, 4, 2, NULL),
(17, '2025-02-01 06:00:00', '03:00:00', 1, true, 1, 1, 1);

-- Insertion des associations entre trains et incidents
-- Permet de tester q7view.sql de manière unitaire
INSERT INTO INCIDENT_TRAIN (id_train, id_incident) VALUES 
(1, 10),
(2, 11),
(2, 15),
(1, 16);

-- Insertion des associations entre trains et incidents
-- Permet de tester q7view.sql de manière unitaire
INSERT INTO INCIDENT_TRAJET (id_trajet, id_incident) VALUES 
(2,13),
(5,13),
(7,14),
(8,14);

-- Insertion des associations entre trains et incidents
-- Permet de tester q7view.sql de manière unitaire
INSERT INTO INCIDENT_WAGON (id_wagon, id_incident) VALUES 
(1, 12),
(3, 12),
(4, 12),
(1, 10),
(4, 11),
(3, 15),
(2, 16);



