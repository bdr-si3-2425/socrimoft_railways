-- =========================================================
-- REQUÊTE RÉCURSIVE POUR CHERCHER UN TRAJET OPTIMAL
-- =========================================================

WITH RECURSIVE paths AS (
    -- Point de départ : on récupère tous les trajets qui commencent à la gare 1
    SELECT 
        t.id_trajet,
        hl.id_instance_ligne,
        t.gare_depart,
        t.gare_arrive,
        hl.horaire_depart,
        hl.horaire_arrive,
        ARRAY[t.id_trajet] AS chemin_trajets,
        ARRAY[hl.id_instance_ligne] AS chemin_instances,
        0 AS nb_correspondances,
        INTERVAL '0' AS temps_attente_total
    FROM TRAJET t
    JOIN HORAIRE_LIGNE hl ON t.id_trajet = hl.id_trajet
    WHERE t.gare_depart = 1
    
    UNION ALL
    
    -- Récursion : étendre les trajets en ajoutant les correspondances possibles
    SELECT 
        t_arrive.id_trajet,
        hl_next.id_instance_ligne,
        t_arrive.gare_depart,
        t_arrive.gare_arrive,
        hl_next.horaire_depart,
        hl_next.horaire_arrive,
        p.chemin_trajets || t_arrive.id_trajet,
        p.chemin_instances || hl_next.id_instance_ligne,
        p.nb_correspondances + 
            CASE WHEN hl_next.id_instance_ligne = p.id_instance_ligne 
                 THEN 0 
                 ELSE 1 
            END,
        p.temps_attente_total + 
            (hl_next.horaire_depart - p.horaire_arrive)
    FROM paths p
    JOIN TRAJET t_arrive ON p.gare_arrive = t_arrive.gare_depart
    JOIN HORAIRE_LIGNE hl_next ON t_arrive.id_trajet = hl_next.id_trajet
    WHERE 
        hl_next.horaire_depart >= p.horaire_arrive
        AND NOT t_arrive.id_trajet = ANY(p.chemin_trajets)
)

-- Sélection des trajets atteignant la gare 4 (Ouest), triés par nombre de correspondances et temps d'attente
SELECT 
    chemin_trajets,
    nb_correspondances,
    temps_attente_total
FROM paths
WHERE gare_arrive = 4
ORDER BY 
    nb_correspondances,
    temps_attente_total;
