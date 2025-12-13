<?php
// trim elimina espacios delante y detrás de un campo
// strip_tags quita etiquetas HTML

if (trim(strip_tags($_REQUEST['nombre'] == ''))){
    print"<p>No ha escrito ningún nombre</p>";
}else{
    print"<p>Su nombre es ".trim(strip_tags($_REQUEST['nombre']))."</p>";
}
?>