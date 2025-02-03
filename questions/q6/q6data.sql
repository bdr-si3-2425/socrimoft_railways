-- Louis DUBAN SI3 FISE
-- Quels trains peuvent être réaffectés pour couvrir une panne sur une autre ligne ?

INSERT INTO type_train (id_type_train, nom, capacite_max, vitesse_max) VALUES 
(1, 'TER', 10, 120),
(2, 'TGV', 15, 370);

INSERT INTO type_gare (id_type_gare, nom) VALUES (1, 'gare voyageur');

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

-- Insertion des types d'incidents
INSERT INTO type_incident (id_type_incident, nom) VALUES 
(1, 'ampoule grillée'),
(2, 'roues endommagées'),
(3, 'déraillage');

-- Insertion des niveaux de risque différents (de 1 à 3)
INSERT INTO niveau_risque (id_niveau_risque, nom, niveau) VALUES 
(1, 'léger', 1),
(2, 'moyen', 2),
(3, 'important', 3);

-- Insertion des incidents
INSERT INTO incident (id_incident, date_incident, retard, cout, resolu, id_type_incident, id_niveau_risque, id_gare) VALUES 
(1, '2025-01-27 16:30:12', '00:00:00', 10, false, 1, 1, NULL),
(2, '2025-01-27 16:32:50', '00:25:00', 10, false, 2, 2, NULL),
(3, '2025-01-27 16:36:50', '02:15:00', 10, false, 3, 3, NULL),
(4, '2025-01-28 16:30:12', '00:00:00', 10, false, 1, 1, NULL),
(5, '2025-01-28 16:32:50', '00:20:00', 10, false, 2, 2, NULL),
(6, '2025-01-30 16:36:50', '02:45:00', 10, false, 3, 3, NULL),
(7, '2025-01-27 16:40:50', '00:25:00', 10, false, 2, 2, NULL),
(8, '2025-01-27 15:27:50', '02:45:00', 10, false, 3, 3, NULL),
(9, '2025-01-27 15:27:50', '02:45:00', 10,  true, 3, 3, NULL);

-- Insertion des associations entre trains et incidents
-- Permet de tester q6view.sql de manière unitaire
INSERT INTO INCIDENT_TRAIN (id_train, id_incident) VALUES 
(1, 2), -- Train 1 impacté par un incident niveau 2 non résolu
(3, 9), -- Train 3 impacté par un incident niveau 3 résolu
(4, 9), -- Train 4 impacté par un incident niveau 1 non résolu
(4, 8), -- Train 4 impacté par un incident niveau 3 non résolu
(6, 8), -- Train 6 impacté par un incident niveau 3 non résolu
(5, 9); -- Train 5 impacté par un incident niveau 3 résolu




 
