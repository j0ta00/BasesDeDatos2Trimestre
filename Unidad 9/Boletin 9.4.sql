--BOLETIN 9.4
--1. N�mero de clientes de cada pa�s.
SELECT Country,COUNT(*) AS [Clientes], FROM Customers GROUP BY Country

--7. Total de ventas (US$) de cada categor�a en el a�o 97. Incluye el nombre de la
--categor�a. 

SELECT C.CategoryID,C.CategoryName,SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) AS [Ventas Totales],YEAR(O.ShippedDate) AS [A�o] FROM [Order Details] AS [OD] 
INNER JOIN Products AS P ON OD.ProductID=P.ProductID
INNER JOIN Orders AS O ON OD.OrderID=O.OrderID
INNER JOIN Categories AS C ON P.CategoryID=C.CategoryID 
WHERE YEAR(O.ShippedDate)='1997'
GROUP BY C.CategoryID,YEAR(O.ShippedDate),C.CategoryName

--11.Cifra de ventas de cada producto en el a�o 97 y su aumento o disminuci�n
--respecto al a�o anterior en US $ y en %.

SELECT  A�O97.ProductID, A�O97.A�o,A�O97.[Numero de Ventas],A�OANTERIOR.A�o,A�OANTERIOR.[Numero de Ventas],A�O97.[Numero de Ventas]-A�OANTERIOR.[Numero de Ventas] AS [Diferencia en dolares], 
ROUND((A�O97.[Numero de Ventas]-A�OANTERIOR.[Numero de Ventas])/A�O97.[Numero de Ventas]*100,-1) AS [Diferencia en porcentaje] FROM
(SELECT YEAR(O.ShippedDate) AS [A�o],OD.ProductID,SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) AS [Numero de Ventas] FROM [Order Details] AS OD
INNER JOIN ORDERS AS O ON OD.OrderID=O.OrderID 
WHERE YEAR(O.ShippedDate)='1997'
GROUP BY OD.ProductID,YEAR(O.ShippedDate)) AS A�O97
INNER JOIN (SELECT YEAR(O.ShippedDate) AS [A�o],OD.ProductID,SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) AS [Numero de Ventas] FROM [Order Details] AS OD
INNER JOIN ORDERS AS O ON OD.OrderID=O.OrderID 
WHERE YEAR(O.ShippedDate)='1997'-1
GROUP BY OD.ProductID,YEAR(O.ShippedDate)) AS A�OANTERIOR ON A�O97.ProductID=A�OANTERIOR.ProductID 

--12. Mejor cliente (el que m�s nos compra) de cada pa�s
 SELECT NCC.CustomerID,MNCP.Country,MNCP.[MNCC] AS [Numero de compras] FROM
(SELECT MAX(NCP.[Numero de compras]) AS [MNCC],NCP.Country FROM
(SELECT C.CustomerID,COUNT(*) AS [Numero de compras],C.Country FROM Orders AS O INNER JOIN Customers AS C
ON O.CustomerID=C.CustomerID
GROUP BY C.CustomerID,C.Country) AS [NCP] GROUP BY NCP.Country) AS [MNCP]
INNER JOIN(SELECT C.CustomerID,COUNT(*) AS [Numero de compras],C.Country FROM Orders AS O INNER JOIN Customers AS C
ON O.CustomerID=C.CustomerID
GROUP BY C.CustomerID,C.Country) AS [NCC] ON MNCP.MNCC=NCC.[Numero de compras] AND MNCP.Country=NCC.Country

--13. N�mero de productos diferentes que nos compra cada cliente. Incluye el
--nombre y apellidos del cliente y su direcci�n completa.

SELECT C.CustomerID,C.ContactName,C.Address,C.City,C.PostalCode,C.Country,COUNT(*) AS [Productos] FROM Products AS P 
INNER JOIN [Order Details] AS OD ON P.ProductID=OD.ProductID 
INNER JOIN Orders AS O ON OD.OrderID=O.OrderID 
INNER JOIN Customers AS C ON O.CustomerID=C.CustomerID 
GROUP BY C.CustomerID,C.ContactName,C.Address,C.City,C.PostalCode,C.Country

--15. Vendedores (nombre y apellidos) que han vendido una mayor cantidad que la
--media en US $ en el a�o 97.

--REALIZADO CON VISTAS
--VISTA
GO
CREATE VIEW [MV] AS
SELECT VT.A�o,AVG(VT.[Ventas Totales]) AS [Ventas Totales 97] FROM
(SELECT C.CustomerID,C.ContactName,SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) AS [Ventas Totales],YEAR(O.ShippedDate) AS [A�o] FROM [Order Details] AS OD
INNER JOIN Orders AS O ON OD.OrderID=O.OrderID 
INNER JOIN Customers AS C ON O.CustomerID=C.CustomerID
WHERE YEAR(O.ShippedDate)='1997'
GROUP BY C.CustomerID,C.ContactName,YEAR(O.ShippedDate)) AS [VT] GROUP BY VT.A�o
GO
--CONSULTA
SELECT C.CustomerID,C.ContactName,YEAR(O.ShippedDate) AS [A�o] FROM [Order Details] AS OD
INNER JOIN Orders AS O ON OD.OrderID=O.OrderID 
INNER JOIN Customers AS C ON O.CustomerID=C.CustomerID INNER JOIN MV ON YEAR(O.ShippedDate)=MV.A�o
GROUP BY C.CustomerID,C.ContactName,YEAR(O.ShippedDate),MV.[Ventas Totales 97]
HAVING SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount))>MV.[Ventas Totales 97]


--REALIZADO CON SUBCONSULTAS
SELECT VTT.ContactName,VTT.CustomerID,MVT.A�o FROM
(SELECT VT.A�o,AVG(VT.[Ventas Totales]) AS [Media Ventas Totales 97] FROM
(SELECT C.CustomerID,C.ContactName,SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) AS [Ventas Totales],YEAR(O.ShippedDate) AS [A�o] FROM [Order Details] AS OD
INNER JOIN Orders AS O ON OD.OrderID=O.OrderID 
INNER JOIN Customers AS C ON O.CustomerID=C.CustomerID
WHERE YEAR(O.ShippedDate)='1997'
GROUP BY C.CustomerID,C.ContactName,YEAR(O.ShippedDate)) AS [VT] GROUP BY VT.A�o) AS [MVT]
INNER JOIN 
(SELECT C.CustomerID,C.ContactName,SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) AS [Ventas Totales],YEAR(O.ShippedDate) AS [A�o] FROM [Order Details] AS OD
INNER JOIN Orders AS O ON OD.OrderID=O.OrderID 
INNER JOIN Customers AS C ON O.CustomerID=C.CustomerID INNER JOIN MV ON YEAR(O.ShippedDate)=MV.A�o
GROUP BY C.CustomerID,C.ContactName,YEAR(O.ShippedDate)) AS [VTT] ON  MVT.A�o=VTT.A�o
WHERE VTT.[Ventas Totales]>MVT.[Media Ventas Totales 97]

