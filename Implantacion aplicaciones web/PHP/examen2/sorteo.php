<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sorteo - Cyber Monday</title>
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
            text-align: center;
        }
        h1 {
            color: #667eea;
            margin-bottom: 30px;
        }
        .btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 30px;
            border: none;
            border-radius: 5px;
            font-size: 18px;
            cursor: pointer;
            margin: 20px 0;
        }
        .btn:hover {
            opacity: 0.9;
        }
        .sorteo-result {
            background: #fff3cd;
            padding: 30px;
            border-radius: 10px;
            margin: 20px 0;
            border: 2px dashed #ffc107;
        }
        .ganador {
            font-size: 1.5em;
            font-weight: bold;
            color: #e91e63;
            margin: 15px 0;
        }
        .info {
            background: #e3f2fd;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
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
        <h1>🎁 Sorteo de Pedidos</h1>

        <div class="info">
            <p>Total de pedidos registrados:</p>
          
        </div>

        <form method="POST" action="">
            <button type="submit" name="realizar_sorteo" class="btn">🎲 Realizar Sorteo</button>
        </form>

         <?php
            $file = fopen('pedidos.txt', 'r');
            $L_nombres = [];
            while (!feof($file)) {
                $linea = fgets($file);
                $datos = explode('|', $linea);
                if (count($datos) === 5) {
                    $L_nombres[] = $datos[0];
                }
            }
            $total_pedidos = count($L_nombres);
            $n_aleatorio = rand(1,$total_pedidos);
            $ganador = $L_nombres[$n_aleatorio-1];

            if (count($ganador) > 0) {
                echo '<div class="sorteo-result">';
                echo '<h2>¡Tenemos un ganador! 🎉</h2>';
                echo "<div class='ganador'>$ganador</div>";
                echo "<p>Número sorteado: $n_aleatorio</p>";
                echo '<p>¡Felicidades! Tu pedido será gratuito.</p>';
                echo '</div>';
            }
            
            ?>

      

        <a href="index.html" class="back-link">← Volver al menú principal</a>
    </div>
</body>
</html>