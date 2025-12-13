<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Añadir Cita - Tattoo Studio</title>
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
            border: 2px solid #1a1a2e;
        }
        h1 {
            color: #ff6b6b;
            text-align: center;
            margin-bottom: 30px;
            border-bottom: 2px solid #ff6b6b;
            padding-bottom: 10px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #1a1a2e;
        }
        input[type="text"],
        input[type="date"],
        select {
            width: 100%;
            padding: 10px;
            border: 2px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            box-sizing: border-box;
            transition: border-color 0.3s;
        }
        input[type="text"]:focus,
        input[type="date"]:focus,
        select:focus {
            border-color: #ff6b6b;
            outline: none;
        }
        .btn {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            width: 100%;
            transition: background 0.3s;
        }
        .btn:hover {
            background: linear-gradient(135deg, #ff6b6b 0%, #ff4757 100%);
        }
        .required {
            color: #ff6b6b;
        }
        .success {
            background: #d4edda;
            color: #155724;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #28a745;
        }
        .error {
            background: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #dc3545;
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
        .info-box {
            background: #e3f2fd;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #2196f3;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>➕ Añadir Nueva Cita</h1>
        
        <div class="info-box">
            <p><strong>💡 Información:</strong> La hora de la cita se asignará automáticamente entre las 8:00 y las 20:00.</p>
        </div>

        

        <form method="POST" action="">
            <div class="form-group">
                <label for="nombre">Nombre del cliente <span class="required">*</span></label>
                <input type="text" id="nombre" name="nombre" required >
            </div>

            <div class="form-group">
                <label for="tipo">Tipo de tatuaje <span class="required">*</span></label>
                <select id="tipo" name="tipo" required>
                    <option value="">Selecciona un tipo</option>
                    <option value="Tribal" >Tribal</option>
                    <option value="Realista" >Realista</option>
                    <option value="Acuarela" >Acuarela</option>
                    <option value="Japonés" >Japonés</option>
                    <option value="Minimalista" >Minimalista</option>
                    <option value="Blackwork">Blackwork</option>
                </select>
            </div>

            <div class="form-group">
                <label for="fecha_nacimiento">Fecha de nacimiento <span class="required">*</span></label>
                <input type="date" id="fecha_nacimiento" name="fecha_nacimiento" required>
            </div>

            <button type="submit" name="añadir" class="btn">➕ Añadir Cita</button>
        </form>

        <a href="index.php" class="back-link">← Volver al menú principal</a>
    </div>
</body>
</html>