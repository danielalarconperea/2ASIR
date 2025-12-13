<!DOCTYPE html>
<html>
<head></head>
<body bgcolor="red">
    <?php
        $precio = 50;
        $cantidad = 4;
        $total = $precio * $cantidad;
        $totalcondescuento = $total * 0.1;
        print "El precio final es de $totalcondescuento €"
    ?>
</body>
</html>