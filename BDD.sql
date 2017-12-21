CREATE DATABASE IF NOT EXISTS MEMBRES DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE MEMBRES;

CREATE TABLE Administrateur (
  idAdmin INT,
  username VARCHAR(20) NOT NULL,
  password VARCHAR(20) NOT NULL,
  /*CONSTRAINTS*/
  CONSTRAINT PK_ADMINISTRATEUR 
  	PRIMARY KEY(idAdmin),
  CONSTRAINT UC_ADMINISTRATEUR
  	UNIQUE(username)
);

CREATE TABLE Ferme_compte (
  idAdmin INT,
  idMembre INT,
  typeFermeture BOOLEAN, /*0 if temporary 1 if permanent*/
  dureeFermeture NUMERIC(3), /*NUMERIC if temporary NULL if permanent*/
  /*CONSTRAINTS*/
  CONSTRAINT PK_FERME_COMPTE 
  	PRIMARY KEY(idAdmin, idMembre),
  CONSTRAINT FK_FERME_COMPTE_ADMIN
  	FOREIGN KEY(idAdmin) REFERENCES Administrateur(idAdmin), /*ON DELETE CASCADE | SET NULL*/
  CONSTRAINT FK_FERME_COMPTE_MEMBRE 
  	FOREIGN KEY(idMembre) REFERENCES Membre(idMembre) /*ON DELETE CASCADE |SET NULL*/
);

CREATE TABLE Adresse (
	idAdr INT,
  numRue NUMERIC(4) NOT NULL,
  nomRue VARCHAR(42) NOT NULL,
  ville VARCHAR(42) NOT NULL,
  /*CONSTRAINTS*/
  CONSTRAINT PK_ADRESSE
  	PRIMARY KEY(idAdr),
  CONSTRAINT UC_ADRESSE
  	UNIQUE(numRue, nomRue, ville, codePostal)
);

CREATE TABLE Membre (
  idMembre INT,
  email VARCHAR(320) NOT NULL, /*TRIGGER LIKE %@%*/
  password VARCHAR(42) NOT NULL,
  nom VARCHAR(42) NOT NULL,
  prenom VARCHAR(42) NOT NULL,
  dateNaissance DATE NOT NULL,
  numTel CHAR(10), NOT NULL,
  reputation NUMERIC(1), /* reputation = somme(avis)/nombre de trajets*/
  idAdr INT,
  /*CONSTRAINTS*/
  CONSTRAINT PK_MEMBRE 
  	PRIMARY KEY(idMembre),
  CONSTRAINT FK_MEMBRE_ID_ADRESSE 
  	FOREIGN KEY(idAdr) REFERENCES Adresse(idAdr), /*ON DELETE CASCADE | SET NULL*/
  CONSTRAINT UC_MEMBRE_EMAIL
  	UNIQUE(email),
);

CREATE TABLE Vehicule (
  idVehi INT,
  marque VARCHAR(20) NOT NULL,
  modele VARCHAR(20) NOT NULL,
  couleur VARCHAR(20) NOT NULL,
  idProprio INT NOT NULL,
  /*CONSTRAINTS*/
  CONSTRAINT PK_VEHICULE
  	PRIMARY KEY(idVehi),
  CONSTRAINT FK_VEHICULE_MEMBRE 
  	FOREIGN KEY(idProprio) REFERENCES Membre(idMembre) /*ON DELETE CASCADE | SET NULL*/
);

CREATE TABLE Inscription ( /*TRIGGER sur nbPlaces*/
  idPassager INT,
  idTraj INT,
  /*CONSTRAINTS*/
  CONSTRAINT PK_INSCRIPTION
  	PRIMARY KEY(idPassager, idTraj),
  CONSTRAINT FK_INSCRIPTION_MEMBRE
  	FOREIGN KEY(idPassager) REFERENCES Membre(idMembre), /*ON DELETE CASCADE | SET NULL*/
  CONSTRAINT FK_INSCRIPTION_TRAJET
  	FOREIGN KEY(idTraj) REFERENCES Inscription(idTraj); /*ON DELETE CASCADE | SET NULL*/
);

CREATE TABLE Avis ( /*TRIGGER on conductor, passager, and itinerary*/
  idAvis INT,
  nbEtoiles NUMERIC(1) NOT NULL, /*0 <= nbEtoiles <= 5*/
  commentaire VARCHAR(120),
  idTraj INT NOT NULL,
  idDonneur INT NOT NULL, /* \neq idCible*/
  idCible INT NOT NULL,
  CONSTRAINT PK_AVIS
  	PRIMARY KEY (idAvis),
  CONSTRAINT FK_AVIS_TRAJET
  	FOREIGN KEY(idTraj) REFERENCES Trajet(idTraj), /*ON DELETE CASCADE | SET NULL*/
  CONSTRAINT FK_AVIS_MEMBRE_DONNEUR
  	FOREIGN KEY(idDonneur) REFERENCES Membre(idMembre), /*ON DELETE CASCADE | SET NULL*/
  CONSTRAINT FK_AVIS_MEMBRE_CIBLE
  	FOREIGN KEY(idCible) REFERENCES Membre(idMembre), /*ON DELETE CASCADE | SET NULL*/
  CONSTRAINT UC_AVIS
  	UNIQUE(idTraj, idDonneur, idCible)
);

CREATE TABLE Trajet_Type (
  idTrajType INT,
  villeDepart VARCHAR(42) NOT NULL,
  villeArrivee VARCHAR(42) NOT NULL,
  distance NUMERIC(4,2) NOT NULL, /*> 0*/
  tempsMoyen NUMERIC(4) NOT NULL, /*> 0*/
  plafondPrix NUMERIC(4,2) NOT NULL, /*> 0*/
  idAdmin INT NOT NULL,
  CONSTRAINT PK_TRAJET_TYPE 
  	PRIMARY KEY(idTrajType),
  CONSTRAINT FK_TRAJET_TYPE_ADMINISTRATEUR 
  	FOREIGN KEY(idAdmin) REFERENCES Administrateur(idAdmin), /*ON DELETE CASCADE | SET NULL*/
  CONSTRAINT UC_TRAJET_TYPE
  	UNIQUE(villeDepart, villeArrivee)
);

CREATE TABLE Trajet (
  idTraj INT,
  villeDepart VARCHAR(42) NOT NULL,
  villeArrivee VARCHAR(42) NOT NULL,
  date TIMESTAMP NOT NULL, /*TRIGGER to make sure that the timestamp is superior to current time else delete from table*/
  idVehiUtilise VARCHAR(20) NOT NULL, /*TRIGGER to make sure that the vehicle belongs to the conductor*/
  nbPlaces NUMERIC(1) NOT NULL, /*TRIGGER to make sure that 0 < nbPlaces < 5*/
  prix NUMERIC(4,2) NOT NULL, /* TRIGGER if not null, prix <= plafond*/
  tailleBagages ENUM("Petite", "Moyenne", "Grande"),
  idConducteur INT NOT NULL, /*TRIGGER verify if conductor is not banished*/
  idTrajType INT, /*if not null, check villeDepart et villeArrivee avec celles de TrajetType*/
  /*CONSTRAINTS*/
  CONSTRAINT PK_TRAJET
  	PRIMARY KEY(idTraj),
  CONSTRAINT FK_TRAJET_VEHICULE
  	FOREIGN KEY(idVehiUtilise) REFERENCES Vehicule(idVehi), /*ON DELETE CASCADE | SET NULL*/
  CONSTRAINT FK_TRAJET_MEMBRE
  	FOREIGN KEY(idConducteur) REFERENCES Membre(idMembre) /*ON DELETE CASCADE | SET NULL*/
);

CREATE TABLE Passe_Par (
	idTraj INT,
  idAdr INT,
  /*CONSTRAINTS*/
  CONSTRAINT PK_PASSE_PAR
  	PRIMARY KEY(idTraj, idAdr),
  CONSTRAINT FK_PASSE_PAR_TRAJET
  	FOREIGN KEY(idTraj) REFERENCES Trajet(idTraj), /*ON DELETE CASCADE | SET NULL*/
  CONSTRAINT FK_PASSE_PAR_ADRESSE
  	FOREIGN KEY(idAdr) REFERENCES Adresse(idAdr) /*ON DELETE CASCADE | SET NULL*/
);