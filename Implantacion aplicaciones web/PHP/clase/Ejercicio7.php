<!DOCTYPE html>
<html>
<head></head>
<body bgcolor="red">
    <?php
        $numeros = [5,2,8,1,9];
        $maximo = max($numeros);
        echo $maximo."<br>";

        $minimo = min($numeros);
        echo $minimo."<br>";

        $suma = array_sum($numeros);
        echo $suma."<br>";

        $numeros = [3,1,2];
        sort($numeros);
        print_r($numeros);
        echo "<br>";
        rsort($numeros);
        print_r($numeros);
    ?>
</body>
</html>