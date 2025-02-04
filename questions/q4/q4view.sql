-- Créer la nouvelle ligne
DROP FUNCTION IF EXISTS ajouter_ligne(VARCHAR);
DROP FUNCTION IF EXISTS ajouter_INSTANCE_LIGNE(INTEGER);
DROP FUNCTION IF EXISTS ajouter_Trajet(INTEGER, INTEGER);
DROP FUNCTION IF EXISTS ajouter_horaires(TIME, TIME, TIME, TIME);
DROP FUNCTION IF EXISTS trouver_chemin_optimal(INTEGER, INTEGER);
DROP FUNCTION IF EXISTS main_ajouter_Ligne(VARCHAR, INTEGER, INTEGER, TIME, TIME, TIME, TIME);

CREATE FUNCTION ajouter_ligne(nom_ligne VARCHAR) 
RETURNS VOID AS $$
DECLARE
    nouvel_id INTEGER;
BEGIN
    -- Calculer le nouvel ID : MAX(id_ligne) + 1
    SELECT COALESCE(MAX(id_ligne), 0) + 1 INTO nouvel_id FROM LIGNE;

    -- Insérer la nouvelle ligne avec le nouvel ID et le nom fourni
    INSERT INTO LIGNE (id_ligne, nom) VALUES (nouvel_id, nom_ligne);
	PERFORM ajouter_INSTANCE_LIGNE(nouvel_id);
END;
$$ LANGUAGE plpgsql;


-- Création de la ligne
CREATE FUNCTION ajouter_INSTANCE_LIGNE(Ligne_id INTEGER) 
RETURNS VOID AS $$
DECLARE
    nouvelle_id_instance_ligne INTEGER;
BEGIN
    -- Calculer le nouvel ID_instance : MAX(id_instance_ligne) + 1
    SELECT COALESCE(MAX(id_instance_ligne), 0) + 1 INTO nouvelle_id_instance_ligne FROM INSTANCE_LIGNE;

    -- Insérer la nouvelle instance de ligne avec le nouvel ID et nouvelle id instance
	INSERT INTO INSTANCE_LIGNE (id_instance_ligne, id_ligne) VALUES (nouvelle_id_instance_ligne, Ligne_id);
END;
$$ LANGUAGE plpgsql;


-- Créer les trajets associés
CREATE FUNCTION ajouter_Trajet(id_gare_prec INTEGER, id_gare_suiv INTEGER) 
RETURNS VOID AS $$
DECLARE
    nouvelle_id_traj INTEGER;
BEGIN
    -- Calculer le nouvel ID_instance : MAX(id_trajet) + 1
    SELECT COALESCE(MAX(id_trajet), 0) + 1 INTO nouvelle_id_traj FROM TRAJET;

    -- Insérer les nouvelles instances de trajet
	INSERT INTO TRAJET (id_trajet, gare_depart, gare_arrive) VALUES (nouvelle_id_traj, id_gare_prec, id_gare_suiv);
	INSERT INTO TRAJET (id_trajet, gare_depart, gare_arrive) VALUES (nouvelle_id_traj + 1, id_gare_suiv, id_gare_prec);
END;
$$ LANGUAGE plpgsql;


-- Créer les horaires
CREATE FUNCTION ajouter_horaires(horaire_depart_traj1 TIME, horaire_arrive_traj1 TIME, horaire_depart_traj2 TIME, horaire_arrive_traj2 TIME) 
RETURNS VOID AS $$
DECLARE
    la_Ligne INTEGER;
    le_traj INTEGER;
BEGIN
    -- Calculer le nouvel ID_instance : MAX(id_ligne)
    SELECT COALESCE(MAX(id_ligne), 0) INTO la_Ligne FROM LIGNE;
    -- Calculer le nouvel ID_instance : MAX(id_trajet)
    SELECT COALESCE(MAX(id_trajet), 0) INTO le_traj FROM TRAJET;

    -- Insérer les nouveaux horaires de trajet
	INSERT INTO HORAIRE_LIGNE (id_instance_ligne, id_trajet, horaire_depart, horaire_arrive) 
	VALUES (la_Ligne, le_traj - 1, horaire_depart_traj1, horaire_arrive_traj1);

	INSERT INTO HORAIRE_LIGNE (id_instance_ligne, id_trajet, horaire_depart, horaire_arrive) 
	VALUES (la_Ligne, le_traj, horaire_depart_traj2, horaire_arrive_traj2);
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION trouver_chemin_optimal(
    gare_depart INTEGER,
    gare_arrive INTEGER
) 
RETURNS TABLE (
    chemin_trajets INTEGER[],
    nb_correspondances INTEGER,
    temps_attente_total INTERVAL
) AS $$
BEGIN
    RETURN QUERY
    WITH RECURSIVE paths AS (
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
        WHERE t.gare_depart = trouver_chemin_optimal.gare_depart
        
        UNION ALL
        
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

    SELECT 
        chemin_trajets,
        nb_correspondances,
        temps_attente_total
    FROM paths
    WHERE gare_arrive = trouver_chemin_optimal.gare_arrive
    ORDER BY 
        nb_correspondances,
        temps_attente_total
    LIMIT 1;
END;
$$ LANGUAGE plpgsql;




-- Fonction principale de création de ligne
CREATE OR REPLACE FUNCTION main_ajouter_Ligne(nom_ligne VARCHAR, id_gare_prec INTEGER, id_gare_suiv INTEGER, horaire_depart_traj1 TIME, horaire_arrive_traj1 TIME, horaire_depart_traj2 TIME, horaire_arrive_traj2 TIME)  
RETURNS TABLE (
    chemin_trajets INTEGER[],
    nb_correspondances INTEGER,
    temps_attente_total INTERVAL
) AS $$
BEGIN
	PERFORM ajouter_ligne(nom_ligne);
	PERFORM ajouter_Trajet(id_gare_prec, id_gare_suiv);
	PERFORM ajouter_horaires(horaire_depart_traj1, horaire_arrive_traj1, horaire_depart_traj2, horaire_arrive_traj2);
	--Optimiser revient a refaire la q1:
	RETURN QUERY SELECT * FROM trouver_chemin_optimal(id_gare_prec, id_gare_suiv); 

	
END;
$$ LANGUAGE plpgsql;

