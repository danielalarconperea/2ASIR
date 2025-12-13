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
