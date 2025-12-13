<?php
print"<h2>Ejercio 1: Suma y media</h2>";

$numeros = [5, 8, 12, 3, 9, 7, 15, 4, 11, 6];
$mayor = 0;
$menor = 99;
print"Lista de números: ";
for($i=0;$i<count($numeros);$i++){
    print"$numeros[$i] ";
    if($numeros[$i]>$mayor){
        $mayor = $numeros[$i];
    }elseif($numeros[$i]<$menor){
        $menor = $numeros[$i];
    }
}
// $max = max($numeros);
// $min = min($numeros);
print"<br> El mayor es: $mayor";
print"<br> El menor es: $menor";
// print"<br> El mayor es: $max";
// print"<br> El menor es: $min";
?>