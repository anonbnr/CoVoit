CREATE DATABASE IF NOT EXISTS `MEMBRES` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `MEMBRES`;

CREATE TABLE `ADMINISTRATEUR` (
  `username` VARCHAR(42),
  `password` VARCHAR(42),
  PRIMARY KEY (`username`)
) 

CREATE TABLE `FERME_COMPTE` (
  `username` VARCHAR(42),
  `email` VARCHAR(42),
  PRIMARY KEY (`username`, `email`)
) 

CREATE TABLE `MEMBRE` (
  `email` VARCHAR(42),
  `password` VARCHAR(42),
  `nom` VARCHAR(42),
  `prenom` VARCHAR(42),
  `datenaissance` VARCHAR(42),
  `numrue` VARCHAR(42),
  `nomrue` VARCHAR(42),
  `ville` VARCHAR(42),
  `codepostal` VARCHAR(42),
  `numtel` VARCHAR(42),
  `reputation` VARCHAR(42),
  PRIMARY KEY (`email`)
) 

CREATE TABLE `VEHICULE` (
  `idvehi` VARCHAR(42),
  `marque` VARCHAR(42),
  `modele` VARCHAR(42),
  `couleur` VARCHAR(42),
  `email` VARCHAR(42),
  PRIMARY KEY (`idvehi`)
) 

CREATE TABLE `INSCRIPTION` (
  `email` VARCHAR(42),
  `idtraj` VARCHAR(42),
  PRIMARY KEY (`email`, `idtraj`)
) 

CREATE TABLE `AVIS` (
  `idavis` VARCHAR(42),
  `nbetoiles` VARCHAR(42),
  `commentaire` VARCHAR(42),
  `idtraj` VARCHAR(42),
  `email` VARCHAR(42),
  `email_1` VARCHAR(42),
  PRIMARY KEY (`idavis`)
) 

CREATE TABLE `TRAJET_TYPE` (
  `idtrajtype` VARCHAR(42),
  `villedepart` VARCHAR(42),
  `villearrivee` VARCHAR(42),
  `distance` VARCHAR(42),
  `tempsmoyen` VARCHAR(42),
  `plafondprix` VARCHAR(42),
  `username` VARCHAR(42),
  PRIMARY KEY (`idtrajtype`)
) 

CREATE TABLE `TRAJET` (
  `idtraj` VARCHAR(42),
  `villedepart` VARCHAR(42),
  `villearrivee` VARCHAR(42),
  `adresserdv` VARCHAR(42),
  `adressedepose` VARCHAR(42),
  `date` VARCHAR(42),
  `typevoiture` VARCHAR(42),
  `nombreplaces` VARCHAR(42),
  `prix` VARCHAR(42),
  `taillebagage` VARCHAR(42),
  `email` VARCHAR(42),
  `idtrajtype` VARCHAR(42),
  PRIMARY KEY (`idtraj`)
) 

ALTER TABLE `FERME_COMPTE` ADD FOREIGN KEY (`email`) REFERENCES `MEMBRE` (`email`);
ALTER TABLE `FERME_COMPTE` ADD FOREIGN KEY (`username`) REFERENCES `ADMINISTRATEUR` (`username`);
ALTER TABLE `VEHICULE` ADD FOREIGN KEY (`email`) REFERENCES `MEMBRE` (`email`);
ALTER TABLE `INSCRIPTION` ADD FOREIGN KEY (`idtraj`) REFERENCES `TRAJET` (`idtraj`);
ALTER TABLE `INSCRIPTION` ADD FOREIGN KEY (`email`) REFERENCES `MEMBRE` (`email`);
ALTER TABLE `AVIS` ADD FOREIGN KEY (`email_1`) REFERENCES `MEMBRE` (`email`);
ALTER TABLE `AVIS` ADD FOREIGN KEY (`email`) REFERENCES `MEMBRE` (`email`);
ALTER TABLE `AVIS` ADD FOREIGN KEY (`idtraj`) REFERENCES `TRAJET` (`idtraj`);
ALTER TABLE `TRAJET_TYPE` ADD FOREIGN KEY (`username`) REFERENCES `ADMINISTRATEUR` (`username`);
ALTER TABLE `TRAJET` ADD FOREIGN KEY (`idtrajtype`) REFERENCES `TRAJET_TYPE` (`idtrajtype`);
ALTER TABLE `TRAJET` ADD FOREIGN KEY (`email`) REFERENCES `MEMBRE` (`email`);