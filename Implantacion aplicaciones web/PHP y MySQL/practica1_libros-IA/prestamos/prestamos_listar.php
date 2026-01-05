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
    $consulta = "SELECT P.id_prestamo, L.titulo AS titulo_libro, E.nombre, E.apellidos, P.fecha_prestamo, P.fecha_devolucion, P.devuelto 
                     FROM Prestamos P
                     JOIN Libros L ON P.id_libro = L.id_libro
                     JOIN Estudiantes E ON P.id_estudiante = E.id_estudiante";
    $resultado = mysqli_query($conexion, $consulta);
}
?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Biblioteca - Listado de Préstamos</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/estilos.css">
</head>

<body>
    <div class="container">
        <header>
            <h1>📅 Gestión de Préstamos</h1>
            <nav class="main-menu">
                <a href="../index.html">Inicio</a>
                <a href="../libros/libros.html">Libros</a>
                <a href="../estudiantes/estudiantes.html">Estudiantes</a>
                <a href="../prestamos/prestamos.html">Préstamos</a>
            </nav>
        </header>

        <main>
            <nav class="submenu">
                <a href="prestamos.html">Inicio</a>
                <a href="prestamos_agregar.php">Añadir</a>
                <a href="prestamos_listar.php">Listar</a>
                <a href="prestamos_buscar.php">Buscar</a>
                <a href="prestamos_modificar.php">Modificar</a>
                <a href="prestamos_borrar.php">Borrar</a>
            </nav>

            <section class="content">
                <h2>Listado de Préstamos</h2>
                <div class="table-container">
                    <?php if (isset($error_detalle)): ?>
                        <div class="error-message">
                            <?php echo $error_detalle; ?>
                        </div>
                    <?php elseif (isset($resultado) && mysqli_num_rows($resultado) > 0): ?>
                        <?php while ($fila = mysqli_fetch_assoc($resultado)): ?>
                            <div class="tarjeta loan-card">
                                <div class="info">
                                    <h3>📖
                                        <?php echo $fila["titulo_libro"]; ?>
                                    </h3>
                                    <p><strong>👤 Estudiante:</strong>
                                        <?php echo $fila["nombre"] . " " . $fila["apellidos"]; ?>
                                    </p>
                                    <p><strong>📅 Fecha Préstamo:</strong>
                                        <?php echo date("d/m/Y H:i", strtotime($fila["fecha_prestamo"])); ?>
                                    </p>
                                    <p><strong>🕒 Fecha Devolución:</strong>
                                        <?php echo $fila["fecha_devolucion"] ? date("d/m/Y H:i", strtotime($fila["fecha_devolucion"])) : 'Pendiente'; ?>
                                    </p>
                                    <p><strong>Estado:</strong>
                                        <?php echo $fila["devuelto"] ? '✅ Devuelto' : '❌ Pendiente'; ?>
                                    </p>
                                </div>
                            </div>
                        <?php endwhile; ?>
                    <?php else: ?>
                        <p>No hay préstamos registrados.</p>
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