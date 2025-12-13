<?php
if ($_REQUEST['nombre'] == ''){
    print"<p>No ha escrito ningún nombre</p>";
}else{
    print"<p>Su contraseña es".$_REQUEST['password']."</p>";
    echo"longitud del nombre ".strlen($_REQUEST['nombre']);
}
?>