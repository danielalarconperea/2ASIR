-- PROCEDIMIENTOS ALMACENADOS 

-- Procedimiento 1: Crea un procedimiento llamado ListarClientesPorCiudad que reciba como parámetro el nombre de una ciudad y muestre todos los clientes que viven en esa ciudad. 

-- Ejemplo de llamada: CALL ListarClientesPorCiudad('Sevilla'); 

drop procedure if exists ListarClientesPorCiudad;

CREATE PROCEDURE ListarClientesPorCiudad(IN ciudad_in VARCHAR(100))
SELECT CONCAT(cl.nombre,' ',cl.apellido1) AS Nombre_Completo, cl.ciudad
FROM cliente cl 
WHERE cl.ciudad = ciudad_in;

CALL ListarClientesPorCiudad('Sevilla');
 

-- Procedimiento 2: Crea un procedimiento llamado MostrarPedidosRecientes que reciba un número N como parámetro y muestre los N pedidos más recientes ordenados por fecha descendente. 

-- Ejemplo de llamada: CALL MostrarPedidosRecientes(5); 

drop procedure if exists MostrarPedidosRecientes;

CREATE PROCEDURE MostrarPedidosRecientes(IN numero_pedidos INT)
SELECT p.id, p.fecha, p.id_cliente, p.total
FROM pedido p
ORDER BY fecha DESC
LIMIT numero_pedidos;

CALL MostrarPedidosRecientes(5);
 

-- Procedimiento 3: Crea un procedimiento llamado ActualizarTotalComprasCliente que reciba el ID de un cliente y recalcule su total de compras sumando todos sus pedidos. 

-- Ejemplo de llamada: CALL ActualizarTotalComprasCliente(1); 

drop procedure if exists ActualizarTotalComprasCliente;

CREATE PROCEDURE ActualizarTotalComprasCliente(IN idCliente INT)
SELECT CONCAT(cl.nombre, cl.apellido1) AS "Cliente", SUM(p.total) AS "Total en compras"
FROM pedido p
JOIN cliente cl ON p.id_cliente = cl.id
WHERE cl.id = idCliente
GROUP BY cl.id;

CALL ActualizarTotalComprasCliente(1);



-- Procedimiento 4: Crea un procedimiento llamado ListarComercialesConComision que muestre todos los comerciales con su comisión, pero solo aquellos cuya comisión sea mayor que un valor mínimo pasado como parámetro. 

-- Ejemplo de llamada: CALL ListarComercialesConComision(0.12); 

drop procedure if exists ListarComercialesConComision;

CREATE PROCEDURE ListarComercialesConComision(IN comision_minima FLOAT)
SELECT c.id, CONCAT(c.nombre,' ',c.apellido1) AS comercial, c.comisión
FROM comercial c
WHERE c.comisión > comision_minima;

CALL ListarComercialesConComision(0.12);


-- Procedimiento 5: Crea un procedimiento llamado InsertarNuevoComercial que reciba nombre, apellido1, apellido2 y comisión, e inserte un nuevo comercial en la tabla. 

-- Ejemplo de llamada: CALL InsertarNuevoComercial('Carlos', 'García', 'López', 0.10); 

drop procedure if exists InsertarNuevoComercial;

CREATE PROCEDURE InsertarNuevoComercial(
    IN nombre_in VARCHAR(100),
    IN apellido1_in VARCHAR(100),
    IN apellido2_in VARCHAR(100),
    IN comision_in FLOAT
)
INSERT INTO comercial (nombre, apellido1, apellido2, comisión)
VALUES (nombre_in, apellido1_in, apellido2_in, comision_in);

CALL InsertarNuevoComercial('Carlos', 'García', 'López', 0.10);

select * from comercial;

delete from comercial where nombre='Carlos' and apellido1='García' and apellido2='López';

-- FUNCIONES 

-- Función 1: Crea una función llamada TotalComprasCliente que reciba el ID de un cliente y devuelva la suma total de todos sus pedidos. 

-- Ejemplo de uso: SELECT TotalComprasCliente(1);

drop function if exists TotalComprasCliente;

SET GLOBAL log_bin_trust_function_creators = 1;

DELIMITER $$
CREATE FUNCTION TotalComprasCliente(idCliente INT)
RETURNS FLOAT
BEGIN
DECLARE compras_totales FLOAT;
SELECT  SUM(p.total) INTO compras_totales
FROM pedido p
WHERE p.id_cliente = idCliente
GROUP BY p.id_cliente;
RETURN compras_totales;
END $$

DELIMITER ;

SELECT TotalComprasCliente(1) AS Total_Compras_Cliente;


-- Función 2: Crea una función llamada NombreCompletoCliente que reciba el ID de un cliente y devuelva su nombre completo en formato "Nombre Apellido1 Apellido2". 

-- Ejemplo de uso: SELECT NombreCompletoCliente(1); 

drop function if exists NombreCompletoCliente;

SET GLOBAL log_bin_trust_function_creators = 1;

DELIMITER $$
CREATE FUNCTION NombreCompletoCliente(idCliente INT)
RETURNS VARCHAR(255)
BEGIN
DECLARE nombre_completo VARCHAR(255);
SELECT CONCAT(cl.nombre, ' ', cl.apellido1, ' ', cl.apellido2) INTO nombre_completo
FROM cliente cl
WHERE cl.id = idCliente;
RETURN nombre_completo;
END $$
DELIMITER ;

SELECT NombreCompletoCliente(1) AS Nombre_Completo;


-- Función 3: Crea una función llamada DiasDesdeUltimoPedido que reciba el ID de un cliente y devuelva cuántos días han pasado desde su último pedido hasta hoy. 

-- Ejemplo de uso: SELECT DiasDesdeUltimoPedido(2); 

drop function if exists DiasDesdeUltimoPedido;

SET GLOBAL log_bin_trust_function_creators = 1;

DELIMITER $$
CREATE FUNCTION DiasDesdeUltimoPedido(idCliente INT)
RETURNS INT
BEGIN
DECLARE dias_transcurridos INT;
SELECT DATEDIFF(CURDATE(), MAX(p.fecha)) INTO dias_transcurridos
FROM pedido p 
WHERE p.id_cliente = idCliente;
RETURN dias_transcurridos;
END $$
DELIMITER ;
SELECT DiasDesdeUltimoPedido(1) AS Dias_Desde_Ultimo_Pedido;

-- Otra forma de hacer la función 3 (mal hecha)

drop function if exists DiasDesdeUltimoPedido2;

SET GLOBAL log_bin_trust_function_creators = 1;

DELIMITER $$
CREATE FUNCTION DiasDesdeUltimoPedido2(idCliente INT)
RETURNS INT
BEGIN
DECLARE dias_transcurridos INT;
SELECT DATEDIFF(CURDATE(), MAX(p.fecha)) INTO dias_transcurridos
FROM pedido p 
WHERE id_cliente = idCliente
ORDER BY fecha
LIMIT 1;
RETURN dias_transcurridos;
END $$
DELIMITER ;

SELECT DiasDesdeUltimoPedido2(1);

-- Función 4: Crea una función llamada CategoriaClienteTexto que reciba el número de categoría y devuelva: 

-- "ALTA" si categoría >= 200 

-- "MEDIA" si categoría >= 100 

-- "BAJA" para el resto 

-- Ejemplo de uso: SELECT CategoriaClienteTexto(150); 

drop function if exists CategoriaClienteTexto;

SET GLOBAL log_bin_trust_function_creators = 1;
DELIMITER $$
CREATE FUNCTION CategoriaClienteTexto(categoria INT)
RETURNS VARCHAR(10)
BEGIN
DECLARE categoria_texto VARCHAR(10);
IF categoria >= 200 THEN
    SET categoria_texto = 'ALTA';
ELSEIF categoria >= 100 THEN
    SET categoria_texto = 'MEDIA';
ELSE
    SET categoria_texto = 'BAJA';
END IF;
RETURN categoria_texto;
END $$
DELIMITER ;
SELECT CategoriaClienteTexto(150) AS Categoria_Texto;

-- Otra forma de hacer la función 4

drop function if exists CategoriaClienteTexto2;

SET GLOBAL log_bin_trust_function_creators = 1;
DELIMITER $$
CREATE FUNCTION CategoriaClienteTexto2(categoria INT)
RETURNS VARCHAR(10)
BEGIN
DECLARE categoria_texto VARCHAR(10);
IF categoria >= 200 THEN
    RETURN 'ALTA';
ELSEIF categoria >= 100 THEN
    RETURN 'MEDIA';
ELSE
    RETURN 'BAJA';
END IF;
END $$
DELIMITER ;
SELECT CategoriaClienteTexto2(250) AS Categoria_Texto;




-- Función 5: Crea una función llamada ComisionEnPorcentaje que reciba el ID de un comercial y devuelva su comisión en formato porcentaje (ej: "15.50%"). 

-- Ejemplo de uso: SELECT ComisionEnPorcentaje(1); 

drop function if exists ComisionEnPorcentaje;

SET GLOBAL log_bin_trust_function_creators = 1;
DELIMITER $$
CREATE FUNCTION ComisionEnPorcentaje(idComercial INT)
RETURNS VARCHAR(10)
BEGIN
DECLARE comision_porcentaje VARCHAR(10);
SELECT CONCAT(ROUND(c.comisión * 100, 2), '%') INTO comision_porcentaje
FROM comercial c
WHERE c.id = idComercial;
RETURN comision_porcentaje;
END $$
DELIMITER ;
SELECT ComisionEnPorcentaje(1) AS Comision_Porcentaje;