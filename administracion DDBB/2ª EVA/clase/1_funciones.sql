CREATE PROCEDURE personas()
    SELECT nombre, apellido1, apellido2 FROM cliente;
DROP PROCEDURE personas;

CREATE PROCEDURE CLIENTES()
    SELECT nombre, apellido1, apellido2 FROM cliente;

CALL CLIENTES();


CREATE PROCEDURE COMERCIAL()
    SELECT nombre, apellido1, apellido2 FROM comercial;

CALL COMERCIAL();

CREATE PROCEDURE PEDIDOS()
    SELECT id, total, fecha FROM pedido;
CALL PEDIDOS();

