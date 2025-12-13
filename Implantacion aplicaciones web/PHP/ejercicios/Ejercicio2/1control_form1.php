<?php
$correo = trim(strip_tags($_REQUEST['correo']));
$correo2 = trim(strip_tags($_REQUEST['correo2']));
$recivir = $_REQUEST['recibir'];

$correo2OK = false;
$correoOK = false;
$recivirOK = false;

if($correo == ''){
    print"<p>No ha escrito su dirección de correo.</p>";
}elseif(!filter_var($correo, FILTER_VALIDATE_EMAIL)){
    print"<p>No ha escrito una dirección de correo correcta.</p>";
}else{
    $correoOK = true;
}

if($correo != $correo2){
    print"<p>Las direcciones de correo no coinciden.</p>";
}else{
    $correo2OK = true;
}if($recivir == '-1'){
    print"<p>No ha indicado si desa recibir corrreo.</p>";
}else{
    $recivirOK = true;
}if($correoOK && $correo2OK && $recivirOK){
    print"<p>Su dirección de correo es <strong>$correo</strong>.</p>";
}


?>