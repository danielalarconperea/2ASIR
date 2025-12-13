<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
<?php
$nombre = $_REQUEST['nombre'];
$fichero = "nombres.txt";
$esta = false;
$fd = fopen($fichero, "r");
while (!feof($fd)){
    $linea = fgets($fd);
    if(trim($linea) == trim($nombre)){
        $esta=true;
        break;
    }
} 
fclose($fd);
if($esta){
    print"asdfasdfasdf";
}else{
    print"________";
}

?>
</body>
</html>