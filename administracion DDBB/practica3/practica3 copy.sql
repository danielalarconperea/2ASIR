-- 1.
CREATE DATABASE futbolasir;
USE futbolasir;
-- 2.
CREATE TABLE Jugadores (
id_jugador INT(3),
nombre VARCHAR(50),
fecha_nac DATE,
demarcacion VARCHAR(50),
internacional INT(3),
id_equipo INT(2)
);

CREATE TABLE Equipos (
id_equipo INT(2),
nombre VARCHAR(50),
estadio VARCHAR(50),
aforo INT(9),
ano_fundacion INT(4),
ciudad VARCHAR(50)
);

CREATE TABLE Partidos (
id_equipo_casa INT(2),
id_equipo_fuera INT(2),
fecha DATE,
goles_casa INT(2),
goles_fuera INT(2),
observaciones VARCHAR(200)
);

CREATE TABLE Goles (
id_equipo_casa INT(2),
id_equipo_fuera INT(2),
minuto INT(2),
descripcion VARCHAR(200),
id_jugador INT(3)
);
-- 3.
ALTER TABLE Partidos ADD hora_comienzo TIME;
-- 4.
ALTER TABLE Jugadores ADD PRIMARY KEY (id_jugador);
-- 5.
ALTER TABLE Equipos ADD PRIMARY KEY (id_equipo);
-- 6.
ALTER TABLE Equipos CHANGE ano_fundacion fundacion INT(4);
-- 7.
ALTER TABLE Equipos ADD anagrama VARCHAR(255);
-- 8.
ALTER TABLE Jugadores ADD FOREIGN KEY (id_equipo) REFERENCES Equipos(id_equipo);





USE futbolasir;

-- -----------------------------------------------------
-- Inserción de datos en la tabla JUGADORES
-- -----------------------------------------------------
INSERT INTO Jugadores (id_jugador, nombre, fecha_nac, demarcacion, internacional, id_equipo) VALUES
(1, 'Iker', '1980-05-09', 'Portero', 50, 1),
(2, 'Ronaldo', '1974-07-07', 'Delantero', 80, 1),
(3, 'Ramos', '1998-09-09', 'Centrocampista', 75, 1),
(4, 'Neymar', '1999-03-03', 'Delantero', 50, 2);

-- -----------------------------------------------------
-- Inserción de datos en la tabla EQUIPOS
-- -----------------------------------------------------
INSERT INTO Equipos (id_equipo, nombre, estadio, aforo, fundacion, ciudad) VALUES
(1, 'Real Madrid', 'Santiago Bernabeu', 80000, 1950, 'Madrid'),
(2, 'F.C. Barcelona', 'Camp Nou', 70000, 1948, 'Barcelona'),
(3, 'Valencia C.F', 'Mestalla', 90000, 1952, 'Valencia'),
(4, 'Atlético de Madrid', 'Vicente Calderón', 55000, 1945, 'Madrid');

-- -----------------------------------------------------
-- Inserción de datos en la tabla PARTIDOS
-- -----------------------------------------------------
INSERT INTO Partidos (id_equipo_casa, id_equipo_fuera, fecha, goles_casa, goles_fuera, observaciones) VALUES
(1, 2, '2014-03-03', 2, 1, NULL),
(1, 3, '2014-04-04', 3, 1, NULL),
(2, 3, '2014-04-03', 0, 4, NULL);

-- -----------------------------------------------------
-- Inserción de datos en la tabla GOLES
-- -----------------------------------------------------
INSERT INTO Goles (id_equipo_casa, id_equipo_fuera, minuto, descripcion, id_jugador) VALUES
(1, 2, 35, 'De falta', 2),
(1, 2, 70, NULL, 2),
(1, 2, 88, NULL, 4),
(1, 3, 5, NULL, 3),
(1, 3, 10, 'De penalti', 2);


-- mysqldump: Es la utilidad para crear respaldos.
mysqldump -u root -p futbolasir > backup_futbolasir.sql



-----

-- ### **Consultas sobre la tabla `City`**
-- 1.  **Ver estructura de la tabla:**
    describe City;

-- 2.  **Ver todas las tuplas de la tabla:**
    SELECT * FROM City

-- 3.  **Ver todos los nombres y distritos de las ciudades:**
    SELECT Name, District FROM City;

-- 4.  **Ver todas las ciudades que tienen el código `ESP`:**
    SELECT * FROM City WHERE CountryCode = 'ESP';

-- 5.  **Ver todas las ciudades y sus códigos de país, ordenados por código de país:**
    SELECT Name, ID FROM City ORDER BY CountryCode;

-- 6.  **Ver cuántas ciudades tiene cada país:**
    SELECT CountryCode, count(ID) AS NumeroCiudades FROM City GROUP BY CountryCode;

-- 7.  **Sacar la población menor:**
    SELECT min(Population) FROM City;

-- 8.  **¿Cómo será la mayor?**
    SELECT max(Population) FROM City;

-- 9.  **Sacar el nombre de la ciudad con más habitantes:**
    SELECT Name AS 'ciudad con más habitantes' FROM City WHERE population = (SELECT max(population) FROM city);

-- 10. **Averigua la suma de todos los habitantes:**
    SELECT sum(population) FROM City;

-- 11. **Saca los distintos códigos de país:**
    SELECT DISTINCT CountryCode FROM City

-- 12. **Cuenta los distintos códigos de país:**
    SELECT DISTINCT count(CountryCode) FROM City

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
    SELECT Name FROM City WHERE District = 'Extremadura'

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
    SELECT 

-- 3.  **Saca la lista de las capitales europeas:**


-- 4.  **Saca las lista de las capitales africanas y norteamericanas:**


-- 5.  **Halla la población media:**


-- 6.  **Saca los países con mayor y menor esperanza de vida:**
 

-- 7.  **Saca una lista de continentes ordenadas por la esperanza de vida media de forma descendente:**


-- 8.  **Cuál es la mayor esperanza de vida (Dos formas de hacerlo):**

    --   * **Forma 1 (Con variable implícita `MAX`):**

    --   * **Forma 2 (Usando `ORDER BY` y `LIMIT`):**


-- 9.  **Sacar el país con mayor extensión de terreno:**


-- 10. **Cuántas regiones distintas tenemos:**


-- 11. **Saca el nombre local de todos los países:**


-- 12. **Saca el nombre local de todos los países Europeos y asiáticos:**


-- 13. **Saca las distintas formas de gobierno:**


-----

-- ### **Consultas de todo (JOINs)**

-- 1.  **Enumera todos los idiomas que se hablan en USA:**


-- 2.  **Obtén la superficie de cada país y el número de ciudades:**


-- 3.  **Averigua la longevidad media en todos los países que hablan Español:**


-- 4.  **Cuántas ciudades tenemos en Spain:**


-- 5.  **¿Cómo puedes averiguar el número de habitantes de cualquier país que no reside en una ciudad?**


-- 6.  **¿Qué países tienen por idioma oficial el inglés?**


-- 7.  **De todas las ciudades que tenemos en un país que sus habitantes llaman España, cuales tienen más de 10.000 habitantes:**


-- 8.  **Saca cada país con su nombre completo y el número de distritos:** (distritos distintos)
   

-- 9.  **Saca cada ciudad con el país al que corresponde, ordenado por ciudad:**


-- 10. **Obtén una lista con los siguientes campos: Ciudad, población, país, superficie, idioma oficial:**


-- 11. **Obtén una lista... Agrupada por países:** (La interpretamos como ordenada por país)


-- 12. **Obtén el nombre de la capital de todos los países:**


-- 13. **Di el nombre de la capital del país más grande:**


-- 14. **Di el nombre de la capital del país con más esperanza de vida:**


-- 15. **Di el nombre de la capital del país con más población:**


-- 16. **Lista todos los países con más de 1 millón de habitantes con sus capitales y sus lenguas no oficiales:**


-- 17. **Cuántos idiomas tiene cada país:**


-- 18. **¿Tenemos algún país con dos lenguas oficiales? (hacer con `HAVING`)**


-- 19. **Saca el jefe de gobierno de un país cuya capital es Madrid:**


-----

-- ### **Creación de Vistas**

-- 1.  **Crea una vista con la media de habitantes (de las ciudades):**


-- 2.  **Crea una vista con la ciudad que tenga exactamente la media de habitantes:**


-- 3.  **Crea una vista con todas las provincias (Distritos) de España:**


-- 4.  **Crea una vista con todos los países con sus capitales y la lengua oficial:**


-- 5.  **Crea una vista con los países con más de 1 millón de habitantes con sus capitales y la lengua oficial:**
