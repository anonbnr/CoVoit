CREATE DATABASE IF NOT EXISTS COVOITURAGE DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE COVOITURAGE;

CREATE TABLE IF NOT EXISTS Administrateur (
  idAdmin INT AUTO_INCREMENT,
  username VARCHAR(20) NOT NULL,
  password VARCHAR(20) NOT NULL,
  /*CONSTRAINTS*/
  CONSTRAINT PK_ADMINISTRATEUR
    PRIMARY KEY(idAdmin),
  CONSTRAINT UC_ADMINISTRATEUR
    UNIQUE(username)
);

CREATE TABLE IF NOT EXISTS Adresse (
	idAdr INT AUTO_INCREMENT,
  numRue NUMERIC(4),
  nomRue VARCHAR(42),
  ville VARCHAR(42) NOT NULL,
  /*CONSTRAINTS*/
  CONSTRAINT PK_ADRESSE
  	PRIMARY KEY(idAdr),
  CONSTRAINT UC_ADRESSE
  	UNIQUE(numRue, nomRue, ville)
);

CREATE TABLE IF NOT EXISTS Membre (
  idMembre INT AUTO_INCREMENT,
  email VARCHAR(100) NOT NULL,
  password VARCHAR(42) NOT NULL,
  nom VARCHAR(42) NOT NULL,
  prenom VARCHAR(42) NOT NULL,
  dateNaissance DATE NOT NULL,
  numTel CHAR(10) NOT NULL,
  reputation NUMERIC(1,1), /* reputation = somme(avis)/nombre de trajets*/
  idAdr INT,
  /*CONSTRAINTS*/
  CONSTRAINT PK_MEMBRE
  	PRIMARY KEY(idMembre),
  CONSTRAINT FK_MEMBRE_ADRESSE
  	FOREIGN KEY(idAdr) REFERENCES Adresse(idAdr) ON DELETE SET NULL,
  CONSTRAINT UC_MEMBRE_EMAIL
  	UNIQUE(email)
);

CREATE TABLE IF NOT EXISTS Vehicule (
  idVehi INT AUTO_INCREMENT,
  marque VARCHAR(20) NOT NULL,
  modele VARCHAR(20) NOT NULL,
  couleur VARCHAR(20) NOT NULL,
  idProprio INT NOT NULL,
  /*CONSTRAINTS*/
  CONSTRAINT PK_VEHICULE
  	PRIMARY KEY(idVehi),
  CONSTRAINT FK_VEHICULE_MEMBRE
  	FOREIGN KEY(idProprio) REFERENCES Membre(idMembre) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Ferme_Compte (
  idFermeture INT AUTO_INCREMENT,
  idAdmin INT,
  idMembre INT NOT NULL,
  typeFermeture BOOLEAN, /*0 if temporary 1 if permanent*/
  dureeFermeture NUMERIC(3), /*NUMERIC if temporary NULL if permanent*/
  /*CONSTRAINTS*/
  CONSTRAINT PK_FERME_COMPTE
    PRIMARY KEY(idFermeture),
  CONSTRAINT FK_FERME_COMPTE_ADMINISTRATEUR
    FOREIGN KEY(idAdmin) REFERENCES Administrateur(idAdmin) ON DELETE SET NULL,
  CONSTRAINT FK_FERME_COMPTE_MEMBRE
    FOREIGN KEY(idMembre) REFERENCES Membre(idMembre) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Trajet_Type (
  idTrajType INT AUTO_INCREMENT,
  villeDepart VARCHAR(42) NOT NULL,
  villeArrivee VARCHAR(42) NOT NULL,
  distance NUMERIC(4,2) NOT NULL, /*> 0*/
  tempsMoyen NUMERIC(4) NOT NULL, /*> 0*/
  plafondPrix NUMERIC(4,2) NOT NULL, /*> 0*/
  idAdmin INT,
  CONSTRAINT PK_TRAJET_TYPE
  	PRIMARY KEY(idTrajType),
  CONSTRAINT FK_TRAJET_TYPE_ADMINISTRATEUR
  	FOREIGN KEY(idAdmin) REFERENCES Administrateur(idAdmin) ON DELETE SET NULL,
  CONSTRAINT UC_TRAJET_TYPE
  	UNIQUE(villeDepart, villeArrivee)
);

CREATE TABLE IF NOT EXISTS Trajet (
  idTraj INT AUTO_INCREMENT,
  villeDepart VARCHAR(42) NOT NULL,
  villeArrivee VARCHAR(42) NOT NULL,
  dateTrajet TIMESTAMP NOT NULL, /*TRIGGER to make sure that the timestamp is superior to current time else reject to insert int table*/
  idVehiUtilise INT, /*TRIGGER to make sure that the vehicle belongs to the conductor else reject to insert into table*/
  nbPlaces NUMERIC(1) NOT NULL, /*TRIGGER to make sure that 0 < nbPlaces < 5*/
  prix NUMERIC(4,2) NOT NULL, /* TRIGGER if not null, prix <= plafond*/
  tailleBagages ENUM("Petite", "Moyenne", "Grande"),
  idConducteur INT NOT NULL, /*TRIGGER verify if conductor is not banished*/
  idTrajType INT, /*TRIGGER check if villeDepart and villeArrivee in Trajet_Type, if yes check prix, else set idTrajType to null*/
  /*CONSTRAINTS*/
  CONSTRAINT PK_TRAJET
  	PRIMARY KEY(idTraj),
  CONSTRAINT FK_TRAJET_VEHICULE
  	FOREIGN KEY(idVehiUtilise) REFERENCES Vehicule(idVehi) ON DELETE SET NULL,
  CONSTRAINT FK_TRAJET_MEMBRE
  	FOREIGN KEY(idConducteur) REFERENCES Membre(idMembre) ON DELETE CASCADE,
  CONSTRAINT FK_TRAJET_TRAJET_TYPE
  	FOREIGN KEY(idTrajType) REFERENCES Trajet_Type(idTrajType) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS Inscription ( /*TRIGGER sur nbPlaces*/
  idPassager INT,
  idTraj INT,
  /*CONSTRAINTS*/
  CONSTRAINT PK_INSCRIPTION
  	PRIMARY KEY(idPassager, idTraj),
  CONSTRAINT FK_INSCRIPTION_MEMBRE
  	FOREIGN KEY(idPassager) REFERENCES Membre(idMembre) ON DELETE CASCADE,
  CONSTRAINT FK_INSCRIPTION_TRAJET
  	FOREIGN KEY(idTraj) REFERENCES Trajet(idTraj) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Avis (
  idAvis INT AUTO_INCREMENT,
  nbEtoiles NUMERIC(1) NOT NULL, /*0 <= nbEtoiles <= 5*/
  commentaire VARCHAR(120),
  idTraj INT,
  idDonneur INT, /* \neq idCible*/
  idCible INT NOT NULL,
  CONSTRAINT PK_AVIS
  	PRIMARY KEY (idAvis),
  CONSTRAINT FK_AVIS_TRAJET
  	FOREIGN KEY(idTraj) REFERENCES Trajet(idTraj) ON DELETE SET NULL,
  CONSTRAINT FK_AVIS_MEMBRE_DONNEUR
  	FOREIGN KEY(idDonneur) REFERENCES Membre(idMembre) ON DELETE SET NULL,
  CONSTRAINT FK_AVIS_MEMBRE_CIBLE
  	FOREIGN KEY(idCible) REFERENCES Membre(idMembre) ON DELETE CASCADE,
  CONSTRAINT UC_AVIS
  	UNIQUE(idTraj, idDonneur, idCible)
);

CREATE TABLE IF NOT EXISTS Passe_Par (
	idTraj INT,
  idAdr INT,
  /*CONSTRAINTS*/
  CONSTRAINT PK_PASSE_PAR
  	PRIMARY KEY(idTraj, idAdr),
  CONSTRAINT FK_PASSE_PAR_TRAJET
  	FOREIGN KEY(idTraj) REFERENCES Trajet(idTraj) ON DELETE CASCADE,
  CONSTRAINT FK_PASSE_PAR_ADRESSE
  	FOREIGN KEY(idAdr) REFERENCES Adresse(idAdr)  ON DELETE CASCADE
);

/*INDEXES*/
CREATE INDEX iAdministrateur ON Administrateur (idAdmin);
CREATE INDEX iMembre ON Membre (idMembre);
CREATE INDEX iAdresse ON Adresse (idAdr);
CREATE INDEX iVehicule ON Vehicule (idVehi);
CREATE INDEX iAvis ON Avis (idAvis);
CREATE INDEX iTrajetType ON Trajet_Type (idTrajType);
CREATE INDEX iTrajet ON Trajet (idTraj);
