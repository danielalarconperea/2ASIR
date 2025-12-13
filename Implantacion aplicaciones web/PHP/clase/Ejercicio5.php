<!DOCTYPE html>
<html>
<head></head>
<body bgcolor="red">
    <?php
        $lista = ["casa","perro","manzana","pera","coche"];
        print "<p>El valor de la posicion es $lista[0]</p> <br>";

        //echo $lista; --> es el unico que hemos dado por ahora
        print_r($lista);
        echo "<br>";
        var_dump($lista);
        echo "<br>";
        $cadena = implode(", ", $lista);
        echo $cadena;

        $lista2 = [6,8,7,9,0];
        print "<p>El valor de la posicion es $lista2[2]</p>";
    ?>
</body>
</html>