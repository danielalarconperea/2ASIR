### 1\. Búsquedas básicas con 'grep'

# Buscar todas las líneas que empiezan con "error" en un fichero de log
grep '^error' /var/log/syslog

# Supongamos que tienes un archivo 'datos.txt' con este contenido:
# item_1
# item_2_vendido
# item_3
# item_vendido_4

grep '[0-9]$' datos.txt

# *Salida esperada:*
# item_1
# item_3
# item_vendido_4


# Busca patrones de email en un archivo llamado 'contactos.txt'
grep -E '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' contactos.txt

# '-E' activa las expresiones regulares extendidas, que son más potentes.
# '[a-zA-Z0-9._%+-]+' busca uno o más caracteres válidos para el nombre del usuario.
# '@' busca el carácter literal "@".
# '[a-zA-Z0-9.-]+' busca el nombre del dominio.
# '\.' busca el punto literal (la barra invertida escapa su significado especial).
# '[a-zA-Z]{2,}' busca el dominio de nivel superior (como .com, .es, .org) de al menos 2 letras.


### 2\. Búsqueda y reemplazo con 'sed'

#**Ejemplo 4: Reemplazar una palabra por otra.**
La sintaxis básica es 's/patrón_a_buscar/texto_de_reemplazo/g'.

# Reemplazar todas las apariciones de "viejo" por "nuevo" en un archivo
sed 's/viejo/nuevo/g' mi_archivo.txt

# La 'g' al final significa "global", para que reemplace todas las ocurrencias en cada línea, no solo la primera.

#**Ejemplo 5: Comentar líneas que no están comentadas.**
Podemos añadir '#' al principio de las líneas que no lo tengan.

# Añade un '#' al principio de las líneas que empiezan por "config"
sed '/^config/ s/^/#/' fichero_configuracion.conf

# '  / ^config/ ' selecciona solo las líneas que empiezan por "config".
# 's/^/#/' en esas líneas seleccionadas, sustituye el inicio de la línea ('^') por un '#'.


### 3\. Búsqueda de archivos con 'find'

#**Ejemplo 6: Encontrar todos los archivos de imagen (jpg, jpeg, png).**

# Busca en el directorio actual (.) archivos que terminen en .jpg, .jpeg o .png
find . -iregex '.*\.\(jpg\|jpeg\|png\)$'

# '-iregex' hace una búsqueda con regex insensible a mayúsculas/minúsculas.
# '.*' coincide con cualquier secuencia de caracteres.
# '\.' coincide con un punto literal.
# '\(jpg\|jpeg\|png\)' es un grupo que busca "jpg" o "jpeg" o "png".
# '$' asegura que el patrón esté al final del nombre del archivo.

#**Ejemplo 7: Encontrar archivos que contengan números en su nombre.**

# Busca archivos que tengan al menos un dígito en su nombre
find . -regex '.*[0-9].*'