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
    $lakers=trim(strip_tags($_POST['lakers_real']));
    $celtics=trim(strip_tags($_POST['celtics_real']));
    print"$lakers";
    ?>

    <!-- Sección para mostrar ganadores -->
    <div class="ganadores">
        <h3>🏅 Ganadores:</h3>
        <!-- Aquí se mostrarán los usuarios que acertaron -->
    </div>
    
    <!-- Sección para mostrar premio -->
    <div class="premio">
        <h3>💰 Premio por Ganador:</h3>
        <!-- Aquí se mostrará el cálculo del premio -->
    </div>
    
    <p><a href="index.php">← Volver al menú principal</a></p>
</body>
</html>