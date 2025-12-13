<!-- 
Ejercicio 3: Búsqueda en Lista
Desarrolla un programa de búsqueda que:
• Busque un número específico en una lista
• Indique si el número fue encontrado o no
• Si se encuentra, muestre su posición en la lista
Lista de ejemplo: [15, 27, 8, 42, 19, 33, 6, 51, 24, 37]
Número a buscar: 19 
-->
<?php
print"Búsqueda en Lista<br>";
$numero = 19;
$Lista = [15, 27, 8, 42, 19, 33, 6, 51, 24, 37];
$Encontrado = false;

print"<br>Lista: ";
for($i=0;$i<count($Lista);$i++){
    print"$Lista[$i] ";
    if($Lista[$i] == $numero){
        $Encontrado = true;
        $posicion = $i+1;
    }
}

if($Encontrado){
    print"<br><br>El número fue encontrado<br>";
    print"La posición del número es $posicion<br>";
}else{
    print"<br><br>El número no fue encontrado<br>";
}
?>