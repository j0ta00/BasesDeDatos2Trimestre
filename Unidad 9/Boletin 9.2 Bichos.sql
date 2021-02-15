
--Boletin 9.2 bichos
--1.Nombre de la mascota, raza, especie y fecha de nacimiento de aquellos que hayan sufrido leucemia, moquillo o toxoplasmosis
SELECT M.Alias,M.Raza,M.Especie,M.FechaNacimiento FROM BI_Mascotas AS M 
INNER JOIN BI_Mascotas_Enfermedades AS ME ON M.Codigo = ME.Mascota
WHERE ME.IDEnfermedad IN (SELECT ID FROM BI_Enfermedades WHERE Nombre IN ('leucemia', 'moquillo','toxoplasmosis'))
--CON INNER JOIN
SELECT M.Alias,M.Raza,M.Especie,M.FechaNacimiento FROM BI_Mascotas AS M 
INNER JOIN BI_Mascotas_Enfermedades AS ME ON M.Codigo = ME.Mascota INNER JOIN BI_Enfermedades AS E ON ME.IDEnfermedad=E.ID
WHERE Nombre IN ('leucemia', 'moquillo','toxoplasmosis')

--2.Nombre, raza y especie de las mascotas que hayan ido a alguna visita en primavera (del 20 de marzo al 20 de Junio)
SELECT M.Alias,M.Raza,M.Especie,V.Fecha FROM BI_Mascotas AS M INNER JOIN BI_Visitas AS V ON M.Codigo=V.Mascota WHERE 
(MONTH(V.Fecha) BETWEEN 4 AND 5) OR (DAY(V.Fecha) BETWEEN 20 AND 31 AND MONTH(V.Fecha) = 3) OR (DAY(V.Fecha) BETWEEN 1 AND 20 AND MONTH(V.Fecha) = 6)
--3.Nombre y teléfono de los propietarios de mascotas que hayan sufrido rabia, sarna, artritis o filariosis y hayan tardado más de 10 días en curarse. Los que no tienen fecha de curación, considera la fecha actual para calcular la duración del tratamiento.
--4.Nombre y especie de las mascotas que hayan ido alguna vez a consulta mientras estaban enfermas. Incluye el nombre d ela enmfermedad que sufrían y la fecha de la visita.
--5.Nombre, dirección y teléfono de los clientes que tengan mascotas de al menos dos especies diferentes
--6.Nombre, teléfono y número de mascotas de cada especie que tiene cada cliente.
--7.Nombre, especie y nombre del propietario de aquellas mascotas que hayan sufrido una enfermedad de tipo infeccioso (IN) o genético (GE) más de una vez.