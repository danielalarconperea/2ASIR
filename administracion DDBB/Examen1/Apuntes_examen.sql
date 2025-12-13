/*
================================================================================
== APUNTES COMPLETOS DE ADMINISTRACIÓN DE MYSQL (TEMAS 1-6) ==
================================================================================
*/

-- ##########################################################################
-- ### TEMA 1: INTRODUCCIÓN E INSTALACIÓN
-- ##########################################################################

/*
--- Conceptos Clave (Tema 1) ---
- DDL (Data Definition Language): Define la estructura.
  - CREATE
  - ALTER
  - DROP
- DML (Data Manipulation Language): Manipula los datos.
  - SELECT
  - INSERT
  - UPDATE
  - DELETE

--- Comandos de Instalación (Ejecutar en BASH, no en SQL) ---

-- (En Ubuntu/Debian) Actualizar e instalar el servidor
sudo apt update
sudo apt install mysql-server

-- Comprobar el estado del servicio
sudo systemctl status mysql

-- Iniciar el servicio
sudo systemctl start mysql

-- Ejecutar el script de seguridad
sudo mysql_secure_installation

-- Conectarse al servidor (desde BASH)
sudo mysql
mysql -u root -p
mysql -h nombre_host -u usuario -p
*/

-- Dentro del cliente MySQL, esto es lo primero que harías
SELECT '¡Conexión exitosa!' AS 'Estado';


-- ##########################################################################
-- ### TEMA 2: FUNCIONAMIENTO DEL SERVIDOR
-- ##########################################################################

-- --- Ver Estado y Variables del Servidor ---

-- Ver la actividad y contadores del servidor
SHOW STATUS;

-- Ver la configuración actual del servidor
SHOW VARIABLES;

-- --- Motores de Almacenamiento (Storage Engines) ---

-- Crear una tabla especificando el motor InnoDB (transaccional)
CREATE TABLE IF NOT EXISTS mi_tabla_innodb (
    id INT PRIMARY KEY,
    dato VARCHAR(100)
) ENGINE=InnoDB;

-- Crear una tabla especificando el motor MyISAM (rápido, no transaccional)
CREATE TABLE IF NOT EXISTS mi_tabla_myisam (
    id INT PRIMARY KEY,
    dato VARCHAR(100)
) ENGINE=MyISAM;

-- Crear una tabla en memoria (HEAP), muy rápida, datos volátiles
CREATE TABLE IF NOT EXISTS mi_tabla_memoria (
    id INT PRIMARY KEY,
    dato_temporal VARCHAR(100)
) ENGINE=MEMORY;

-- Cambiar el motor de una tabla existente
ALTER TABLE mi_tabla_myisam ENGINE=InnoDB;

-- --- Diccionario de Datos (INFORMATION_SCHEMA) ---

-- Ver todas las bases de datos (esquemas) en el servidor
SELECT schema_name FROM information_schema.schemata;

-- Ver todas las tablas, su tipo y motor en una BBDD específica
SELECT table_name, table_type, engine
FROM information_schema.tables
WHERE table_schema = 'mysql'
ORDER BY table_name;

-- Ver todas las columnas de una tabla específica
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = 'mysql' AND table_name = 'user';

-- Ver los privilegios globales de los usuarios
SELECT * FROM information_schema.user_privileges;

-- --- Comandos SHOW (Alternativa al Diccionario de Datos) ---
SHOW DATABASES;
SHOW TABLES FROM mysql;
SHOW COLUMNS FROM mysql.user;
SHOW TABLE STATUS WHERE Name = 'user';
SHOW CHARACTER SET;
SHOW COLLATION;
SHOW INDEX FROM mysql.user;

-- --- Logs (Gestión de Logs) ---
-- (La activación de logs se hace en el archivo my.cnf)

-- Rotar los logs binarios (crea un nuevo archivo)
FLUSH LOGS;


-- ##########################################################################
-- ### TEMA 3: ADMINISTRACIÓN BÁSICA (DDL, DML, VISTAS)
-- ##########################################################################

-- --- Gestión de Bases de Datos y Tablas (DDL) ---

-- Crear una base de datos
CREATE DATABASE IF NOT EXISTS mi_base_de_datos;

-- Seleccionar (usar) una base de datos
USE mi_base_de_datos;

-- Ver qué base de datos está seleccionada
SELECT DATABASE();

-- Crear una tabla
CREATE TABLE IF NOT EXISTS clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    fecha_registro DATE,
    departamento_id INT,
    CONSTRAINT fk_departamento
        FOREIGN KEY (departamento_id) REFERENCES departamentos(id)
);

-- Describir la estructura de una tabla
DESCRIBE clientes;
-- (Alternativa)
SHOW COLUMNS FROM clientes;

-- Borrar una tabla
DROP TABLE IF EXISTS clientes;

-- Borrar una base de datos
DROP DATABASE IF EXISTS mi_base_de_datos;

-- --- Manipulación de Datos (DML) ---

-- Insertar una fila
INSERT INTO clientes (nombre, email) VALUES ('Juan Perez', 'juan@correo.com');

-- Insertar varias filas
INSERT INTO clientes (nombre, email) VALUES
    ('Ana Lopez', 'ana@correo.com'),
    ('Luis Garcia', 'luis@correo.com');

-- Insertar datos desde otra consulta (ej: copiar alumnos buenos)
INSERT INTO alumnos_buenos (ape1, ape2, nombre, nota)
SELECT ape1, ape2, nombre, media
FROM alumnos
WHERE media >= 7.5;

-- Seleccionar datos (Consultas)
SELECT nombre, email FROM clientes WHERE id = 1;

-- Seleccionar valores únicos (DISTINCT)
SELECT DISTINCT departamento_id FROM clientes;

-- Actualizar (modificar) datos
UPDATE clientes
SET email = 'nuevo.email@correo.com'
WHERE id = 1;

-- Borrar datos
DELETE FROM clientes WHERE id = 1;

-- Borrar todas las filas de una tabla (más rápido que DELETE sin WHERE)
TRUNCATE TABLE clientes;

-- --- Transacciones ---
-- (Solo funciona con motores transaccionales como InnoDB)

-- Iniciar una transacción
BEGIN;

-- (Realizar operaciones DML)
INSERT INTO clientes (nombre, email) VALUES ('Cliente Temporal', 'temp@correo.com');
UPDATE clientes SET nombre = 'Nombre Cambiado' WHERE id = 2;

-- Deshacer los cambios de la transacción
ROLLBACK;

-- (Iniciar de nuevo)
BEGIN;
INSERT INTO clientes (nombre, email) VALUES ('Cliente Permanente', 'perm@correo.com');

-- Confirmar (hacer permanentes) los cambios
COMMIT;

-- --- Bloqueo de Tablas ---

-- Bloquear una tabla para LECTURA (otros pueden leer, pero no escribir)
LOCK TABLES clientes READ;

-- Bloquear una tabla para ESCRITURA (nadie más puede leer ni escribir)
LOCK TABLES clientes WRITE;

-- Desbloquear todas las tablas bloqueadas en la sesión actual
UNLOCK TABLES;

-- --- Joins (Combinar tablas) ---

-- JOIN Clásico (implícito)
SELECT emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- JOIN Moderno (explícito, preferido)
SELECT e.ename, d.dname
FROM emp e
INNER JOIN dept d ON e.deptno = d.deptno
WHERE d.loc IN ('DALLAS', 'NEW YORK');

-- LEFT JOIN (Mostrar todos de A, aunque no tengan B)
SELECT a.nombre, b.pedido
FROM clientes a
LEFT JOIN pedidos b ON a.id = b.cliente_id;

-- --- Subconsultas ---

-- Subconsulta en un WHERE (Ej: Salario mayor que Jones)
SELECT ename
FROM emp
WHERE sal > (
    SELECT sal
    FROM emp
    WHERE ename = 'JONES'
);

-- Subconsulta con [NOT] EXISTS (Comprueba si la subconsulta devuelve filas)