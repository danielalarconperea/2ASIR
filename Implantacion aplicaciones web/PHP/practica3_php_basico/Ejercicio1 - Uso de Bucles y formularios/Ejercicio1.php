<?php
$ancho = intval($_REQUEST['ancho']);
$alto = intval($_REQUEST['alto']);

if($ancho <= 0 || $alto <= 0){
    print"<h2>El cuadrado es técnicamente imposible</h2>";
}elseif($ancho >= 100 || $alto >= 100){
    print"<h2>El numero tiene que ser menor que 100</h2>";
}else{
    for($i=0;$alto>$i;$i++){
        for($j=0;$ancho>$j;$j++){
            print" *";
        }
        print"<br>";
    }
}
?>