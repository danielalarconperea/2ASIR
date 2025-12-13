SET GLOBAL log_bin_trust_function_creators = 1;

DELIMITER $$
CREATE FUNCTION calcularBeneficio(nombre varchar(100))
RETURNS FLOAT
BEGIN
DECLARE beneficio FLOAT;

SELECT sum(total) into beneficio from pedido, cliente
WHERE pedido.id_cliente = cliente.id
AND cliente.nombre = nombre;

RETURN beneficio; -- retorna al programa
END$$
DELIMITER ;

SELECT calcularBeneficio("Aaron") AS beneficio;
SELECT calcularBeneficio("Adolfo") AS beneficio;

-- DROP FUNCTION calcularBeneficio;


