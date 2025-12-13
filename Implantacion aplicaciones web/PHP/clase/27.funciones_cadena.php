<?php
$nombreBuscado = $_POST['nombre'];
$archivo = 'correos.txt';
$file = fopen($archivo, 'r');
$encontrado = false; // si no está en false

while (!feof($file)) {
    $linea = trim(fgets($file));

    if (!empty($linea)) {
        // Buscar el patrón "nombre:correo"
        $partes = explode(':', $linea);
        
        // Aplicamos trim al nombre del archivo para asegurar la limpieza
        $nombre_archivo = trim($partes[0]);
        $correo_archivo = trim($partes[1]);

        if (strcmp($nombreBuscado, $nombre_archivo) === 0) {
            echo "<h2>¡Correo Encontrado!</h2>";
            echo "Nombre: " . $nombre_archivo . "<br>";
            echo "Correo: " . $correo_archivo . "<br>";
            
            $encontrado = true;
            break;
        }
    }
}

fclose($file);

if (!$encontrado) {
    // Si no se encontró en el bucle
    echo "No se encontró ningún correo para el nombre " . htmlspecialchars($nombreBuscado) . ".";
}
?>