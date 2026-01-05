<?php
$host = "localhost";
$user = "root";
$pass = "asdf";
$db = "biblioteca_escolar";

$conexion = @mysqli_connect($host, $user, $pass, $db);

if ($conexion) {
    mysqli_set_charset($conexion, "utf8mb4");

    // Obtener estudiantes para el select
    $res_est = mysqli_query($conexion, "SELECT id_estudiante, nombre, apellidos FROM Estudiantes ORDER BY apellidos, nombre");
    // Obtener libros para el select (solo los que estén disponibles, opcionalmente)
    $res_lib = mysqli_query($conexion, "SELECT id_libro, titulo FROM Libros WHERE disponible = 1 ORDER BY titulo");

    if (isset($_POST['agregar'])) {
        $id_estudiante = mysqli_real_escape_string($conexion, $_POST['id_estudiante']);
        $id_libro = mysqli_real_escape_string($conexion, $_POST['id_libro']);
        $fecha_prestamo = mysqli_real_escape_string($conexion, $_POST['fecha_prestamo']);
        $fecha_devolucion = mysqli_real_escape_string($conexion, $_POST['fecha_devolucion']);
        $devuelto = isset($_POST['devuelto']) ? 1 : 0;

        $consulta = "INSERT INTO Prestamos (id_estudiante, id_libro, fecha_prestamo, fecha_devolucion, devuelto) 
                         VALUES ($id_estudiante, $id_libro, '$fecha_prestamo', '$fecha_devolucion', $devuelto)";

        if (mysqli_query($conexion, $consulta)) {
            // Opcional: Marcar libro como no disponible al prestarlo si no estaba ya
            mysqli_query($conexion, "UPDATE Libros SET disponible = 0 WHERE id_libro = $id_libro");
            $msg_exito = "Préstamo registrado correctamente.";

            // Refrescar listas para el formulario si es necesario
            $res_lib = mysqli_query($conexion, "SELECT id_libro, titulo FROM Libros WHERE disponible = 1 ORDER BY titulo");
        } else {
            $msg_error = "Error al registrar: " . mysqli_error($conexion);
        }
    }
}
?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Biblioteca - Añadir Préstamo</title>
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
                <h2>Añadir Nuevo Préstamo</h2>
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

                <form action="prestamos_agregar.php" method="post">
                    <div class="form-group">
                        <label for="id_estudiante">Estudiante:</label>
                        <select name="id_estudiante" id="id_estudiante" required>
                            <option value="">-- Seleccionar Estudiante --</option>
                            <?php if ($res_est): ?>
                                <?php while ($est = mysqli_fetch_assoc($res_est)): ?>
                                    <option value="<?php echo $est['id_estudiante']; ?>">
                                        <?php echo $est['apellidos'] . ", " . $est['nombre']; ?>
                                    </option>
                                <?php endwhile; ?>
                            <?php endif; ?>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="id_libro">Libro (solo disponibles):</label>
                        <select name="id_libro" id="id_libro" required>
                            <option value="">-- Seleccionar Libro --</option>
                            <?php if ($res_lib): ?>
                                <?php while ($lib = mysqli_fetch_assoc($res_lib)): ?>
                                    <option value="<?php echo $lib['id_libro']; ?>">
                                        <?php echo $lib['titulo']; ?>
                                    </option>
                                <?php endwhile; ?>
                            <?php endif; ?>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="fecha_prestamo">Fecha de Préstamo:</label>
                        <input type="datetime-local" id="fecha_prestamo" name="fecha_prestamo" required
                            value="<?php echo date('Y-m-d\TH:i'); ?>">
                    </div>

                    <div class="form-group">
                        <label for="fecha_devolucion">Fecha Prevista Devolución:</label>
                        <input type="datetime-local" id="fecha_devolucion" name="fecha_devolucion" required
                            value="<?php echo date('Y-m-d\TH:i', strtotime('+15 days')); ?>">
                    </div>

                    <div class="form-group" style="flex-direction: row; align-items: center; gap: 10px;">
                        <input type="checkbox" id="devuelto" name="devuelto">
                        <label for="devuelto">¿Ya devuelto?</label>
                    </div>

                    <button type="submit" name="agregar">💾 Registrar Préstamo</button>
                </form>
            </section>
        </main>

        <footer>
            <p>Sistema de Gestión de Biblioteca Escolar &copy; 2025</p>
        </footer>
    </div>
</body>

</html>