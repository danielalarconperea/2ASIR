<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <form action="add_piso2.php" method="post">
        <label for="titulo">Título:</label>
        <input type="text" name="titulo" required><br>

        <label for="texto">Texto:</label>
        <textarea name="texto" required></textarea><br>

        <label for="categoria">Categoría:</label>
        <select name="categoria">
            <option value="promociones">Promociones</option>
            <option value="ofertas">Ofertas</option>
            <option value="costas">Costas</option>
        </select><br>

        <label for="fecha">Fecha:</label>
        <input type="date" name="fecha" required><br>

        <label for="imagen">Imagen:</label>
        <input type="text" name="imagen"><br>
        <input type="submit" value="Insertar">
    </form>

</body>
</html>