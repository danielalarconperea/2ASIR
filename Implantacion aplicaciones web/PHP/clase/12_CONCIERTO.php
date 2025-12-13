<!-- 
EJERCICIO: SISTEMA DE ACCESO A UN CONCIERTO
Crea un programa PHP que simule el control de acceso a un concierto. 
El programa debe: Generar cuatro variables aleatorias:
-Edad: número entre 15 y 70 años
-Ticket: número 0 o 1 (0 = sin ticket, 1 = con ticket)
-Hora: número entre 16 y 24 (hora de llegada)
-Acompañantes: número entre 0 y 3

Mostrar todos los datos generados

Aplicar las siguientes reglas de acceso:
-ACCESO PERMITIDO si: Tiene ticket Y edad >= 18 Y hora <= 23
-ACCESO CON RESTRICCIONES si: Tiene ticket Y (edad entre 16-17) Y hora <= 22
-ACCESO DENEGADO si: No tiene ticket O edad < 16 O hora > 23
-ACCESO VIP si: Tiene ticket Y edad >= 18 Y hora <= 21 Y acompañantes <= 1

Mostrar mensajes específicos según cada caso 
-->
<?php
$Edad=rand(15,70);
$Ticket=rand(0,1);
$Hora=rand(16,24);
$Acompañantes=rand(0,3);

print "<p>";
print "Edad: " . $Edad;
print " | Ticket: " . $Ticket;
print " | Hora: " . $Hora;
print " | Acompañantes: " . $Acompañantes;
print "</p>";

$AccesoPermitido = false;
$AccesoConRestricciones = false;
$AccesoVip = false;

if($Ticket==1 && $Edad>=18 && $Hora<=23){
    $AccesoPermitido = true;
}
if($Ticket==1 && ($Edad==16 || $Edad==17) && $Hora<=22){
    $AccesoConRestricciones = true;
    $AccesoPermitido = true;
}
if($Ticket==0 || $Edad<16 || $Hora>23){
    $AccesoPermitido = false;
}
if($Ticket==1 && $Edad>=18 && $Hora<=21 && $Acompañantes<=1){
    $AccesoVip = true;
}

if($AccesoPermitido){
    print"Tienes el acceso permitido<br>";
}else{
    print"¡ACCESO DENEGADO!";
}
if($AccesoConRestricciones){
    print"Tu acceso es con restricciones!!";
}
if($AccesoVip){
    print"Tu acceso es VIP!!!";
}
?>