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
                <h2>Añadir Libros</h2>
                <form action="libros_agregar.php" method="post" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="titulo">Título:</label>
                        <input type="text" id="titulo" name="titulo" placeholder="Ej: El Quijote" required>
                    </div>

                    <div class="form-group">
                        <label for="autor">Autor:</label>
                        <input type="text" id="autor" name="autor" placeholder="Ej: Miguel de Cervantes" required>
                    </div>

                    <div class="form-group">
                        <label for="editorial">Editorial:</label>
                        <input type="text" id="editorial" name="editorial" placeholder="Ej: Alfaguara" required>
                    </div>

                    <div class="form-group">
                        <label for="isbn">ISBN:</label>
                        <input type="text" id="isbn" name="isbn" required pattern="^(97[89])-\d{1,10}$"
                            placeholder="978-XXXXXXXXXX"
                            title="Por favor, introduce un ISBN válido (Formato: 978-0000000000)">
                    </div>

                    <div class="form-group">
                        <label for="anio_publicacion">Año de Publicación:</label>
                        <input type="number" id="anio_publicacion" name="anio_publicacion" min="1000" max="2100"
                            required>
                    </div>

                    <div class="form-group">
                        <label for="genero">Género:</label>
                        <input type="text" id="genero" name="genero" placeholder="Ej: Novela" required>
                    </div>

                    <div class="form-group">
                        <label for="estado">Estado:</label>
                        <select id="estado" name="estado" required>
                            <option value="1">Disponible</option>
                            <option value="0">No disponible</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="portada">Portada del Libro:</label>
                        <input type="file" id="portada" name="portada" required>
                    </div>

                    <button type="submit" name="enviar">✨ Agregar Nuevo Libro</button>
                </form>
            </section>
        </main>

        <footer>
            <p>Sistema de Gestión de Biblioteca Escolar &copy; 2025</p>
        </footer>
    </div>
</body>

</html>

<?php

if (isset($_POST["enviar"]) && $_SERVER["REQUEST_METHOD"] == "POST") {
    $titulo = $_POST["titulo"];
    $autor = $_POST["autor"];
    $editorial = $_POST["editorial"];
    $isbn = $_POST["isbn"];
    $anio_publicacion = $_POST["anio_publicacion"];
    $estado = $_POST["estado"];
    $portada_nombre = $_FILES["portada"]["name"];
    $portada_temp = $_FILES["portada"]["tmp_name"];
    $directorio_destino = "../portadas/";

    // Asegurarse de que el directorio existe (ya lo creamos pero por seguridad en PHP)
    if (!file_exists($directorio_destino)) {
        mkdir($directorio_destino, 0777, true);
    }

    $ruta_final = $directorio_destino . basename($portada_nombre);

    $host = "localhost";
    $user = "root";
    $pass = "asdf";
    $db = "biblioteca_escolar";

    $conexion = mysqli_connect($host, $user, $pass, $db);

    if (!$conexion) {
        die("Error de conexión: " . mysqli_connect_error());
    }

    mysqli_set_charset($conexion, "utf8mb4");

    // Nota: El campo 'genero' se omite porque no existe en la tabla Libros de backup.sql
    $consulta = "INSERT INTO Libros (titulo, autor, editorial, isbn, anio_publicacion, disponible, portada) 
                 VALUES ('$titulo', '$autor', '$editorial', '$isbn', $anio_publicacion, $estado, '$portada_nombre')";

    if (mysqli_query($conexion, $consulta)) {
        if (move_uploaded_file($portada_temp, $ruta_final)) {
            echo "<div class='success-message'>✅ Libro '$titulo' agregado correctamente con su portada.</div>";
        } else {
            echo "<div class='success-message'>✅ Libro '$titulo' agregado, pero hubo un problema al subir la imagen.</div>";
        }
    } else {
        echo "<div class='error-message'>❌ Error al agregar el libro: " . mysqli_error($conexion) . "</div>";
    }

    mysqli_close($conexion);
}
?>