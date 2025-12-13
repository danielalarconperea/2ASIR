delimiter //

create procedure actualizar_cat(IN name varchar(100))
begin
 select * from cliente where nombre = name;
 update cliente set categoría = 500 where nombre = name;
 select * from cliente where nombre = name;
end
//
delimiter ;

call actualizar_cat("Adela");

select * from cliente;




delimiter $$
create procedure contar_clientes(OUT cuenta int)
begin
 select count(*) into cuenta from cliente;
end $$
delimiter ;

call contar_clientes(@num);
select @num;








DELIMITER //

CREATE PROCEDURE InsertarCliente(
 IN p_nombre VARCHAR(100),
 IN p_apellido1 VARCHAR(100),
 IN p_apellido2 VARCHAR(100),
 IN p_ciudad VARCHAR(100)
)
BEGIN
 INSERT INTO cliente (nombre, apellido1, apellido2, ciudad) 
 VALUES (p_nombre, p_apellido1, p_apellido2, p_ciudad);
END //

DELIMITER ;

CALL InsertarCliente('Carlos', 'Contreras', 'Garcia', 'Madrid');