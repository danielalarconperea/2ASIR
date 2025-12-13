<?php
$alto = rand(5,10);
$ancho = rand(5,10);

print"<h1>Rectangulo</h1>";
print"<pre>";
for($i=1; $i<=$alto; $i++){
    for($j=1; $j<=$ancho; $j++){
        if($i==1 || $i==$alto || $j==1 || $j==$ancho){
            print"* ";
        } else {
            print"  ";
        }
    }
    print"\n";
}
print"</pre>";
?>