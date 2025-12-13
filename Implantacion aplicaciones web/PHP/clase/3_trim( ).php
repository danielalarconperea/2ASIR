<?php
    $cadena_con_espacios = "   espacios   ";
    $cadena_sin_espacios = trim($cadena_con_espacios);
    echo "Cadena con espacios: '" . $cadena_con_espacios . "'<br>";
    echo "Cadena sin espacios: '" . $cadena_sin_espacios . "'";
    // Salida:
    // Cadena con espacios: '   espacios   '
    // Cadena sin espacios: 'espacios'
?>