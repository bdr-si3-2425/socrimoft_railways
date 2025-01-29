
INSERT INTO public.type_train (id_type_train, nom, capacite_max, vitesse_max) VALUES 
(1, 'TER', 10, 120),
(2, 'TGV', 15, 370);

INSERT INTO public.train (id_train, heures_fonctionnement, gare_actuelle, id_type_train, trajet_actuel, ligne_habituelle) VALUES 
(1, 1000, NULL, 1, NULL, NULL),
(2, 3500, NULL, 1, NULL, NULL),
(3, 1000, NULL, 1, NULL, NULL),
(4, 4000, NULL, 2, NULL, NULL),
(5, 1500, NULL, 2, NULL, NULL),
(6, 8000, NULL, 2, NULL, NULL),
(7, 1500, NULL, 2, NULL, NULL),
(8, 7500, NULL, 1, NULL, NULL);

INSERT INTO public.type_incident (id_type_incident, nom) VALUES 
(1, 'ampoule grillée'),
(2, 'roues endommagées'),
(3, 'déraillage');


INSERT INTO public.niveau_risque (id_niveau_risque, nom, niveau) VALUES 
(1, 'léger', 1),
(2, 'moyen', 2),
(3, 'important', 3);


INSERT INTO incident (id_incident, date_incident, retard, cout, resolu, id_type_incident, id_niveau_risque, id_gare) VALUES 
(1, '2025-01-27 16:30:12', '00:00:00', 10, false, 1, 1, NULL),
(2, '2025-01-27 16:32:50', '00:25:00', 10, false, 2, 2, NULL),
(3, '2025-01-27 16:36:50', '02:15:00', 10, false, 3, 3, NULL),
(4, '2025-01-28 16:30:12', '00:00:00', 10, false, 1, 1, NULL),
(5, '2025-01-28 16:32:50', '00:20:00', 10, false, 2, 2, NULL),
(6, '2025-01-30 16:36:50', '02:45:00', 10, false, 3, 3, NULL),
(7, '2025-01-27 16:40:50', '00:25:00', 10, false, 2, 2, NULL),
(8, '2025-01-27 15:27:50', '02:45:00', 10, false, 3, 3, NULL);


INSERT INTO public.incident_train (id_train, id_incident) VALUES 
(3, 1),
(3, 2),
(4, 7),
(5, 3),
(7, 4),
(7, 5),
(7, 6),
(8, 8);

INSERT INTO public.type_maintenance (id_type_maintenance, nom) VALUES 
(1, 'maintenance régulière'),
(2, 'réparation après incident');

INSERT INTO public.maintenance (id_maintenance, date_maintenance, id_type_maintenance, id_train, heures_fonctionnement, niveau_risque) VALUES 
(1, '2025-01-27', 1, 4, 3000, 2),
(2, '2025-01-27', 2, 5, 1500, 3),
(3, '2025-01-27', 1, 6, 3000, 0),
(4, '2025-01-27', 1, 7, 1500, 3),
(5, '2025-01-26', 1, 8, 3000, 0),
(6, '2025-01-27', 2, 8, 3500, 3);
