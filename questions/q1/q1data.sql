INSERT INTO TYPE_GARE (id_type_gare, nom) VALUES
(1, 'Grande Ligne'),
(2, 'Régionale'),
(3, 'Banlieue');

INSERT INTO GARE (id_gare, nom, adresse, id_type_gare) VALUES
(1, 'Gare Nord', 'Place de la Gare 1', 1),
(2, 'Gare Centrale', 'Avenue Centrale 5', 1),
(3, 'Gare Est', 'Rue de l''Est 10', 2),
(4, 'Gare Ouest', 'Boulevard Ouest 15', 2),
(5, 'Gare Sud', 'Quai Sud 20', 3);

INSERT INTO QUAI (id_quai, nom, id_gare) VALUES
(1, 'Voie 1', 1),
(2, 'Voie 2', 1),
(3, 'Voie A', 2),
(4, 'Voie B', 2),
(5, 'Quai 1', 3),
(6, 'Quai 2', 4),
(7, 'Quai Unique', 5);

INSERT INTO EQUIPEMENT_GARE (id_equipement_gare, nom) VALUES
(1, 'Guichets'),
(2, 'Distributeurs'),
(3, 'Consignes');

INSERT INTO EQUIPER_GARE (id_gare, id_equipement_gare) VALUES
(1, 1), (1, 2), (1, 3),
(2, 1), (2, 2),
(3, 2),
(4, 2),
(5, 2);

INSERT INTO TRAJET (id_trajet, gare_depart, gare_arrive) VALUES
(1, 1, 2), -- Nord -> Centrale
(2, 2, 3), -- Centrale -> Est
(3, 2, 4), -- Centrale -> Ouest
(4, 3, 4), -- Est -> Ouest
(5, 1, 4), -- Nord -> Ouest (direct)
(6, 4, 5); -- Ouest -> Sud

INSERT INTO LIGNE (id_ligne, nom) VALUES
(1, 'Ligne Principale'),
(2, 'Ligne Secondaire');

INSERT INTO INSTANCE_LIGNE (id_instance_ligne, id_ligne) VALUES
(1, 1),
(2, 2);

INSERT INTO HORAIRE_LIGNE (id_instance_ligne, id_trajet, horaire_depart, horaire_arrive) VALUES
(1, 1, '08:00:00', '08:30:00'),  -- Nord -> Centrale
(1, 2, '08:35:00', '09:05:00'),  -- Centrale -> Est
(1, 3, '08:40:00', '09:10:00'),  -- Centrale -> Ouest
(1, 5, '08:15:00', '09:00:00');  -- Nord -> Ouest (direct)

INSERT INTO HORAIRE_LIGNE (id_instance_ligne, id_trajet, horaire_depart, horaire_arrive) VALUES
(2, 4, '09:15:00', '09:45:00'),  -- Est -> Ouest
(2, 6, '09:50:00', '10:20:00');  -- Ouest -> Sud

INSERT INTO TYPE_TRAIN (id_type_train, nom, capacite_max, vitesse_max) VALUES
(1, 'TGV', 500, 300),
(2, 'TER', 200, 160);

INSERT INTO TRAIN (id_train, heures_fonctionnement, gare_actuelle, id_type_train, trajet_actuel, ligne_habituelle) VALUES
(1, 1500, 1, 1, 1, 1),
(2, 800, 2, 2, 3, 2);
