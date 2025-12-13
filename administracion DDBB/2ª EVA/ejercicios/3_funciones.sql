Crea una función que reciba el ID de un comercial y devuelva el total de comisiones que ha generado (suma de todos sus pedidos multiplicado por su porcentaje de comisión).




DELIMITER $$

CREATE FUNCTION CalcularComisionTotal(p_id_comercial INT)
RETURNS FLOAT
BEGIN
DECLARE total_comision FLOAT;

SELECT IFNULL(SUM(p.total * c.comisión), 0)
INTO total_comision
FROM comercial c
LEFT JOIN pedido p ON c.id = p.id_comercial
WHERE c.id = p_id_comercial
GROUP BY c.id;

RETURN total_comision;
END $$

DELIMITER ;

SELECT CalcularComisionTotal(1) AS comision_total;

-- DROP FUNCTION CalcularComisionTotal;






DELIMITER //

CREATE FUNCTION ContarPedidosCliente(cliente_id INT)
RETURNS INT
BEGIN
DECLARE total_pedidos INT;

SELECT COUNT(*) INTO total_pedidos
FROM pedido
WHERE id_cliente = cliente_id;

RETURN total_pedidos;
END //

DELIMITER ;

SELECT ContarPedidosCliente(2);

-- DROP FUNCTION ContarPedidosCliente;







DELIMITER //
CREATE FUNCTION NombreCompletoCliente(cliente_id INT)
RETURNS VARCHAR(300)
BEGIN
DECLARE nombre_completo VARCHAR(300);

SELECT CONCAT(nombre, ' ', apellido1, ' ', IFNULL(apellido2, '')) INTO nombre_completo
FROM cliente
WHERE id = cliente_id;

RETURN TRIM(nombre_completo);  
END //

DELIMITER ;

SELECT NombreCompletoCliente(1);

-- DROP FUNCTION NombreCompletoCliente;