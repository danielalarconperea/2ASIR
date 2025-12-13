<!-- 
 EJERCICIO: SISTEMA DE CLIMA ALEATORIO
Crea un programa PHP que simule un sistema de clima para una ciudad. El programa debe:
Generar tres variables con valores aleatorios:
-Temperatura: número entre -25 y 50 grados
-Humedad: número entre 0 y 100%
-Lluvia: número entre 0 y 50 mm

Mostrar los valores obtenidos

Determinar y mostrar el estado del clima según estas condiciones:

-Si la temperatura es menor a 0° → "¡ALERTA POR HELADA!"
-Si la temperatura es mayor a 35° → "¡ALERTA POR CALOR EXTREMO!"
-Si la humedad es mayor a 80% y lluvia es mayor a 20mm → "¡ALERTA POR TORMENTA!"
-Si la lluvia es mayor a 30mm → "¡RIESGO DE INUNDACIÓN!"
-Si ninguna alerta se activa → "Clima normal para la temporada" 
-->
<?php
$temp = rand(-25, 50);
$hum  = rand(0, 100);
$lluv = rand(0, 50);

print "<p>";
print "Temperatura: " . $temp . "º";
print " | Humedad: " . $hum . "%";
print " | Lluvia: " . $lluv . "mm";
print "</p>";

$alertaActivada = false;

if ($temp < 0) {
    print "¡ALERTA POR HELADA!<br>";
    $alertaActivada = true;
}

if ($temp > 35) {
    print "¡ALERTA POR CALOR EXTREMO!<br>";
    $alertaActivada = true;
}

if ($hum > 80 && $lluv > 20) {
    print "¡ALERTA POR TORMENTA!<br>";
    $alertaActivada = true;
}

if ($lluv > 30) {
    print "¡RIESGO DE INUNDACIÓN!<br>";
    $alertaActivada = true;
}

if (!$alertaActivada) {
    print "Clima normal para la temporada";
}
?>