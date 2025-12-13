<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Contenido de datos.txt</title>
    <style>
        body { font-family: sans-serif; }
        pre { 
            background-color: #f4f4f4; 
            border: 1px solid #ccc; 
            padding: 10px; 
            white-space: pre-wrap;
        }
    </style>
</head>
<body>

    <h1>Contenido del archivo datos.txt</h1>

    <?php
    $archivo = "datos.txt";

    if (file_exists($archivo)) {
        
        $file = fopen($archivo, "r");
        
        if ($file) {
            echo "<pre>";
            while (!feof($file)) {
                $linea = fgets($file);
                echo "$linea";
            }
            fclose($file);
            echo "</pre>";
        } else {
            echo "<p>Error: No se pudo abrir el archivo $archivo.</p>";
        }

    } else {
        echo "<p>El archivo $archivo todavía no existe. Rellena el formulario primero.</p>";
    }

    ?>

    <br>
    <a href="alumno.html">Volver al formulario</a>

</body>
</html>