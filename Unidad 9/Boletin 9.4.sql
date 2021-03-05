--7. Total de ventas (US$) de cada categoría en el año 97. Incluye el nombre de la
--categoría. 

SELECT P.CategoryID,SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) AS [Ventas Totales],YEAR(O.ShippedDate) AS [Año] FROM [Order Details] AS [OD] 
		INNER JOIN Products AS P 
			ON OD.ProductID=P.ProductID
		INNER JOIN Orders AS O 
			ON OD.OrderID=O.OrderID
		WHERE YEAR(O.ShippedDate)='1997'
		GROUP BY CategoryID,YEAR(O.ShippedDate)


--12. Mejor cliente (el que más nos compra) de cada país
	
	 SELECT NCC.CustomerID,MNCP.Country,MNCP.[MNCC] AS [Numero de compras] FROM
	 (SELECT MAX(NCP.[Numero de compras]) AS [MNCC],NCP.Country FROM
	 (SELECT C.CustomerID,COUNT(*) AS [Numero de compras],C.Country FROM Orders AS O INNER JOIN Customers AS C
	 ON O.CustomerID=C.CustomerID
	 GROUP BY C.CustomerID,C.Country) AS [NCP] GROUP BY NCP.Country) AS [MNCP]
	 INNER JOIN
	 (SELECT C.CustomerID,COUNT(*) AS [Numero de compras],C.Country FROM Orders AS O INNER JOIN Customers AS C
	 ON O.CustomerID=C.CustomerID
	 GROUP BY C.CustomerID,C.Country) AS [NCC] ON MNCP.MNCC=NCC.[Numero de compras] AND MNCP.Country=NCC.Country


--11.Cifra de ventas de cada producto en el año 97 y su aumento o disminución
--respecto al año anterior en US $ y en %.
--NO TERMINADO **EN PROCESO**
SELECT  AÑO97.ProductID, AÑO97.Año,AÑO97.[Numero de Ventas],AÑOANTERIOR.Año,AÑOANTERIOR.[Numero de Ventas],AÑO97.[Numero de Ventas]-AÑOANTERIOR.[Numero de Ventas] AS [Diferencia en dolares], 
ROUND(((AÑO97.[Numero de Ventas]/AÑOANTERIOR.[Numero de Ventas])*100)-100,-1) AS [Diferencia en porcentaje] FROM
(SELECT YEAR(O.ShippedDate) AS [Año],OD.ProductID,SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) AS [Numero de Ventas] FROM [Order Details] AS OD
INNER JOIN ORDERS AS O ON OD.OrderID=O.OrderID 
WHERE YEAR(O.ShippedDate)='1997'
GROUP BY OD.ProductID,YEAR(O.ShippedDate)) AS AÑO97
INNER JOIN 
(SELECT YEAR(O.ShippedDate) AS [Año],OD.ProductID,SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) AS [Numero de Ventas] FROM [Order Details] AS OD
INNER JOIN ORDERS AS O ON OD.OrderID=O.OrderID 
WHERE YEAR(O.ShippedDate)='1997'-1
GROUP BY OD.ProductID,YEAR(O.ShippedDate)) AS AÑOANTERIOR ON AÑO97.ProductID=AÑOANTERIOR.ProductID 