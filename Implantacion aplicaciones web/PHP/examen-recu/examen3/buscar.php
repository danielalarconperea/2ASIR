<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Buscar Citas - Tattoo Studio</title>
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
        .search-form {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #1a1a2e;
        }
        select {
            width: 100%;
            padding: 10px;
            border: 2px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            box-sizing: border-box;
        }
        select:focus {
            border-color: #ff6b6b;
            outline: none;
        }
        .btn {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background 0.3s;
        }
        .btn:hover {
            background: linear-gradient(135deg, #ff6b6b 0%, #ff4757 100%);
        }
        .results {
            margin-top: 30px;
        }
        .no-results {
            text-align: center;
            padding: 40px;
            color: #666;
            font-style: italic;
            background: #f9f9f9;
            border-radius: 8px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        th {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            color: white;
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
    </style>
</head>
<body>
    <div class="container">
        <h1>🔍 Buscar Citas por Hora</h1>

        <div class="search-form">
            <form method="POST" action="">
                <div class="form-group">
                    <label for="hora">Selecciona la hora (8:00 - 20:00):</label>
                    <select id="hora" name="hora" required>
                        <option value="">Selecciona una hora</option>
                        <!-- Las opciones se generarán con PHP -->
                    </select>
                </div>
                <button type="submit" name="buscar" class="btn">🔍 Buscar Citas</button>
            </form>
        </div>

        <div class="results">
            <!-- Los resultados se mostrarán aquí con PHP -->
        </div>

        <a href="index.php" class="back-link">← Volver al menú principal</a>
    </div>
</body>
</html>