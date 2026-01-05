<?php
/*
  php -v
  cd "C:\Users\dania\OneDrive - Salesianos Atocha\Escritorio\PROGRAM\2ASIR\Implantacion aplicaciones web\PHP y MySQL\practica1_libros"
  php -S localhost:8080 index.php
*/
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

// =============================================================
//               INICIO DE LA PARTE VISUAL (HTML/CSS)
// =============================================================
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <link rel="icon" type="image/x-icon" href="https://www.php.net/favicon.ico">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Explorador de Archivos PHP ✨</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <style>
        :root {
            --bg-color: #282c34; /* Gris muy oscuro */
            --text-color: #f8f8f2; /* Blanco suave */
            --link-color: #61afef; /* Azul claro */
            --hover-color: #98c379; /* Verde para hover */
            --border-color: #4b5263; /* Gris para bordes */
            --header-bg: #323842; /* Gris más oscuro para cabecera */
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--bg-color);
            color: var(--text-color);
            margin: 0;
            padding: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
        }
        .container {
            background-color: var(--header-bg);
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.5);
            padding: 30px 40px;
            width: 90%;
            max-width: 800px;
            margin-bottom: 20px;
            text-align: center;
        }
        header {
            margin-bottom: 30px;
        }
        header h1 {
            color: var(--link-color);
            font-size: 2.5em;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
        }
        header h1 .icon {
            font-size: 0.8em; /* Ajustar el tamaño del emoji/icono */
        }
        h2 {
            color: var(--text-color);
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 10px;
            margin-top: 20px;
            margin-bottom: 25px;
            font-size: 1.8em;
        }
        ul {
            list-style: none;
            padding: 0;
            text-align: left;
        }
        li {
            margin-bottom: 12px;
            border-bottom: 1px dashed var(--border-color);
            padding-bottom: 10px;
            display: flex;
            align-items: center;
        }
        li:last-child {
            border-bottom: none;
        }
        a {
            color: var(--link-color);
            text-decoration: none;
            font-size: 1.1em;
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 5px 0;
            width: 100%; /* Para que el área de clic sea más grande */
        }
        a:hover {
            color: var(--hover-color);
            transform: translateX(5px); /* Pequeño efecto visual al pasar el ratón */
            transition: all 0.2s ease-in-out;
        }
        .file-icon {
            width: 20px; /* Tamaño fijo para los iconos */
            text-align: center;
            color: var(--text-color); /* Color por defecto para iconos */
        }
        .file-icon.folder { color: #e5c07b; } /* Amarillo para carpetas */
        .file-icon.up { color: #c678dd; } /* Púrpura para subir */
        .file-icon.php { color: #a546d1; } /* Más púrpura para PHP */
        .file-icon.html { color: #e06c75; } /* Rojo para HTML */
        .file-icon.image { color: #56b6c2; } /* Verde azulado para imágenes */
        .file-icon.code { color: #abb2bf; } /* Gris claro para otros códigos */

        footer {
            margin-top: auto; /* Empuja el footer hacia abajo */
            padding-top: 20px;
            color: #636b77; /* Gris más claro para el footer */
            font-size: 0.9em;
        }
        .error-message {
            background-color: #e06c75; /* Rojo para errores */
            color: white;
            padding: 15px;
            border-radius: 5px;
            margin-top: 30px;
            font-size: 1.2em;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>
                <span class="icon">💻</span>
                Explorador de Archivos <span class="icon">📂</span>
            </h1>
        </header>
<?php
// =============================================================
//               FIN DE LA PARTE VISUAL (HTML/CSS)
// =============================================================

// 5. Si la ruta es un directorio (una carpeta), listamos su contenido
if (is_dir($fsPath)) {
    
    echo "<h2>Contenido de: " . htmlspecialchars($path) . "</h2>";
    echo "<ul>";

    // 6. Añadir un enlace para "subir" un nivel si no estamos en la raíz
    if ($path != '/') {
        // Usamos un enlace relativo simple '../' que significa "subir un nivel"
        // Esto evita el 'about:blank#blocked' que causan algunos bloqueadores/navegadores
        echo "<li><a href='../'><span class='file-icon up'><i class='fas fa-level-up-alt'></i></span> Subir</a></li>";
    }

    // 7. Escanear el directorio solicitado
    $archivos = scandir($fsPath);

    // Extensiones de imagen que queremos reconocer
    $imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'svg', 'webp', 'ico'];
    
    // Extensiones de otros archivos de código que queremos ver
    $codeExtensions = ['php', 'html', 'htm', 'css', 'js', 'json', 'xml', 'txt', 'md']; // Añadimos .txt y .md

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

        // Determinar el icono y la clase CSS
        $iconHtml = '';
        $iconClass = 'file-icon';

        if (is_dir($itemFsPath)) {
            $iconHtml = '<i class="fas fa-folder"></i>';
            $iconClass .= ' folder';
            $displayName = $archivo . '/'; // Añadir barra para carpetas
        } elseif (in_array($ext, $imageExtensions)) {
            $iconHtml = '<i class="fas fa-image"></i>';
            $iconClass .= ' image';
            $displayName = $archivo;
        } elseif ($ext === 'php') { // PHP tiene su propio icono
            $iconHtml = '<i class="fab fa-php"></i>';
            $iconClass .= ' php';
            $displayName = $archivo;
        } elseif (in_array($ext, $codeExtensions)) {
            $iconHtml = '<i class="fas fa-file-code"></i>';
            $iconClass .= ' code';
            $displayName = $archivo;
        } else {
            // Icono por defecto para otros archivos no especificados
            $iconHtml = '<i class="fas fa-file"></i>';
            $iconClass .= ' default';
            $displayName = $archivo;
        }
        
        // Mostrar el elemento de la lista
        echo "<li><a href='$linkPath'><span class='$iconClass'>$iconHtml</span> " . htmlspecialchars($displayName) . "</a></li>";
    }
    echo "</ul>";

} else {
    // 8. Si no es ni un archivo ni un directorio, es un 404
    http_response_code(404);
    echo "<div class='error-message'><h2>Error 404</h2><p>No se encontró el recurso: " . htmlspecialchars($path) . "</p><p>¡Oops! Parece que te has perdido. Intenta volver a la <a href='/' style='color: white; text-decoration: underline;'>página principal</a>.</p></div>";
}

?>
    </div>
    <footer>
        <p>&copy; <?php echo date("Y"); ?> Tonto el que lo lea / Explorador PHP. Todos los derechos reservados.</p>
    </footer>
</body>
</html>