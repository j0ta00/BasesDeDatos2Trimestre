

--BOLET�N 8.1+

--2. ID de producto y n�mero de unidades vendidas de cada producto.  A�ade el nombre del producto
SELECT OD.ProductID, OD.Quantity, P.ProductName FROM [Order Details] AS OD INNER JOIN Products AS P ON OD.ProductID=P.ProductID 
--3. ID del cliente y n�mero de pedidos que nos ha hecho. A�ade nombre (CompanyName) y ciudad del cliente
SELECT COUNT(*) AS [Numero de pedidos], O.CustomerID, C.CompanyName FROM Orders AS O INNER JOIN CUSTOMERS AS C ON O.CustomerID = C.CustomerID GROUP BY O.CustomerID,C.CompanyName
--4. ID del cliente, a�o y n�mero de pedidos que nos ha hecho cada a�o. A�ade nombre (CompanyName) y ciudad del cliente, as� como la fecha del primer pedido que nos hizo.
SELECT O.CustomerID,COUNT(*) AS [Numero de Pedidos],YEAR(O.OrderDate) AS  A�o,C.CompanyName,C.City,MIN(O.OrderDate) AS [Fecha Primer Pedido] FROM  Orders AS O INNER JOIN 
CUSTOMERS AS C ON O.CustomerID = C.CustomerID 
GROUP BY YEAR(O.OrderDate),O.CustomerID,C.CompanyName,C.City
--5. ID del producto, precio unitario y total facturado de ese producto, ordenado por cantidad facturada de mayor a menor. Si hay varios precios unitarios para el mismo producto tomaremos el mayor. A�ade el nombre del producto
SELECT OD.ProductID,MAX(OD.UnitPrice) AS [Precio Unitario Mayor],SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) AS [Total Facturado],P.ProductName FROM [Order Details] AS OD INNER JOIN 
Products AS P ON OD.ProductID=P.ProductID
GROUP BY OD.ProductID,P.ProductName
ORDER BY [Total Facturado] DESC
--6. ID del proveedor e importe total del stock acumulado de productos correspondientes a ese proveedor. A�ade el nombre del proveedor
SELECT P.SupplierID,SUM(P.UnitPrice*(P.UnitsInStock)) AS [Importe Total del Stock],S.ContactName  FROM Products AS P INNER JOIN Suppliers AS S ON P.SupplierID=S.SupplierID GROUP BY P.SupplierID,S.ContactName
--9. ID del distribuidor y n�mero de pedidos enviados a trav�s de ese distribuidor. A�ade el nombre del distribuidor
SELECT O.ShipVia,COUNT(*) AS [Numero De Pedidos],SH.CompanyName FROM Orders AS O INNER JOIN Shippers AS SH ON O.ShipVia=SH.ShipperID GROUP BY O.ShipVia,SH.CompanyName
--10. ID de cada proveedor y n�mero de productos distintos que nos suministra. A�ade el nombre del proveedor.
SELECT P.SupplierID,COUNT(*) AS Productos, S.ContactName FROM Products AS P INNER JOIN Suppliers AS S ON P.SupplierID=S.SupplierID  GROUP BY P.SupplierID,S.ContactName 