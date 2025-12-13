<!DOCTYPE html>
<html>
<head>
    <title>Consultar Premios - Quinielas</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .resultado-form { max-width: 400px; margin: 20px 0; padding: 20px; 
                         border: 1px solid #ddd; border-radius: 10px; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; }
        input[type="number"] { 
            width: 80px; padding: 8px; border: 1px solid #ddd; 
            border-radius: 5px; 
        }
        button { 
            background: #28a745; color: white; padding: 10px 15px; 
            border: none; border-radius: 5px; cursor: pointer; 
        }
        button:hover { background: #218838; }
        .ganadores { margin: 20px 0; padding: 15px; background: #d4edda; 
                    border-radius: 5px; }
        .premio { margin: 20px 0; padding: 15px; background: #fff3cd; 
                 border-radius: 5px; }
    </style>
</head>
<body>
    <h1>🏆 Consultar Premios</h1>
    
    <!-- Formulario para resultado real -->
    <div class="resultado-form">
        <h3>Introducir Resultado Real:</h3>
        <form method="POST" action="">
            <div class="form-group">
                <label>Lakers: <input type="number" name="lakers_real" min="80" max="120" required></label>
                <label>Celtics: <input type="number" name="celtics_real" min="80" max="120" required></label>
            </div>
            
            <button type="submit" name="calcular">Calcular Ganadores</button>
        </form>
    </div>
    
    <?php
    $nombres = [];
    $P_lakers = [];
    $P_celtics = [];
    if (isset($_POST['calcular'])) {
        $lakers_real=trim($_POST['lakers_real']);
        $celtics_real=trim($_POST['celtics_real']);

        $quinielas = 'quinielas.txt';
        $file = fopen($quinielas, 'r');

        if (empty($file)) {
            echo "<p>El contenido está vacío.</p>";
        } else { 
            while (!feof($file)) {
                $linea = trim(fgets($file));

                if (empty($linea)){continue;}

                $datos = explode('|', $linea);

                if (count($datos) === 3) {
                    $nombre = $datos[0];
                    $lakers = $datos[1];
                    $celtics = $datos[2];

                    $nombres[] = strtolower($nombre);
                    $P_lakers[] = $lakers;
                    $P_celtics[] = $celtics;
                }
            }
            fclose($file);
        }
        $ganadores = [];
        for ($i = 0; $i < count($nombres); $i++) {
            if ($P_lakers[$i] == $lakers_real && $P_celtics[$i] == $celtics_real) {
                $ganadores[] = ucfirst($nombres[$i]);
            }
        }
        if (count($ganadores) > 0) {
            echo '<div class="ganadores">';
            echo '<h3>🏅 Ganadores:</h3>';
            echo '<ul>';
            // foreach ($ganadores as $ganador) {
            //     echo "<li>" . ucfirst($ganador) . "</li>";
            // }
            for ($i = 0; $i < count($ganadores); $i++) {
                echo "<li>" . ucfirst($ganadores[$i]) . "</li>";
            }
            echo '</ul>';
            echo '</div>';
            
        } else {
            echo '<div class="ganadores">';
            echo '<h3>🏅 Ganadores:</h3>';
            echo '<p>No hay ganadores.</p>';
            echo '</div>';
        }
        $total_apuestas = count($nombres);
        echo '<div class="premio">';
        echo '<h3>💰 Premio por Ganador:</h3>';
        if (count($ganadores) > 0) {
            $premio = 5 * $total_apuestas / count($ganadores);
            echo "<p>Cada ganador recibe: " . number_format($premio, 2) . " €</p>";
        } else {
            echo "<p>No hay ganadores, por lo tanto no hay premio.</p>";
        }
        echo '</div>';
    }
    ?>
    <p><a href="index.php">← Volver al menú principal</a></p>
</body>
</html>