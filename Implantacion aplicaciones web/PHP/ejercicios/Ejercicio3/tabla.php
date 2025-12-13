<?php
$num = trim(strip_tags($_REQUEST['tabla']));

if(is_numeric($num)){
    for($i=1; $i<=10; $i++){
        echo"$num x $i = ".$num*$i."<br>";
    }
}else{echo"No es un número";}

?>