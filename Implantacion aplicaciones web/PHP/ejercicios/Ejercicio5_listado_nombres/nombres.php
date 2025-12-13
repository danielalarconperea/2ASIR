<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
<?php
$nombre=$_REQUEST['nombre'];
    //hacer las comprobaciones
$fichero="nombres.txt";
$cont=0;
$fd = fopen($fichero, "r"); # Modo r, read
while(!feof($fd)) {   // feof: end of file EOF
    $linea = fgets($fd); //lee del fichero una linea
    if ($linea == $nombre) { //función intval—convierto a int
        $cont++;
    }
}
print "El nombre $nombre aparece $cont veces en el fichero $fichero ";
fclose($fd);
?>

</body>
</html>