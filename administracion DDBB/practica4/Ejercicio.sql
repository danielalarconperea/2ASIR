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

-- Creamos el usuario 'alumno' que puede conectarse desde cualquier host ('%')
CREATE USER 'alumno'@'%' IDENTIFIED BY 'tu_contraseña_segura';

-- Le damos todos los permisos sobre las tablas especificadas
GRANT ALL PRIVILEGES ON pruebas.alumno TO 'alumno'@'%';
GRANT ALL PRIVILEGES ON pruebas.cursa TO 'alumno'@'%';
GRANT ALL PRIVILEGES ON pruebas.modulo TO 'alumno'@'%';

-- Creamos el usuario 'profesor'
CREATE USER 'profesor'@'localhost' IDENTIFIED BY 'otra_contraseña';

-- Le damos únicamente permiso de lectura sobre todas las tablas de la BBDD 'pruebas'
GRANT SELECT ON pruebas.* TO 'profesor'@'localhost';

-- Creamos el usuario 'profesorasir'
CREATE USER 'profesorasir'@'localhost' IDENTIFIED BY 'pass_profesorasir';

-- Le damos los permisos de SELECT, INSERT y DELETE en toda la BBDD 'pruebas'
GRANT SELECT, INSERT, DELETE ON pruebas.* TO 'profesorasir'@'localhost';

-- Creamos el usuario 'adminasir'
CREATE USER 'adminasir'@'localhost' IDENTIFIED BY 'pass_adminasir';

-- Le damos todos los privilegios en todas las bases de datos
GRANT ALL PRIVILEGES ON *.* TO 'adminasir'@'localhost';
Importante: Por defecto, ALL PRIVILEGES no incluye el permiso GRANT OPTION.

-- Creamos el usuario 'superasir'
CREATE USER 'superasir'@'localhost' IDENTIFIED BY 'pass_superasir';

-- Le damos todos los privilegios en todas las bases de datos y la capacidad de otorgarlos
GRANT ALL PRIVILEGES ON *.* TO 'superasir'@'localhost' WITH GRANT OPTION;

-- Creamos el usuario 'ocasional'
CREATE USER 'ocasional'@'localhost' IDENTIFIED BY 'pass_ocasional';

-- Le damos permiso para hacer SELECT en todas las tablas de 'pruebas'
GRANT SELECT ON pruebas.* TO 'ocasional'@'localhost';

-- Cambiamos la contraseña para el usuario root en localhost
ALTER USER 'root'@'localhost' IDENTIFIED BY 'css99';
SET PASSWORD FOR root@localhost = 'css99';

-- Revocamos todos los privilegios al usuario
REVOKE ALL PRIVILEGES ON pruebas.* FROM 'profesorasir'@'localhost';

-- Para quitar todos los privilegios globales que pudiera tener
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'alumno'@'%';

-- Y quitamos los específicos de las tablas
REVOKE ALL PRIVILEGES ON pruebas.alumno FROM 'alumno'@'%';
REVOKE ALL PRIVILEGES ON pruebas.cursa FROM 'alumno'@'%';
REVOKE ALL PRIVILEGES ON pruebas.modulo FROM 'alumno'@'%';

SHOW GRANTS FOR 'alumno'@'%';