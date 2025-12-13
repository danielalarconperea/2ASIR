<?php
// php -v
// cd "C:\Users\dania\OneDrive - Salesianos Atocha\Escritorio\PROGRAM\2ASIR\IAW\PHP"
// php -S localhost:8080 index.php

/**
 * Función para normalizar la ruta (limpiar los '.' y '..')
 */
function normalizePath($path) {
    $parts = [];
    $path = str_replace('\\', '/', $path); // Normalizar slashes a /
    $path = preg_replace('/\/+/', '/', $path); // Quitar slashes duplicados

    foreach (explode('/', $path) as $part) {
        if (empty($part) || $part === '.') {
            continue; // Ignorar partes vacías o .
        }

        if ($part === '..') {
            array_pop($parts); // Subir un nivel
        } else {
            $parts[] = $part; // Bajar un nivel
        }
    }

    // Volver a unir y añadir el / inicial
    return '/' . implode('/', $parts);
}

// 1. Obtener la ruta que pide el navegador
$path = urldecode(parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH));

// 2. Normalizar la ruta
$path = normalizePath($path);

// 3. Convertirla a una ruta real del disco
$fsPath = __DIR__ . $path;

// 4. Si la ruta es un archivo real (y no este mismo script)
//    Esto servirá .php, .html, .jpg, .css, etc.
if (is_file($fsPath) && $fsPath != __FILE__) {
    return false; // El servidor ejecuta/sirve el archivo y se detiene aquí.
}

// 5. Si la ruta es un directorio (una carpeta), listamos su contenido
if (is_dir($fsPath)) {
    
    echo "<h1>Mostrando Carpeta: $path</h1>";
    echo "<ul>";

    // 6. Añadir un enlace para "subir" un nivel si no estamos en la raíz
    if ($path != '/') {
        $parent = dirname($path);
        // Asegurarse de que el enlace padre termine en /
        $parent = rtrim($parent, '/') . '/'; 
        echo "<li><a href='$parent'>⬆️ (Subir)</a></li>";
    }

    // 7. Escanear el directorio solicitado
    $archivos = scandir($fsPath);

    // ===============================================
    //               INICIO DEL CAMBIO
    // ===============================================

    // Extensiones de imagen que queremos reconocer
    $imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'svg', 'webp', 'ico'];
    
    // Extensiones de otros archivos de código que queremos ver
    $codeExtensions = ['php', 'html', 'htm', 'css', 'js', 'json', 'xml'];

    foreach ($archivos as $archivo) {
        // Omitir los directorios '.' y '..' y este mismo archivo
        if ($archivo == '.' || $archivo == '..' || ($fsPath == __DIR__ && $archivo == 'index.php') ) {
            continue;
        }

        // Construir la ruta de enlace (URL) y la ruta del disco
        $linkPath = rtrim($path, '/') . '/' . $archivo;
        $itemFsPath = rtrim($fsPath, '/') . '/' . $archivo;
        
        // Obtener extensión del archivo
        $ext = strtolower(pathinfo($itemFsPath, PATHINFO_EXTENSION));

        // Comprobar si es un directorio
        if (is_dir($itemFsPath)) {
            echo "<li><a href='$linkPath/'>📁 $archivo/</a></li>";
        
        // Comprobar si es una imagen
        } elseif (in_array($ext, $imageExtensions)) {
            echo "<li><a href='$linkPath'>🖼️ $archivo</a></li>";
        
        // Comprobar si es un archivo de código
        } elseif (in_array($ext, $codeExtensions)) {
            echo "<li><a href='$linkPath'>📄 $archivo</a></li>";
        }
        // (Otros archivos, como .txt, etc., no se listarán)
    }

    // ===============================================
    //                FIN DEL CAMBIO
    // ===============================================

    echo "</ul>";

} else {
    // 8. Si no es ni un archivo ni un directorio, es un 404
    http_response_code(404);
    echo "Error 404: No se encontró '$path'";
}

?>