<!DOCTYPE html>
<html>
<head></head>
<body bgcolor="red">
<?php
    $notas = [7.5,8.0,6.5,9.0,7.0];
    $notaAlta = max($notas);
    $notaBaja = min($notas);
    $notaPromedio = (array_sum($notas)/count($notas));
    print"La nota más alta es $notaAlta<br>La nota más baja es $notaBaja<br>La nota promedio es $notaPromedio";
?>
</body>
</html>