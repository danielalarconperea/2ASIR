<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mostrar Citas - Tattoo Studio</title>
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
        .stats-box {
            background: #1a1a2e;
            color: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            margin-bottom: 30px;
        }
        .stats-number {
            font-size: 2.5em;
            font-weight: bold;
            color: #ff6b6b;
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
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        tr:hover {
            background-color: #ffeaea;
        }
        .empty-message {
            text-align: center;
            padding: 40px;
            color: #666;
            font-style: italic;
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
        <h1>📋 Citas del Día</h1>

        <div class="stats-box">
            <h3>Total de Citas Hoy</h3>
            <div class="stats-number">0</div>
        </div>

        <table>
            <thead>
                <tr>
                    <th>Nombre</th>
                    <th>Tipo de Tatuaje</th>
                    <th>Fecha Nacimiento</th>
                    <th>Hora Cita</th>
                </tr>
            </thead>
            <tbody>
                <!-- Las citas se mostrarán aquí con PHP -->
            </tbody>
        </table>

        <a href="index.php" class="back-link">← Volver al menú principal</a>
    </div>
</body>
</html>