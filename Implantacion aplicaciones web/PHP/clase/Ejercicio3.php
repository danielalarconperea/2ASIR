<!DOCTYPE html>
<html>
<head></head>
<body bgcolor="red">
<h1>Título</h1>
    <?php
        $x = 2;
        $y = 4;
        $suma = $x + $y;
        $producto = $x * $y;
        $potencia = pow($x, $y);
        print "<p>Suma $x + $y = $suma</p>";
        print "<p>Producto $x * $y = $producto</p>";
        print "<p>Potencia $x ^ $y = $potencia</p>";
    ?>
</body>
</html>