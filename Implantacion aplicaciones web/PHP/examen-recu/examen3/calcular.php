<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Calcular Ganancias - Tattoo Studio</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            border: 2px solid #1a1a2e;
        }
        h1 {
            color: #ff6b6b;
            text-align: center;
            margin-bottom: 30px;
        }
        .info-box {
            background: #e3f2fd;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
            border-left: 4px solid #2196f3;
        }
        .tarifas {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
        }
        .tarifas ul {
            list-style-type: none;
            padding-left: 0;
        }
        .tarifas li {
            padding: 8px 0;
            border-bottom: 1px solid #ddd;
        }
        .tarifas li:last-child {
            border-bottom: none;
        }
        .btn {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            color: white;
            padding: 15px 30px;
            border: none;
            border-radius: 5px;
            font-size: 18px;
            cursor: pointer;
            margin: 20px 0;
            transition: background 0.3s;
        }
        .btn:hover {
            background: linear-gradient(135deg, #ff6b6b 0%, #ff4757 100%);
        }
        .resultado {
            background: #fff3cd;
            padding: 30px;
            border-radius: 10px;
            margin: 20px 0;
            border: 2px dashed #ffc107;
            text-align: center;
        }
        .ganancia-total {
            font-size: 2.5em;
            font-weight: bold;
            color: #28a745;
            margin: 15px 0;
        }
        .detalle {
            margin-top: 20px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
        }
        .back-link {
            display: inline-block;
            margin-top: 20px;
            color: #1a1a2e;
            text-decoration: none;
            font-weight: bold;
        }
        .back-link:hover {
            color: #ff6b6b;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }
        th {
            background: #1a1a2e;
            color: white;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>💰 Calcular Ganancias</h1>

        <div class="info-box">
            <h3>💡 Información:</h3>
            <p>Las ganancias se calculan automáticamente a partir de las citas del día.</p>
        </div>

        <div class="tarifas">
            <h3>📋 Tarifas:</h3>
            <ul>
                <li><strong>Menores de 18 años:</strong> 50€ por tatuaje</li>
                <li><strong>Mayores de 18 años:</strong> 100€ por tatuaje</li>
            </ul>
        </div>

        <form method="POST" action="">
            <button type="submit" name="calcular" class="btn">💰 Calcular Ganancias del Día</button>
        </form>

        <div class="resultado">
            <!-- Los resultados se mostrarán aquí con PHP -->
        </div>

        <a href="index.php" class="back-link">← Volver al menú principal</a>
    </div>
</body>
</html>