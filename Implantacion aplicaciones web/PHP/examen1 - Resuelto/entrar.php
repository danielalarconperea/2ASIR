<?php
if (isset($_POST['comprobar'])) {
    $usuarios = 'usuarios.txt';

    $contrasena = trim(strip_tags($_POST['passwd']));
    $usuario = trim(strip_tags($_POST['usuario']));
    
    if($contrasena == 'baloncesto') {
        $file = fopen($usuarios, 'w');
        fwrite($file, $usuario);
        fclose($file);
        header("Location: apostar.php");
        exit();
    }else{
        $error = "Contraseña incorrecta";
    }
}

?>
<!DOCTYPE html>
<html>
<head>
    <title>Iniciar Sesión - Quinielas</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .login-form { max-width: 300px; margin: 0 auto; padding: 20px; 
                     border: 1px solid #ddd; border-radius: 10px; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; }
        input[type="text"], input[type="password"] { 
            width: 100%; padding: 8px; border: 1px solid #ddd; 
            border-radius: 5px; 
        }
        button { 
            background: #28a745; color: white; padding: 10px 15px; 
            border: none; border-radius: 5px; cursor: pointer; 
            width: 100%; 
        }
        button:hover { background: #218838; }
        .error { color: red; margin-top: 10px; }
    </style>
</head>
<body>
    <h1>🔐 Iniciar Sesión</h1>
    
    <div class="login-form">
        <form method="POST" action="">
            <div class="form-group">
                <label for="usuario">Usuario:</label>
                <input type="text" id="usuario" name="usuario" required>
            </div>

            <div class="form-group">
                <label for="passwd">Contraseña:</label>
                <input type="password" id="passwd" name="passwd" required>
            </div>
            <button type="submit"  name="comprobar">Comprobar</button>
        </form>
        <div>
            <?php if (isset($error)) echo "<p style='color:red;'>$error</p>"; ?>
        </div>
    </div>
    
    <p><a href="index.php">← Volver al menú principal</a></p>
</body>
</html>