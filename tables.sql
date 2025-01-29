-- SQL Schema based on the provided diagram

-- Table: TYPE_GARE
CREATE TABLE TYPE_GARE (
    id_type_gare integer NOT NULL,
    nom varchar(50) NOT NULL,
    PRIMARY KEY (id_type_gare)
);

-- Table: GARE
CREATE TABLE GARE (
    id_gare integer NOT NULL,
    nom varchar(50) NOT NULL,
    adresse varchar(100) NOT NULL,
    id_type_gare integer NOT NULL,
    PRIMARY KEY (id_gare),
    FOREIGN KEY (id_type_gare) REFERENCES TYPE_GARE(id_type_gare)
);

-- Table: QUAI
CREATE TABLE QUAI (
    id_quai integer NOT NULL,
    nom varchar(50) NOT NULL,
    id_gare integer NOT NULL,
    PRIMARY KEY (id_quai),
    FOREIGN KEY (id_gare) REFERENCES GARE(id_gare)
);

-- Table: EQUIPEMENT_GARE
CREATE TABLE EQUIPEMENT_GARE (
    id_equipement_gare integer NOT NULL,
    nom varchar(50) NOT NULL,
    PRIMARY KEY (id_equipement_gare)
);

-- Table: EQUIPER_GARE
CREATE TABLE EQUIPER_GARE (
    id_gare integer NOT NULL,
    id_equipement_gare integer NOT NULL,
    PRIMARY KEY (id_gare, id_equipement_gare),
    FOREIGN KEY (id_gare) REFERENCES GARE(id_gare),
    FOREIGN KEY (id_equipement_gare) REFERENCES EQUIPEMENT_GARE(id_equipement_gare)
);

-- Table: TRAJET
CREATE TABLE TRAJET (
    id_trajet integer NOT NULL,
    gare_depart integer NOT NULL,
    gare_arrive integer NOT NULL,
    PRIMARY KEY (id_trajet),
    FOREIGN KEY (gare_depart) REFERENCES GARE(id_gare),
    FOREIGN KEY (gare_arrive) REFERENCES GARE(id_gare)
);

-- Table: LIGNE
CREATE TABLE LIGNE (
    id_ligne integer NOT NULL,
    nom varchar(50) NOT NULL,
    PRIMARY KEY (id_ligne)
);

-- Table: INSTANCE_LIGNE
CREATE TABLE INSTANCE_LIGNE (
    id_instance_ligne integer NOT NULL,
    id_ligne integer NOT NULL,
    PRIMARY KEY (id_instance_ligne),
    FOREIGN KEY (id_ligne) REFERENCES LIGNE(id_ligne)
);

-- Table: HORAIRE
CREATE TABLE HORAIRE_LIGNE (
    id_instance_ligne integer NOT NULL,
    id_trajet integer NOT NULL,
    horaire_depart time NOT NULL,
    horaire_arrive time NOT NULL,
    PRIMARY KEY (id_instance_ligne, id_trajet),
    FOREIGN KEY (id_instance_ligne) REFERENCES INSTANCE_LIGNE(id_instance_ligne),
    FOREIGN KEY (id_trajet) REFERENCES TRAJET(id_trajet)
);

-- Table: TYPE_TRAIN
CREATE TABLE TYPE_TRAIN (
    id_type_train integer NOT NULL,
    nom varchar(50) NOT NULL,
    capacite_max integer NOT NULL,
    vitesse_max float NOT NULL,
    PRIMARY KEY (id_type_train)
);

-- Table: TRAIN
CREATE TABLE TRAIN (
    id_train integer NOT NULL,
    heures_fonctionnement integer NOT NULL,
    gare_actuelle integer,
    id_type_train integer NOT NULL,
    trajet_actuel integer,
    ligne_habituelle integer,
    PRIMARY KEY (id_train),
    FOREIGN KEY (id_type_train) REFERENCES TYPE_TRAIN(id_type_train),
    FOREIGN KEY (gare_actuelle) REFERENCES GARE(id_gare),
    FOREIGN KEY (trajet_actuel) REFERENCES TRAJET(id_trajet),
    FOREIGN KEY (ligne_habituelle) REFERENCES LIGNE(id_ligne)
);

-- Table: TYPE_MAINTENANCE
CREATE TABLE TYPE_MAINTENANCE (
    id_type_maintenance integer NOT NULL,
    nom varchar(50) NOT NULL,
    PRIMARY KEY (id_type_maintenance)
);

-- Table: MAINTENANCE
CREATE TABLE MAINTENANCE (
    id_maintenance integer NOT NULL,
    date_maintenance timestamp NOT NULL,
    heures_fonctionnement integer NOT NULL,
    niveau_risque integer NOT NULL,
    id_type_maintenance integer NOT NULL,
    id_train integer NOT NULL,
    PRIMARY KEY (id_maintenance),
    FOREIGN KEY (id_type_maintenance) REFERENCES TYPE_MAINTENANCE(id_type_maintenance),
    FOREIGN KEY (id_train) REFERENCES TRAIN(id_train)
);

-- Table: TYPE_WAGON
CREATE TABLE TYPE_WAGON (
    id_type_wagon integer NOT NULL,
    nom varchar(50) NOT NULL,
    PRIMARY KEY (id_type_wagon)
);

-- Table: WAGON
CREATE TABLE WAGON (
    id_wagon integer NOT NULL,
    capacite_max integer NOT NULL,
    num_voiture integer NOT NULL,
    id_type_wagon integer NOT NULL,
    id_train integer,
    PRIMARY KEY (id_wagon),
    FOREIGN KEY (id_type_wagon) REFERENCES TYPE_WAGON(id_type_wagon),
    FOREIGN KEY (id_train) REFERENCES TRAIN(id_train)
);

-- Table: TYPE_INCIDENT
CREATE TABLE TYPE_INCIDENT (
    id_type_incident integer NOT NULL,
    nom varchar(50) NOT NULL,
    PRIMARY KEY (id_type_incident)
);

-- Table: NIVEAU_RISQUE
CREATE TABLE NIVEAU_RISQUE (
    id_niveau_risque integer NOT NULL,
    nom varchar(50) NOT NULL,
    niveau integer NOT NULL,
    PRIMARY KEY (id_niveau_risque)
);

-- Table: INCIDENT
CREATE TABLE INCIDENT (
    id_incident integer NOT NULL,
    date_incident timestamp NOT NULL,
    retard time NOT NULL,
    cout float NOT NULL,
    resolu boolean NOT NULL,
    id_type_incident integer NOT NULL,
    id_niveau_risque integer NOT NULL,
    id_gare integer,
    PRIMARY KEY (id_incident),
    FOREIGN KEY (id_type_incident) REFERENCES TYPE_INCIDENT(id_type_incident),
    FOREIGN KEY (id_niveau_risque) REFERENCES NIVEAU_RISQUE(id_niveau_risque),
    FOREIGN KEY (id_gare) REFERENCES GARE(id_gare)
);

-- Table: INCIDENT_TRAIN
CREATE TABLE INCIDENT_TRAIN (
    id_train integer NOT NULL,
    id_incident integer NOT NULL,
    PRIMARY KEY (id_train, id_incident),
    FOREIGN KEY (id_train) REFERENCES TRAIN(id_train),
    FOREIGN KEY (id_incident) REFERENCES INCIDENT(id_incident)
);

-- Table: INCIDENT_WAGON
CREATE TABLE INCIDENT_WAGON (
    id_wagon integer NOT NULL,
    id_incident integer NOT NULL,
    PRIMARY KEY (id_wagon, id_incident),
    FOREIGN KEY (id_wagon) REFERENCES WAGON(id_wagon),
    FOREIGN KEY (id_incident) REFERENCES INCIDENT(id_incident)
);

-- Table: INCIDENT_TRAJET
CREATE TABLE INCIDENT_TRAJET (
    id_trajet integer NOT NULL,
    id_incident integer NOT NULL,
    PRIMARY KEY (id_trajet, id_incident),
    FOREIGN KEY (id_trajet) REFERENCES TRAJET(id_trajet),
    FOREIGN KEY (id_incident) REFERENCES INCIDENT(id_incident)
);


