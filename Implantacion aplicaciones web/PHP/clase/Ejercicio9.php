<!DOCTYPE html>
<html>
<head></head>
<body bgcolor="red">
<?php
    $tareas = ["Estudiar PHP","Hacer la compra","Llamar al médico","Pasear al perro","Limpiar la casa"];
    for ($i=0;$i<count($tareas);$i++){
        print"$tareas[$i]<br>";
    }
    echo"<br>En total hay ".count($tareas)." tareas<br>";
    echo"<br>La primera tarea de la lista es: $tareas[0]";
    $n=count($tareas)-1;
    echo"<br>La última tarea de la lista es: $tareas[$n]";
    echo"<br>La tercera tarea de la lista es: $tareas[2]";
?>
</body>
</html>