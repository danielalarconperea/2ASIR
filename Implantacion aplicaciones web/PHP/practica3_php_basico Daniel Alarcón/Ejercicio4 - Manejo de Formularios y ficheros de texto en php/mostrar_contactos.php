<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Agenda - Ver Todos</title>
    <style>
        body { font-family: sans-serif; width: 800px; margin: 20px auto; }
        .contactos-lista { background-color: #f9f9f9; border: 1px solid #eee; padding: 10px; }
        nav { margin-bottom: 15px; }
    </style>
</head>
<body>
    <h1>Agenda Virtual PHP</h1>

    <nav>
        <a href="formulario.html">Añadir Contacto</a> | 
        <a href="mostrar_contactos.php">Ver Todos</a> | 
        <a href="buscar.html">Buscar</a>
    </nav>

    <div class="contactos-lista">
        <h2>Lista Completa de Contactos</h2>

        <?php

        $archivo_agenda = 'agenda.txt';
        if (!file_exists($archivo_agenda)) {
            echo "<p>No hay contactos en la agenda.</p>";
        } else {
            

            $file = fopen($archivo_agenda, "r");
            
            if ($file) {

                $contenido = file_get_contents($archivo_agenda);
                if (empty(trim($contenido))) {
                    echo "<p>La agenda está vacía.</p>";
                } else { 
                    echo "<pre>";
                    while (!feof($file)) {
                        $linea = fgets($file);
                        $datos = explode('|', $linea);

                            if (count($datos) >= 5) {
                                $nombre = $datos[0];
                                $trabajo = $datos[1];
                                $telefono = $datos[2];
                                $direccion = $datos[3];
                                $otras = $datos[4];

                                echo "<p><strong>Contacto:</strong> $nombre $trabajo $telefono $direccion $otras</p>";
                            }
                        }
                        fclose($file); 
                        echo "</pre>";
                }
            } else {
                echo "<p>Error: No se pudo abrir el archivo $archivo_agenda.</p>";
            }
        }
        ?>
    </div>

</body>
</html>