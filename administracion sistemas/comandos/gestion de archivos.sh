# 1. Gestión de Ficheros y Directorios
# Primero, creamos los tres ficheros en nuestro directorio de conexión (normalmente tu directorio home).

touch f1.txt f2.txt f3.txt
# a. Crea un directorio “copias” utilizando direccionamiento absoluto.
# Usamos mkdir con la ruta absoluta. La variable $HOME representa tu directorio de conexión.

mkdir $HOME/copias
# b. Copia los ficheros en el directorio “copias” cambiando su extensión a “.doc” utilizando direccionamiento relativo.
# Podemos usar un bucle for para procesar cada fichero, copiarlo y cambiarle el nombre en el destino.

for f in  f2.txt f3.txt; do cp "$f" copias/"${f%.txt}.doc"; done
cp f1.txt copias/f1.txt.doc
# Explicación: El bucle recorre cada fichero. cp "$f" copia el fichero origen. copias/ es el directorio destino relativo. ${f%.txt}.doc es una técnica que elimina la parte .txt del nombre y le añade .doc.

# c. Mueve el fichero f1.doc a tu directorio de conexión con direccionamiento absoluto.
# Movemos el fichero desde su ubicación en copias a nuestro directorio $HOME.

mv $HOME/copias/f1.doc $HOME
# d. Cambia el nombre al directorio y llámalo “copiados” utilizando direccionamiento absoluto.
# Usamos mv para renombrar el directorio copias.

mv $HOME/copias $HOME/copiados
# e. Crea otro directorio llamado “otro” y copia el directorio “copiados” completo utilizando direccionamiento relativo.
# Primero creamos el nuevo directorio y luego copiamos el contenido de copiados de forma recursiva (-r).
mkdir otro
cp -r copiados otro/
# f. Borra el fichero “f2.doc” del directorio “copiados” mediante direccionamiento relativo.
# Usamos rm (remove) para eliminar el fichero especificado.

rm copiados/f2.doc
# g. Oculta el fichero “f3.doc”.
# En Linux, para ocultar un fichero basta con renombrarlo para que su nombre empiece por un punto (.).

mv copiados/f3.doc copiados/.f3.doc
# h. Borra el directorio “otro” completo.
# Para borrar un directorio y todo su contenido, usamos rm con la opción recursiva -r.

rm -r otro
# 2. Localizar los usuarios del equipo
# a. Mostrar la Shell de cada uno de ellos.
# La información de los usuarios y su shell de inicio de sesión se encuentra en el fichero /etc/passwd. Podemos usar cut para extraer solo el nombre de usuario (campo 1) y la shell (campo 7), usando los dos puntos (:) como delimitador.

cut -d: -f1,7 /etc/passwd
# b. Copiar el fichero /etc/passwd y /etc/shadow en el directorio de conexión.
# Copiamos los ficheros desde su ruta absoluta al directorio actual (.).
# ⚠️ Nota: Para acceder a /etc/shadow necesitarás permisos de superusuario (sudo), ya que contiene información sensible.

cp /etc/passwd .
sudo cp /etc/shadow .
# c. Crear un fichero resultante “datos_usuario”...
# Usamos el comando join para combinar la información de passwd y shadow y awk para formatear la salida como se pide (nombre, shell, directorio, contraseña y UID).

join -t: <(sort passwd) <(sort shadow) | awk -F: '{print $1, $7, $6, $8, $3}' > datos_usuario
# Explicación: join une las líneas de los dos ficheros que tienen un primer campo idéntico (el nombre de usuario). awk reorganiza los campos ($1, $7, etc.) en el orden deseado.
# d. Ordenarlo por el id del usuario.
# El ID de usuario (UID) es ahora el quinto campo. Usamos sort para ordenar numéricamente (-n) por esa columna (-k5).

sort -k5 -n datos_usuario -o datos_usuario
# e. Sustituir en dicho fichero todas las apariciones de la palabra “home” por la palabra “casa”.
# Usamos sed (stream editor) para buscar y reemplazar. La g final indica que se reemplacen todas las apariciones en cada línea.

sed -i 's/home/casa/g' datos_usuario
# Explicación: La opción -i modifica el fichero directamente. s/home/casa/g es la expresión de sustitución.
# f. Sustituir las líneas completas que contengan la palabra “false”...
# De nuevo con sed, buscamos las líneas que contienen "false" (/false/) y las reemplazamos (c) por el texto indicado.

sed -i '/false/c\#LINEA ELIMINADA POR EL ADMINISTRADOR' datos_usuario
# g. Mostrar por pantalla el número de palabras del fichero resultante y el de líneas que tengan contenido.
# Usamos wc -w para contar palabras y grep -c . para contar líneas no vacías.

echo "Número de palabras:"
wc -w datos_usuario
echo "Número de líneas con contenido:"
grep -c . datos_usuario
# 3. Empaquetar con tar
# Empaquetamos el directorio /bin primero sin comprimir (.tar) y luego comprimido (.tar.gz).

# Empaquetado sin comprimir
tar -cvf bin.tar /bin

# Empaquetado comprimido con gzip
tar -czvf bin_comprimido.tar.gz /bin
# Ahora comparamos sus tamaños con ls -lh para ver la diferencia.

ls -lh bin.tar bin_comprimido.tar.gz
# Verás que el fichero .tar.gz es significativamente más pequeño.

# a. Añadir los ficheros txt que haya en nuestro directorio de conexión al fichero comprimido.
# Primero, creamos un par de ficheros de texto vacíos.

touch mi_fichero1.txt mi_fichero2.txt
# Añadir ficheros directamente a un archivo .tar.gz es posible con versiones modernas de tar usando la opción -u (update).

tar -uzvf bin_comprimido.tar.gz mi_fichero1.txt mi_fichero2.txt
# b. Elimina del fichero comprimido los archivos cuyo nombre empiece por “p”.
# Usamos la opción --delete de tar junto con --wildcards para usar comodines.
tar -f bin_comprimido.tar.gz --delete --wildcards 'bin/p*'
# c. Verificar el contenido del fichero mostrándolo por pantalla.
# Listamos el contenido del archivo con la opción -t.

tar -tvf bin_comprimido.tar.gz
# d. Muestra ahora sólo los ficheros cuya tercera letra es una n.
# Listamos el contenido y usamos grep con una expresión regular para filtrar el resultado. '/..n' significa "cualquier carácter, seguido de otro carácter, seguido de una 'n'".

tar -tf bin_comprimido.tar.gz | grep '/..n'
# 4. Repetir la operación con zip
# Repetimos el proceso usando el comando zip.

# Crear el archivo zip recursivamente (-r)
zip -r bin.zip /bin

# Añadir los ficheros txt (zip añade por defecto)
zip bin.zip *.txt

# Eliminar (-d) los archivos que empiezan por 'p'
zip -d bin.zip 'bin/p*'

# Verificar el contenido (-l)
unzip -l bin.zip

# Mostrar ficheros con 'n' como tercera letra
unzip -l bin.zip | grep '/..n'
# Si comparas el tamaño con ls -lh *.zip *.tar.gz, verás que los algoritmos de compresión pueden dar resultados ligeramente diferentes.

# 5. Descomprimir el fichero
# Creamos un directorio y descomprimimos el archivo tar.gz en él.

mkdir bin_copia
tar -xzvf bin_comprimido.tar.gz -C bin_copia
# Explicación: -x para extraer, z para filtrar por gzip, v para modo verboso (mostrar ficheros), f para indicar el fichero de entrada y -C para especificar el directorio de destino.

# 6. Dividir y Unir Ficheros
# Dividir el fichero no comprimido (bin.tar) en 10 partes.
# Usamos el comando split. La opción -n l/10 lo divide en 10 ficheros de aproximadamente el mismo tamaño, y -d usa sufijos numéricos.

split -n l/10 -d bin.tar parte_
# Vuelve a unirlos con otro nombre y comprueba que el contenido permanece intacto.
# Usamos cat para concatenar las partes en un nuevo fichero.

cat parte_* > bin_unido.tar
# Para verificar que el fichero unido es idéntico al original, usamos diff. Si no muestra ninguna salida, los ficheros son iguales.
diff bin.tar bin_unido.tar
# 7. Enlaces Duros y Blandos
# a. Comprueba el número de enlaces de los ficheros originales.
# El número de enlaces se muestra en la segunda columna del comando ls -l.
ls -l bin_comprimido.tar.gz
ls -l /usr/share/dict/spanish
# b. Realiza los enlaces y vuelve a comprobar.

# Enlace duro
ln bin_comprimido.tar.gz compr_duro

# Enlace blando (simbólico)
ln -s /usr/share/dict/spanish diccionario
# Ahora, vuelve a comprobar los enlaces de los ficheros originales.

ls -l bin_comprimido.tar.gz
ls -l /usr/share/dict/spanish
# Observarás que el número de enlaces de bin_comprimido.tar.gz ha aumentado a 2, mientras que el del diccionario no ha cambiado.

# c. Haz un listado mostrando el número de inodo y saca conclusiones.
# Usamos ls -i para ver el número de inodo (el identificador único del fichero en el sistema de archivos).
ls -i bin_comprimido.tar.gz compr_duro
ls -i /usr/share/dict/spanish diccionario
# Conclusiones:
# Enlace duro: compr_duro y bin_comprimido.tar.gz tienen el mismo número de inodo. Un enlace duro es simplemente otro nombre para el mismo fichero. No hay original ni copia, ambos son accesos directos a los mismos datos.
# Enlace blando: diccionario y /usr/share/dict/spanish tienen números de inodo diferentes. Un enlace blando es un fichero especial que apunta a la ruta de otro fichero, similar a un acceso directo en Windows.

# 8. Manipulación de Texto
# Usaremos el enlace diccionario que creamos antes.

# Crea dos ficheros, uno con las 5 primeras palabras y otro con las 5 últimas.

head -n 5 diccionario > primeras.txt
tail -n 5 diccionario > ultimas.txt
# a. Une con paste los ficheros con un separador “;”.
# paste uneimeras.txt ultimas.txt
# b. Ahora de ma ficheros línea por línea. -d especifica el delimitador.

paste -d';' prnera que aparezcan las palabras en líneas diferentes separadas por “-”.
# Podemos concatenar los ficheros con cat e insertar el separador entre ellos.

cat primeras.txt > combinado.txt
echo "-" >> combinado.txt
cat ultimas.txt >> combinado.txt
# c. Encripta el fichero resultante con un cifrado César (desplazamiento +6).
# El comando tr (translate) es perfecto para sustituir caracteres.

tr 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ' 'ghijklmnopqrstuvwxyzabcdefGHIJKLMNOPQRSTUVWXYZABCDEF' < combinado.txt > encriptado.txt
# d. Ahora desencríptalo con la operación inversa.
# Simplemente invertimos el mapeo de tr para desplazar los caracteres 6 posiciones hacia atrás.
tr 'ghijklmnopqrstuvwxyzabcdefGHIJKLMNOPQRSTUVWXYZABCDEF' 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ' < encriptado.txt > desencriptado.txt
# Puedes comprobar que desencriptado.txt es idéntico a combinado.txt con el comando diff combinado.txt desencriptado.txt.