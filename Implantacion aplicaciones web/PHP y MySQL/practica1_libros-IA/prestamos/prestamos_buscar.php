<?php
$host = "localhost";
$user = "root";
$pass = "asdf";
$db = "biblioteca_escolar";

$conexion = @mysqli_connect($host, $user, $pass, $db);

if ($conexion) {
    mysqli_set_charset($conexion, "utf8mb4");

    if (isset($_POST['buscar'])) {
        $busqueda = mysqli_real_escape_string($conexion, trim(strtolower($_POST['query'])));
        $consulta = "SELECT P.id_prestamo, L.titulo AS titulo_libro, E.nombre, E.apellidos, P.fecha_prestamo, P.fecha_devolucion, P.devuelto 
                         FROM Prestamos P
                         JOIN Libros L ON P.id_libro = L.id_libro
                         JOIN Estudiantes E ON P.id_estudiante = E.id_estudiante
                         WHERE LOWER(L.titulo) LIKE '%$busqueda%' 
                            OR LOWER(E.nombre) LIKE '%$busqueda%' 
                            OR LOWER(E.apellidos) LIKE '%$busqueda%'";
        $resultado_busqueda = mysqli_query($conexion, $consulta);
    }
}
?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Biblioteca - Buscar Préstamo</title>
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
                <h2>Buscar Préstamos</h2>
                <form action="prestamos_buscar.php" method="post">
                    <div class="form-group">
                        <label for="query">Buscar por libro o estudiante:</label>
                        <input type="text" id="query" name="query" placeholder="Título, nombre o apellido..." required>
                    </div>
                    <button type="submit" name="buscar">🔍 Buscar</button>
                </form>

                <?php if (isset($resultado_busqueda)): ?>
                    <div class="table-container" style="margin-top: 30px;">
                        <?php if (mysqli_num_rows($resultado_busqueda) > 0): ?>
                            <?php while ($fila = mysqli_fetch_assoc($resultado_busqueda)): ?>
                                <div class="tarjeta loan-card">
                                    <div class="info">
                                        <h3>📖
                                            <?php echo $fila["titulo_libro"]; ?>
                                        </h3>
                                        <p><strong>👤 Estudiante:</strong>
                                            <?php echo $fila["nombre"] . " " . $fila["apellidos"]; ?>
                                        </p>
                                        <p><strong>📅 Fecha Préstamo:</strong>
                                            <?php echo date("d/m/Y", strtotime($fila["fecha_prestamo"])); ?>
                                        </p>
                                        <p><strong>🕒 Devolución:</strong>
                                            <?php echo $fila["fecha_devolucion"] ? date("d/m/Y", strtotime($fila["fecha_devolucion"])) : 'Pendiente'; ?>
                                        </p>
                                        <p><strong>Estado:</strong>
                                            <?php echo $fila["devuelto"] ? '✅ Devuelto' : '❌ Pendiente'; ?>
                                        </p>
                                    </div>
                                </div>
                            <?php endwhile; ?>
                        <?php else: ?>
                            <p style="text-align: center; color: #e06c75;">No se encontraron préstamos para esa búsqueda.</p>
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