--7. Total de ventas (US$) de cada categor�a en el a�o 97. Incluye el nombre de la
--categor�a. 

SELECT P.CategoryID,SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) AS [Ventas Totales],YEAR(O.ShippedDate) AS [A�o] FROM [Order Details] AS [OD] 
		INNER JOIN Products AS P 
			ON OD.ProductID=P.ProductID
		INNER JOIN Orders AS O 
			ON OD.OrderID=O.OrderID
		WHERE YEAR(O.ShippedDate)='1997'
		GROUP BY CategoryID,YEAR(O.ShippedDate)


--12. Mejor cliente (el que m�s nos compra) de cada pa�s
	
	 SELECT NCC.CustomerID,MNCP.Country,MNCP.[MNCC] AS [Numero de compras] FROM
	 (SELECT MAX(NCP.[Numero de compras]) AS [MNCC],NCP.Country FROM
	 (SELECT C.CustomerID,COUNT(*) AS [Numero de compras],C.Country FROM Orders AS O INNER JOIN Customers AS C
	 ON O.CustomerID=C.CustomerID
	 GROUP BY C.CustomerID,C.Country) AS [NCP] GROUP BY NCP.Country) AS [MNCP]
	 INNER JOIN
	 (SELECT C.CustomerID,COUNT(*) AS [Numero de compras],C.Country FROM Orders AS O INNER JOIN Customers AS C
	 ON O.CustomerID=C.CustomerID
	 GROUP BY C.CustomerID,C.Country) AS [NCC] ON MNCP.MNCC=NCC.[Numero de compras] AND MNCP.Country=NCC.Country


--11.Cifra de ventas de cada producto en el a�o 97 y su aumento o disminuci�n
--respecto al a�o anterior en US $ y en %.
--NO TERMINADO **EN PROCESO**
SELECT  A�O97.ProductID, A�O97.A�o,A�O97.[Numero de Ventas],A�OANTERIOR.A�o,A�OANTERIOR.[Numero de Ventas],A�O97.[Numero de Ventas]-A�OANTERIOR.[Numero de Ventas] AS [Diferencia en dolares], 
ROUND(((A�O97.[Numero de Ventas]/A�OANTERIOR.[Numero de Ventas])*100)-100,-1) AS [Diferencia en porcentaje] FROM
(SELECT YEAR(O.ShippedDate) AS [A�o],OD.ProductID,SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) AS [Numero de Ventas] FROM [Order Details] AS OD
INNER JOIN ORDERS AS O ON OD.OrderID=O.OrderID 
WHERE YEAR(O.ShippedDate)='1997'
GROUP BY OD.ProductID,YEAR(O.ShippedDate)) AS A�O97
INNER JOIN 
(SELECT YEAR(O.ShippedDate) AS [A�o],OD.ProductID,SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) AS [Numero de Ventas] FROM [Order Details] AS OD
INNER JOIN ORDERS AS O ON OD.OrderID=O.OrderID 
WHERE YEAR(O.ShippedDate)='1997'-1
GROUP BY OD.ProductID,YEAR(O.ShippedDate)) AS A�OANTERIOR ON A�O97.ProductID=A�OANTERIOR.ProductID 