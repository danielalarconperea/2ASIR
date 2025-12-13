<?php
    // Variables para simular datos de un usuario
    $edad = 18;
    $esta_registrado = true;
    $tiene_suscripcion_premium = false;

    echo "--- Estado del Usuario ---<br>";
    echo "Edad: " . $edad . "<br>";
    echo "Registrado: " . ($esta_registrado ? "Sí" : "No") . "<br>";
    echo "Suscripción Premium: " . ($tiene_suscripcion_premium ? "Sí" : "No") . "<br><br>";

    echo "--- Verificación de Acceso ---<br>";

    // Condicional 1: Verificación de edad y registro
    // Se requiere que la edad sea mayor o igual a 18 Y que el usuario esté registrado.
    if ($edad >= 18 && $esta_registrado) {
        echo "✅ **Acceso concedido**: Eres mayor de edad y estás registrado.<br>";
    } else {
        echo "❌ **Acceso denegado**: No cumples los requisitos básicos (edad o registro).<br>";
    }

    echo "---<br>";

    // Condicional 2: Verificación de una oferta especial
    // El usuario puede ser mayor o igual a 18, O bien tener una suscripción premium.
    if ($edad >= 18 || $tiene_suscripcion_premium) {
        echo "✅ **Oferta especial disponible**: Cumples con al menos una condición (mayor de 18 o Premium).<br>";
    } else {
        echo "❌ **Oferta no disponible**: No cumples ninguna de las condiciones.<br>";
    }

    echo "---<br>";

    // Condicional 3: Verificación de excepción
    // El usuario puede acceder si la edad es menor o igual a 25 Y NO tiene una suscripción premium.
    // El operador `!=` (diferente de) también puede usarse en lugar de `!` para comparar directamente,
    // como en `$tiene_suscripcion_premium != true`.
    if ($edad <= 25 && $tiene_suscripcion_premium != true) {
        echo "✅ **Acceso a contenido especial**: Eres menor o igual a 25 y no eres un usuario premium.<br>";
    } else {
        echo "❌ **Sin acceso al contenido especial**: No cumples los requisitos de la oferta.<br>";
    }

?>