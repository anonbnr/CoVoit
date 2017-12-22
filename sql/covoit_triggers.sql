USE COVOITURAGE;

DELIMITER //

/*MEMBRE*/
/*=======*/
CREATE OR REPLACE TRIGGER checkEmail
BEFORE INSERT /*OR UPDATE*/ ON Membre
FOR EACH ROW
BEGIN
  IF NEW.email NOT REGEXP '^[a-zA-Z0-9][a-zA-Z0-9._-]*[a-zA-Z0-9._-]@[a-zA-Z0-9][a-zA-Z0-9._-]*[a-zA-Z0-9]\\.[a-zA-Z]{2,4}$' THEN
    SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30001, MESSAGE_TEXT = 'Email invalide !';
  END IF;
END;
//

/*FERME_COMPTE*/
/*============*/
CREATE OR REPLACE TRIGGER setBanMember
AFTER INSERT /*OR UPDATE*/ ON Ferme_Compte
FOR EACH ROW
BEGIN
  IF NEW.typeFermeture = 1 THEN
    UPDATE Membre SET dureeFermeture = NULL;
  ELSE
    IF NEW.dureeFermeture IS NULL THEN
      SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30002, MESSAGE_TEXT = 'La duree de fermeture doit être non nulle !';
    END IF;
  END IF;
END;
//

/*TRAJET_TYPE*/
/*===========*/
CREATE OR REPLACE TRIGGER verifyTrajetType
BEFORE INSERT  /*OR UPDATE*/  ON Trajet_Type
FOR EACH ROW
BEGIN
  IF NEW.distance <= 0 THEN
    SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30003, MESSAGE_TEXT = 'Distance doit être positive !';
  END IF;
  IF NEW.tempsMoyen <= 0 THEN
    SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30004, MESSAGE_TEXT = 'Temps moyen doit être positive !';
  END IF;
  IF NEW.plafondPrix <= 0 THEN
    SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30005, MESSAGE_TEXT = 'Plafond du prix doit être positive !';
  END IF;
END;
//

/*TRAJET*/
/*======*/
CREATE OR REPLACE TRIGGER verifyDateTrajet
BEFORE INSERT /*OR UPDATE*/ ON Trajet
FOR EACH ROW
BEGIN
  IF NEW.dateTrajet < CURRENT_TIMESTAMP THEN
    SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30006, MESSAGE_TEXT = 'Date du trajet invalide !';
  END IF;
END;
//

DELIMITER ;

/*TRAJET*/
/*======*/
/*nbPlaces NUMERIC(1) NOT NULL,
  TRIGGER to make sure that 0 < nbPlaces < 5*/
/*prix NUMERIC(4,2) NOT NULL,
  TRIGGER to make sur that if idTrajType is not null, prix <= plafond*/
/*idConducteur INT NOT NULL,
  TRIGGER verify if conductor is not banished*/
/*idTrajType INT,
  TRIGGER check if villeDepart and villeArrivee in Trajet_Type
    if yes check prix
    else set idTrajType to null*/

/*INSCRIPTION*/
/*===========*/
/*TRIGGER
  if nbPlaces in Trajet of idTraj different from 0, nbPlaces--
  else reject new inscription*/

/*AVIS*/
/*====*/
/*nbEtoiles NUMERIC(1) NOT NULL,
  TRIGGER /*0 <= nbEtoiles <= 5*/
/*idDonneur INT,
  different from idCible*/


-- CREATE OR REPLACE TRIGGER calculReputation
-- AFTER INSERT ON Avis FOR EACH ROW
-- DECLARE
--   membreReputation NUMERIC(1,2);
--   nbTrajets INT;
-- BEGIN
--   SET @membreReputation := (
--     SELECT DISTINCT reputation
--     FROM Membre, Avis
--     WHERE Membre.idMembre = Avis.idCible;
--   );
--   SET @nbTrajets := (
--     SELECT COUNT(*)
--     FROM Trajet, Inscription
--     WHERE Avis.idCible = Trajet.idConducteur
--     OR Avis.idCible = Inscription.idPassager
--   );
--   IF nbTrajets = 1 THEN
--     UPDATE Membre SET reputation = Avis.nbEtoiles WHERE Membre.idMembre = Avis.idCible;
--   ELSIF nbTrajets > 1 THEN
--     UPDATE Membre SET reputation = (membreReputation + Avis.nbEtoiles)/nbPlaces WHERE Membre.idMembre = Avis.idCible;
--   ELSE
--     SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30002, MESSAGE_TEXT = 'Aucun trajet fait par ce membre !';
-- END;
-- //

/*idVehiUtilise INT,
  TRIGGER to make sure that the vehicle belongs to the conductor else reject to insert into table*/
-- CREATE OR REPLACE TRIGGER verifyConducteurVehicule
-- BEFORE INSERT /*OR UPDATE*/ ON Trajet
-- FOR EACH ROW
-- BEGIN
--   IF NEW.idVehiUtilise NOT IN (
--     SELECT idVehi
--     FROM Vehicule
--     WHERE NEW.idConducteur = idProprio;
--   ) THEN
--     SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30006, MESSAGE_TEXT = 'Choix de véhicule invalide !';
--   END IF;
-- END;
-- //
