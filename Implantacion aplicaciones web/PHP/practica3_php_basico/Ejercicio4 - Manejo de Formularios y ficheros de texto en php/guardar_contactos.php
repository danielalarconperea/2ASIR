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
        <h2>Datos Guardados</h2>

        <?php
        $archivo_agenda = "agenda.txt";

        $nombre = $_POST['nombre'];
        $trabajo = $_POST['trabajo'];
        $telefono = $_POST['telefono'];
        $direccion = $_POST['direccion'];
        $otras = $_POST['otras'];

        $linea = "$nombre|$trabajo|$telefono|$direccion|$otras" . PHP_EOL;

        if (!file_exists($archivo_agenda)) {
                fopen($archivo_agenda, 'w');
            }

        if (!empty($nombre)) {
            $file = fopen($archivo_agenda, 'r');
            if (!file_exists($archivo_agenda)) {
                fopen($archivo_agenda, 'w');
            }

            $file = fopen($archivo_agenda, 'a');
            fwrite($file, $linea);
            fclose($file);
            echo "<p>La información ha sido guardada en $archivo_agenda.</p>";
            
        }
        ?>
    </div>

</body>
</html>