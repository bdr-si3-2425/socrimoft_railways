-- ================================
-- REQUÊTE RÉCURSIVE POUR CHERCHER UN TRAJET OPTIMAL EN CAS D'INCIDENT
-- ================================
WITH RECURSIVE 
trajets_incidentes AS (
    -- Sélection des trajets affectés par un incident spécifique
    SELECT t.id_trajet
    FROM INCIDENT_TRAJET it
    JOIN TRAJET t ON it.id_trajet = t.id_trajet
    WHERE it.id_incident = 1
),
paths AS (
    -- Étape initiale : rechercher les trajets disponibles depuis la gare de départ
    SELECT 
        t.id_trajet,
        t.gare_depart,
        t.gare_arrive,
        hl.horaire_depart,
        hl.horaire_arrive,
        ARRAY[t.id_trajet] AS chemin,
        0 AS correspondances,
        INTERVAL '0' AS attente,
        hl.id_instance_ligne
    FROM TRAJET t
    JOIN HORAIRE_LIGNE hl ON t.id_trajet = hl.id_trajet
    WHERE 
        t.gare_depart = 1 
        AND t.id_trajet NOT IN (SELECT id_trajet FROM trajets_incidentes)
    
    UNION ALL
    
    -- Étape récursive : étendre les chemins en évitant les trajets incidentés
    SELECT 
        t_arrive.id_trajet,
        t_arrive.gare_depart,
        t_arrive.gare_arrive,
        hl_next.horaire_depart,
        hl_next.horaire_arrive,
        p.chemin || t_arrive.id_trajet,
        p.correspondances + (hl_next.id_instance_ligne <> p.id_instance_ligne)::int,
        p.attente + (hl_next.horaire_depart - p.horaire_arrive),
        hl_next.id_instance_ligne
    FROM paths p
    JOIN TRAJET t_arrive ON p.gare_arrive = t_arrive.gare_depart
    JOIN HORAIRE_LIGNE hl_next ON t_arrive.id_trajet = hl_next.id_trajet
    WHERE 
        hl_next.horaire_depart >= p.horaire_arrive
        AND t_arrive.id_trajet NOT IN (SELECT id_trajet FROM trajets_incidentes)
        AND t_arrive.id_trajet <> ALL(p.chemin)
)

-- Sélection des itinéraires viables pour la destination cible
SELECT 
    chemin AS "Trajet alternatif",
    correspondances AS "Nb correspondances",
    attente AS "Temps attente"
FROM paths
WHERE gare_arrive = 5
ORDER BY correspondances, attente;
