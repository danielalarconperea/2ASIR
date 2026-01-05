<?php
$host = "localhost";
$user = "root";
$pass = "asdf";
$db = "biblioteca_escolar";

$conexion = @mysqli_connect($host, $user, $pass, $db);

if ($conexion) {
    mysqli_set_charset($conexion, "utf8mb4");
}

if ($conexion && isset($_POST['id_a_borrar'])) {
    $id_a_borrar = mysqli_real_escape_string($conexion, $_POST['id_a_borrar']);
    $consulta = "DELETE FROM Estudiantes WHERE id_estudiante = $id_a_borrar";
    if (mysqli_query($conexion, $consulta)) {
        $msg_exito = "Estudiante eliminado correctamente.";
    } else {
        $msg_error = "Error al eliminar: " . mysqli_error($conexion);
    }
}

if ($conexion) {
    $consulta = "SELECT * FROM Estudiantes";
    $resultado = mysqli_query($conexion, $consulta);
}
?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Biblioteca - Borrar Estudiante</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/estilos.css">
</head>

<body>
    <div class="container">
        <header>
            <h1>👨‍🎓 Gestión de Estudiantes</h1>
            <nav class="main-menu">
                <a href="../index.html">Inicio</a>
                <a href="../libros/libros.html">Libros</a>
                <a href="../estudiantes/estudiantes.html">Estudiantes</a>
                <a href="../prestamos/prestamos.html">Préstamos</a>
            </nav>
        </header>

        <main>
            <nav class="submenu">
                <a href="estudiantes.html">Inicio</a>
                <a href="estudiantes_agregar.php">Añadir</a>
                <a href="estudiantes_listar.php">Listar</a>
                <a href="estudiantes_buscar.php">Buscar</a>
                <a href="estudiantes_modificar.php">Modificar</a>
                <a href="estudiantes_borrar.php">Borrar</a>
            </nav>

            <section class="content">
                <h2>Borrar Estudiantes</h2>
                <?php if (isset($msg_exito)): ?>
                    <p class="success-message">
                        <?php echo $msg_exito; ?>
                    </p>
                <?php endif; ?>
                <?php if (isset($msg_error)): ?>
                    <p class="error-message">
                        <?php echo $msg_error; ?>
                    </p>
                <?php endif; ?>

                <div class="table-container">
                    <?php if (isset($resultado) && mysqli_num_rows($resultado) > 0): ?>
                        <?php while ($fila = mysqli_fetch_assoc($resultado)): ?>
                            <div class="tarjeta student-card">
                                <div class="info">
                                    <h3>
                                        <?php echo $fila["nombre"] . " " . $fila["apellidos"]; ?>
                                    </h3>
                                    <p><strong>Código:</strong>
                                        <?php echo $fila["codigo_estudiante"]; ?>
                                    </p>
                                    <p><strong>Curso:</strong>
                                        <?php echo $fila["curso"]; ?>
                                    </p>
                                </div>
                                <form action="estudiantes_borrar.php" method="post" style="margin-top: 15px;">
                                    <input type="hidden" name="id_a_borrar" value="<?php echo $fila['id_estudiante']; ?>">
                                    <button type="submit" class="btn-borrar"
                                        onclick="return confirm('¿Estás seguro de que quieres eliminar a este estudiante?');">Borrar</button>
                                </form>
                            </div>
                        <?php endwhile; ?>
                    <?php else: ?>
                        <p>No hay estudiantes registrados.</p>
                    <?php endif; ?>
                </div>
            </section>
        </main>

        <footer>
            <p>Sistema de Gestión de Biblioteca Escolar &copy; 2025</p>
        </footer>
    </div>
</body>

</html>