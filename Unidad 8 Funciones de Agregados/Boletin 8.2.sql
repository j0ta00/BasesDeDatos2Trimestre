

--BOLETIN 8.2 CONSULTAS CON AGREGADOS

--1. Numero de libros que tratan de cada tema
SELECT COUNT(*) AS Libros,[type] FROM titles GROUP BY [type]
--2. Número de autores diferentes en cada ciudad y estado
SELECT COUNT(*) AS Autores,city,[state] FROM authors GROUP BY city,[state]
--3. Nombre, apellidos, nivel y antigüedad en la empresa de los empleados con un nivel entre 100 y 150.
SELECT fname,lname,job_lvl,(YEAR(GETDATE())-YEAR(hire_date)) AS [Antigüedad en años] FROM employee WHERE job_lvl BETWEEN 100 AND 150
--4. Número de editoriales en cada país. Incluye el país.
SELECT COUNT(*) AS Editoriales,Country FROM publishers GROUP BY country
--5. Número de unidades vendidas de cada libro en cada año (title_id, unidades y año).
SELECT SUM(qty) AS [Unidades vendidas],title_id,YEAR(ord_date)AS Año FROM sales GROUP BY YEAR(ord_date),title_id
--6. Número de autores que han escrito cada libro (title_id y numero de autores).
SELECT COUNT(*) AS Autores,title_id FROM titleauthor GROUP BY title_id
--7. ID, Titulo, tipo y precio de los libros cuyo adelanto inicial (advance) tenga un valor superior a $7.000, ordenado por tipo y título
SELECT title_id,title,price FROM titles WHERE advance>7000 ORDER BY [type],title
