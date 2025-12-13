<?php
$nombre = $_POST['nombre'];
$numero = $_POST['numero'];
$matricula = $_POST['matricula'];
$enseñanza = $_POST['enseñanza'];
$ver_datos = $_POST['ver_datos'];

if ($matricula === NULL){
    $matriculado = "no está";
}elseif($matricula === 'on'){
    $matriculado = "está";
}else{
    print"error con la matricula";
}
if ($ver_datos == 'pantalla'){
    print"El alumno <b>$nombre</b>, con teléfono <b>$numero</b>, <b>$matriculado matriculado en $enseñanza</b>";
}else{
    $archivo = 'datos.txt';
    if (!file_exists($archivo)) {
        fopen($archivo, 'w'); // crea el archivo vacio
    }

    // Abrir el archivo en modo escritura y agregar los datos
    $file = fopen($archivo, 'a');
    fwrite($file, "El alumno <b>$nombre</b>, con teléfono <b>$numero</b>, <b>$matriculado matriculado en $enseñanza</b>" . PHP_EOL);
    fclose($file);

    print"Los datos se han guardado en el archivo datos.txt";
}


echo "<br><br>$nombre $numero $matricula $enseñanza $ver_datos";


?>