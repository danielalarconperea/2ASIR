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
        $busqueda = mysqli_real_escape_string($conexion, trim(strtolower($_POST['titulo'])));
        $consulta = "SELECT * FROM Libros WHERE LOWER(titulo) LIKE '%$busqueda%' OR LOWER(autor) LIKE '%$busqueda%' OR LOWER(editorial) LIKE '%$busqueda%' OR LOWER(isbn) LIKE '%$busqueda%' OR LOWER(anio_publicacion) LIKE '%$busqueda%'";
        $resultado_busqueda = mysqli_query($conexion, $consulta);
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
                <h2>Modificar Libros</h2>
                <form action="libros_modificar.php" method="post" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="titulo">Buscar:</label>
                        <input type="text" id="titulo" name="titulo"
                            placeholder="Ej: El Quijote, Miguel de Cervantes, 1605" required>
                    </div>
                    <button type="submit" name="buscar">Buscar</button>
                </form>

                <?php if (isset($msg_exito)): ?>
                    <p class="success-message"><?php echo $msg_exito; ?></p>
                <?php endif; ?>

                <?php if (isset($resultado_busqueda)): ?>
                    <div class="table-container" style="margin-top: 30px;">
                        <?php if (mysqli_num_rows($resultado_busqueda) > 0): ?>
                            <?php while ($fila = mysqli_fetch_assoc($resultado_busqueda)): ?>
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
                                        <form action="libros_modificar.php" method="post">
                                            <p><strong>ID Libro:</strong> <?php echo $fila["id_libro"]; ?>
                                            </p>
                                            <input type="hidden" name="id_libro" value="<?php echo $fila['id_libro']; ?>">
                                            <h3><input type="text" class="input-modificar" name="titulo"
                                                    value="<?php echo $fila["titulo"]; ?>"></h3>
                                            <p><strong>Autor:</strong>
                                                <input type="text" class="input-modificar" name="autor"
                                                    value="<?php echo $fila["autor"]; ?>">
                                            </p>
                                            <p><strong>Editorial:</strong>
                                                <input type="text" class="input-modificar" name="editorial"
                                                    value="<?php echo $fila["editorial"]; ?>">
                                            </p>
                                            <p><strong>ISBN:</strong>
                                                <input type="text" class="input-modificar" name="isbn" pattern="^(97[89])-\d{1,10}$"
                                                    title="Por favor, introduce un ISBN válido (Formato: 978-0000000000)"
                                                    value="<?php echo $fila["isbn"]; ?>">
                                            </p>
                                            <p><strong>Año:</strong>
                                                <input type="number" class="input-modificar" name="anio_publicacion"
                                                    value="<?php echo $fila["anio_publicacion"]; ?>">
                                            </p>
                                            <p><strong>Estado:</strong>
                                                <input type="text" class="input-modificar" name="disponible"
                                                    value="<?php echo $fila["disponible"] ? 'Disponible' : 'No disponible'; ?>">
                                            </p>
                                            <button type="submit" class="btn-modificar" name="modificar">Modificar</button>
                                        </form>
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

<?php
if (isset($_POST["modificar"])) {
    $id_libro = mysqli_real_escape_string($conexion, $_POST['id_libro']);
    $titulo = mysqli_real_escape_string($conexion, trim($_POST['titulo']));
    $autor = mysqli_real_escape_string($conexion, trim($_POST['autor']));
    $editorial = mysqli_real_escape_string($conexion, trim($_POST['editorial']));
    $isbn = mysqli_real_escape_string($conexion, trim($_POST['isbn']));
    $anio_publicacion = mysqli_real_escape_string($conexion, trim($_POST['anio_publicacion']));
    $disponible_texto = strtolower($_POST['disponible']);
    $disponible = (strpos($disponible_texto, "no") === false) ? 1 : 0;

    $consulta_upd = "UPDATE Libros SET titulo = '$titulo', autor = '$autor', editorial = '$editorial', isbn = '$isbn', anio_publicacion = '$anio_publicacion', disponible = $disponible WHERE id_libro = '$id_libro'";
    if (mysqli_query($conexion, $consulta_upd)) {
        echo "<p class='success-message' style='text-align:center;'>Libro actualizado correctamente.</p>";
    } else {
        echo "<p class='error-message' style='text-align:center;'>Error al actualizar: " . mysqli_error($conexion) . "</p>";
    }
}
?>