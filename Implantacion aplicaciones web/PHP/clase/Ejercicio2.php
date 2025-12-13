<!DOCTYPE html>
<html>
<head></head>
<body bgcolor="red">
<h1>Título</h1>
    <?php
        $edad = 88;
        print "<p>La edad de Pepe es $edad</p>";
        $radio = 12;
        $perimetro = 2 * 3.14 * $radio;
        print "el valor es $perimetro";
        $cadena1 = "Hola";
        $cadena2 = "ASIR";
        $cadena3 = $cadena1 ."".$cadena2;
        print "<p>$cadena3</p>\n"   ;
    ?>
</body>
</html>