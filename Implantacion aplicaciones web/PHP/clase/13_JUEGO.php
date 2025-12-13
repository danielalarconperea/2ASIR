<!-- 
Crea un juego de dados en PHP llamado "Dados ASIR" donde deberás generar tres variables que representen dados de 6 caras usando números aleatorios entre 1 y 6.
Luego, implementa un sistema de condicionales que evalúe las combinaciones obtenidas: 
    -Si los tres dados son iguales muestra el mensaje "ASIR GANA" junto con el valor de los dados.
    -Si los dados forman una escalera perfecta (1-2-3 o 4-5-6 en cualquier orden) muestra "Escalera Perfecta". 
    -Si solo dos dados son iguales muestra "Pareja" indicando el valor de la pareja y si ninguna de estas combinaciones se cumple muestra "Carta Alta" con el valor del dado más alto.  
-->

<?php
$dado1 = rand(1,6);
$dado2 = rand(1,6);
$dado3 = rand(1,6);
print "<p>";
print "  <img src='./img/$dado1.jpg' height=140>";
print "  <img src='./img/$dado2.jpg' height=140>";
print "  <img src='./img/$dado3.jpg' height=140>";
print "</p>";

if($dado1 == $dado2 && $dado2 == $dado3){
    print"<p>ASIR GANA</p>";
}elseif(($dado1==($dado2-1) && $dado1==($dado3-2)) || ($dado1==($dado2+1) && $dado1==($dado3+2))){
    print"Escalera Perfecta";
}elseif($dado1 == $dado2 || $dado2 == $dado3 || $dado1 == $dado3){
    print"<p>Pareja</p>";
}else{
    print"<p>Dado alto: ".max($dado1,$dado2,$dado3)."</p>";
}
?>