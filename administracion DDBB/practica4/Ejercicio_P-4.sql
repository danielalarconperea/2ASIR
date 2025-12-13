-- Creamos la base de datos
CREATE DATABASE pruebas;

-- Seleccionamos la base de datos para usarla
USE pruebas;

-- Creamos la tabla profesor
CREATE TABLE profesor (
    DNI VARCHAR(9) PRIMARY KEY,
    nombre VARCHAR(50),
    direccion VARCHAR(100),
    telefono VARCHAR(15)
);

-- Creamos la tabla alumno
CREATE TABLE alumno (
    expediente INT PRIMARY KEY,
    nombre VARCHAR(50),
    apellidos VARCHAR(100),
    fecha_de_nacimiento DATE
);

-- Creamos la tabla modulo
CREATE TABLE modulo (
    codigo INT PRIMARY KEY,
    nombre VARCHAR(100)
);

-- Creamos la tabla imparte (relación entre profesor y modulo)
CREATE TABLE imparte (
    DNI_profesor VARCHAR(9),
    codigo_modulo INT,
    PRIMARY KEY (DNI_profesor, codigo_modulo),
    FOREIGN KEY (DNI_profesor) REFERENCES profesor(DNI),
    FOREIGN KEY (codigo_modulo) REFERENCES modulo(codigo)
);

-- Creamos la tabla cursa (relación entre alumno y modulo)
CREATE TABLE cursa (
    expediente_alumno INT,
    codigo_modulo INT,
    PRIMARY KEY (expediente_alumno, codigo_modulo),
    FOREIGN KEY (expediente_alumno) REFERENCES alumno(expediente),
    FOREIGN KEY (codigo_modulo) REFERENCES modulo(codigo)
);

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