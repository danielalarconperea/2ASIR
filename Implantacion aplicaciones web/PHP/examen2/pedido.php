<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Realizar Pedido - Cyber Monday</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        h1 {
            color: #667eea;
            text-align: center;
            margin-bottom: 30px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }
        input[type="text"],
        input[type="number"],
        select {
            width: 100%;
            padding: 10px;
            border: 2px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            box-sizing: border-box;
        }
        input[type="text"]:focus,
        input[type="number"]:focus,
        select:focus {
            border-color: #667eea;
            outline: none;
        }
        .btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            width: 100%;
        }
        .btn:hover {
            opacity: 0.9;
        }
        .required {
            color: red;
        }
        .error {
            background: #ffebee;
            color: #c62828;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #c62828;
        }
        .success {
            background: #e8f5e8;
            color: #2e7d32;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #2e7d32;
        }
        .back-link {
            display: inline-block;
            margin-top: 20px;
            color: #667eea;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>📦 Realizar Pedido</h1>

       
        <form method="POST" action="">
            <div class="form-group">
                <label for="nombre">Nombre completo <span class="required">*</span></label>
                <input type="text" id="nombre" name="nombre" required  >
            </div>

            <div class="form-group">
                <label for="direccion">Dirección de envío <span class="required">*</span></label>
                <input type="text" id="direccion" name="direccion" required >
            </div>

            <div class="form-group">
                <label for="producto">Producto <span class="required">*</span></label>
                <select id="producto" name="producto" required>
                    <option value="">Selecciona un producto</option>
                    <option value="iPhone">iPhone - 1000€</option>
                    <option value="MacBook" >MacBook - 2000€</option>
                    <option value="AirPods">AirPods - 200€</option>
                    <option value="iPad" >iPad - 800€</option>
                </select>
            </div>

            <div class="form-group">
                <label for="cantidad">Cantidad <span class="required">*</span></label>
                <input type="number" id="cantidad" name="cantidad" min="1" max="10" required>
            </div>

            <button type="submit" name="enviar" class="btn">Realizar Pedido</button>
        </form>

        <a href="index.html" class="back-link">← Volver al menú principal</a>
    </div>
    <?php
    if (isset($_POST['enviar'])){
        $nombre = $_POST['nombre'];
        $direccion = $_POST['direccion'];
        $producto = $_POST['producto'];
        $cantidad = $_POST['cantidad'];
        $pedidos = 'pedidos.txt';
        $date = date("d-m-y").'/'.time();

        $datos = "$nombre|$direccion|$producto|$cantidad|$date";


        if(!file_exists($pedidos)){
            fopen($pedidos, 'w');
        }
        $file = fopen($pedidos, 'a');
        fwrite($file,$datos.PHP_EOL);
        fclose($file);
    }
    ?>
</body>
</html>