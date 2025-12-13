#!/bin/bash
# Script de Apuntes de Bash - Comando 'du' (Disk Usage)
# 
# NOTA IMPORTANTE: Todos los comandos a continuación están descomentados y
# listos para ser ejecutados en tu sistema para pruebas.

### --- Sección 1: Sintaxis Básica y Casos de Uso Comunes del Comando 'du' ---
# El comando 'du' estima el espacio de disco utilizado por archivos y directorios.
# Por defecto, muestra el uso del disco para cada subdirectorio y el directorio actual.
# Se usa para identificar dónde se consume espacio en el sistema de archivos.

# 1.1: Uso Básico - Tamaño del directorio actual y subdirectorios en bloques (por defecto)
du
# -> 4	./.vscode
# -> 108	.

# 1.2: Opción '-h' (Human-readable) - Muestra el tamaño en unidades legibles (K, M, G)
# Es la opción más común y útil para una lectura rápida.
du -h .
# -> 4.0K	./.vscode
# -> 108K	.

# 1.3: Opción '-s' (Summarize) - Muestra solo el total del argumento proporcionado (directorio actual)
# Ideal para saber rápidamente cuánto ocupa un directorio sin listar sus contenidos.
du -sh .
# -> 108K	.

# 1.4: Combinación de '-h' y '-c' (Total) - Muestra el total general de todos los argumentos.
# Útil cuando se evalúan varios directorios o archivos a la vez.
du -ch .
# -> 4.0K	./.vscode
# -> 108K	.
# -> 108K	total

# 1.5: Calcular el tamaño de un directorio específico (e.g., /var/log)
# NOTA: Puede requerir permisos de 'sudo' si /var/log no es accesible para el usuario.
du -sh /var/log
# -> 34M	/var/log


### --- Sección 2: Opciones de Visualización y Exclusión ---
# Estas opciones permiten controlar qué y cómo se muestra la información.

# 2.1: Opción '-a' (All) - Muestra el tamaño de cada archivo, no solo de los directorios.
# Se usa 'head -n 5' para limitar la salida solo a las primeras 5 líneas.
du -ah . | head -n 5
# -> 4.0K	./.vscode/settings.json
# -> 4.0K	./.vscode
# -> 4.0K	./my_script.sh
# -> 4.0K	./file1.txt
# -> 4.0K	./file2.txt

# 2.2: Opción '-d N' (Depth) - Limita la profundidad de la recursión a N niveles.
# Esto previene que 'du' recorra todo el árbol de directorios. N=1 muestra solo subdirectorios de primer nivel.
du -h -d 1 .
# -> 4.0K	./.vscode
# -> 104K	./src
# -> 108K	.

# 2.3: Opción '--exclude=PATRÓN' - Excluye archivos o directorios que coincidan con el patrón.
# Útil para ignorar archivos temporales o de caché (ej: *.log).
du -sh --exclude='*.log' .
# -> 98K	.

# 2.4: Opción '-k' (Kilobytes) - Muestra los tamaños en bloques de 1024 bytes (KB).
# Similar a '-h', pero fuerza la unidad KB para una comparación precisa.
du -k .
# -> 4	./.vscode
# -> 108	.


### --- Sección 3: Usos Avanzados: Automatización, Pipes y Redirecciones ---
# Combinando 'du' con otros comandos como 'sort' o 'grep'.

# 3.1: Encontrar los 10 directorios/archivos más grandes en el directorio actual (Muy común)
# Uso de 'du -a', 'sort -n' (numérico) y 'tail -n 10' para ver los mayores.
du -a . | sort -n | tail -n 10
# -> 56	./src/big_data_file.dat
# -> 108	.
# -> ... (Lista de los 10 mayores)

# 3.2: Listar los 10 directorios más grandes en formato legible
# Uso de 'du -h', 'sort -h' (human-numeric) y 'tail'
du -h . | sort -h | tail -n 10
# -> 4.0K	./.vscode
# -> 8.0K	./src/lib
# -> 20K	./assets
# -> 56K	./src/big_data_file.dat
# -> 108K	.

# 3.3: Encontrar directorios de más de 1 Gigabyte (1G)
# Se usa 'du -h' y luego 'grep' para filtrar la salida. El ejemplo usa el directorio home para probar.
du -h /home | grep 'G'
# -> 3.4G	/home/usuario1
# -> 1.2G	/home/usuario2

# 3.4: Redirigir el resultado resumido a un archivo de registro
# NOTA: Este comando creará o sobrescribirá el archivo 'uso_web.log' en el directorio actual.
du -sh /var/www/html > uso_web.log
# -> El resultado (e.g., 2.1G /var/www/html) se guarda en 'uso_web.log'

### --- Sección 4: Opciones de Diagnóstico y Enlaces Simbólicos ---
# Opciones para manejar errores, enlaces simbólicos y formato de salida.

# 4.1: Opción '-L' (Dereference) - Sigue los enlaces simbólicos.
# Muestra el tamaño del archivo de destino del enlace, no el tamaño del propio enlace (que suele ser 4K).
# NOTA: Necesitas un enlace simbólico existente para probar esto. Se usa una ruta de ejemplo.
du -shL /path/to/symlink_dir
# -> 500M	/path/to/symlink_dir (Muestra el tamaño real del destino)

# 4.2: Opción '-x' (One-file-system) - Solo cuenta archivos en el mismo sistema de archivos.
# Previene que 'du' cruce a sistemas de archivos montados (ej: directorios en NFS o particiones separadas).
du -xh /
# -> Muestra el uso del disco para la partición raíz (/) sin incluir otras particiones montadas.

# 4.3: Opción '--apparent-size' - Muestra el tamaño aparente del archivo (bytes reales), no el espacio en disco que ocupa.
# El tamaño aparente puede ser menor o mayor que el espacio real ocupado debido a la fragmentación o a los archivos dispersos (sparse files).
du -sh --apparent-size .
# -> 90K	. (Puede diferir de 108K)

# 4.4: Opción '-P' (No-dereference) - NO sigue los enlaces simbólicos (comportamiento por defecto).
# Muestra el tamaño del propio enlace simbólico (generalmente 4K). Es el opuesto de '-L'.
# NOTA: Necesitas un enlace simbólico existente para probar esto. Se usa una ruta de ejemplo.
du -shP /path/to/symlink_dir
# -> 4.0K	/path/to/symlink_dir (Muestra el tamaño del enlace)