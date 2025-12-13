--1
SELECT c.nombre_cliente, e.nombre AS 'nombre de su representante en ventas', e.apellido1 AS 'apellido de su representante en ventas' FROM cliente c
JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado;
--2
SELECT p.codigo_pedido, p.fecha_entrega, c.nombre_cliente FROM pedido p
JOIN cliente c ON p.codigo_cliente = p.codigo_cliente
WHERE p.estado = 'Entregado';
--3
CREATE VIEW Productos_Mas_Vendidos AS
SELECT p.nombre, sum(d.cantidad) AS 'Cantidad total vendida' FROM detalle_pedido d
JOIN producto p ON d.codigo_producto = p.codigo_producto
GROUP BY d.codigo_producto
ORDER BY sum(d.cantidad) DESC
LIMIT 5;
--4
CREATE USER usuario_consulta@localhost IDENTIFIED BY '123456';
--5
GRANT SELECT ON empresa.producto TO usuario_consulta@localhost;
--6
REVOKE SELECT ON empresa.producto FROM usuario_consulta@localhost;
--7
sudo mysqldump -u root -p empresa cliente > backup_cliente.sql
--8
SHOW grants FOR usuario_consulta@localhost;
--9
select * from sys.version;
--10
EXPLAIN SELECT * FROM pedido p
JOIN cliente c ON p.codigo_cliente = c.codigo_cliente
WHERE p.estado = 'Entregado';