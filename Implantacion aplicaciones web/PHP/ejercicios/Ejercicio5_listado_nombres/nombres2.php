<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
<?php
$nombre = $_REQUEST['nombre'];
$fichero = "nombres.txt";
$esta = false;
// Verificar si el archivo existe antes de abrirlo
if (file_exists($fichero)) {
    $fd = fopen($fichero, "r"); // Modo r, read
    while (!feof($fd)) {   // feof: end of file
        $linea = fgets($fd); // lee línea
        if ($linea != false) {
            // Eliminar espacios y saltos de línea
            if (trim(strtolower($linea)) == trim(strtolower($nombre))) {
                $esta = true;
                break; // Salir del bucle si encontramos el nombre
            }
        }
    }
    fclose($fd);
}
if ($esta == true) {
    echo "Está en el fichero";
} else {
    echo "NO!!!!!!!!!!";
}
?>
</body>
</html>