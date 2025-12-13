<?php
$nombreArchivo = "nombres.txt";
$archivo_w = fopen($nombreArchivo, "w");
$archivo_a = fopen($nombreArchivo, "a");
//echo $archivo_w;
$nombres = array("Luis","María","Carlos","Paco","Lucia");
for($i=0;$i<count($nombres);$i++)
{
    fwrite($archivo_w, $nombres[$i] .$i. PHP_EOL); //End of Line
}

foreach ($nombres as $n){
    fwrite($archivo_a, "\n". $n);
}

fclose($archivo_w);
fclose($archivo_a);
echo "fichero creado...";
?>
