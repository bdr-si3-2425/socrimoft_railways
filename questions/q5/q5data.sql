-- ================================
-- SCRIPT DE DONNÉES POUR TESTER LES REQUÊTES DE TRAJETS INCIDENTEES
-- ================================

-- Types de gares
INSERT INTO TYPE_GARE (id_type_gare, nom) VALUES
(1, 'Grande Ligne'), 
(2, 'Régionale'), 
(3, 'Banlieue');

-- Gares avec leurs types
INSERT INTO GARE (id_gare, nom, adresse, id_type_gare) VALUES
(1, 'Gare Nord', 'Place Nord', 1),
(2, 'Gare Centrale', 'Avenue Centrale', 1),
(3, 'Gare Est', 'Rue Est', 2),
(4, 'Gare Ouest', 'Boulevard Ouest', 2),
(5, 'Gare Sud', 'Quai Sud', 3);

-- Lignes ferroviaires
INSERT INTO LIGNE (id_ligne, nom) VALUES
(1, 'Ligne Principale'), 
(2, 'Ligne Secondaire'),
(3, 'Ligne Express');

-- Instances de lignes (pour représenter différents services sur une ligne)
INSERT INTO INSTANCE_LIGNE (id_instance_ligne, id_ligne) VALUES
(1, 1), 
(2, 2),
(3, 3);

-- Trajets entre gares
INSERT INTO TRAJET (id_trajet, gare_depart, gare_arrive) VALUES
(1, 1, 2), -- Nord -> Centrale
(2, 2, 5), -- Centrale -> Sud
(3, 1, 3), -- Nord -> Est
(4, 3, 4), -- Est -> Ouest
(5, 4, 5), -- Ouest -> Sud
(6, 4, 5); -- Ouest -> Sud (Express)

-- Horaires des trajets selon les lignes
INSERT INTO HORAIRE_LIGNE (id_instance_ligne, id_trajet, horaire_depart, horaire_arrive) VALUES
-- Ligne Principale
(1, 1, '08:00', '08:30'),
(1, 2, '08:35', '09:15'),
-- Ligne Secondaire
(2, 3, '08:05', '08:45'), 
(2, 4, '08:50', '09:20'),
(2, 5, '09:25', '10:00'),
-- Ligne Express
(3, 6, '09:30', '10:05');

-- Incidents et niveaux de risque
INSERT INTO TYPE_INCIDENT (id_type_incident, nom) VALUES (1, 'Déraillement');
INSERT INTO NIVEAU_RISQUE (id_niveau_risque, nom, niveau) VALUES (3, 'Critique', 3);
INSERT INTO INCIDENT (id_incident, date_incident, retard, cout, resolu, id_type_incident, id_niveau_risque) VALUES
(1, NOW(), '03:00:00', 10000, false, 1, 3);
INSERT INTO INCIDENT_TRAJET (id_trajet, id_incident) VALUES (1, 1), (2, 1);
