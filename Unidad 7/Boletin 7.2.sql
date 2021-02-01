/*
Create Database Colegas
go
Use Colegas
GO
-- People
Create Table People (
	ID SmallInt Not NULL Constraint PKPeople Primary Key,
	Nombre VarChar(20) Not NULL,
	Apellidos VarChar(20) Not NULL,
	FechaNac Date NULL
)
GO
-- Carros
Create Table Carros (
	ID SmallInt Not NULL Constraint PKCarros Primary Key,
	Marca VarChar(15) Not NULL,
	Modelo VarChar(20) Not NULL,
	Anho SmallInt NULL Constraint CKAnno Check (Anho Between 1900 AND YEAR(Current_Timestamp)),
	Color VarChar(15),
	IDPropietario SmallInt NULL Constraint FKCarroPeople Foreign Key References People (ID) On Update No action On Delete No action
)
-- Libros
Create Table Libros(
	ID Int Not NULL Constraint PKLibros Primary Key,
	Titulo VarChar(60) Not NULL,
	Autors VarChar(50) NULL
)
GO
--Lecturas
Create Table Lecturas(
	IDLibro Int Not NULL,
	IDLector SmallInt Not NULL,
	Constraint PKLecturas Primary Key (IDLibro, IDLector),
	Constraint FKLecturasLibros Foreign Key (IDLibro) References Libros (ID) On Update No action On Delete No action,
	Constraint FKLecturasLectores Foreign Key (IDLector) References People (ID) On Update No action On Delete No action,
	AnhoLectura SmallInt NULL
)
*/
--2--
GO
SET DATEFORMAT dmy 
INSERT INTO People(ID,Nombre,Apellidos,FechaNac)
VALUES(1,'Eduardo','Mingo','14-07-1990'),(2,'Margarita','Padera','11-11-1992'),(4,'Eloisa','Lamandra','02-03-2000'),(5,'Jordi','Videndo','28-05-1989'),(6,'Alfonso','Sitio','10-10-1978')
GO
--1--
GO
INSERT INTO Carros(ID,Marca,Modelo,Anho,Color,IDPropietario) 
VALUES (1,'Seat','Ibiza',2014,'Blanco',NULL),(2,'Ford','Focus',2016,'Rojo',1),(3,'Toyota','Corolla',2017,'Blanco',4),(5,'Renault','Megane',2015,'Azul',2),(8,'Mitsubishi','Colt',2011,'Rojo',6)
GO
--3--
GO
INSERT INTO Libros(ID,Titulo,Autors) 
VALUES (2,'El corazón de las Tinieblas','Joseph Conrad'),(4,'Cien años de soledad','Gabriel García'),(8,'Harry Potter y la cámara de los secretos','J.K. Rowling'),(16,'Evangelio del Flying Spaguetti Monster','Bobby Henderson')
GO
--4--
GO
SET DATEFORMAT dmy
INSERT INTO Lecturas(IDLibro,IDLector,AnhoLectura) VALUES (4,1,(Year(GETDATE()-1))) , (2,2,2014) , (4,4,2015) , (8,4,2017) , (16,5,2010) , (16,6,2010)
GO
--5--
GO
UPDATE Carros SET IDPropietario=6 WHERE IDPropietario=2
GO
--6--
GO
SELECT nombre,Apellidos FROM People WHERE YEAR(CURRENT_TIMESTAMP)-YEAR(FechaNac)>=30
GO
--7--
GO
SELECT Marca,Anho,Modelo FROM  Carros WHERE Color NOT IN('Blanco','Azul')
GO
--8--
GO
INSERT INTO Libros(ID,Titulo,Autors) VALUES (32,'Vida Santa','Abate Bringas')
UPDATE Lecturas SET IDLibro=32 WHERE IDLibro=16
GO
--9--
GO
INSERT INTO Lecturas(IDLibro,IDLector,AnhoLectura) VALUES (2,4,YEAR(GETDATE()))
GO
--10--
GO
UPDATE Carros SET IDPropietario=5 WHERE Marca='Seat' AND Modelo='Ibiza'
GO
--11--
GO
SELECT DISTINCT IDLector FROM Lecturas WHERE IDLibro%2=0
GO
