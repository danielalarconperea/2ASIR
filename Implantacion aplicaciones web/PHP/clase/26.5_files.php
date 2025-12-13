<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
<?php
$numero=$_REQUEST['numero'];
    //hacer las comprobaciones
$fichero="uno.txt";
$cont=0;
$fd = fopen($fichero, "r"); # Modo r, read
while(!feof($fd)) {   // feof: end of file EOF
    $linea = fgets($fd); //lee del fichero una linea
    if (intval($linea) == intval($numero)) { //función intval—convierto a int
        $cont++;
    }
}
print "El numero $numero aparece $cont veces en el fichero $fichero ";
fclose($fd);
?>
</body>
</html>