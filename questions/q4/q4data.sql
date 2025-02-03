-- Insérer des types de gares
INSERT INTO TYPE_GARE (id_type_gare, nom) VALUES
(1, 'Gare principale'),
(2, 'Gare secondaire'),
(3, 'Gare de correspondance');

-- Insérer des gares
INSERT INTO GARE (id_gare, nom, adresse, id_type_gare) VALUES
(1, 'Gare de Paris Nord', '18 Rue de Dunkerque, 75010 Paris', 1),
(2, 'Gare de Lyon', 'Place Louis-Armand, 75012 Paris', 1),
(3, 'Gare de Marseille Saint-Charles', 'Square Narvik, 13001 Marseille', 1),
(4, 'Gare de Lille Flandres', 'Place des Buisses, 59000 Lille', 2);

-- Insérer des quais
INSERT INTO QUAI (id_quai, nom, id_gare) VALUES
(1, 'Quai 1', 1),
(2, 'Quai 2', 1),
(3, 'Quai A', 2),
(4, 'Quai B', 2),
(5, 'Quai 5', 3),
(6, 'Quai 6', 4);

-- Insérer des équipements de gare
INSERT INTO EQUIPEMENT_GARE (id_equipement_gare, nom) VALUES
(1, 'Distributeur de billets'),
(2, 'Guichet d information'),
(3, 'Toilettes'),
(4, 'Restauration');

-- Associer des équipements aux gares
INSERT INTO EQUIPER_GARE (id_gare, id_equipement_gare) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 1),
(2, 4),
(3, 3),
(4, 2);

-- Insérer des trajets
INSERT INTO TRAJET (id_trajet, gare_depart, gare_arrive) VALUES
(1, 1, 2), -- Paris Nord -> Lyon
(2, 2, 3), -- Lyon -> Marseille
(3, 1, 4), -- Paris Nord -> Lille
(4, 4, 3); -- Lille -> Marseille

-- Insérer des lignes
INSERT INTO LIGNE (id_ligne, nom) VALUES
(1, 'Ligne Paris-Lyon'),
(2, 'Ligne Lyon-Marseille'),
(3, 'Ligne Paris-Lille'),
(4, 'Ligne Lille-Marseille');

-- Insérer des instances de ligne
INSERT INTO INSTANCE_LIGNE (id_instance_ligne, id_ligne) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);

-- Insérer des horaires pour les trajets
INSERT INTO HORAIRE_LIGNE (id_instance_ligne, id_trajet, horaire_depart, horaire_arrive) VALUES
(1, 1, '08:00:00', '10:00:00'), -- Paris Nord -> Lyon
(2, 2, '10:30:00', '13:00:00'), -- Lyon -> Marseille
(3, 3, '09:00:00', '11:00:00'), -- Paris Nord -> Lille
(4, 4, '12:00:00', '16:00:00'); -- Lille -> Marseille

-- Insérer des types de train
INSERT INTO TYPE_TRAIN (id_type_train, nom, capacite_max, vitesse_max) VALUES
(1, 'TGV', 500, 320),
(2, 'TER', 300, 160),
(3, 'Intercités', 400, 200);

-- Insérer des trains
INSERT INTO TRAIN (id_train, heures_fonctionnement, gare_actuelle, id_type_train, trajet_actuel, ligne_habituelle) VALUES
(1, 120, 1, 1, 1, 1), -- TGV à Paris Nord
(2, 80, 2, 2, 2, 2), -- TER à Lyon
(3, 150, 4, 3, 3, 3); -- Intercités à Lille

-- Insérer des types de maintenance
INSERT INTO TYPE_MAINTENANCE (id_type_maintenance, nom) VALUES
(1, 'Maintenance légère'),
(2, 'Maintenance lourde'),
(3, 'Révision technique');

-- Insérer des maintenances
INSERT INTO MAINTENANCE (id_maintenance, date_maintenance, heures_fonctionnement, niveau_risque, id_type_maintenance, id_train) VALUES
(1, '2023-10-01 14:00:00', 100, 1, 1, 1),
(2, '2023-09-15 10:00:00', 200, 2, 2, 2);

-- Insérer des types de wagon
INSERT INTO TYPE_WAGON (id_type_wagon, nom) VALUES
(1, 'Wagon passagers'),
(2, 'Wagon restaurant'),
(3, 'Wagon fret');

-- Insérer des wagons
INSERT INTO WAGON (id_wagon, capacite_max, num_voiture, id_type_wagon, id_train) VALUES
(1, 50, 1, 1, 1),
(2, 30, 2, 2, 1),
(3, 40, 1, 1, 2);

-- Insérer des types d'incident
INSERT INTO TYPE_INCIDENT (id_type_incident, nom) VALUES
(1, 'Retard'),
(2, 'Panne technique'),
(3, 'Problème de signalisation');

-- Insérer des niveaux de risque
INSERT INTO NIVEAU_RISQUE (id_niveau_risque, nom, niveau) VALUES
(1, 'Faible', 1),
(2, 'Moyen', 2),
(3, 'Élevé', 3);

-- Insérer des incidents
INSERT INTO INCIDENT (id_incident, date_incident, retard, cout, resolu, id_type_incident, id_niveau_risque, id_gare) VALUES
(1, '2023-10-05 08:30:00', '01:00:00', 500.0, TRUE, 1, 2, 1),
(2, '2023-10-06 12:00:00', '02:30:00', 1000.0, FALSE, 2, 3, 2);

-- Associer des incidents à des trains
INSERT INTO INCIDENT_TRAIN (id_train, id_incident) VALUES
(1, 1),
(2, 2);

-- Associer des incidents à des wagons
INSERT INTO INCIDENT_WAGON (id_wagon, id_incident) VALUES
(1, 1),
(2, 2);

-- Associer des incidents à des trajets
INSERT INTO INCIDENT_TRAJET (id_trajet, id_incident) VALUES
(1, 1),
(2, 2);