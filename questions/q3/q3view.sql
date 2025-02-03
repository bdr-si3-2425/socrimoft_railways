-- On récupère tous les départ de tous les trains pour chaque gare
CREATE OR REPLACE VIEW depart_gare (id_gare, horaire_depart) AS
SELECT t.gare_depart AS id_gare, h.horaire_depart FROM horaire_ligne h
INNER JOIN trajet t ON h.id_trajet = t.id_trajet
ORDER BY t.gare_depart, h.horaire_depart;

SELECT * FROM depart_gare;


-- On récupère toutes les arrivées de tous les trains pour chaque gare
CREATE OR REPLACE VIEW arrive_gare (id_gare, horaire_arrive) AS
SELECT t.gare_arrive AS id_gare, h.horaire_arrive FROM horaire_ligne h
INNER JOIN trajet t ON h.id_trajet = t.id_trajet
ORDER BY t.gare_arrive, h.horaire_arrive;

SELECT * FROM arrive_gare;


-- On calcule l'indice de surcharge prévu pour une horaire donnée pour chaque gare
-- Pour chaque train qui part de la gare, son indice est réduit de 1
-- Pour chaque train qui arrive dans la gare, son indice est augmenté de 1
-- Cela signifie que l'indice peut être négatif, cependant, c'est normal
-- L'indice indique la surcharge théorique de la gare, pas un nombre de train précis
-- Les deux colones sont nécéssaire pour savoir si l'horaire est celle d'un train qui part ou qui arrive
-- On obtient les deux colones grace au FULL OUTER JOIN et aux deux view précédente
-- Ici, l'ordre des lignes est très important, car l'indice de surcharge est calculé ligne après ligne
CREATE OR REPLACE VIEW gare_surcharge_prevue_tout_horaire (id_gare, horaire_debut, horaire_fin, surcharge) AS
WITH horaire_gare (id_gare, horaire_depart, horaire_arrive) AS (
	SELECT 
	COALESCE(d.id_gare,a.id_gare) AS id_gare, 
	d.horaire_depart, 
	a.horaire_arrive 
	FROM depart_gare d
	FULL OUTER JOIN arrive_gare a ON d.id_gare = a.id_gare AND d.horaire_depart = a.horaire_arrive
)
SELECT 
id_gare, 
horaire_depart, 
horaire_arrive,
-- Pour chaque horaire dans chaque gare :
-- On calcule la valeur de surcharge par rapport à toutes les valeurs précédentes
SUM(
	CASE
		WHEN horaire_depart IS NULL THEN 1
		WHEN horaire_arrive IS NULL THEN -1 
		ELSE 0
	END
) OVER (
	PARTITION BY id_gare ORDER BY (
		CASE
			-- Le case nous permet de trier correctement les horaires sur les deux colones
			WHEN horaire_arrive IS NOT NULL AND horaire_depart IS NOT NULL THEN horaire_arrive
			WHEN horaire_arrive IS NOT NULL THEN horaire_arrive
			WHEN horaire_depart IS NOT NULL THEN horaire_depart
			ELSE '00:00:00'
		END
	)
) AS surcharge
FROM horaire_gare
ORDER BY id_gare;

SELECT * FROM gare_surcharge_prevue_tout_horaire


-- La vue finale permettant de répondre à la question
-- Utilise la vue "gare_surcharge_prevue_tout_horaire" 
-- pour créer des intervales de temps et leur donner l'indice de surcharge
-- On sélection ensuite seulement les intervales où:
-- la valeur de surcharge >= 2
-- l'horaire de fin de l'intervale est différente que celle de début
CREATE OR REPLACE VIEW gare_surcharge_prevue (id_gare, horaire_debut, horaire_fin, surcharge) AS
WITH intervales (id_gare, horaire_debut, horaire_fin, surcharge) AS (
	SELECT 
	id_gare, 
	-- Coalesce nous permet d'obtenir une horaire peut importe si l'un des colonnes est NULL
	COALESCE(horaire_debut,horaire_fin) AS horaire_debut,
	CASE 
		-- On récupère l'horaire de la ligne suivante si elle appartient à la même gare
		WHEN lead(id_gare) OVER(ORDER BY(SELECT NULL)) = id_gare THEN 
			COALESCE(
				lead(horaire_debut) OVER(ORDER BY(SELECT NULL)),
				lead(horaire_fin) OVER(ORDER BY(SELECT NULL))
			)
		ELSE NULL
	END AS horaire_fin,
	surcharge
	FROM gare_surcharge_prevue_tout_horaire
)
SELECT * FROM intervales
WHERE horaire_debut != horaire_fin AND surcharge >= 2;

SELECT * from gare_surcharge_prevue;