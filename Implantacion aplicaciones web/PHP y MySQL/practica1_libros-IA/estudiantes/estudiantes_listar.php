<?php
$host = "localhost";
$user = "root";
$pass = "asdf";
$db = "biblioteca_escolar";

$conexion = @mysqli_connect($host, $user, $pass, $db);

if (!$conexion) {
    $error_detalle = "Error de conexión: " . mysqli_connect_error();
} else {
    mysqli_set_charset($conexion, "utf8mb4");
    $consulta = "SELECT * FROM Estudiantes";
    $resultado = mysqli_query($conexion, $consulta);
}
?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Biblioteca - Gestión de Estudiantes</title>
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
                <h2>Listado de Estudiantes</h2>
                <div class="table-container">
                    <?php if (isset($error_detalle)): ?>
                        <div class="error-message">
                            <?php echo $error_detalle; ?>
                        </div>
                    <?php elseif (isset($resultado) && mysqli_num_rows($resultado) > 0): ?>
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
                                    <p><strong>Teléfono:</strong>
                                        <?php echo $fila["telefono"]; ?>
                                    </p>
                                </div>
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