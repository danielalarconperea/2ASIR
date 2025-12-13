<!-- 
Ejercicio 2: Invertir una Lista
Crea un programa que:
1. Muestre una lista original
2. Genere y muestre una versión invertida de la misma lista
Lista de ejemplo: [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
-->
<?php
print"Invertir una Lista<br>";
$Lista = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100];
$ListaInvertida = [];

print"<br>Lista: ";
for($i=0;$i<count($Lista);$i++){
    print"$Lista[$i] ";
}

print"<br>Lista invertida: ";
for($i = count($Lista);$i>=0;$i--){
    print"$Lista[$i] ";
    $ListaInvertida[] = $Lista[$i];
}

print"<br><br>Lista invertida creada: ";
for($i=0;$i<count($ListaInvertida);$i++){
    print"$ListaInvertida[$i] ";
}
?>