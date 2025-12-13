<!DOCTYPE html>
<html>
<head>
    <title>Realizar Apuesta - Quinielas</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .apuesta-form { max-width: 400px; margin: 20px 0; padding: 20px; 
                       border: 1px solid #ddd; border-radius: 10px; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; }
        input[type="number"] { 
            width: 80px; padding: 8px; border: 1px solid #ddd; 
            border-radius: 5px; 
        }
        button { 
            background: #007bff; color: white; padding: 10px 15px; 
            border: none; border-radius: 5px; cursor: pointer; 
            margin-right: 10px; 
        }
        button:hover { background: #0056b3; }
        table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background: #f8f9fa; }
    </style>
</head>
<body>
    <h1>🏀 Realizar Apuesta</h1>
    <?php 
    $usuarios = 'usuarios.txt';
    $documento = fopen($usuarios, 'r');
    $usuario = fgets($documento);
    print "<p>Usuario activo: <strong style='text-transform: capitalize;'>$usuario</strong></p>";
    ?>
    <!-- Tabla de apuestas existentes -->
    <h3>Apuestas Realizadas:</h3>
    <table>
        <thead>
            <tr>
                <th>Lakers</th>
                <th>Celtics</th>
                <th>Usuario</th>
            </tr>
        </thead>
        <tbody>

        <?php
        $quinielas = 'quinielas.txt';
        $file = fopen($quinielas, 'r');

        if (trim(empty($file))) {
            echo "<p>El contenido está vacío.</p>";
        } else { 
            echo "<pre>";
            while (!feof($file)) {
                $linea = fgets($file);
                $datos = explode('|', $linea);

                if (count($datos) === 3) {
                    $nombre = $datos[0];
                    $lakers = $datos[1];
                    $celtics = $datos[2];
                    echo "<strong>$nombre:</strong> apuesta: $lakers - $celtics";
                }
            }
            fclose($file); 
            echo "</pre>";
        }
        ?>
            <!-- Aquí se cargarán las apuestas desde quinielas.txt -->
        </tbody>
    </table>
    
    <!-- Formulario de apuesta -->
    <div class="apuesta-form">
        <h3>Tu Apuesta:</h3>
        <form method="POST" action="index.php">
            <div class="form-group">
                <label>Lakers: <input type="number" name="lakers" min="80" max="120"></label>
                <label>Celtics: <input type="number" name="celtics" min="80" max="120"></label>
            </div>
            
            <button type="submit" name="apostar">Apostar (5€)</button>
            <button type="reset" name="limpiar">Limpiar</button>
        </form>
        
        <p><small>💡 Si dejas los campos vacíos, se generará una apuesta aleatoria.</small></p>
    </div>

    <p><a href="index.php">← Volver al menú principal</a></p>
</body>
</html>