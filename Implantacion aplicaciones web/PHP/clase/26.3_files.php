<?php
/*Leer archivo de texto con PHP*/
$nombre_archivo = "noticia1.txt";
$fd = fopen($nombre_archivo, "r"); # Modo r, read
echo "El contenido del fichero es: <br>";

while(!feof($fd)){ // feof: end of file EOF
    $lectura = fgets($fd); //lee del fichero una linea
    echo $lectura."<br>";
}
// No olvides cerrar el fich
fclose($fd);
?>