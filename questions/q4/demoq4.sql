-- exemple de commande a executer pou ajouter une ligne distribuant deux garres
-- Ici on ajoute une ligne 'nouvelle ligne' reliant les gares 1 (Paris Nord) et 2 (Lyon)
-- avec un navette faisant l'allé de 8h a 9h et le retour de 9h30 à 10h30
SELECT main_ajouter_Ligne('nouvelle ligne', 1, 2, '08:00:00', '09:00:00', '09:30:00', '10:30:00');

-- de nouveaux elements sont ajoutés dans les tables Ligne, Trajet, Horaire, Instance_ligne