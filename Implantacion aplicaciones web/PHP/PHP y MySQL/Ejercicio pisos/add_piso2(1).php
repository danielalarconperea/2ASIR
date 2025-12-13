<?php
$titulo = $_POST['titulo'];
$texto = $_POST['texto'];
$categoria = $_POST['categoria'];
$fecha = $_POST['fecha'];
$imagen = $_POST['imagen'];

$conexion = mysqli_connect ("localhost", "root", "rootroot")
    or die ("No se puede conectar con el servidor");
mysqli_select_db ($conexion,"pisos")
    or die ("No se puede seleccionar la base de datos");
$instruccion = "INSERT INTO noticias (titulo, texto, categoria, fecha, imagen) VALUES ('$titulo', '$texto', '$categoria', '$fecha', '$imagen')";
$Inserccion = mysqli_query ($conexion,$instruccion)
    or die ("Fallo en la insercción de datos");

if ($Inserccion){
    echo "Noticia agregada con éxito.";
    echo '<br><a href="ejercicio1.php">Ver noticias</a>';
} else {
    echo "Error al agregar la noticia.";
}
mysqli_close ($conexion);
?>