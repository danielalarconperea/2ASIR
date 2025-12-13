<?php
print"<h2>Ejercio 1: Suma y media</h2>";

$numeros = [5, 8, 12, 3, 9, 7, 15, 4, 11, 6];
$suma = 0;

print"Lista de números: ";
for($i=0;$i<count($numeros);$i++){
    print"$numeros[$i] ";
    $suma += $numeros[$i];
}

$media = $suma/count($numeros);
print"<br> Suma total: $suma";
print"<br> La media es: $media";
?>