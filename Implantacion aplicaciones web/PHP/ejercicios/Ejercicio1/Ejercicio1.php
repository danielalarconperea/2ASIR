<!-- 
Ejercicio 1: Clasificación de Números
Escribe un programa que cuente cuántos números son:
• Positivos (mayores que 0)
• Negativos (menores que 0)
• Ceros (iguales a 0)
Lista de ejemplo: [5, -3, 0, 8, -7, 0, 12, -2, 4, -9] 
-->
<?php
print"Contador de Números<br>";
$Positivos = 0;
$Negativos = 0;
$Ceros = 0;
$numeros = [5, -3, 0, 8, -7, 0, 12, -2, 4, -9];
print"<br>Lista de números: ";
for($i=0;$i<count($numeros);$i++){
    print"$numeros[$i] ";
    if($numeros[$i] > 0){
        $Positivos++;
    }elseif($numeros[$i] == 0){
        $Ceros++;
    }else{
        $Negativos++;
    }
}
print"<br><br>Cantidad de Positivos: $Positivos<br>";
print"Cantidad de Negativos: $Negativos<br>";
print"Cantidad de Ceros: $Ceros";
?>