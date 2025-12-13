<?php
$nombre_archivo = "noticia1.txt";
// Obtener contenido de archivo como cadena
$contenido = file_get_contents($nombre_archivo);
echo "El contenido es: " . $contenido;
?>
