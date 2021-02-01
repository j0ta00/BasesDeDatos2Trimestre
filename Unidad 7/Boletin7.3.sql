/*Consultas sobre una sola Tabla sin agregados
Sobre la base de datos "pubs” (En la plataforma aparece como "Ejemplos 2000").

1.Título, precio y notas de los libros (titles) que tratan de cocina, ordenados de mayor a menor precio.
2.ID, descripción y nivel máximo y mínimo de los puestos de trabajo (jobs) que pueden tener un nivel 110.
3.Título, ID y tema de los libros que contengan la palabra "and” en las notas
4.Nombre y ciudad de las editoriales (publishers) de los Estados Unidos que no estén en California ni en Texas
5.Título, precio, ID de los libros que traten sobre psicología o negocios y cuesten entre diez y 20 dólares.
6.Nombre completo (nombre y apellido) y dirección completa de todos los autores que no viven en California ni en Oregón.
7.Nombre completo y dirección completa de todos los autores cuyo apellido empieza por D, G o S.
8.ID, nivel y nombre completo de todos los empleados con un nivel inferior a 100, ordenado alfabéticamente

Modificaciones de datos
1.Inserta un nuevo autor.
2.Inserta dos libros, escritos por el autor que has insertado antes y publicados por la editorial "Ramona publishers”.
3.Modifica la tabla jobs para que el nivel mínimo sea 90.
4.Crea una nueva editorial (publihers) con ID 9908, nombre Mostachon Books y sede en Utrera.
5.Cambia el nombre de la editorial con sede en Alemania para que se llame "Machen Wücher" y traslasde su sede a Stuttgart
*/

--MODIFICACIONES

--1.Inserta un nuevo autor.
GO
INSERT INTO authors(au_id,au_lname,au_fname,phone,address,city,state,zip,contract) VALUES ('173-32-1123','Martin','George','038 473-4833','10 Jhonson Dr.','Los Angeles','CA','32745',1)
GO
--2.Inserta dos libros, escritos por el autor que has insertado antes y publicados por la editorial "Ramona publishers”.
SELECT*FROM titles
GO
INSERT INTO titles(title_id,title,type,pub_id,price,advance,royalty,ytd_sales,notes,pubdate) VALUES ('PC8435','The armageddon rag','popular_comp',1756,20,'600,000',10,467,null,'2016-08-16T11:41:52'),('PC8645','A Game of Thrones','popular_comp',1756,25,'300,000',10,302,null,'2016-08-16T11:41:52') 
GO
--3.Modifica la tabla jobs para que el nivel mínimo sea 90.
GO
UPDATE jobs SET min_lvl=90 WHERE min_lvl<>90
ALTER TABLE jobs ADD CONSTRAINT CK_Minimo CHECK (minit=90) 
GO
--4.Crea una nueva editorial (publihers) con ID 9908, nombre Mostachon Books y sede en Utrera.
INSERT INTO publishers(pub_id,pub_name,city,state,country) VALUES (9908,'Mostachon Books','Utrera','Seville','Spain')
--5.Cambia el nombre de la editorial con sede en Alemania para que se llame "Machen Wücher" y traslasde su sede a Stuttgart
GO
UPDATE  publishers SET city='Stuttgart' WHERE city='Machen Wücher'
GO

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--CONSULTAS

--1.Título, precio y notas de los libros (titles) que tratan de cocina, ordenados de mayor a menor precio.
SELECT title,price,notes FROM titles WHERE type NOT LIKE '%cook%' ORDER BY price DESC
--2.ID, descripción y nivel máximo y mínimo de los puestos de trabajo (jobs) que pueden tener un nivel 110.
SELECT*FROM jobs WHERE min_lvl>=110
--3.Título, ID y tema de los libros que contengan la palabra "and” en las notas
SELECT title,title_id,type FROM titles WHERE notes LIKE '%and%'
--4.Nombre y ciudad de las editoriales (publishers) de los Estados Unidos que no estén en California ni en Texas
SELECT city,pub_name FROM publishers WHERE country='USA' AND state NOT IN('CA','TX')
--5.Título, precio, ID de los libros que traten sobre psicología o negocios y cuesten entre diez y 20 dólares.
SELECT*FROM titles
SELECT title,price,title_id FROM titles WHERE type IN ('psychology','business') AND price BETWEEN 10 AND 20
--6.Nombre completo (nombre y apellido) y dirección completa de todos los autores que no viven en California ni en Oregón.
SELECT*FROM authors
SELECT au_fname,au_lname,address FROM authors WHERE state NOT IN('CA','OR')
--7.Nombre completo y dirección completa de todos los autores cuyo apellido empieza por D, G o S.
SELECT au_fname,au_lname,city,state,address,zip FROM authors WHERE au_lname LIKE '[SDG]%'
--8.ID, nivel y nombre completo de todos los empleados con un nivel inferior a 100, ordenado alfabéticamente
SELECT*FROM employee
SELECT emp_id,job_lvl,fname,lname FROM employee WHERE job_lvl<100 ORDER BY fname,lname