#!/bin/bash

# ==============================================================================
# 📘 APUNTES DE BASH: CONSULTA DE INFORMACIÓN DE FICHEROS Y DIRECTORIOS
# ==============================================================================

### --- Sección 1: Comando 'ls' (List List) - Sintaxis Básica y Flags Comunes ---

# 📂 El comando 'ls' es la herramienta fundamental para ver contenidos.
# Sin argumentos, lista los archivos del directorio actual en formato simple.
ls
# -> Documentos  Descargas  script.sh  notas.txt

# 📝 Flag -l (long format): Muestra información detallada.
# Columnas: Permisos | Enlaces | Dueño | Grupo | Tamaño | Fecha Modificación | Nombre
ls -l
# -> -rw-r--r-- 1 usuario grupo 4096 nov 25 10:00 notas.txt

# 👁️ Flag -a (all): Muestra archivos ocultos (los que empiezan por punto).
# Es vital para ver ficheros de configuración como .bashrc o .gitignore.
ls -a
# -> .  ..  .bashrc  .config  Documentos  notas.txt

# 📏 Flag -h (human-readable): Convierte los bytes a formatos legibles (K, M, G).
# Debe usarse junto con -l para tener contexto.
ls -lh
# -> -rw-r--r-- 1 usuario grupo 4.0K nov 25 10:00 notas.txt

### --- Sección 2: Comando 'ls' - Ordenamiento y Visualización Avanzada ---

# ⏱️ Flag -t (time): Ordena por fecha de modificación (el más reciente primero).
# Muy útil para ver qué archivos se han tocado últimamente.
ls -lt
# -> notas_nuevas.txt  notas_viejas.txt  archivo_antiguo.bak

# 🔄 Flag -r (reverse): Invierte el orden de salida.
# Combinado con -t (-ltr), muestra los archivos más recientes al final de la lista
# (justo encima de tu prompt), lo cual es muy ergonómico.
ls -ltr
# -> archivo_antiguo.bak  notas_viejas.txt  notas_nuevas.txt

# 🌲 Flag -R (Recursive): Lista el directorio actual y todos los subdirectorios.
ls -R
# -> ./carpeta1:
# -> archivo1.txt
# -> ./carpeta1/subcarpeta:
# -> archivo2.txt

# 🆔 Flag -i (inode): Muestra el número de inodo (identificador único en el sistema de ficheros).
ls -i notas.txt
# -> 134567 notas.txt

# 🎨 Opciones de visualización extra:
# --group-directories-first: Agrupa carpetas al principio.
# --color=auto: Colorea la salida según el tipo de archivo (común en alias por defecto).
ls -l --group-directories-first --color=auto
# -> drwxr-xr-x 2 user group 4.0K ... Carpetas/
# -> -rw-r--r-- 1 user group 1.2K ... archivo.txt

### --- Sección 3: Comando 'stat' - Metadatos Profundos y Diagnóstico ---

# 🔬 El comando 'ls' se queda corto para detalles técnicos precisos.
# 'stat' muestra toda la metadata del inodo: Acceso (Access), Modificación (Modify), y Cambio (Change).
# Access: Última lectura. Modify: Cambio en contenido. Change: Cambio en metadatos (permisos/nombre).
stat notas.txt
# ->  Fichero: notas.txt
# ->   Tamaño: 25        	Bloques: 8          Bloque E/S: 4096   fichero regular
# -> Dispositivo: 801h/2049d	Inodo: 26245       Enlaces: 1
# -> Acceso: (0644/-rw-r--r--)  Uid: ( 1000/ user)   Gid: ( 1000/ user)
# -> Acceso: 2023-11-25 09:00:00.000000000 +0100
# -> Modif : 2023-11-25 09:30:00.000000000 +0100
# -> Cambio: 2023-11-25 09:30:00.000000000 +0100

# 🛠️ Formateo personalizado con 'stat -c' (útil para scripts y automatización).
# %a: Permisos octales, %n: Nombre, %s: Tamaño en bytes.
stat -c "Permisos: %a | Nombre: %n | Bytes: %s" notas.txt
# -> Permisos: 644 | Nombre: notas.txt | Bytes: 25

### --- Sección 4: Comando 'file' - Identificación de Tipo de Contenido ---

# 🕵️ Bash no confía en las extensiones (.txt, .jpg). 'file' lee la cabecera (magic numbers).
# Determina qué es realmente el archivo.
file script.sh
# -> script.sh: Bourne-Again shell script, ASCII text executable

file imagen_sin_extension
# -> imagen_sin_extension: JPEG image data, JFIF standard 1.01

# 🤖 Flag -i (mime-type): Muestra el tipo MIME, ideal para validaciones en scripts web o subidas.
file -i script.sh
# -> script.sh: text/x-shellscript; charset=utf-8

### --- Sección 5: Comando 'du' - Información de Espacio en Disco ---

# 💾 'du' (Disk Usage) estima el uso de espacio de archivos y directorios.
# Sin flags, muestra el tamaño de cada subdirectorio recursivamente.
du ./proyecto
# -> 4       ./proyecto/logs
# -> 8       ./proyecto/src
# -> 16      ./proyecto

# 📊 Flags comunes para resumen rápido:
# -s (summary): Solo el total, sin listar subcarpetas.
# -h (human): Formato legible (K, M, G).
du -sh ./proyecto
# -> 16K     ./proyecto

### --- Sección 6: Automatización y Diagnóstico (Pipes y Redirecciones) ---

# 🔗 Caso de uso: Contar cuántos archivos hay en el directorio actual.
# ls -1 (uno): Fuerza la salida a una sola columna.
# wc -l: Cuenta líneas.
ls -1 | wc -l
# -> 42

# 🔍 Caso de uso: Encontrar los 3 archivos más grandes en una carpeta.
# du -ah: todos los archivos (a) legible (h).
# sort -rh: ordenar reverso (r) interpretando unidades humanas (h).
# head -n 3: mostrar solo los 3 primeros.
du -ah | sort -rh | head -n 3
# -> 500M    ./video_grande.mp4
# -> 200M    ./backup.zip
# -> 700M    .

# 🛡️ Diagnóstico de fechas completas (Full Time).
# ls por defecto trunca la fecha si es antigua. --full-time muestra precisión de nanosegundos.
# Útil para debuggear problemas de sincronización (rsync, make).
ls --full-time
# -> -rw-r--r-- 1 user group 0 2023-11-25 10:05:32.123456789 +0100 archivo.txt