<?php
$num1 = $_REQUEST['num1'];
$num2 = $_REQUEST['num2'];
$op = $_REQUEST['op'];
$Resultado = 0;

if($num1 == '' || $num2 == ''){
    print"Escribe un valor para cada número";
}elseif($op == '+'){
    $Resultado = $num1 + $num2;
    print"$num1 $op $num2 = $Resultado";
}elseif($op == '-'){
    $Resultado = $num1 - $num2;
    print"$num1 $op $num2 = $Resultado";
}elseif($op == '*'){
    $Resultado = $num1 * $num2;
    print"$num1 $op $num2 = $Resultado";
}elseif($op == '/'){
    $Resultado = $num1 / $num2;
    print"$num1 $op $num2 = $Resultado";
}
?>