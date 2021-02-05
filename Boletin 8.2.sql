

--BOLETIN 8.2 CONSULTAS CON AGREGADOS

--1. Numero de libros que tratan de cada tema
SELECT COUNT(*) AS Libros,[type] FROM titles GROUP BY [type]
--2. N�mero de autores diferentes en cada ciudad y estado
SELECT COUNT(*) AS Autores,city,[state] FROM authors GROUP BY city,[state]
--3. Nombre, apellidos, nivel y antig�edad en la empresa de los empleados con un nivel entre 100 y 150.
SELECT fname,lname,job_lvl,(YEAR(GETDATE())-YEAR(hire_date)) AS [Antig�edad en a�os] FROM employee WHERE job_lvl BETWEEN 100 AND 150
--4. N�mero de editoriales en cada pa�s. Incluye el pa�s.
SELECT COUNT(*) AS Editoriales,Country FROM publishers GROUP BY country
--5. N�mero de unidades vendidas de cada libro en cada a�o (title_id, unidades y a�o).
SELECT SUM(qty) AS [Unidades vendidas],title_id,YEAR(ord_date)AS A�o FROM sales GROUP BY YEAR(ord_date),title_id
--6. N�mero de autores que han escrito cada libro (title_id y numero de autores).
SELECT COUNT(*) AS Autores,title_id FROM titleauthor GROUP BY title_id
--7. ID, Titulo, tipo y precio de los libros cuyo adelanto inicial (advance) tenga un valor superior a $7.000, ordenado por tipo y t�tulo
SELECT title_id,title,price FROM titles WHERE advance>7000 ORDER BY [type],title