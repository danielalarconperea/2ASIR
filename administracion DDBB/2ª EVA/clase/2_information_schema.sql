CREATE PROCEDURE RUTINAS_VENTAS2()
    SELECT routine_name
    FROM information_schema.routines
    WHERE routine_type='PROCEDURE'
      AND routine_schema='ventas2';
CALL RUTINAS_VENTAS2();