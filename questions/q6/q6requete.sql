/* Louis DUBAN SI3 FISE 

6. Quels trains peuvent être réaffectés pour couvrir une panne sur une autre ligne ?

   Cette requête identifie les trains en circulation subissant une panne critique (niveau de risque ≥ 2),
   ainsi que les trains disponibles pouvant les remplacer dans les gares du trajet impacté.

   Veuillez d'abord exécuter q6data.sql situé dans le même dossier.
*/

WITH Train_en_panne AS (
    -- Identifier les trains en circulation (ayant un trajet actuel) et étant en panne avec un niveau de risque supérieur à 2.
    SELECT DISTINCT t.id_train AS id_train_panne, t.trajet_actuel
    FROM TRAIN t
    JOIN INCIDENT_TRAIN it ON it.id_train = t.id_train
    JOIN INCIDENT i ON it.id_incident = i.id_incident
	JOIN NIVEAU_RISQUE nr ON i.id_niveau_risque = nr.id_niveau_risque
    WHERE nr.niveau >= 2 AND i.resolu = FALSE
    AND t.trajet_actuel IS NOT NULL
),
Gares_Impactees AS (
    -- Trouver les gares de départ et d'arrivée des trajets des trains en panne
    SELECT DISTINCT t.trajet_actuel, tr.gare_depart AS id_gare FROM TRAIN t
    JOIN TRAJET tr ON t.trajet_actuel = tr.id_trajet
    WHERE t.id_train IN (SELECT id_train_panne FROM Train_en_panne)
    UNION
    SELECT DISTINCT t.trajet_actuel, tr.gare_arrive AS id_gare FROM TRAIN t
    JOIN TRAJET tr ON t.trajet_actuel = tr.id_trajet
    WHERE t.id_train IN (SELECT id_train_panne FROM Train_en_panne)
),
Trains_Disponibles AS (
    -- Associer les trains disponibles aux trajets des trains en panne pour s'assurer qu'ils sont bien dans les gares du trajet concerné
    SELECT t.id_train AS id_train_dispo, t.gare_actuelle, gi.trajet_actuel
    FROM TRAIN t
    JOIN Gares_Impactees gi ON t.gare_actuelle = gi.id_gare
	-- Sous requête qui vérifie que le train disponible ne subit aucun incident non résolu
    WHERE NOT EXISTS (
        SELECT 1 FROM INCIDENT_TRAIN it
        JOIN INCIDENT i ON it.id_incident = i.id_incident
        WHERE it.id_train = t.id_train AND i.resolu = FALSE
    )
)
-- Associer chaque train en panne uniquement aux trains disponibles dans les gares de son propre trajet
SELECT 
    tp.id_train_panne, 
    td.id_train_dispo, 
    g.nom AS nom_gare
FROM Train_en_panne tp
JOIN Trains_Disponibles td ON tp.trajet_actuel = td.trajet_actuel
JOIN GARE g ON td.gare_actuelle = g.id_gare
ORDER BY tp.id_train_panne;
