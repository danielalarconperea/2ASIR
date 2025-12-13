-- sudo mysql -u root -p < clientes.sql

SHOW INDEXES FROM producto;

EXPLAIN SELECT * 
FROM producto 
WHERE codigo_producto = 'OR-114'; 

EXPLAIN SELECT * 
FROM producto 
WHERE nombre = 'Evonimus Pulchellus';


EXPLAIN SELECT AVG(total) 
FROM pago 
WHERE YEAR(fecha_pago) = 2008; 

EXPLAIN SELECT AVG(total) 
FROM pago 
WHERE fecha_pago >= '2008-01-01' AND fecha_pago <=  
'2008-12-31';

EXPLAIN SELECT * 
FROM cliente INNER JOIN pedido 
ON cliente.codigo_cliente = pedido.codigo_cliente 
WHERE cliente.nombre_cliente LIKE 'A%';

CREATE INDEX idx_cliente_nombre ON cliente (nombre_cliente);

EXPLAIN SELECT * 
FROM cliente INNER JOIN pedido 
ON cliente.codigo_cliente = pedido.codigo_cliente 
WHERE cliente.nombre_cliente LIKE 'A%';


CREATE INDEX idx_contacto_nombre_completo ON cliente (apellido_contacto, nombre_contacto);

EXPLAIN SELECT * 
FROM cliente 
WHERE apellido_contacto = 'Villar' 
AND nombre_contacto = 'Javier';

EXPLAIN SELECT * FROM cliente 
WHERE apellido_contacto = 'Villar';

EXPLAIN SELECT * FROM cliente 
WHERE nombre_contacto = 'Javier';