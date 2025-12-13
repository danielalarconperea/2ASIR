<?php
$puntuaciones = [];
for($j=1;$j<3;$j++){
    print"<h1>jugador $j</h1>";
    print "<p>";
    for($i=0;$i<6;$i++){
        $dado = rand(1,6);
        print "<img src='../img/$dado.jpg' height=140>";
        $suma += $dado;
    }
    print "</p>";
    $puntuaciones[$j] = $suma;
    $suma = 0;
}

if($puntuaciones[0] == $puntuaciones[1]){
    print"<br><h1>Ha habido un empate</h1>";
}elseif($puntuaciones[0] < $puntuaciones[1]){
    print"<br><h1>Ha ganado el jugador 2</h1>";
}else{
    print"<br><h1>Ha ganado el jugador 1</h1>";
}

?>