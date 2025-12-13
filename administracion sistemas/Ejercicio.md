¡Claro que sí\! Con todos esos comandos, ahora podemos resolver la evaluación completa (con una pequeña excepción que te comentaré).

Aquí tienes la solución detallada para cada ejercicio, usando solo los comandos de tus apuntes y de la lista permitida.

-----

### 1\) Genera un fichero `archivos_grandes.txt` que contenga el listado de los 10 ficheros más grandes que haya en `/var/log` en una línea separados por `";"`

```bash
find /var/log -type f -printf "%s %p\n" | sort -nr | head -n 10 | sed 's/^[0-9]\+ //' | tr '\n' ';' | sed 's/;$//' > archivos_grandes.txt
```

**Explicación:**

1.  **`find /var/log -type f -printf "%s %p\n"`:** Busca (`find`) en `/var/log` solo ficheros (`-type f`) e imprime su tamaño en bytes (`%s`) seguido de su ruta (`%p`) y un salto de línea (`\n`).
2.  **`| sort -nr`:** Ordena (`sort`) la lista numéricamente (`-n`) y en orden reverso (`-r`, de mayor a menor).
3.  **`| head -n 10`:** Se queda solo con las 10 primeras líneas (los 10 más grandes).
4.  **`| sed 's/^[0-9]\+ //'`:** Usa `sed` para buscar (`s/`) al principio de la línea (`^`) una o más cifras (`[0-9]\+`) seguidas de un espacio, y las reemplaza por nada. Esto elimina el tamaño y deja solo la ruta.
5.  **`| tr '\n' ';'`:** Traduce (`tr`) todos los saltos de línea (`\n`) por puntos y coma (`;`).
6.  **`| sed 's/;$//'`:** Elimina el último punto y coma que sobra al final de la línea (`$`).
7.  **`> archivos_grandes.txt`:** Guarda el resultado en el fichero.

-----

### 2\) Genera... un fichero `ip.txt` que contenga tu dirección IP del sistema (sólo el número).

```bash
ip a | grep "inet " | grep -v "127.0.0.1" | sed 's/^ *inet //' | cut -d' ' -f1 | cut -d'/' -f1 | head -n 1 > ip.txt
```

**Explicación:**

1.  **`ip a`:** Muestra toda la información de las interfaces de red.
2.  **`| grep "inet "`:** Filtra las líneas que contienen ` inet  ` (con un espacio, para coger IPv4 y no `inet6`).
3.  **`| grep -v "127.0.0.1"`:** Excluye (`-v`) la línea de *loopback* (la propia máquina).
4.  **`| sed 's/^ *inet //'`:** Elimina la palabra "inet" y los espacios que haya al principio (` ^ *inet  `).
5.  **`| cut -d' ' -f1`:** Corta (`cut`) la línea usando el espacio como delimitador (`-d' '`) y se queda con el primer campo (`-f1`), que es la IP con su máscara (ej: `192.168.1.5/24`).
6.  **`| cut -d'/' -f1`:** Vuelve a cortar, esta vez usando `/` como delimitador, para quedarse solo con la IP.
7.  **`| head -n 1`:** Se queda con la primera IP si el sistema tuviera varias (Ej. WiFi y Ethernet).
8.  **`> ip.txt`:** Lo guarda en el fichero.

-----

### 3\) Calcula... cuántos usuarios están creados... que no sean los preinstalados y cuáles son sus nombres.

```bash
cat /etc/passwd | grep -E ":[1-9][0-9]{3,}:" | cut -d: -f1 | tee /dev/tty | wc -l
```

**Explicación:**
(En Linux, los usuarios "humanos" suelen tener un UID de 1000 o más. El UID es el 3er campo en `/etc/passwd`).

1.  **`cat /etc/passwd`:** Muestra el fichero de usuarios.
2.  **`| grep -E ":[1-9][0-9]{3,}:"`:** Usamos `grep` con Expresiones Regulares (`-E`) para buscar UIDs de 1000 o más. Esta expresión busca un `:` seguido de un número de 4 o más cifras que no empiece por 0 (`[1-9][0-9]{3,}`), seguido de otro `:`.
3.  **`| cut -d: -f1`:** Corta la línea usando `:` como delimitador y extrae el primer campo (el nombre de usuario).
4.  **`| tee /dev/tty`:** Bifurca (`tee`) la salida. Envía la lista de nombres a la terminal (`/dev/tty`) para que veas "cuáles son sus nombres".
5.  **`| wc -l`:** La lista de nombres continúa por la tubería y `wc -l` (Word Count - lines) las cuenta, dándote el "cuántos usuarios".

-----

### 4\) Crea una carpeta `TEMPORAL`... y copia... todos los ficheros de `/etc` junto con sus subdirectorios.

```bash
mkdir TEMPORAL && cp -r /etc TEMPORAL/
```

**Explicación:**

1.  **`mkdir TEMPORAL`:** Crea el directorio `TEMPORAL`.
2.  **`&&`:** Es un conector lógico. El segundo comando solo se ejecuta si el primero (`mkdir`) tuvo éxito.
3.  **`cp -r /etc TEMPORAL/`:** Copia (`cp`) de forma recursiva (`-r`) toda la carpeta `/etc` *dentro* de `TEMPORAL`.

-----

### 5\) Empaqueta la carpeta `etc` copiada... Y crea un enlace blando a dicho fichero.

```bash
tar -cvf TEMPORAL/empaquetado.tar TEMPORAL/etc
```

**Explicación:**

1.  **`tar -cvf ...`:** Es el comando para empaquetar.
      * `-c`: **C**rear un nuevo archivo.
      * `-v`: **V**erboso (muestra los ficheros que va añadiendo).
      * `-f`: **F**ichero (indica que el siguiente argumento es el nombre del archivo a crear: `TEMPORAL/empaquetado.tar`).
2.  **`TEMPORAL/etc`:** Es el directorio que queremos empaquetar (el que copiamos en el paso 4).

**Nota sobre el enlace blando:** El comando para crear enlaces blandos (simbólicos) es `ln -s`. Este comando **no estaba en ninguna de las listas** que me has dado (ni en los apuntes ni en la lista extra). El comando sería `ln -s TEMPORAL/empaquetado.tar enlace_blando`, pero no puedes usarlo si no te lo han enseñado.

-----

### 6\) Comprime dicho fichero mediante `bzip2` y genera otro `empaquetado.tar.bz2`...

```bash
bzip2 -k TEMPORAL/empaquetado.tar
```

**Explicación:**
(El enunciado del examen pide `bzip2` explícitamente).

1.  **`bzip2`:** El comando compresor.
2.  **`-k`:** Opción **k**eep (conservar). Esto es fundamental, ya que el enunciado pide generar "otro" fichero. Sin `-k`, `bzip2` borraría el `empaquetado.tar` original.
3.  **`TEMPORAL/empaquetado.tar`:** El fichero a comprimir. `bzip2` creará `TEMPORAL/empaquetado.tar.bz2` automáticamente.

-----

### 7\) Muestra por pantalla el número de archivos que contiene este fichero.

```bash
tar -tjf TEMPORAL/empaquetado.tar.bz2 | wc -l
```

**Explicación:**

1.  **`tar -tjf ...`:** Usamos `tar` de nuevo, esta vez para leer.
      * `-t`: **T**abla de contenidos (listar lo que hay dentro).
      * `-j`: Le dice a `tar` que el fichero está comprimido con **bzip2** (la `j` es por b**j**zip2).
      * `-f`: **F**ichero (indica el nombre del archivo a leer).
2.  **`| wc -l`:** Enviamos la lista de ficheros (uno por línea) a `wc -l`, que cuenta el número total de líneas (o sea, de archivos).

-----

### 8\) Muestra... un listado de los ficheros modificados hoy con el formato: `Nombre` `Tamaño` `Fecha`

```bash
echo -e "Nombre\t\tTamaño\tFecha"
find . -type f -mtime 0 -printf "%f\t\t%s\t%Tc\n"
```

**Explicación:**

1.  **`echo -e "Nombre\t\tTamaño\tFecha"`:** Imprime la cabecera. `-e` habilita la interpretación de `\t` como un tabulador para alinear las columnas.
2.  **`find . -type f -mtime 0 ...`:**
      * `find .`: Busca en el directorio actual.
      * `-type f`: Solo ficheros.
      * `-mtime 0`: Busca ficheros modificados en las últimas 24 horas (mod-time 0 = "hoy").
3.  **`-printf "%f\t\t%s\t%Tc\n"`:** Formatea la salida tal como se pide:
      * `%f`: **F**ilename (Nombre).
      * `%s`: **S**ize (Tamaño en bytes).
      * `%Tc`: **T**ime **c**hange (Fecha de modificación completa).
      * `\t\t` y `\n` son los tabuladores y el salto de línea.

-----

### 9\) Borra todo el directorio `TEMPORAL`

```bash
rm -rf TEMPORAL
```

**Explicación:**

1.  **`rm`:** Comando para borrar (remove).
2.  **`-r`:** **R**ecursivo. Necesario para borrar un directorio y todo su contenido.
3.  **`-f`:** **F**orzar. No preguntará confirmación para cada fichero. Es útil aquí porque los ficheros de `/etc` pueden tener permisos especiales que pedirían confirmación.