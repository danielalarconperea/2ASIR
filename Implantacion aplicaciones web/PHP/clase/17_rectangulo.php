<?php
$alto = rand(5,10);
$ancho = rand(5,10);
print"<h1>Rectangulo</h1>";
for($i=1;$i<=$alto;$i++){
    for($j=1;$j<=$ancho;$j++){
        print"* ";
    }
    print"<br>";
}
?>