<?php
$alto = rand(5,10);
print"<h1>Triángulo</h1>";
print"Altura: $alto<br><br>";
for($i=1;$i<=$alto;$i++){
    for($j=1;$j<=$i;$j++){
        print"* ";
    }
    print"<br>";
}
?>