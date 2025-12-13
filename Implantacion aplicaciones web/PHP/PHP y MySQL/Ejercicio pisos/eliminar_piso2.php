<?php
$id = $_POST['id'];

$conexion = mysqli_connect ("localhost", "root", "rootroot")
    or die ("No se puede conectar con el servidor");
mysqli_select_db ($conexion,"pisos")
    or die ("No se puede seleccionar la base de datos");
$instruccion = "DELETE FROM noticias WHERE id=".$id;
$eliminacion = mysqli_query ($conexion,$instruccion)
    or die ("Fallo en la insercción de datos");

if ($eliminacion){
    echo "Noticia eliminada con éxito.";
    echo '<br><a href="ejercicio1.php">Ver noticias</a>';
} else {
    echo "Error al eliminar la noticia.";
}
mysqli_close ($conexion);
?>