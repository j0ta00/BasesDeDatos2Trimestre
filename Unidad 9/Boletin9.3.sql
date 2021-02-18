
--Boletín 9.3
--1.Título y tipo de todos los libros en los que alguno de los autores vive en California (CA).

SELECT DISTINCT T.title_id,T.[type] FROM titles AS T INNER JOIN titleauthor AS TA ON T.title_id=TA.title_id INNER JOIN authors AS A ON TA.au_id=A.au_id
WHERE ISNULL(A.state,'UNKNOWN') IN('CA')

--2.Título y tipo de todos los libros en los que ninguno de los autores vive en California (CA).
--Con except aparecen 9 filas debido a que muestra todo libro cuyo autor no sea de CA tenga un autor registrado o no ya que la consulta es a la tabla libros

SELECT title_id,[type] FROM titles
EXCEPT 
SELECT  DISTINCT T.title_id,T.[type] FROM titles AS T 
INNER JOIN titleauthor AS TA ON T.title_id=TA.title_id 
INNER JOIN authors AS A ON TA.au_id=A.au_id
WHERE ISNULL(A.state,'UNKNOWN') IN('CA')

--Aparecen 6 filas ya que aparecen los libros cuyo autor no es de CA pero claro si el autor no esta registrado en TA no aparecerá aunque no sea de CA ya que aunque
--la consulta es también a la tabla libros esta está relacionada con TA y si hay libros que no esten en esta tabla es decir no haya relación  entre autor y libro 
--no aparecerá
SELECT  DISTINCT T.title_id,T.[type] FROM titles AS T 
INNER JOIN titleauthor AS TA ON T.title_id=TA.title_id 
INNER JOIN authors AS A ON TA.au_id=A.au_id
WHERE ISNULL(A.state,'UNKNOWN') NOT IN('CA')
select*from titles
select*from  titleauthor
select*from authors

--3.Número de libros en los que ha participado cada autor, incluidos los que no han publicado nada.

SELECT ISNULL([A].au_id,'UNKNOWN') AS [Id de los autores], COUNT(T.title_id) AS [Cantidad de libros] FROM titleauthor AS [AT] 
INNER JOIN titles AS T ON [AT].title_id=T.title_id
RIGHT JOIN authors AS A ON [AT].au_id=A.au_id
GROUP BY A.au_id
SELECT*FROM authors

--4.Número de libros que ha publicado cada editorial, incluidas las que no han publicado ninguno.

SELECT P.pub_id,COUNT(T.title_id) AS [Número de libros] FROM titles AS T 
RIGHT JOIN publishers AS P ON T.pub_id=P.pub_id 
GROUP BY P.pub_id 

--5.Número de empleados de cada editorial.

SELECT P.pub_id,COUNT(E.emp_id) AS [Cantidadd de Empleados] FROM employee AS E 
INNER JOIN publishers AS P ON E.pub_id=P.pub_id 
GROUP BY P.pub_id

--6.Calcular la relación entre número de ejemplares publicados y número de empleados de cada editorial, incluyendo el nombre de la misma.

SELECT P.pub_name,P.pub_id,COUNT(T.title_id) AS [Número de libros/Empleados] FROM titles AS T 
RIGHT JOIN publishers AS P ON T.pub_id=P.pub_id 
GROUP BY P.pub_id,P.pub_name 
UNION
SELECT P.pub_name,P.pub_id,COUNT(E.emp_id) AS [Cantidad de Empleados] FROM employee AS E 
INNER JOIN publishers AS P ON E.pub_id=P.pub_id 
GROUP BY P.pub_id,P.pub_name 

--7.Nombre, Apellidos y ciudad de todos los autores que han trabajado para la editorial "Binnet & Hardley” o "Five Lakes Publishing”

SELECT A.au_fname,A.au_lname,A.city FROM authors AS A 
INNER JOIN titleauthor AS [AT] ON A.au_id=AT.au_id
EXCEPT
SELECT A.au_fname,A.au_lname,A.city FROM authors AS A 
INNER JOIN titleauthor AS AT ON A.au_id=AT.au_id
INNER JOIN titles AS T ON [AT].title_id=T.title_id
INNER JOIN publishers AS P ON T.pub_id=P.pub_id
WHERE pub_name IN('Binnet & Hardley','Five Lakes Publishing') 


--De nuevo sería erroneo con el NOT IN ya que hay autores que han escrito varios libros y uno puede cumplir la condición y el otro no y aun así se mostraría el autor
--cuando no debería ser así

SELECT DISTINCT A.au_fname,A.au_lname,A.city FROM authors AS A 
INNER JOIN titleauthor AS AT ON A.au_id=AT.au_id
INNER JOIN titles AS T ON [AT].title_id=T.title_id
INNER JOIN publishers AS P ON T.pub_id=P.pub_id
WHERE pub_name NOT IN('Binnet & Hardley','Five Lakes Publishing') 

--8.Empleados que hayan trabajado en alguna editorial que haya publicado algún libro en el que alguno de los autores fuera Marjorie Green o Michael O'Leary.

SELECT DISTINCT E.emp_id,E.fname FROM employee AS E 
INNER JOIN publishers AS P ON E.pub_id=P.pub_id
INNER JOIN titles AS T ON P.pub_id=T.pub_id 
INNER JOIN titleauthor AS [AT] ON T.title_id=[AT].title_id
INNER JOIN authors AS A ON [AT].au_id=A.au_id
WHERE (A.au_fname='Marjorie' AND A.au_lname='Green') OR (A.au_fname='Michael' AND A.au_lname='O''Leary')



--9.Número de ejemplares vendidos de cada libro, especificando el título y el tipo.

SELECT T.[type],T.title,SUM(ISNULL(S.qty,0)) AS [Ejemplares Vendidos] FROM sales AS S 
RIGHT JOIN titles AS T ON S.title_id=T.title_id 
GROUP BY T.title_id,T.[type],T.title

--10.Número de ejemplares de todos sus libros que ha vendido cada autor.

SELECT A.au_fname,SUM(ISNULL(S.qty,0)) AS [Ejemplares Vendidos] FROM sales AS S
INNER JOIN titles AS T ON S.title_id=T.title_id 
INNER JOIN titleauthor AS [AT] ON T.title_id=[AT].title_id
RIGHT JOIN authors AS A ON [AT].au_id=A.au_id
GROUP BY A.au_id,A.au_fname

--11.Número de empleados de cada categoría (jobs).

SELECT J.job_desc,COUNT(E.emp_id) AS [Número de empleados] FROM employee AS E 
RIGHT JOIN jobs AS J ON E.job_id=J.job_id
GROUP BY J.job_id,J.job_desc

--12.Número de empleados de cada categoría (jobs) que tiene cada editorial, incluyendo aquellas categorías en las que no haya ningún empleado.

SELECT P.pub_name,J.job_desc,COUNT(E.job_id) AS [Número de empleados por Categoría]
FROM publishers AS P
CROSS JOIN jobs AS J 
LEFT JOIN  employee AS E
ON P.pub_id=E.pub_id AND J.job_id=E.job_id
GROUP BY P.pub_id,P.pub_name,J.job_desc

--13.Autores que han escrito libros de dos o más tipos diferentes

SELECT A.au_fname,A.au_lname FROM authors AS A
INNER JOIN titleauthor AS [TA] ON A.au_id=ta.au_id
INNER JOIN titles AS T ON [TA].title_id=T.title_id
GROUP BY A.au_id,A.au_fname,A.au_lname
HAVING COUNT(DISTINCT T.[type])>=2

--14.Empleados que no trabajan actualmente en editoriales que han publicado libros cuya columna notes contenga la palabra "and”

SELECT E.fname,E.lname FROM employee AS E
EXCEPT
SELECT DISTINCT E.fname,E.lname FROM employee AS E 
INNER JOIN publishers AS P ON E.pub_id=P.pub_id
INNER JOIN titles as T ON P.pub_id=T.pub_id
WHERE T.notes LIKE ('% and[., ]%')
