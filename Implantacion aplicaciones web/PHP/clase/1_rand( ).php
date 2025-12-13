<?php
    // Generar un número aleatorio entre 1 y 100
    $numero_aleatorio = rand(1, 100);

    // Guardar un mensaje que se mostrará más adelante
    $mensaje = "";

    // Usar un condicional para evaluar el número
    if ($numero_aleatorio <= 30) {
        $mensaje = "¡Es un número pequeño!";
    } elseif ($numero_aleatorio <= 70) {
        $mensaje = "Es un número mediano.";
    } else {
        $mensaje = "¡Es un número grande!";
    }

    // Mostrar el resultado final
    echo "El número aleatorio es: " . $numero_aleatorio . "<br>";
    echo $mensaje;
?>