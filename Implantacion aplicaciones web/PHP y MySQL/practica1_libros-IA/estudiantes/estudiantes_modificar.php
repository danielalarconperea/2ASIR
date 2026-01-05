<?php
$host = "localhost";
$user = "root";
$pass = "asdf";
$db = "biblioteca_escolar";

$conexion = @mysqli_connect($host, $user, $pass, $db);

if ($conexion) {
    mysqli_set_charset($conexion, "utf8mb4");

    if (isset($_POST['buscar_est'])) {
        $busqueda = mysqli_real_escape_string($conexion, trim(strtolower($_POST['query'])));
        $consulta = "SELECT * FROM Estudiantes WHERE LOWER(nombre) LIKE '%$busqueda%' OR LOWER(apellidos) LIKE '%$busqueda%' OR LOWER(codigo_estudiante) LIKE '%$busqueda%'";
        $resultado_busqueda = mysqli_query($conexion, $consulta);
    }

    if (isset($_POST['modificar'])) {
        $id_estudiante = mysqli_real_escape_string($conexion, $_POST['id_estudiante']);
        $nombre = mysqli_real_escape_string($conexion, trim($_POST['nombre']));
        $apellidos = mysqli_real_escape_string($conexion, trim($_POST['apellidos']));
        $codigo = mysqli_real_escape_string($conexion, trim($_POST['codigo_estudiante']));
        $curso = mysqli_real_escape_string($conexion, trim($_POST['curso']));
        $telefono = mysqli_real_escape_string($conexion, trim($_POST['telefono']));

        $consulta_upd = "UPDATE Estudiantes SET nombre = '$nombre', apellidos = '$apellidos', codigo_estudiante = '$codigo', curso = '$curso', telefono = '$telefono' WHERE id_estudiante = '$id_estudiante'";
        if (mysqli_query($conexion, $consulta_upd)) {
            $msg_exito = "Estudiante actualizado correctamente.";
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
    <title>Biblioteca - Modificar Estudiante</title>
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
                <h2>Modificar Estudiantes</h2>
                <form action="estudiantes_modificar.php" method="post">
                    <div class="form-group">
                        <label for="query">Buscar:</label>
                        <input type="text" id="query" name="query" placeholder="Nombre, apellido o código..." required>
                    </div>
                    <button type="submit" name="buscar_est">Buscar</button>
                </form>

                <?php if (isset($msg_exito)): ?>
                    <p class="success-message" style="text-align: center;">
                        <?php echo $msg_exito; ?>
                    </p>
                <?php endif; ?>
                <?php if (isset($msg_error)): ?>
                    <p class="error-message" style="text-align: center;">
                        <?php echo $msg_error; ?>
                    </p>
                <?php endif; ?>

                <?php if (isset($resultado_busqueda)): ?>
                    <div class="table-container" style="margin-top: 30px;">
                        <?php if (mysqli_num_rows($resultado_busqueda) > 0): ?>
                            <?php while ($fila = mysqli_fetch_assoc($resultado_busqueda)): ?>
                                <div class="tarjeta student-card">
                                    <div class="info">
                                        <form action="estudiantes_modificar.php" method="post">
                                            <input type="hidden" name="id_estudiante" value="<?php echo $fila['id_estudiante']; ?>">
                                            <p><strong>ID:</strong>
                                                <?php echo $fila["id_estudiante"]; ?>
                                            </p>
                                            <p>Nombre: <input type="text" class="input-modificar" name="nombre"
                                                    value="<?php echo $fila["nombre"]; ?>"></p>
                                            <p>Apellidos: <input type="text" class="input-modificar" name="apellidos"
                                                    value="<?php echo $fila["apellidos"]; ?>"></p>
                                            <p>Código: <input type="text" class="input-modificar" name="codigo_estudiante"
                                                    value="<?php echo $fila["codigo_estudiante"]; ?>"></p>
                                            <p>Curso: <input type="text" class="input-modificar" name="curso"
                                                    value="<?php echo $fila["curso"]; ?>"></p>
                                            <p>Teléfono: <input type="text" class="input-modificar" name="telefono"
                                                    value="<?php echo $fila["telefono"]; ?>"></p>
                                            <button type="submit" class="btn-modificar" name="modificar">Guardar
                                                Cambios</button>
                                        </form>
                                    </div>
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