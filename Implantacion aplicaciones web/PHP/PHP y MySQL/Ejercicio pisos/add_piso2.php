<?php
// Configuración de la base de datos
$servername = "localhost"; $username = "root"; $password = "rootroot"; $dbname = "Pisos";
// Crear conexión
$conn = mysqli_connect($servername, $username, $password, $dbname);
// Verificar la conexión
if (!$conn) {
    die("Conexión fallida: " . mysqli_connect_error());
}
// Recuperar datos del formulario
$titulo = $_REQUEST['titulo'];
$texto = $_REQUEST['texto'];
$categoria = $_REQUEST['categoria'];
$fecha = $_REQUEST['fecha'];
$imagen = $_REQUEST['imagen'];
print"$fecha";
// Preparar y ejecutar la consulta de inserción
$sql = "INSERT INTO noticias (titulo, texto, categoria, fecha, imagen) VALUES ('$titulo', '$texto', '$categoria', '$fecha', '$imagen')";
if (mysqli_query($conn, $sql)) {
    echo "Noticia insertada con éxito.". mysqli_error($conn);
    echo '<br><a href="ejercicio1.php">Ver noticias</a>';
} else {
    echo "Error al insertar noticia: " . mysqli_error($conn);
}
// Cerrar la conexión
