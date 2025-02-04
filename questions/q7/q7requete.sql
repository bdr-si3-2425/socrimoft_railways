/* Louis DUBAN SI3 FISE

7. Quels incidents ont le plus grand impact sur la ponctualité du réseau ferroviaire ?

   Pour répondre à cette question, trois approches différentes sont utilisées :
   - Approche 1 : Identification des types d’incidents causant le plus de retard cumulé.
   - Approche 2 : Analyse du retard moyen par incident pour mesurer leur impact par infrastructure.
   - Approche 3 : Étude des incidents les plus récurrents impactant les trains.

   Ces requêtes offrent une vue d’ensemble sur les incidents les plus perturbateurs sur la ponctualité du réseau ferroviaire. 

   Pour les tests unitaires : veuillez d'abord exécuter q6data.sql situé dans le même dossier.
 */

-- Approche 1 : Classement des types d'incidents par retard total
SELECT 
    ti.nom AS type_incident, 
    ROUND(SUM(EXTRACT(EPOCH FROM i.retard) / 60)) AS retard_total_minutes
FROM INCIDENT i
JOIN TYPE_INCIDENT ti ON i.id_type_incident = ti.id_type_incident
GROUP BY ti.nom
ORDER BY retard_total_minutes DESC;

-- Approche 2 : Impact des incidents par type d'infrastructure (train, wagon, trajet, gare)
SELECT 
    'Train' AS categorie, ROUND(SUM(EXTRACT(EPOCH FROM i.retard) / 60)) AS retard_total_minutes
FROM INCIDENT i
JOIN INCIDENT_TRAIN it ON i.id_incident = it.id_incident
UNION ALL
SELECT 
    'Wagon' AS categorie, ROUND(SUM(EXTRACT(EPOCH FROM i.retard) / 60))
FROM INCIDENT i
JOIN INCIDENT_WAGON iw ON i.id_incident = iw.id_incident
UNION ALL
SELECT 
    'Trajet' AS categorie, ROUND(SUM(EXTRACT(EPOCH FROM i.retard) / 60))
FROM INCIDENT i
JOIN INCIDENT_TRAJET itj ON i.id_incident = itj.id_incident
UNION ALL
SELECT 
    'Gare' AS categorie, ROUND(SUM(EXTRACT(EPOCH FROM i.retard) / 60))
FROM INCIDENT i
WHERE i.id_gare IS NOT NULL
ORDER BY retard_total_minutes DESC;

-- Approche 3 : Quels incidents affectent le plus de trains ?
SELECT 
    ti.nom AS type_incident, 
    COUNT(DISTINCT it.id_train) AS nombre_trains_affectes
FROM INCIDENT i
JOIN TYPE_INCIDENT ti ON i.id_type_incident = ti.id_type_incident
JOIN INCIDENT_TRAIN it ON i.id_incident = it.id_incident
GROUP BY ti.nom
ORDER BY nombre_trains_affectes DESC;
