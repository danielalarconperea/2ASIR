<?php

// 1. Ejemplo Básico: Eliminando todas las etiquetas HTML
$html_cadena_1 = "<h1>Título Importante</h1><p>Esto es un párrafo con <b>texto en negrita</b>.</p>";
$limpia_1 = strip_tags($html_cadena_1);

echo "<h2>1. Ejemplo Básico</h2>";
echo "Cadena Original: " . htmlspecialchars($html_cadena_1) . "<br>";
echo "Cadena Original: " . $html_cadena_1 . "   <br>";
echo "Resultado (strip_tags): " . $limpia_1 . "<br>";
echo "<hr>";


// 2. Ejemplo con Etiquetas Permitidas: Dejando ciertas etiquetas
$html_cadena_2 = "<ul><li>Elemento 1</li><li>Elemento 2 con <i>énfasis</i>.</li></ul>";
// Permitimos las etiquetas <li> y <i>
$permitidas = "<li><i>";
$limpia_2 = strip_tags($html_cadena_2, $permitidas);

echo "<h2>2. Etiquetas Permitidas (\$permitidas = \"$permitidas\")</h2>";
echo "Cadena Original: " . htmlspecialchars($html_cadena_2) . "<br>";
echo "Resultado (strip_tags con permitidas): " . $limpia_2 . "<br>";
echo "<hr>";


// 3. Ejemplo con Etiquetas Anidadas y Comentarios
$html_cadena_3 = "<div>Texto en un <span>span</span> y un <a href='#'>enlace</a>.</div>";
// No permitimos ninguna etiqueta
$limpia_3 = strip_tags($html_cadena_3);

echo "<h2>3. Etiquetas Anidadas y Comentarios</h2>";
echo "Cadena Original: " . htmlspecialchars($html_cadena_3) . "<br>";
echo "Resultado (strip_tags): " . $limpia_3 . "<br>";
echo "<hr>";


// 4. Ejemplo con Etiquetas PHP (strip_tags las elimina por defecto)
$php_cadena_4 = "Esto es texto normal con <?php echo 'código PHP'; ?> incrustado.";
$limpia_4 = strip_tags($php_cadena_4);

echo "<h2>4. Etiquetas PHP</h2>";
echo "Cadena Original: " . htmlspecialchars($php_cadena_4) . "<br>";
echo "Resultado (strip_tags): " . $limpia_4 . "<br>";

?>