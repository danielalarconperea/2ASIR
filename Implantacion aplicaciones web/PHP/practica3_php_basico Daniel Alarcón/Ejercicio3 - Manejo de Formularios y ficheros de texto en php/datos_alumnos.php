<?php
$nombre = $_POST['nombre'];
$numero = $_POST['numero'];
$ver_datos = $_POST['ver_datos'];
$matricula = $_POST['matricula'];
if ($matricula === NULL){
    $estadoMatricula = "no está matriculado";
}elseif($matricula === 'on'){
    $estadoMatricula = "está matriculado";
}else{
    print"error con la matricula";
}

if (isset($_POST['enseñanza'])) {
    $enseñanza = $_POST['enseñanza'];
} else {
    $enseñanza = "enseñanza no especificada"; 
}

$frase = "El alumno <b>$nombre</b>, con teléfono <b>$numero</b>, <b>$estadoMatricula en $enseñanza</b>";


if ($ver_datos == 'pantalla'){
    echo "<h1>Resultados del Alumno</h1>";
    echo "<p>$frase</p>";
    echo '<br><a href="alumno.html">Volver al formulario</a>';
}elseif($ver_datos == 'fichero'){
    $archivo = 'datos.txt';
    if (!file_exists($archivo)) {
        fopen($archivo, 'w');
    }

    $file = fopen($archivo, 'a');
    fwrite($file, "$frase" . PHP_EOL);
    fclose($file);

    echo "<h1>Datos Guardados</h1>";
    echo "<p>La información ha sido guardada en $archivo.</p>";
    echo '<a href="mostrardatos.php">mostrar archivo</a>';
    echo '<br><br><a href="alumno.html">Volver al formulario</a>';
}


?>