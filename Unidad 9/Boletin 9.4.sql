--BOLETIN 9.4
--1. Número de clientes de cada país.
SELECT Country,COUNT(*) AS [Clientes], FROM Customers GROUP BY Country

--7. Total de ventas (US$) de cada categoría en el año 97. Incluye el nombre de la
--categoría. 

SELECT C.CategoryID,C.CategoryName,SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) AS [Ventas Totales],YEAR(O.ShippedDate) AS [Año] FROM [Order Details] AS [OD] 
INNER JOIN Products AS P ON OD.ProductID=P.ProductID
INNER JOIN Orders AS O ON OD.OrderID=O.OrderID
INNER JOIN Categories AS C ON P.CategoryID=C.CategoryID 
WHERE YEAR(O.ShippedDate)='1997'
GROUP BY C.CategoryID,YEAR(O.ShippedDate),C.CategoryName

--11.Cifra de ventas de cada producto en el año 97 y su aumento o disminución
--respecto al año anterior en US $ y en %.

SELECT  AÑO97.ProductID, AÑO97.Año,AÑO97.[Numero de Ventas],AÑOANTERIOR.Año,AÑOANTERIOR.[Numero de Ventas],AÑO97.[Numero de Ventas]-AÑOANTERIOR.[Numero de Ventas] AS [Diferencia en dolares], 
ROUND((AÑO97.[Numero de Ventas]-AÑOANTERIOR.[Numero de Ventas])/AÑO97.[Numero de Ventas]*100,-1) AS [Diferencia en porcentaje] FROM
(SELECT YEAR(O.ShippedDate) AS [Año],OD.ProductID,SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) AS [Numero de Ventas] FROM [Order Details] AS OD
INNER JOIN ORDERS AS O ON OD.OrderID=O.OrderID 
WHERE YEAR(O.ShippedDate)='1997'
GROUP BY OD.ProductID,YEAR(O.ShippedDate)) AS AÑO97
INNER JOIN (SELECT YEAR(O.ShippedDate) AS [Año],OD.ProductID,SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) AS [Numero de Ventas] FROM [Order Details] AS OD
INNER JOIN ORDERS AS O ON OD.OrderID=O.OrderID 
WHERE YEAR(O.ShippedDate)='1997'-1
GROUP BY OD.ProductID,YEAR(O.ShippedDate)) AS AÑOANTERIOR ON AÑO97.ProductID=AÑOANTERIOR.ProductID 

--12. Mejor cliente (el que más nos compra) de cada país
 SELECT NCC.CustomerID,MNCP.Country,MNCP.[MNCC] AS [Numero de compras] FROM
(SELECT MAX(NCP.[Numero de compras]) AS [MNCC],NCP.Country FROM
(SELECT C.CustomerID,COUNT(*) AS [Numero de compras],C.Country FROM Orders AS O INNER JOIN Customers AS C
ON O.CustomerID=C.CustomerID
GROUP BY C.CustomerID,C.Country) AS [NCP] GROUP BY NCP.Country) AS [MNCP]
INNER JOIN(SELECT C.CustomerID,COUNT(*) AS [Numero de compras],C.Country FROM Orders AS O INNER JOIN Customers AS C
ON O.CustomerID=C.CustomerID
GROUP BY C.CustomerID,C.Country) AS [NCC] ON MNCP.MNCC=NCC.[Numero de compras] AND MNCP.Country=NCC.Country

--13. Número de productos diferentes que nos compra cada cliente. Incluye el
--nombre y apellidos del cliente y su dirección completa.

SELECT C.CustomerID,C.ContactName,C.Address,C.City,C.PostalCode,C.Country,COUNT(*) AS [Productos] FROM Products AS P 
INNER JOIN [Order Details] AS OD ON P.ProductID=OD.ProductID 
INNER JOIN Orders AS O ON OD.OrderID=O.OrderID 
INNER JOIN Customers AS C ON O.CustomerID=C.CustomerID 
GROUP BY C.CustomerID,C.ContactName,C.Address,C.City,C.PostalCode,C.Country

--15. Vendedores (nombre y apellidos) que han vendido una mayor cantidad que la
--media en US $ en el año 97.

--REALIZADO CON VISTAS
--VISTA
GO
CREATE VIEW [MV] AS
SELECT VT.Año,AVG(VT.[Ventas Totales]) AS [Ventas Totales 97] FROM
(SELECT C.CustomerID,C.ContactName,SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) AS [Ventas Totales],YEAR(O.ShippedDate) AS [Año] FROM [Order Details] AS OD
INNER JOIN Orders AS O ON OD.OrderID=O.OrderID 
INNER JOIN Customers AS C ON O.CustomerID=C.CustomerID
WHERE YEAR(O.ShippedDate)='1997'
GROUP BY C.CustomerID,C.ContactName,YEAR(O.ShippedDate)) AS [VT] GROUP BY VT.Año
GO
--CONSULTA
SELECT C.CustomerID,C.ContactName,YEAR(O.ShippedDate) AS [Año] FROM [Order Details] AS OD
INNER JOIN Orders AS O ON OD.OrderID=O.OrderID 
INNER JOIN Customers AS C ON O.CustomerID=C.CustomerID INNER JOIN MV ON YEAR(O.ShippedDate)=MV.Año
GROUP BY C.CustomerID,C.ContactName,YEAR(O.ShippedDate),MV.[Ventas Totales 97]
HAVING SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount))>MV.[Ventas Totales 97]


--REALIZADO CON SUBCONSULTAS
SELECT VTT.ContactName,VTT.CustomerID,MVT.Año FROM
(SELECT VT.Año,AVG(VT.[Ventas Totales]) AS [Media Ventas Totales 97] FROM
(SELECT C.CustomerID,C.ContactName,SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) AS [Ventas Totales],YEAR(O.ShippedDate) AS [Año] FROM [Order Details] AS OD
INNER JOIN Orders AS O ON OD.OrderID=O.OrderID 
INNER JOIN Customers AS C ON O.CustomerID=C.CustomerID
WHERE YEAR(O.ShippedDate)='1997'
GROUP BY C.CustomerID,C.ContactName,YEAR(O.ShippedDate)) AS [VT] GROUP BY VT.Año) AS [MVT]
INNER JOIN 
(SELECT C.CustomerID,C.ContactName,SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) AS [Ventas Totales],YEAR(O.ShippedDate) AS [Año] FROM [Order Details] AS OD
INNER JOIN Orders AS O ON OD.OrderID=O.OrderID 
INNER JOIN Customers AS C ON O.CustomerID=C.CustomerID INNER JOIN MV ON YEAR(O.ShippedDate)=MV.Año
GROUP BY C.CustomerID,C.ContactName,YEAR(O.ShippedDate)) AS [VTT] ON  MVT.Año=VTT.Año
WHERE VTT.[Ventas Totales]>MVT.[Media Ventas Totales 97]

