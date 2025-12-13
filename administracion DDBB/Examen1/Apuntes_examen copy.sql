
-- ### **Consultas sobre la tabla `City`**

-- 1.  **Ver estructura de la tabla:**
    DESCRIBE City;
    

-- 2.  **Ver todas las tuplas de la tabla:**
    SELECT * FROM City;
    

-- 3.  **Ver todos los nombres y distritos de las ciudades:**
    SELECT NamDistricte,  FROM City;
    

-- 4.  **Ver todas las ciudades que que tienen el código `ESP`:**
    SELECT * FROM City WHERE CountryCode = 'ESP';
    

-- 5.  **Ver todas las ciudades y sus códigos de país, ordenados por código de país:**
    SELECT Name, CountryCode FROM City ORDER BY CountryCode;
    

-- 6.  **Ver cuántas ciudades tiene cada país:**
    SELECT CountryCode, COUNT(ID) AS NumeroDeCiudades FROM City GROUP BY CountryCode;
    

-- 7.  **Sacar la población menor:**
    SELECT MIN(Population) FROM City;
    

-- 8.  **¿Cómo será la mayor?**
    SELECT MAX(Population) FROM City;
    

-- 9.  **Sacar el nombre de la ciudad con más habitantes:**
    SELECT Name, Population FROM City ORDER BY Population DESC LIMIT 1;
    

-- 10. **Averigua la suma de todos los habitantes:**
    SELECT SUM(Population) FROM City;
    

-- 11. **Saca los distintos códigos de país:**
    SELECT DISTINCT CountryCode FROM City;
    

-- 12. **Cuenta los distintos códigos de país:**
    SELECT COUNT(DISTINCT CountryCode) FROM City;
    

-- 13. **Saca las ciudades del país `USA`, que su población sea mayor de 10000:**
    SELECT Name, Population FROM City WHERE CountryCode = 'USA' AND Population > 10000;
    

-- 14. **Cuenta todos los códigos de países:** (Esto cuenta las filas, no los distintos)
    SELECT COUNT(CountryCode) FROM City;
    

-- 15. **Suma todas las poblaciones distintas:**
    SELECT SUM(DISTINCT Population) FROM City;
    

-- 16. **Saca el nombre de la ciudad con menos habitantes:**
    SELECT Name, Population FROM City ORDER BY Population ASC LIMIT 1;
    

-- 17. **Saca sólo las provincias distintas de España:** (La columna se llama `District`)
    SELECT DISTINCT District FROM City WHERE CountryCode = 'ESP' ORDER BY District;
    

-- 18. **Saca el número de ciudades por provincia:**
    SELECT District, COUNT(ID) AS NumeroCiudades FROM City GROUP BY District ORDER BY District;
    

-- 19. **Saca todas las ciudades de Extremadura:** (Asumiendo que el distrito se llama 'Extremadura')
    SELECT Name FROM City WHERE District = 'Extremadura';
    

-- 20. **Saca la cuenta de las ciudades agrupadas por provincias y por países:**
    SELECT CountryCode, District, COUNT(ID) AS NumeroCiudades 
    FROM City 
    GROUP BY CountryCode, District 
    ORDER BY CountryCode, District;
    

-- 21. **Saca la suma de la población de todos los distritos de España:**
    SELECT District, SUM(Population) AS PoblacionTotal 
    FROM City 
    WHERE CountryCode = 'ESP' 
    GROUP BY District;
    

-- 22. **Cuál es el distrito español con más habitantes:**
    SELECT District, SUM(Population) AS PoblacionTotal 
    FROM City 
    WHERE CountryCode = 'ESP' 
    GROUP BY District 
    ORDER BY PoblacionTotal DESC 
    LIMIT 1;
    

-----

-- ### **Consultas sobre la tabla `Country`**

-- 1.  **¿Cuál es la esperanza de vida máxima?**
    SELECT MAX(LifeExpectancy) FROM Country;
    

-- 2.  **Saca la lista de las capitales de todos los países:** (Muestra el ID de la ciudad capital)
    SELECT Name, Capital FROM Country;
    

-- 3.  **Saca la lista de las capitales europeas:**
    SELECT Name, Capital FROM Country WHERE Continent = 'Europe';
    

-- 4.  **Saca las lista de las capitales africanas y norteamericanas:**
    SELECT Name, Capital FROM Country WHERE Continent = 'Africa' OR Continent = 'North America';
    

-- 5.  **Halla la población media:**
    SELECT AVG(Population) FROM Country;
    

-- 6.  **Saca los países con mayor y menor esperanza de vida:**
    (SELECT Name, LifeExpectancy FROM Country ORDER BY LifeExpectancy DESC LIMIT 1)
    UNION
    (SELECT Name, LifeExpectancy FROM Country WHERE LifeExpectancy IS NOT NULL ORDER BY LifeExpectancy ASC LIMIT 1);
    

-- 7.  **Saca una lista de continentes ordenadas por la esperanza de vida media de forma descendente:**
    SELECT Continent, AVG(LifeExpectancy) AS MediaEsperanzaDeVida 
    FROM Country 
    GROUP BY Continent 
    ORDER BY MediaEsperanzaDeVida DESC;
    

-- 8.  **Cuál es la mayor esperanza de vida (Dos formas de hacerlo):**

    --   * **Forma 1 (Con variable implícita `MAX`):**
        SELECT MAX(LifeExpectancy) FROM Country;
        
    --   * **Forma 2 (Usando `ORDER BY` y `LIMIT`):**
        SELECT Name, LifeExpectancy FROM Country ORDER BY LifeExpectancy DESC LIMIT 1;
        

-- 9.  **Sacar el país con mayor extensión de terreno:**
    SELECT Name, SurfaceArea FROM Country ORDER BY SurfaceArea DESC LIMIT 1;
    

-- 10. **Cuántas regiones distintas tenemos:**
    SELECT COUNT(DISTINCT Region) FROM Country;
    

-- 11. **Saca el nombre local de todos los países:**
    SELECT LocalName FROM Country;
    

-- 12. **Saca el nombre local de todos los países Europeos y asiáticos:**
    SELECT LocalName FROM Country WHERE Continent IN ('Europe', 'Asia');
    

-- 13. **Saca las distintas formas de gobierno:**
    SELECT DISTINCT GovernmentForm FROM Country;
    

-----

-- ### **Consultas de todo (JOINs)**

-- 1.  **Enumera todos los idiomas que se hablan en USA:**
    SELECT cl.Language 
    FROM CountryLanguage cl
    JOIN Country c ON cl.CountryCode = c.Code
    WHERE c.Name = 'United States';
    

-- 2.  **Obtén la superficie de cada país y el número de ciudades:**
    SELECT c.Name, c.SurfaceArea, COUNT(ci.ID) AS NumeroCiudades
    FROM Country c
    LEFT JOIN City ci ON c.Code = ci.CountryCode
    GROUP BY c.Code;
    

-- 3.  **Averigua la longevidad media en todos los países que hablan Español:**
    SELECT AVG(c.LifeExpectancy) AS MediaLongevidad
    FROM Country c
    JOIN CountryLanguage cl ON c.Code = cl.CountryCode
    WHERE cl.Language = 'Spanish';
    

-- 4.  **Cuántas ciudades tenemos en Spain:**
    SELECT COUNT(ci.ID)
    FROM City ci
    JOIN Country c ON ci.CountryCode = c.Code
    WHERE c.Name = 'Spain';
    

-- 5.  **¿Cómo puedes averiguar el número de habitantes de cualquier país que no reside en una ciudad?**
    -- Es la resta de la población total del país menos la suma de la población de sus ciudades registradas.
    SELECT c.Name, (c.Population - SUM(ci.Population)) AS PoblacionNoUrbana
    FROM Country c
    JOIN City ci ON c.Code = ci.CountryCode
    GROUP BY c.Code;
    

-- 6.  **¿Qué países tienen por idioma oficial el inglés?**
    SELECT c.Name
    FROM Country c
    JOIN CountryLanguage cl ON c.Code = cl.CountryCode
    WHERE cl.Language = 'English' AND cl.IsOfficial = 'T';
    

-- 7.  **De todas las ciudades que tenemos en un país que sus habitantes llaman España, cuales tienen más de 10.000 habitantes:**
    SELECT ci.Name, ci.Population
    FROM City ci
    JOIN Country c ON ci.CountryCode = c.Code
    WHERE c.LocalName = 'España' AND ci.Population > 10000;
    

-- 8.  **Saca cada país con su nombre completo y el número de distritos:** (distritos distintos)
    SELECT c.Name, COUNT(DISTINCT ci.District) AS NumeroDistritos
    FROM Country c
    JOIN City ci ON c.Code = ci.CountryCode
    GROUP BY c.Code;
    

-- 9.  **Saca cada ciudad con el país al que corresponde, ordenado por ciudad:**
    SELECT ci.Name AS Ciudad, c.Name AS Pais
    FROM City ci
    JOIN Country c ON ci.CountryCode = c.Code
    ORDER BY ci.Name;
    

-- 10. **Obtén una lista con los siguientes campos: Ciudad, población, país, superficie, idioma oficial:**
    SELECT ci.Name AS Ciudad, ci.Population, c.Name AS Pais, c.SurfaceArea, cl.Language AS IdiomaOficial
    FROM City ci
    JOIN Country c ON ci.CountryCode = c.Code
    JOIN CountryLanguage cl ON c.Code = cl.CountryCode
    WHERE cl.IsOfficial = 'T';
    

-- 11. **Obtén una lista... Agrupada por países:** (La interpretamos como ordenada por país)
    SELECT ci.Name AS Ciudad, ci.Population, c.Name AS Pais, c.SurfaceArea, cl.Language AS IdiomaOficial
    FROM City ci
    JOIN Country c ON ci.CountryCode = c.Code
    JOIN CountryLanguage cl ON c.Code = cl.CountryCode
    WHERE cl.IsOfficial = 'T'
    ORDER BY c.Name, ci.Name;
    

-- 12. **Obtén el nombre de la capital de todos los países:**
    SELECT c.Name AS Pais, ci.Name AS Capital
    FROM Country c
    JOIN City ci ON c.Capital = ci.ID;
    

-- 13. **Di el nombre de la capital del país más grande:**
    SELECT ci.Name AS Capital
    FROM Country c
    JOIN City ci ON c.Capital = ci.ID
    ORDER BY c.SurfaceArea DESC
    LIMIT 1;
    

-- 14. **Di el nombre de la capital del país con más esperanza de vida:**
    SELECT ci.Name AS Capital
    FROM Country c
    JOIN City ci ON c.Capital = ci.ID
    ORDER BY c.LifeExpectancy DESC
    LIMIT 1;
    

-- 15. **Di el nombre de la capital del país con más población:**
    SELECT ci.Name AS Capital
    FROM Country c
    JOIN City ci ON c.Capital = ci.ID
    ORDER BY c.Population DESC
    LIMIT 1;
    

-- 16. **Lista todos los países con más de 1 millón de habitantes con sus capitales y sus lenguas no oficiales:**
    SELECT c.Name AS Pais, ci.Name AS Capital, cl.Language AS LenguaNoOficial
    FROM Country c
    JOIN City ci ON c.Capital = ci.ID
    JOIN CountryLanguage cl ON c.Code = cl.CountryCode
    WHERE c.Population > 1000000 AND cl.IsOfficial = 'F';
    

-- 17. **Cuántos idiomas tiene cada país:**
    SELECT c.Name, COUNT(cl.Language) AS NumeroDeIdiomas
    FROM Country c
    JOIN CountryLanguage cl ON c.Code = cl.CountryCode
    GROUP BY c.Name;
    

-- 18. **¿Tenemos algún país con dos lenguas oficiales? (hacer con `HAVING`)**
    SELECT c.Name, COUNT(cl.Language) as NumeroLenguasOficiales
    FROM Country c
    JOIN CountryLanguage cl ON c.Code = cl.CountryCode
    WHERE cl.IsOfficial = 'T'
    GROUP BY c.Name
    HAVING COUNT(cl.Language) >= 2;
    

-- 19. **Saca el jefe de gobierno de un país cuya capital es Madrid:**
    SELECT c.HeadOfState
    FROM Country c
    JOIN City ci ON c.Capital = ci.ID
    WHERE ci.Name = 'Madrid';
    

-----

-- ### **Creación de Vistas**

-- 1.  **Crea una vista con la media de habitantes (de las ciudades):**
    CREATE VIEW VistaMediaHabitantes AS
    SELECT AVG(Population) AS MediaHabitantes FROM City;
    

-- 2.  **Crea una vista con la ciudad que tenga exactamente la media de habitantes:**
    CREATE VIEW VistaCiudadMediaHabitantes AS
    SELECT * FROM City 
    WHERE Population = (SELECT AVG(Population) FROM City);
    

-- 3.  **Crea una vista con todas las provincias (Distritos) de España:**
    CREATE VIEW VistaProvinciasEspana AS
    SELECT DISTINCT District FROM City WHERE CountryCode = 'ESP';
    

-- 4.  **Crea una vista con todos los países con sus capitales y la lengua oficial:**
    CREATE VIEW VistaPaisCapitalIdioma AS
    SELECT c.Name AS Pais, ci.Name AS Capital, cl.Language AS IdiomaOficial
    FROM Country c
    JOIN City ci ON c.Capital = ci.ID
    JOIN CountryLanguage cl ON c.Code = cl.CountryCode
    WHERE cl.IsOfficial = 'T';
    

-- 5.  **Crea una vista con los países con más de 1 millón de habitantes con sus capitales y la lengua oficial:**
    CREATE VIEW VistaGrandesPaises AS
    SELECT c.Name AS Pais, ci.Name AS Capital, cl.Language AS IdiomaOficial
    FROM Country c
    JOIN City ci ON c.Capital = ci.ID
    JOIN CountryLanguage cl ON c.Code = cl.CountryCode
    WHERE cl.IsOfficial = 'T' AND c.Population > 1000000;
    




-- 1 Crear un usuario llamado “alumno” que tenga acceso a las tablas ALUMNO, CURSA,Y MODULO desde cualquier lugar .
CREATE USER alumno@'%' IDENTIFIED BY 'asdf';

GRANT ALL ON pruebas.alumno TO alumno@'%';
GRANT ALL ON pruebas.cursa TO alumno@'%';
GRANT ALL ON pruebas.modulo TO alumno@'%';

-- 2 Crear un usuario llamado “profesor” que tenga permiso de lectura(no puede añadir y modificar nada) a toda la base de datos.
CREATE USER profesor@localhost IDENTIFIED BY 'asdf';

GRANT SELECT ON pruebas.* TO profesor@localhost;

-- 3 Crear un usuario llamado “profesorasir” con los privilegios anteriores y los privilegios de inserción y borrado en la tabla.
CREATE USER profesorasir@localhost IDENTIFIED BY 'asdf';

GRANT SELECT, INSERT, DELETE ON pruebas.* TO profesorasir@localhost;

-- 4 Crear un usuario llamado “adminasir” que tenga todos los privilegios a todas las bases de datos de nuestro servidor. Este administrador no tendrá la posibilidad de dar privilegios.
CREATE USER adminasir@localhost IDENTIFIED BY 'asdf';

GRANT ALL ON *.* TO adminasir@localhost;

-- 5 Crear un usuario llamado “superasir” con los privilegios anteriores y con posibilidad de dar privilegios.
CREATE USER superasir@localhost IDENTIFIED BY 'asdf';

GRANT ALL ON *.* TO superasir@localhost WITH GRANT OPTION;

-- 6 Crear un usuario llamado “ocasional” con permiso para realizar consultas(select) en las tablas.
CREATE USER ocasional@localhost IDENTIFIED BY 'asdf';

GRANT SELECT ON pruebas.* TO ocasional@localhost;

-- 7 Cambiar la contraseña de root a “css99”.
SET PASSWORD FOR root@localhost=PASSWORD('css99');
ALTER USER root@localhost IDENTIFIED BY 'css99';
SET PASSWORD FOR root@localhost = 'css99';

-- 8 Quitar los privilegios al usuario “profesorasir”.
REVOKE ALL ON pruebas.* FROM profesorasir@localhost;

-- 9 Eliminar todos los privilegios al usuario "alumno".
REVOKE ALL ON pruebas.alumno FROM alumno@'%';
REVOKE ALL ON pruebas.cursa FROM alumno@'%';
REVOKE ALL ON pruebas.modulo FROM alumno@'%';
-- REVOKE ALL ON pruebas.* FROM alumno@'%'; no se porque no funciona

-- 10 Muestra los privilegios de usuario alumno.
SHOW GRANTS FOR alumno@'%';





-- sudo mysqldump -u root -p futbolasir > backup_futbolasir.sql

INSERT INTO Equipos (id_equipo, nombre, estadio, aforo, ano_fundacion, ciudad) 
VALUES (99, 'Canela FC', 'El Pipote', 1500, None, 'Rama');

UPDATE Equipos 
SET aforo = 55000 
WHERE id_equipo = 1;

UPDATE Partidos 
SET goles_casa = 2, goles_fuera = 1 
WHERE id_equipo_casa = 1 AND id_equipo_fuera = 2;

DELETE FROM Equipos 
WHERE id_equipo = 5;

drop database futbolasir;

create database futbolasir;
-- sudo mysql -u root -p futbolasir < backup_futbolasir.sql


-- mysqlbinlog /var/log/mysql/mysql-bin.000002 | mysql -u root -p











-- sudo mysql -u root -p < clientes.sql

SHOW INDEXES FROM producto;

EXPLAIN SELECT * 
FROM producto 
WHERE codigo_producto = 'OR-114'; 

EXPLAIN SELECT * 
FROM producto 
WHERE nombre = 'Evonimus Pulchellus';


EXPLAIN SELECT AVG(total) 
FROM pago 
WHERE YEAR(fecha_pago) = 2008; 

EXPLAIN SELECT AVG(total) 
FROM pago 
WHERE fecha_pago >= '2008-01-01' AND fecha_pago <=  
'2008-12-31';

EXPLAIN SELECT * 
FROM cliente INNER JOIN pedido 
ON cliente.codigo_cliente = pedido.codigo_cliente 
WHERE cliente.nombre_cliente LIKE 'A%';

CREATE INDEX idx_cliente_nombre ON cliente (nombre_cliente);

EXPLAIN SELECT * 
FROM cliente INNER JOIN pedido 
ON cliente.codigo_cliente = pedido.codigo_cliente 
WHERE cliente.nombre_cliente LIKE 'A%';


CREATE INDEX idx_contacto_nombre_completo ON cliente (apellido_contacto, nombre_contacto);

EXPLAIN SELECT * 
FROM cliente 
WHERE apellido_contacto = 'Villar' 
AND nombre_contacto = 'Javier';

EXPLAIN SELECT * FROM cliente 
WHERE apellido_contacto = 'Villar';

EXPLAIN SELECT * FROM cliente 
WHERE nombre_contacto = 'Javier';





Select salario from empleados 
where salario != (select MAX(salario) from empleados ) ORDER BY salario DESC LIMIT 1;



Imagine que tiene dos tablas: Productos (ID, NombreProducto) y Ventas (ProductoID, FechaVenta).

Escriba una consulta que muestre los NombreProducto que nunca han sido vendidos (es decir, que no tienen entradas correspondientes en la tabla Ventas).

SELECT NombreProducto from productos 
LEFT JOIN Ventas ON Productos.ID = Ventas.ProductoID
WHERE ProductoID IS NULL;