<?php
$nombreArchivo = "clase2.txt";
$mensaje = "Texto en el fichero";

// Abrir un fichero
$archivo = fopen($nombreArchivo, "a"); // w - write, a - append
if (!$archivo) {
    die("Error: No se pudo abrir el archivo.");
}

echo $archivo; // Esto imprime el ID del recurso, no es útil para ver contenido.

for ($i = 0; $i < 10; $i++) {
    fwrite($archivo, $mensaje . $i . "\n"); // Concatenación con . y salto de línea opcional
}

fclose($archivo); // Cierra el fichero.
?>
