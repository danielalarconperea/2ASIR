<?php
$host = "localhost";
$user = "root";
$pass = "asdf";
$db = "biblioteca_escolar";

// Intentar conectar con supresión de errores para manejo personalizado
$conexion = @mysqli_connect($host, $user, $pass, $db);

if (!$conexion) {
    $error_msg = mysqli_connect_error();
    if (strpos($error_msg, "undefined function") !== false || !function_exists('mysqli_connect')) {
        $error_detalle = "La extensión 'mysqli' no está habilitada en tu PHP. Revisa tu archivo php.ini.";
    } else {
        $error_detalle = "Error de conexión: " . $error_msg;
    }
} else {
    mysqli_set_charset($conexion, "utf8mb4");
    if (isset($_POST['buscar'])) {
        $titulo = mysqli_real_escape_string($conexion, trim(strtolower($_POST['titulo'])));
        $consulta = "SELECT * FROM Libros WHERE LOWER(titulo) LIKE '%$titulo%' OR LOWER(autor) LIKE '%$titulo%' OR LOWER(editorial) LIKE '%$titulo%' OR LOWER(isbn) LIKE '%$titulo%' OR LOWER(anio_publicacion) LIKE '%$titulo%'";
        $resultado = mysqli_query($conexion, $consulta);
    }
}

?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Biblioteca - Gestión de Libros</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/estilos.css">
</head>

<body>
    <div class="container">
        <header>
            <h1>📖 Gestión de Libros</h1>
            <nav class="main-menu">
                <a href="../index.html">Inicio</a>
                <a href="../libros/libros.html">Libros</a>
                <a href="../estudiantes/estudiantes.html">Estudiantes</a>
                <a href="../prestamos/prestamos.html">Préstamos</a>
            </nav>
        </header>

        <main>
            <nav class="submenu">
                <a href="libros.html">Inicio</a>
                <a href="libros_agregar.php">Añadir</a>
                <a href="libros_listar.php">Listar</a>
                <a href="libros_buscar.php">Buscar</a>
                <a href="libros_modificar.php">Modificar</a>
                <a href="libros_borrar.php">Borrar</a>
            </nav>

            <section class="content">
                <h2>Buscar Libros</h2>
                <form action="libros_buscar.php" method="post" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="titulo">Buscar:</label>
                        <input type="text" id="titulo" name="titulo"
                            placeholder="Ej: El Quijote, Miguel de Cervantes, 1605" required>
                    </div>
                    <button type="submit" name="buscar">Buscar</button>
                </form>

                <?php if (isset($resultado)): ?>
                    <div class="table-container" style="margin-top: 30px;">
                        <?php if (mysqli_num_rows($resultado) > 0): ?>
                            <?php while ($fila = mysqli_fetch_assoc($resultado)): ?>
                                <div class="tarjeta">
                                    <div class="portada">
                                        <?php if (!empty($fila['portada']) && file_exists("../portadas/" . $fila['portada'])): ?>
                                            <img src="../portadas/<?php echo $fila['portada']; ?>"
                                                alt="Portada de <?php echo $fila['titulo']; ?>">
                                        <?php else: ?>
                                            <div class="no-image" style="font-size: 4rem;">📚</div>
                                        <?php endif; ?>
                                    </div>
                                    <div class="info">
                                        <h3><?php echo $fila["titulo"]; ?></h3>
                                        <p><strong>Autor:</strong> <?php echo $fila["autor"]; ?></p>
                                        <p><strong>Editorial:</strong> <?php echo $fila["editorial"]; ?></p>
                                        <p><strong>ISBN:</strong> <?php echo $fila["isbn"]; ?></p>
                                        <p><strong>Año:</strong> <?php echo $fila["anio_publicacion"]; ?></p>
                                        <p><strong>Estado:</strong>
                                            <?php echo $fila["disponible"] ? '✅ Disponible' : '❌ No disponible'; ?></p>
                                    </div>
                                </div>
                            <?php endwhile; ?>
                        <?php else: ?>
                            <p style="text-align: center; color: #e06c75;">No se encontraron resultados para la búsqueda.</p>
                        <?php endif; ?>
                    </div>
                <?php endif; ?>
            </section>
        </main>

        <footer>
            <p>Sistema de Gestión de Biblioteca Escolar &copy; 2025</p>
        </footer>
    </div>
</body>

</html>