/*1. Nombre de la compañía y dirección completa (dirección, cuidad, país) de todos los
clientes que no sean de los Estados Unidos.
2. La consulta anterior ordenada por país y ciudad.
3. Nombre, Apellidos, Ciudad y Edad de todos los empleados, ordenados por antigüedad en
la empresa.
4. Nombre y precio de cada producto, ordenado de mayor a menor precio.
5. Nombre de la compañía y dirección completa de cada proveedor de algún país de
América del Norte.
6. Nombre del producto, número de unidades en stock y valor total del stock, de los
productos que no sean de la categoría 4.
7. Clientes (Nombre de la Compañía, dirección completa, persona de contacto) que no
residan en un país de América del Norte y que la persona de contacto no sea el
propietario de la compañía
8. ID del cliente y número de pedidos realizados por cada cliente, ordenado de mayor a
menor número de pedidos.
9. Número de pedidos enviados a cada ciudad, incluyendo el nombre de la ciudad.
10. Número de productos de cada categoría. */

--1--
SELECT CompanyName,Address,City,Country FROM Customers WHERE Country<>'USA'
--2--
SELECT CompanyName,Address,City,Country FROM Customers WHERE Country<>'USA' ORDER BY Country,City
--3--
SELECT FirstName,Lastname,City,BirthDate FROM Employees ORDER BY HireDate 
--4--
SELECT ProductName,UnitPrice FROM Products ORDER BY UnitPrice DESC
--5--
SELECT CompanyName,Address,Country FROM Suppliers WHERE Country IN ('USA','Canada')
--6--
SELECT ProductName,UnitsInStock,UnitsInStock*UnitPrice AS ValorTotalDelStock FROM Products WHERE CategoryID<>4 
--7--
SELECT CompanyName,Address,ContactName,ContactTitle FROM Customers WHERE ContactTitle<>'owner' AND Country NOT IN('USA','Canada') 