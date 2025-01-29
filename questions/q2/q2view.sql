CREATE OR REPLACE VIEW train_besoin_maintenance (id_train, heures_depuis_derniere_maintenance, risque_depuis_derniere_maintenance) AS
SELECT 
	t.id_train, 
	(t.heures_fonctionnement-COALESCE(m.heures_fonctionnement,0)) AS heures_depuis_derniere_maintenance, 
	(SUM(COALESCE(r.niveau,0)) - COALESCE(m.niveau_risque,0)) AS risque_depuis_derniere_maintenance
FROM train t

LEFT JOIN incident_train it ON t.id_train = it.id_train

LEFT JOIN incident i ON it.id_incident = i.id_incident

LEFT JOIN niveau_risque r ON i.id_niveau_risque = r.id_niveau_risque

LEFT JOIN (
    SELECT m1.id_train, m1.heures_fonctionnement, m1.niveau_risque
	FROM maintenance m1
	INNER JOIN (
		SELECT id_train, MAX(date_maintenance) AS max_date
		FROM maintenance
		GROUP BY id_train
	) m2 ON m1.id_train = m2.id_train AND m1.date_maintenance = m2.max_date
) m ON t.id_train = m.id_train

GROUP BY t.id_train, t.heures_fonctionnement, m.niveau_risque, m.heures_fonctionnement

HAVING 
    (SUM(COALESCE(r.niveau, 0)) - COALESCE(m.niveau_risque, 0)) >= 3 
    OR 
    (t.heures_fonctionnement - COALESCE(m.heures_fonctionnement, 0)) >= 3000

ORDER BY 
    t.id_train;

SELECT * FROM train_besoin_maintenance;