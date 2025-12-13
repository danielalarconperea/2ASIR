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
    print"<p>Has sacado un trío de: $dado1</p>";
}elseif($dado1 == $dado2 || $dado2 == $dado3){
    print"<p>Has sacado una pareja de: $dado2</p>";
}elseif($dado1 == $dado3){
    print"<p>Has sacado una pareja de: $dado1</p>";
}else{
    print"<p>El valor más alto es: ".max($dado1,$dado2,$dado3)."</p>";
}
?>
