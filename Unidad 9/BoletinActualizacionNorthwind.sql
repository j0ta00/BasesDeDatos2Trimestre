GO 
USE Northwind
GO
SELECT * FROM Customers
WHERE Country IN ('California','Texas')
SELECT * FROM Categories
SELECT * FROM [Order Details]

SELECT * FROM Territories
WHERE TerritoryDescription IN ('Louisville','Phoenix','Santa Cruz','Atlanta')
SELECT [Order Details].ProductID FROM [Order Details]
GROUP BY ProductID
HAVING SUM(Quantity) < 200

SELECT * FROM EmployeeTerritories

SELECT * FROM Products
WHERE ProductName like ('Outback Lager')
WHERE Products.UnitPrice > 5 AND Products.CategoryID=4
SELECT * FROM Shippers
WHERE Shippers.CompanyName IN ('Speedy Express')
SELECT * FROM Employees
WHERE Employees.FirstName IN ('Laura') AND Employees.LastName IN ('Callahan')

SET DATEFORMAT DMY

SELECT * FROM Products AS P
INNER JOIN [Order Details] AS OD ON P.ProductID=OD.ProductID
INNER JOIN Orders AS O ON OD.OrderID=O.OrderID
WHERE O.CustomerID IN ('ALDRO')
--id speedy= 1
--pav 16  17,45;ing 36 19; filo 52 7
--LAURA 8
--Inserta un nuevo cliente.
BEGIN TRANSACTION
ROLLBACK
COMMIT
INSERT INTO Customers

VALUES('ALDRO','Alicates de Doraemon','Nobita Nobi','Owner','Arigato Street,69','Sevilla',NULL,NULL,'Spain',NULL,NULL)

--Véndele (hoy) tres unidades de "Pavlova”, diez de "Inlagd Sill” y 25 de "Filo Mix”. El distribuidor será Speedy Express y el vendedor Laura Callahan.
INSERT INTO Orders
VALUES('ALDRO',8,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1,NULL,'Tu mami reshulona',NULL,'Perú',NULL,NULL,'Perú')
INSERT INTO [Order Details]
VALUES(11078,16,17.45,3,0),(11078,36,19,10,0),(11078,52,7,25,0)
--Ante la bajada de ventas producida por la crisis, hemos de adaptar nuestros precios según las siguientes reglas:
	--Los productos de la categoría de bebidas (Beverages) que cuesten más de $10 reducen su precio en un dólar.
	UPDATE Products
	SET UnitPrice=UnitPrice-1
	WHERE CategoryID=1 AND UnitPrice>10
	
	--Los productos de la categoría Lácteos que cuesten más de $5 reducen su precio en un 10%.
	UPDATE Products
	SET UnitPrice=UnitPrice-UnitPrice*0.1
	WHERE CategoryID=4 AND UnitPrice>5
	--Los productos de los que se hayan vendido menos de 200 unidades en el último año, reducen su precio en un 5%
	
	UPDATE Products
	SET UnitPrice=UnitPrice-UnitPrice*0.05
	WHERE Products.ProductID IN (
		SELECT OD.ProductID FROM [Order Details] AS OD
		INNER JOIN Orders AS O ON OD.OrderID=O.OrderID
		WHERE YEAR(O.OrderDate)=YEAR(CURRENT_TIMESTAMP)-1
		GROUP BY OD.ProductID
		HAVING SUM(OD.Quantity) < 200
	)
	

	
--Inserta un nuevo vendedor llamado Michael Trump. Asígnale los territorios de Louisville, Phoenix, Santa Cruz y Atlanta.

INSERT INTO Employees
VALUES('Trump','Michael','Sales Representative','Mr.','01/12/1965',CURRENT_TIMESTAMP,'Ave. Make America Great Again',null,null,null,null,null,null,null,null,null,null)
INSERT INTO EmployeeTerritories
VALUES(11,30346),(11,40222),(11,85014),(11,95060)
--Haz que las ventas del año 97 de Robert King que haya hecho a clientes de los estados de California y Texas se le asignen al nuevo empleado.

	UPDATE Orders
	SET EmployeeID=11
	WHERE Orders.OrderID IN(
		SELECT O.OrderID FROM Orders AS O
		INNER JOIN Customers AS C ON O.CustomerID=C.CustomerID
		WHERE O.EmployeeID=7 AND YEAR(O.OrderDate)=1997 AND C.Region IN ('CA','TX') 
	)
	 
--Inserta un nuevo producto con los siguientes datos:
--ProductID: 90
--ProductName: Nesquick Power Max
--SupplierID: 12
--CategoryID: 3
--QuantityPerUnit: 10 x 300g
--UnitPrice: 2,40
--UnitsInStock: 38
--UnitsOnOrder: 0
--ReorderLevel: 0
--Discontinued: 0
 INSERT INTO Products
 VALUES('Nesquick Power Max',12,3,'10 x 300g',2.40,38,0,0,0)
 
--Inserta un nuevo producto con los siguientes datos:
--ProductID: 91
--ProductName: Mecca Cola
--SupplierID: 1
--CategoryID: 1
--QuantityPerUnit: 6 x 75 cl
--UnitPrice: 7,35
--UnitsInStock: 14
--UnitsOnOrder: 0
--ReorderLevel: 0
--Discontinued: 0
INSERT INTO Products
VALUES('Mecca Cola',1,1,'6 x 75 cl',7.35,14,0,0,0)
--Todos los que han comprado "Outback Lager" han comprado cinco años después la misma cantidad de Mecca Cola al mismo vendedor

	INSERT INTO Orders(CustomerID,EmployeeID,OrderDate)
	SELECT O.CustomerID,O.EmployeeID,(DATEADD(YEAR,5,O.OrderDate)) AS [Anno] FROM Orders AS O
	INNER JOIN [Order Details] AS OD ON O.OrderID=OD.OrderID
	WHERE OD.ProductID=70

	INSERT INTO [Order Details](OrderID,ProductID,Quantity)
	SELECT MeccaCola.OrderID,OD.ProductID,OD.Quantity FROM Orders AS OutbackComprado
		INNER JOIN Orders as MeccaCola ON OutbackComprado.CustomerID=MeccaCola.CustomerID AND
										  OutbackComprado.EmployeeID=MeccaCola.EmployeeID AND
										  MeccaCola.OrderDate=DATEADD(YEAR,5,OutbackComprado.OrderDate)
		INNER JOIN [Order Details] AS OD ON OutbackComprado.OrderID=OD.OrderID
		WHERE OD.ProductID=70

	UPDATE [Order Details]
	SET ProductID=83,
		UnitPrice=7.35
	WHERE OrderID IN(
		SELECT MeccaCola.OrderID FROM Orders AS OutbackComprado
		INNER JOIN Orders as MeccaCola ON OutbackComprado.CustomerID=MeccaCola.CustomerID AND
										  OutbackComprado.EmployeeID=MeccaCola.EmployeeID AND
										  MeccaCola.OrderDate=DATEADD(YEAR,5,OutbackComprado.OrderDate)
		INNER JOIN [Order Details] AS OD ON OutbackComprado.OrderID=OD.OrderID
		WHERE OD.ProductID=70
	)

	

	
	

--El pasado 20 de enero, Margaret Peacock consiguió vender una caja de Nesquick Power Max a todos los clientes que le habían comprado algo anteriormente. Los datos de envío (dirección, transportista, etc) son los mismos de alguna de sus ventas anteriores a ese cliente).