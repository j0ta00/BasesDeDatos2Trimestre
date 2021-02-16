
--BOLETIN 9.1

--1.Nombre de los proveedores y número de productos que nos vende cada uno
SELECT ISNULL(S.ContactName,S.CompanyName) AS [Nombre del Proveedor],COUNT(*) AS [Número de Productos] FROM Suppliers AS S INNER JOIN 
Products AS P ON S.SupplierID=P.SupplierID 
GROUP BY S.SupplierID,S.ContactName,S.CompanyName


--2.Nombre completo y telefono de los vendedores que trabajen en New York, Seattle, Vermont, Columbia, Los Angeles, Redmond o Atlanta.
SELECT DISTINCT E.FirstName,E.LastName,ISNULL(E.HomePhone,'(71) 555-4542') FROM Employees AS E INNER JOIN 
EmployeeTerritories AS ET ON E.EmployeeID=ET.EmployeeID INNER JOIN Territories AS T ON ET.TerritoryID=T.TerritoryID
WHERE T.TerritoryDescription IN ('New York','Seattle','Vermont','Columbia','Los Angeles', 'Redmond','Atlanta')


--3.Número de productos de cada categoría y nombre de la categoría.
SELECT COUNT(*) AS [Productos de Cada Categoria], C.CategoryName FROM Products AS P 
INNER JOIN Categories AS C ON P.CategoryID=C.CategoryID 
GROUP BY P.CategoryID,C.CategoryName


--4.Nombre de la compañía de todos los clientes que hayan comprado queso de cabrales o tofu.
SELECT DISTINCT C.CompanyName FROM Customers AS C INNER JOIN 
Orders AS O ON C.CustomerID=O.CustomerID INNER JOIN 
[Order Details] AS OD ON O.OrderID=OD.OrderID INNER JOIN Products AS P ON OD.ProductID=P.ProductID
WHERE P.ProductName IN ('Queso Cabrales',' Tofu')


--5.Empleados (ID, nombre, apellidos y teléfono) que han vendido algo a Bon app' o Meter Franken.
SELECT E.EmployeeID,E.FirstName,E.LastName,ISNULL(E.HomePhone,'(71) 555-4542') FROM Employees AS E INNER JOIN
Orders AS O ON E.EmployeeID=O.EmployeeID INNER JOIN Customers AS C ON O.CustomerID=C.CustomerID
WHERE C.CompanyName in ('Bon app''','Meter Franken')


--6.Empleados (ID, nombre, apellidos, mes y día de su cumpleaños) que no han vendido nunca nada a ningún cliente de Francia. *
SELECT EmployeeID,FirstName,LastName,DAY(BirthDate) AS [Día Cumpleaños],MONTH(BirthDate) AS [Mes Cumpleaños] FROM Employees  
WHERE EmployeeID NOT IN (SELECT DISTINCT E.EmployeeID FROM Employees AS E INNER JOIN Orders AS O ON E.EmployeeID=O.EmployeeID INNER JOIN 
Customers AS C ON  O.CustomerID=C.CustomerID WHERE C.Country='France')


--7.Total de ventas en US$ de productos de cada categoría (nombre de la categoría).
SELECT CAST(SUM(OD.UnitPrice*OD.Quantity*(1-Discount)) AS money) AS [Total Facturado],C.CategoryName  FROM [Order Details] AS OD INNER JOIN 
Products AS P ON OD.ProductID=P.ProductID INNER JOIN 
Categories AS C ON P.CategoryID=C.CategoryID 
GROUP BY C.CategoryID,C.CategoryName


--8.Total de ventas en US$ de cada empleado cada año (nombre, apellidos, dirección).
SELECT E.FirstName,E.LastName,E.[Address],YEAR(OrderDate) AS Año,
CAST(SUM(OD.UnitPrice*OD.Quantity*(1-Discount))AS money) AS [Total Facturado] FROM Employees AS E INNER JOIN 
Orders AS O ON E.EmployeeID=O.EmployeeID INNER JOIN [Order Details] AS OD ON O.OrderID=OD.OrderID
GROUP BY YEAR(OrderDate),E.EmployeeID,E.FirstName,E.LastName,E.[Address]
ORDER BY E.EmployeeID,YEAR(OrderDate)


--9.Ventas de cada producto en el año 97. Nombre del producto y unidades.
SELECT P.ProductName,SUM(OD.Quantity)AS [Cantidad],YEAR(OrderDate) AS Año FROM [Order Details] AS OD INNER JOIN
Orders AS O ON OD.OrderID=O.OrderID INNER JOIN Products AS P ON OD.ProductID=P.ProductID
WHERE YEAR(OrderDate)='1997'
GROUP BY YEAR(OrderDate),P.ProductName


--10.Cuál es el producto del que hemos vendido más unidades en cada país. *


--11.Empleados (nombre y apellidos) que trabajan a las órdenes de Andrew Fuller.
SELECT EB.FirstName,EB.LastName FROM Employees AS E INNER JOIN Employees AS EB ON E.EmployeeID=ISNULL(EB.ReportsTo,0) WHERE 
E.FirstName IN ('Andrew') AND E.LastName IN ('Fuller')


--12.Número de subordinados que tiene cada empleado, incluyendo los que no tienen ninguno. Nombre, apellidos, ID.
SELECT E.FirstName,COUNT(EB.ReportsTo) AS [Cantidad Subordinados] FROM Employees AS E LEFT JOIN 
Employees AS EB ON E.EmployeeID=ISNULL(EB.ReportsTo,0) GROUP BY E.EmployeeID,E.FirstName