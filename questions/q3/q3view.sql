CREATE OR REPLACE VIEW depart_gare (id_gare, horaire_depart) AS
SELECT t.gare_depart AS id_gare, h.horaire_depart FROM horaire_ligne h
INNER JOIN trajet t ON h.id_trajet = t.id_trajet
ORDER BY t.gare_depart, h.horaire_depart;

SELECT * FROM depart_gare;

CREATE OR REPLACE VIEW arrive_gare (id_gare, horaire_arrive) AS
SELECT t.gare_arrive AS id_gare, h.horaire_arrive FROM horaire_ligne h
INNER JOIN trajet t ON h.id_trajet = t.id_trajet
ORDER BY t.gare_arrive, h.horaire_arrive;

SELECT * FROM arrive_gare;


--------------------


SELECT COALESCE(d.id_gare,a.id_gare), d.horaire_depart, a.horaire_arrive FROM depart_gare d
FULL OUTER JOIN arrive_gare a ON d.id_gare = a.id_gare AND d.horaire_depart = a.horaire_arrive
ORDER BY  
COALESCE(d.id_gare,a.id_gare),
CASE
	WHEN horaire_arrive IS NOT NULL AND horaire_depart IS NOT NULL THEN horaire_arrive
	WHEN horaire_arrive IS NOT NULL THEN horaire_arrive
	WHEN horaire_depart IS NOT NULL THEN horaire_depart
	ELSE '00:00:00'
END


-------------


CREATE OR REPLACE VIEW gare_surcharge_prevue_tout_horaire (id_gare, horaire_debut, horaire_fin, surcharge) AS
WITH horaire_gare (id_gare, horaire_depart, horaire_arrive) AS (
	SELECT COALESCE(d.id_gare,a.id_gare), d.horaire_depart, a.horaire_arrive FROM depart_gare d
	FULL OUTER JOIN arrive_gare a ON d.id_gare = a.id_gare AND d.horaire_depart = a.horaire_arrive
)
SELECT 
id_gare, horaire_depart, horaire_arrive,
SUM(
	CASE
		WHEN horaire_depart IS NULL THEN 1
		WHEN horaire_arrive IS NULL THEN -1 
		ELSE 0
	END
) OVER (
PARTITION BY id_gare ORDER BY (
	CASE
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


---------------

CREATE OR REPLACE VIEW gare_surcharge_prevue (id_gare, horaire_debut, horaire_fin, surcharge) AS
WITH intervales (id_gare, horaire_debut, horaire_fin, surcharge) AS (
SELECT 
id_gare, 
COALESCE(horaire_debut,horaire_fin) AS horaire_debut,
CASE 
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
