/*
ENUNCIADOS:

1. Nombre del país y número de clientes de cada país, ordenados alfabéticamente por el nombre del país.

2. ID de producto y número de unidades vendidas de cada producto.

3. ID del cliente y número de pedidos que nos ha hecho.

4. ID del cliente, año y número de pedidos que nos ha hecho cada año.

5. ID del producto, precio unitario y total facturado de ese producto, ordenado por cantidad facturada de mayor a menor. Si hay varios precios unitarios para el mismo producto tomaremos el mayor.

6. ID del proveedor e importe total del stock acumulado de productos correspondientes a ese proveedor.

7. Número de pedidos registrados mes a mes de cada año.

8. Año y tiempo medio transcurrido entre la fecha de cada pedido (OrderDate) y la fecha en la que lo hemos enviado (ShipDate), en días para cada año.

9. ID del distribuidor y número de pedidos enviados a través de ese distribuidor.

10. ID de cada proveedor y número de productos distintos que nos suministra.*/


--*BOLETIN 8.1*--


--1. Nombre del país y número de clientes de cada país, ordenados alfabéticamente por el nombre del país.

SELECT Country, COUNT(CustomerID) AS [Numero De Clientes] FROM Customers GROUP BY Country

--2. ID de producto y número de unidades vendidas de cada producto.

SELECT ProductID,SUM(Quantity) AS [Numero de unidades vendidas] FROM [Order Details] GROUP BY ProductID ORDER BY ProductID--No es necesario el order by pero es para que se vea más claro y ordenado

--3. ID del cliente y número de pedidos que nos ha hecho.

SELECT CustomerID,COUNT(OrderID) AS [Numero de pedidos] FROM Orders GROUP BY CustomerID

--4. ID del cliente, año y número de pedidos que nos ha hecho cada año.

SELECT CustomerID,YEAR(OrderDate) AS Año,COUNT(OrderID) AS [Numero de pedidos] FROM Orders GROUP BY YEAR(OrderDate),CustomerID

--5. ID del producto, precio unitario y total facturado de ese producto, ordenado por cantidad facturada de mayor a menor. Si hay varios precios unitarios para el mismo producto tomaremos el mayor.

SELECT ProductID,MAX(UnitPrice) AS [Mayor Precio Unitario],SUM(UnitPrice*UnitsOnOrder) AS [Total Facturado] FROM Products GROUP BY ProductID  ORDER BY [Total Facturado] DESC

--6.ID del proveedor e importe total del stock acumulado de productos correspondientes a ese proveedor.

SELECT SupplierID,SUM(UnitPrice*(UnitsInStock+UnitsOnOrder)) AS [Importe Total del Stock]  FROM Products GROUP BY SupplierID

--7.Número de pedidos registrados mes a mes de cada año

SELECT COUNT(OrderID) AS [Numero De Pedidos],MONTH(OrderDate) AS Mes,YEAR(OrderDate) AS Año FROM Orders GROUP BY MONTH(OrderDate),YEAR(OrderDate) ORDER BY Mes,Año--No es necesario el order by pero es para que se vea más claro y ordenado

--8.Año y tiempo medio transcurrido entre la fecha de cada pedido (OrderDate) y la fecha en la que lo hemos enviado (ShipDate), en días para cada año.
SELECT YEAR(OrderDate) AS Año,AVG(DATEDIFF(DAY,OrderDate,ShippedDate)) AS [Tiempo Medio en dias] FROM Orders GROUP BY OrderDate

--9. ID del distribuidor y número de pedidos enviados a través de ese distribuidor.

SELECT ShipVia,COUNT(OrderID) AS [Numero De Pedidos] FROM Orders GROUP BY ShipVia

--10. ID de cada proveedor y número de productos distintos que nos suministra.

SELECT SupplierID,COUNT(ProductID) AS Productos FROM Products GROUP BY SupplierID