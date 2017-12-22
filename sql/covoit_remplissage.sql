
/*
Effacer les anciennes valeurs des relations
*/

-------------------------------------------;
--- Suppression des anciens tuples --------;
-------------------------------------------;
    DELETE FROM Administrateur; 
    DELETE FROM Adresse; 
    DELETE FROM Membre; 
    DELETE FROM Vehicule; 
    DELETE FROM Ferme_Compte; 
    DELETE FROM Trajet_Type; 
    DELETE FROM Trajet; 
    DELETE FROM Inscription; 
    DELETE FROM Avis; 
    DELETE FROM  Passe_Par;




/*
Insertion des tuples dans les relations
*/

 -------------------------------------------;
 --- Insertion des nouveaux tuples ---------;
 -------------------------------------------;

 ------------------------------------------;
 -----     insertion Administrateur    ------------;
 ------------------------------------------;
INSERT INTO Administrateur VALUES(0,'Bachar','Bachar');
INSERT INTO Administrateur VALUES(1,'Othmane','Othmane');
INSERT INTO Administrateur VALUES(2,'Souha','Souha');
INSERT INTO Administrateur VALUES(3,'Mooscles','Mooscles');

 ------------------------------------------;
 -----     insertion adresse     ------------;
 ------------------------------------------;


INSERT INTO Adresse VALUES (0,60,"Avenue Guilhem de Poitiers", "Montpellier");
INSERT INTO Adresse VALUES (1,5,"Rue de Boscet", "Montpellier");
INSERT INTO Adresse VALUES (2,12,"Rue de l'europe", "Montpellier");
INSERT INTO Adresse VALUES (3,43,"Avenue de toulouse", "Montpellier");
INSERT INTO Adresse VALUES (4,34,"Avenue des champs elysées", "Paris");
INSERT INTO Adresse VALUES (5,16,"Rue de la paix", "Paris");
INSERT INTO Adresse VALUES (6,16,"Rue 14 Juillet", "Toulouse");
INSERT INTO Adresse VALUES (7,29,"Place des jacobins","Le Mans");
INSERT INTO Adresse VALUES (8,NULL,NULL,"LeMans");
INSERT INTO Adresse VALUES (9,NULL,NULL,"Montpellier");
INSERT INTO Adresse VALUES (10,NULL,NULL,"Toulouse");
INSERT INTO Adresse VALUES (11,NULL,NULL,"Limoges");



 ------------------------------------------;
 -----     insertion Membre ------------;
 ------------------------------------------;


INSERT INTO Membre VALUES (0,'othfarajallah@hotmai.fr','otho123','Othmane','FARAJALLAH','01-12-1997','0667147394',5,NULL); 
INSERT INTO Membre VALUES (1,'bashar.nabil.rima@gmail.com','bachar123','Bachar','Rima','18-3-1992','0667147394',5,NULL); 
INSERT INTO Membre VALUES (2,'daniel.dumesnil@gmail.com','daniel123','Daniel','Dumesnil','18-3-1957','0667147394',5,NULL); 
INSERT INTO Membre VALUES (3,'benabderrazakwiam@hotmail.fr','wiam23','Wiam','Benabderrazak','07-23-1998','0667147394',5,NULL); 
INSERT INTO Membre VALUES (4,'juliedarbor@hotmail.fr','julie23','Julie','Darbor','23-07-1997','0667147394',5,NULL); 
INSERT INTO Membre VALUES (5,'ericdupont@hotmail.fr','eric23','Eric','Dupont','12-07-1975','0667147394',5,NULL);



 ------------------------------------------;
 -----     insertion Vehicule   --------;
 ------------------------------------------;


INSERT INTO Vehicule VALUES ('0','Renault','CLIO','Noire',2);
INSERT INTO Vehicule VALUES ('1','Renault','Kadgar','Blanc',2);
INSERT INTO Vehicule VALUES ('2','Renault','Zoe','Blanc',4);
INSERT INTO Vehicule VALUES ('3','BMW','X6','Blanc',0);
INSERT INTO Vehicule VALUES ('4','Porsche','Cayenne','Blanc',1);
INSERT INTO Vehicule VALUES ('5','Tesla','roadster','rouge',0);
INSERT INTO Vehicule VALUES ('6','BMW','X1','Blanc',3);

 ------------------------------------------;
 -----     insertion Trajet_Type ----------;
 ------------------------------------------;


INSERT INTO Ferme_Compte VALUES (0,0,1,0,3); 
INSERT INTO Ferme_Compte VALUES (1,0,1,0,4); 
INSERT INTO Ferme_Compte VALUES (2,0,0,0,3);  



 ------------------------------------------;
 -----     insertion Trajet_Type ----------;
 ------------------------------------------;


INSERT INTO Trajet_TYPE VALUES (0, 'Montpellier','Paris',748,420,100,0);
INSERT INTO Trajet_TYPE VALUES (1, 'Montpellier','Toulouse',242,215,80,0);
INSERT INTO Trajet_TYPE VALUES (2, 'Montpellier','Limoges',529,300,100,1);




 ------------------------------------------;
 -----     insertion Trajet   ------------;
 ------------------------------------------;

INSERT INTO Trajet VALUES (0,'Montpellier','Paris',1514012400,0,3,70,"Petite",2,0); 
INSERT INTO Trajet VALUES (1,'Montpellier','Toulouse',1514012400,6,3,15,"Grande",3,1); 
INSERT INTO Trajet VALUES (2,'Montpellier','LeMans',1514271600,5,3,80,"Grande",0,NULL); 


 ------------------------------------------;
 -----     insertion Inscription   ------------;
 ------------------------------------------;

INSERT INTO Inscription VALUES (5,1);
INSERT INTO Inscription VALUES(4,1);
INSERT INTO Inscription VALUES(1,0);


 ------------------------------------------;
 -----     insertion Avis   ------------;
 ------------------------------------------;

INSERT INTO Avis VALUES (0,5,'très sympa, bon voyage',0,1,2);
INSERT INTO Avis VALUES (1,5,'très agréable',1,5,3);
INSERT INTO Avis VALUES(2,3,NULL,1,1,3);


 ------------------------------------------;
 -----     insertion Passe_Par   ------------;
 ------------------------------------------;

INSERT INTO Passe_Par VALUES (0,0);
INSERT INTO Passe_Par VALUES (0,1);
INSERT INTO Passe_Par VALUES (0,2);
INSERT INTO Passe_Par VALUES (0,4);
INSERT INTO Passe_Par VALUES (0,11);
INSERT INTO Passe_Par VALUES (1,9);
INSERT INTO Passe_Par VALUES (1,10);
INSERT INTO Passe_Par VALUES (1,2);


