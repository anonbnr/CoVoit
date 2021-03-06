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
CREATE OR REPLACE TRIGGER verifyTrajet
BEFORE INSERT /*OR UPDATE*/ ON Trajet
FOR EACH ROW
BEGIN
  IF NEW.dateTrajet < CURRENT_TIMESTAMP THEN
    SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30006, MESSAGE_TEXT = 'Date du trajet invalide !';
  END IF;
  IF NEW.nbPlaces <=0 OR NEW.nbPlaces >=5 THEN
    SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30007, MESSAGE_TEXT = 'Nombre de places invalide !';
  END IF;
  IF NEW.idTrajType IS NOT NULL THEN
    IF prix > (
      SELECT plafondPrix
      FROM Trajet_Type
      WHERE NEW.idTrajType = Trajet_Type.idTrajType
    ) THEN
      SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30008, MESSAGE_TEXT = 'Le plafond du prix du trajet non respecté !';
    END IF;
  END IF;
END;
//

CREATE OR REPLACE TRIGGER checkAvis
BEFORE INSERT OR UPDATE ON Avis
FOR EACH ROW
BEGIN
  IF NEW.nbEtoiles >5 OR NEW.nbEtoiles<0 THEN
    SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30020, MESSAGE_TEXT = 'Le nombre detoiles doit etre entre 0 et 5!';
  END IF;
  
END;
//

CREATE OR REPLACE TRIGGER checkIdDonneur
BEFORE INSERT OR UPDATE ON Avis
FOR EACH ROW
BEGIN
  
  IF NEW.idDonneur=NEW.idCible THEN
    SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30021, MESSAGE_TEXT = 'La cible et le donneur doivent etre differents';
  END IF;

  IF (NEW.idDonneur  IN  SELECT idPassager FROM Inscription WHERE idTraj=NEW.idTraj) THEN
    IF  (NEW.idCible <> SELECT idConducteur FROM Trajet WHERE idTraj=NEW.idTraj) THEN 
          SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30022, MESSAGE_TEXT = 'Si la donneur est un passager alors cible doit etre son conducteur';

  ELSE IF (NEW.idDonneur = SELECT idConducteur FROM Trajet WHERE idTraj=NEW.idTraj) THEN
    IF (NEW.idCible NOT IN  SELECT idPassager FROM Inscription WHERE idTraj=NEW.idTraj) THEN
      SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30022, MESSAGE_TEXT = 'Si la donneur est un conducteur alors cible doit etre un de ses passagers';

  ELSE
      SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 30022, MESSAGE_TEXT = 'Le donneur doit etre ou bien le conducteur ou un passager du trajet ';


END;
//

DELIMITER ;

/*TRAJET*/
/*======*/
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
