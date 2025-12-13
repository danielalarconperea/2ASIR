-- Crea un procedimiento almacenado que reciba como parámetro una ciudad y devuelva todos los pedidos realizados por clientes de esa ciudad.
-- El resultado debe incluir información del cliente, comercial y pedido.


delimiter //
CREATE PROCEDURE PEDIDOS_CIUDAD(IN ciudad_in VARCHAR(100))
BEGIN
 SELECT 
  CONCAT(cl.nombre," ", cl.apellido1) AS "cliente", 
  CONCAT(co.nombre," ",co.apellido1) AS "comercial",
  count(cl.nombre) AS "Pedidos_CIUDAD realizados" 
 FROM pedido p
 JOIN cliente cl ON cl.id = p.id_cliente
 JOIN comercial co ON  co.id = p.id_comercial
 WHERE cl.ciudad = ciudad_in
 GROUP BY cl.id, co.id;
END //

delimiter ;

call PEDIDOS_CIUDAD("Sevilla");

DROP PROCEDURE PEDIDOS_CIUDAD;







DELIMITER //

CREATE PROCEDURE BuscarPedidosPorCiudad(IN p_ciudad VARCHAR(100))
BEGIN
SELECT 
 p.id AS pedido_id, 
 p.total, 
 p.fecha, 
 c.nombre AS cliente_nombre,
 c.ciudad AS cliente_ciudad, 
 co.nombre AS comercial_nombre
FROM pedido p
INNER JOIN cliente c ON p.id_cliente = c.id
INNER JOIN comercial co ON p.id_comercial = co.id
WHERE c.ciudad = p_ciudad;
END //

DELIMITER ;

CALL BuscarPedidosPorCiudad('Sevilla');
CALL BuscarPedidosPorCiudad('Granada');


-- Crea un procedimiento almacenado que reciba dos fechas como parámetros (fecha inicio y fecha fin) y devuelva todos los comerciales que hayan realizado pedidos en ese período, junto con el total de ventas y la cantidad de pedidos realizados por cada comercial.

DELIMITER //
CREATE PROCEDURE ComercialesPorPeriodo(
 IN p_fecha_inicio DATE,
 IN p_fecha_fin DATE
)
BEGIN
 SELECT 
  co.id AS comercial_id,
  CONCAT(co.nombre, ' ', co.apellido1) AS comercial_nombre,
  COUNT(p.id) AS cantidad_pedidos,
  SUM(p.total) AS total_ventas
 FROM pedido p
 JOIN comercial co ON p.id_comercial = co.id
 WHERE p.fecha BETWEEN p_fecha_inicio AND p_fecha_fin
 GROUP BY co.id;
END //
DELIMITER ;
CALL ComercialesPorPeriodo('2023-01-01', '2023-12-31');

DROP PROCEDURE ComercialesPorPeriodo;
