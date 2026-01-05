<?php
$host = "localhost";
$user = "root";
$pass = "asdf";
$db = "biblioteca_escolar";

$conexion = @mysqli_connect($host, $user, $pass, $db);

if ($conexion) {
    mysqli_set_charset($conexion, "utf8mb4");

    if (isset($_POST['buscar_pr'])) {
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

    if (isset($_POST['modificar'])) {
        $id_prestamo = mysqli_real_escape_string($conexion, $_POST['id_prestamo']);
        $fecha_prestamo = mysqli_real_escape_string($conexion, $_POST['fecha_prestamo']);
        $fecha_devolucion = mysqli_real_escape_string($conexion, $_POST['fecha_devolucion']);
        $devuelto = isset($_POST['devuelto']) ? 1 : 0;

        $consulta_upd = "UPDATE Prestamos SET 
                             fecha_prestamo = '$fecha_prestamo', 
                             fecha_devolucion = '$fecha_devolucion', 
                             devuelto = $devuelto 
                             WHERE id_prestamo = $id_prestamo";

        if (mysqli_query($conexion, $consulta_upd)) {
            $msg_exito = "Préstamo actualizado correctamente.";
            // Si se marca como devuelto, podríamos volver a poner el libro en disponible
            if ($devuelto == 1) {
                $res_loan = mysqli_query($conexion, "SELECT id_libro FROM Prestamos WHERE id_prestamo = $id_prestamo");
                $loan_data = mysqli_fetch_assoc($res_loan);
                $id_lib = $loan_data['id_libro'];
                mysqli_query($conexion, "UPDATE Libros SET disponible = 1 WHERE id_libro = $id_lib");
            }
        } else {
            $msg_error = "Error al actualizar: " . mysqli_error($conexion);
        }
    }
}
?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Biblioteca - Modificar Préstamo</title>
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
                <h2>Modificar Préstamos</h2>
                <form action="prestamos_modificar.php" method="post">
                    <div class="form-group">
                        <label for="query">Buscar préstamo a modificar:</label>
                        <input type="text" id="query" name="query" placeholder="Libro o estudiante..." required>
                    </div>
                    <button type="submit" name="buscar_pr">🔍 Buscar</button>
                </form>

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

                <?php if (isset($resultado_busqueda)): ?>
                    <div class="table-container" style="margin-top: 30px;">
                        <?php if (mysqli_num_rows($resultado_busqueda) > 0): ?>
                            <?php while ($fila = mysqli_fetch_assoc($resultado_busqueda)): ?>
                                <div class="tarjeta loan-card" style="padding: 20px;">
                                    <form action="prestamos_modificar.php" method="post" style="max-width: 100%; margin: 0;">
                                        <input type="hidden" name="id_prestamo" value="<?php echo $fila['id_prestamo']; ?>">
                                        <h3>📖
                                            <?php echo $fila["titulo_libro"]; ?>
                                        </h3>
                                        <p>👤 <strong>Estudiante:</strong>
                                            <?php echo $fila["nombre"] . " " . $fila["apellidos"]; ?>
                                        </p>

                                        <div class="form-group">
                                            <label>Fecha Préstamo:</label>
                                            <input type="datetime-local" name="fecha_prestamo"
                                                value="<?php echo date('Y-m-d\TH:i', strtotime($fila['fecha_prestamo'])); ?>"
                                                required>
                                        </div>

                                        <div class="form-group">
                                            <label>Fecha Devolución:</label>
                                            <input type="datetime-local" name="fecha_devolucion"
                                                value="<?php echo $fila['fecha_devolucion'] ? date('Y-m-d\TH:i', strtotime($fila['fecha_devolucion'])) : ''; ?>"
                                                required>
                                        </div>

                                        <div class="form-group" style="flex-direction: row; align-items: center; gap: 10px;">
                                            <input type="checkbox" id="devuelto_<?php echo $fila['id_prestamo']; ?>" name="devuelto"
                                                <?php echo $fila['devuelto'] ? 'checked' : ''; ?>>
                                            <label for="devuelto_<?php echo $fila['id_prestamo']; ?>">¿Devuelto?</label>
                                        </div>

                                        <button type="submit" name="modificar" style="width: 100%;">💾 Guardar Cambios</button>
                                    </form>
                                </div>
                            <?php endwhile; ?>
                        <?php else: ?>
                            <p style="text-align: center; color: #e06c75;">No se encontraron resultados.</p>
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