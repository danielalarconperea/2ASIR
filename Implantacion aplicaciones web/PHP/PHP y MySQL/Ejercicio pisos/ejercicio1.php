<HTML LANG="es">
<HEAD>
<style>
        /* --- Reset y Estilos Generales --- */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f7f6;
            color: #333;
            margin: 0;
            padding: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
        }

        h1 {
            color: #2c3e50;
            text-transform: uppercase;
            letter-spacing: 2px;
            font-size: 24px;
            margin-bottom: 30px;
            border-bottom: 3px solid #009879;
            padding-bottom: 10px;
        }

        /* --- Estilos de la Tabla --- */
        .table-wrapper {
            width: 100%;
            max-width: 1000px;
            overflow-x: auto; /* Permite scroll lateral en móviles */
            box-shadow: 0 10px 25px rgba(0,0,0,0.1); /* Sombra suave */
            border-radius: 8px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background-color: #ffffff;
            border-radius: 8px;
            overflow: hidden; /* Para que el border-radius funcione en las esquinas */
        }

        th, td {
            padding: 15px 20px;
            text-align: left;
        }

        /* Cabecera de la tabla */
        th {
            background-color: #009879; /* Color principal (Verde azulado elegante) */
            color: #ffffff;
            font-weight: bold;
            text-transform: uppercase;
            font-size: 14px;
        }

        /* Filas de la tabla */
        tr {
            border-bottom: 1px solid #dddddd;
        }

        /* Efecto Zebra (filas alternas) */
        tr:nth-of-type(even) {
            background-color: #f3f3f3;
        }

        tr:last-of-type {
            border-bottom: 2px solid #009879;
        }

        /* Efecto Hover (al pasar el mouse) */
        tr:hover {
            background-color: #e9f7f5;
            color: #009879;
            cursor: default;
            transition: background-color 0.3s ease;
        }

        /* Mensaje de error o vacío */
        .no-data {
            padding: 20px;
            background-color: #fff3cd;
            color: #856404;
            border: 1px solid #ffeeba;
            border-radius: 5px;
        }

    </style>
</HEAD>

<BODY>

<H1>Consulta de noticias</H1>

<?PHP

   // Conectar con el servidor de base de datos
      $conexion = mysqli_connect ("localhost", "root", "rootroot")
         or die ("No se puede conectar con el servidor");
		 
   // Seleccionar base de datos
      mysqli_select_db ($conexion,"pisos")
         or die ("No se puede seleccionar la base de datos");
   // Enviar consulta
      $instruccion = "select * from noticias";
      $consulta = mysqli_query ($conexion,$instruccion)
         or die ("Fallo en la consulta");
   // Mostrar resultados de la consulta
      $nfilas = mysqli_num_rows ($consulta);
      if ($nfilas > 0)
      {
         print ("<TABLE>\n");
         print ("<TR>\n");
         print ("<TH>ID</TH>\n");
         print ("<TH>Titulo</TH>\n");
         print ("<TH>Texto</TH>\n");
         print ("<TH>Categoria</TH>\n");
         print ("<TH>Fecha</TH>\n");
        
         print ("</TR>\n");

         for ($i=0; $i<$nfilas; $i++)
         {
            $resultado = mysqli_fetch_array ($consulta);
            if($resultado['titulo'] == '' && $resultado['texto'] == '' && $resultado['categoria'] == '' && $resultado['fecha'] == ''){
               $eliminar = "DELETE FROM noticias WHERE id=".$resultado['id'];
               mysqli_query($conexion, $eliminar);
               continue;
            }
            print ("<TR>\n");
            print ("<TD>" . $resultado['id'] . "</TD>\n");
            print ("<TD>" . $resultado['titulo'] . "</TD>\n");
            print ("<TD>" . $resultado['texto'] . "</TD>\n");
            print ("<TD>" . $resultado['categoria'] . "</TD>\n");
            print ("<TD>" . $resultado['fecha'] . "</TD>\n");

            
            print ("</TR>\n");
         }

         print ("</TABLE>\n");
      }
      else
         print ("No hay noticias disponibles");

// Cerrar 
mysqli_close ($conexion);

?>

</BODY>
</HTML>
