<!DOCTYPE html>
<html>
<head></head>
<body bgcolor="red">
    <?php
        $lista_compra = ["casa","perro","manzana","pera","coche"];
        
        echo "<p>Primer producto: $lista_compra[0]</p>";
        echo "<p>Último producto: $lista_compra[4]</p>";
        echo "<p>Tercer producto: $lista_compra[2]</p>";

        $cantidad = count($lista_compra);
        echo "<p>Total de productos en la lista: $cantidad</p>";
    ?>
</body>
</html>