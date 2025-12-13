<?php
$total = 0;
$numero = 5;
print"<h2>$numero dados</h2>";
for($i=0;$i<$numero;$i++){
    $dado = rand(1,6);
    print"<img src='./img/$dado.jpg' height=140>";
    $total = $total + $dado;
}
print"<p>El total de puntos obtenidos es <b>$total</b>.</p>";
?>