INSERT INTO type_gare (id_type_gare, nom) VALUES (1, 'gare voyageur');

INSERT INTO gare (id_gare, nom, adresse, id_type_gare) VALUES 
(1,'gare1', 'impasse 4 vents',1),
(2,'gare2', 'rue 3 vents',1),
(3,'gare3', 'impasse 2 oiseaux',1),
(4,'gare4', 'rue 1 oiseau',1);

INSERT INTO ligne (id_ligne, nom) VALUES 
(1,'gare1-gare4'),
(2,'gare4-gare1'),
(3,'gare1-gare3'),
(4,'gare3-gare1'),
(5,'gare2-gare4'),
(6,'gare4-gare2');

INSERT INTO instance_ligne (id_instance_ligne, id_ligne) VALUES
--ligne 1 : 3 instance
(1,1),
(2,1),
(3,1),
--ligne 2 : 2 instance
(4,2),
(5,2),
--ligne 3 : 1 instance
(6,3),
--ligne 4 : 1 instance
(7,4),
--ligne 5 : 1 instance
(8,5),
--ligne 6 : 1 instance
(9,6);

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

INSERT INTO horaire_ligne (id_instance_ligne, id_trajet, horaire_depart, horaire_arrive) VALUES
(1, 1, '06:00:00', '06:30:00'),
(1, 2, '06:35:00', '06:45:00'),
(1, 3, '06:50:00', '07:10:00'),

(2, 1, '06:30:00', '07:00:00'),
(2, 2, '07:05:00', '07:15:00'),
(2, 3, '07:20:00', '07:40:00'),

(3, 1, '07:00:00', '07:30:00'),
(3, 2, '07:35:00', '07:45:00'),
(3, 3, '07:50:00', '08:10:00'),

(4, 4, '06:00:00', '06:30:00'),
(4, 5, '06:45:00', '06:55:00'),
(4, 6, '07:10:00', '07:30:00'),

(5, 4, '06:30:00', '07:00:00'),
(5, 5, '07:15:00', '07:25:00'),
(5, 6, '07:40:00', '08:00:00'),

(6, 1, '06:25:00', '06:55:00'),
(6, 2, '07:05:00', '07:15:00'),

(7, 5, '06:25:00', '06:55:00'),
(7, 6, '07:05:00', '07:15:00'),

(8, 7, '06:25:00', '06:55:00'),

(9, 8, '07:05:00', '07:15:00');