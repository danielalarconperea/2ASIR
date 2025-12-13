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

-- -----------------------------------------------------
-- Inserción de datos en la tabla EQUIPOS
-- -----------------------------------------------------
INSERT INTO Equipos (id_equipo, nombre, estadio, aforo, ano_fundacion, ciudad) VALUES
(1, 'Real Madrid', 'Santiago Bernabeu', 80000, 1950, 'Madrid'),
(2, 'F.C. Barcelona', 'Camp Nou', 70000, 1948, 'Barcelona'),
(3, 'Valencia C.F', 'Mestalla', 90000, 1952, 'Valencia'),
(4, 'Atlético de Madrid', 'Vicente Calderón', 55000, 1945, 'Madrid'),
(5, 'Sevilla FC', 'Ramón Sánchez-Pizjuán', 43000, 1905, 'Sevilla');


-- -----------------------------------------------------
-- Inserción de datos en la tabla JUGADORES
-- -----------------------------------------------------
INSERT INTO Jugadores (id_jugador, nombre, fecha_nac, demarcacion, internacional, id_equipo) VALUES
(1, 'Iker', '1980-05-09', 'Portero', 50, 1),
(2, 'Ronaldo', '1974-07-07', 'Delantero', 80, 1),
(3, 'Ramos', '1998-09-09', 'Centrocampista', 75, 1),
(4, 'Neymar', '1999-03-03', 'Delantero', 50, 2);

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



drop database futbolasir;
create database futbolasir; 
use futbolasir;



select * from Equipos;