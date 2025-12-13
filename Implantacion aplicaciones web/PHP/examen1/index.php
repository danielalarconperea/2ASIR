<!DOCTYPE html>
<html>
<head>
    <title>Sistema de Quinielas - Baloncesto</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .menu { background: #f0f0f0; padding: 20px; border-radius: 10px; }
        .menu a { display: block; margin: 10px 0; padding: 10px; 
                  background: #007bff; color: white; text-decoration: none; 
                  border-radius: 5px; text-align: center; }
        .menu a:hover { background: #0056b3; }
    </style>
</head>
<body>
    <h1>🏀 Sistema de Quinielas - NBA</h1>
    
    <div class="menu">
        <h2>Menú Principal</h2>
        <a href="entrar.php">🎯 Entrar al Sistema</a>
        <a href="premios.php">🏆 Consultar Premios</a>
    </div>
    <?php
    $lakers = trim(strip_tags($_POST['lakers']));
    $celtics = trim(strip_tags($_POST['celtics']));
    $quinielas = 'quinielas.txt';
    $usuarios = 'usuarios.txt';
    if(!file_exists($quinielas)) {
        fopen($quinielas, 'w');
    }
    if(file_exists($usuarios)){
        $fileusu = fopen($usuarios, 'r');
        $usuario = fgets($fileusu);
    }
    $filequi = fopen($quinielas, 'a');
    if($lakers === ''){
        $lakers = rand(80, 120);
    }if($celtics === ''){
        $celtics = rand(80,120);
    }
    if($lakers!='' && $celtics!=''){
        $apuesta = "$usuario|$lakers|$celtics";
        fwrite($filequi,$apuesta.PHP_EOL);
    }
    ?>

</body>
</html>