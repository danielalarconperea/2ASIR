#!/bin/bash

# ==============================================================================
# APUNTES DE BASH: GESTIÓN Y ANÁLISIS DE DISCO
# Archivo: apuntes_uso_disco.sh
# Propósito: Guía exhaustiva de comandos para analizar almacenamiento.
# ==============================================================================

### --- Sección 1: Comando 'df' (Disk Free) - Sistema de Archivos ---
# El comando 'df' reporta el uso del espacio en disco del sistema de archivos.
# Es la herramienta principal para ver cuánto espacio queda libre en las particiones montadas.

# 1.1 Uso Básico y Legibilidad Humana
# Por defecto, 'df' muestra bloques de 1K. Usamos '-h' (human-readable) para ver G (Giga), M (Mega).
echo "--- 1.1 df: Salida legible ---"
df -h
# -> Filesystem      Size  Used Avail Use% Mounted on
# -> /dev/sda1        50G   25G   25G  50% /
# -> tmpfs           4.0G     0  4.0G   0% /sys/fs/cgroup

# 1.2 Mostrar tipos de Sistema de Archivos
# La flag '-T' (Type) muestra si es ext4, xfs, tmpfs, nfs, etc.
# Útil para distinguir discos físicos de sistemas en memoria o red.
echo "--- 1.2 df: Tipos de FS ---"
df -hT
# -> Filesystem     Type      Size  Used Avail Use% Mounted on
# -> /dev/sda1      ext4       50G   25G   25G  50% /

# 1.3 Información sobre Inodos (Crucial para troubleshooting)
# A veces el disco no está lleno en espacio (GB), pero sí en inodos (cantidad de archivos).
# La flag '-i' muestra el uso de inodos.
echo "--- 1.3 df: Uso de Inodos ---"
df -i
# -> Filesystem      Inodes IUsed   IFree IUse% Mounted on
# -> /dev/sda1      3276800 150000 3126800    5% /

# 1.4 Filtrado y Totales
# '--total': Agrega una fila al final con la suma de todo.
# '-t ext4': Muestra solo sistemas de archivos de tipo ext4.
# '-x tmpfs': Excluye sistemas de archivos temporales (limpia la visualización).
echo "--- 1.4 df: Totales y Exclusiones ---"
df -h --total -x tmpfs -x devtmpfs
# -> Filesystem      Size  Used Avail Use% Mounted on
# -> /dev/sda1        50G   25G   25G  50% /
# -> total            50G   25G   25G  50% -

# 1.5 Personalización de Salida
# '--output': Permite seleccionar columnas específicas.
# Opciones: source, fstype, itotal, iused, avail, pcent, target.
echo "--- 1.5 df: Columnas personalizadas ---"
df -h --output=source,pcent,target
# -> Filesystem      Use% Mounted on
# -> /dev/sda1        50% /

### --- Sección 2: Comando 'du' (Disk Usage) - Directorios y Archivos ---
# El comando 'du' estima el espacio usado por archivos y directorios.
# Es recursivo por defecto.

# 2.1 Resumen de un directorio (Lo más usado)
# '-s' (summarize): Muestra solo el total del argumento, no el desglose interno.
# '-h' (human-readable): Muestra K, M, G.
echo "--- 2.1 du: Resumen del directorio actual ---"
du -sh .
# -> 150M    .

# 2.2 Control de Profundidad
# Si quieres ver qué carpetas ocupan más pero solo en el primer nivel.
# '--max-depth=N': Nivel de recursividad a mostrar.
# '-c': Muestra un 'total' al final.
echo "--- 2.2 du: Primer nivel de subdirectorios ---"
du -h -c --max-depth=1 .
# -> 50M     ./imagenes
# -> 100M    ./videos
# -> 150M    .
# -> 150M    total

# 2.3 Uso Avanzado: Ordenar por tamaño (Diagnóstico de espacio)
# Combinación con 'sort' para encontrar los directorios más pesados.
# 'du -ah': '-a' (all) incluye archivos, no solo directorios.
# 'sort -rh': '-r' (reverse), '-h' (human-numeric-sort, entiende 1G > 500M).
# 'head -n 5': Muestra solo el top 5.
echo "--- 2.3 du + sort: Top 5 elementos más pesados ---"
# Nota: Usamos stderr redireccionado (2>/dev/null) para evitar errores de permiso.
du -ah . 2>/dev/null | sort -rh | head -n 5
# -> 150M    .
# -> 100M    ./videos/pelicula.mp4
# -> 100M    ./videos
# -> 50M     ./imagenes
# -> 10M     ./imagenes/foto_raw.tiff

# 2.4 Exclusión de patrones
# '--exclude': Ignora archivos que coincidan con el patrón.
# Útil para medir proyectos de código ignorando 'node_modules' o '.git'.
echo "--- 2.4 du: Excluyendo archivos ocultos ---"
du -sh --exclude=".*" .
# -> 140M    .

# 2.5 Uso con Marcas de Tiempo
# '--time': Muestra la fecha de última modificación del archivo/directorio junto al tamaño.
echo "--- 2.5 du: Con fecha de modificación ---"
du -sh --time .
# -> 150M    2023-10-27 10:00    .

### --- Sección 3: Comando 'lsblk' (List Block Devices) - Estructura de Dispositivos ---
# Muestra información sobre todos los dispositivos de bloque (discos duros, SSD, USB)
# y su estructura de árbol (particiones). No requiere sudo para ver, pero sí para detalles.

# 3.1 Vista de Árbol Básica
# Muestra nombre, número mayor:menor, si es removible (RM), tamaño, solo lectura (RO), tipo y punto de montaje.
echo "--- 3.1 lsblk: Árbol de dispositivos ---"
lsblk
# -> NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
# -> sda      8:0    0    50G  0 disk 
# -> └─sda1   8:1    0    50G  0 part /

# 3.2 Información de Sistema de Archivos y UUID
# '-f' (fs): Muestra el tipo de sistema de archivos (ext4, swap) y el UUID (identificador único).
# Fundamental para configurar /etc/fstab.
echo "--- 3.2 lsblk: UUID y Filesystems ---"
lsblk -f
# -> NAME   FSTYPE LABEL UUID                                 MOUNTPOINT
# -> sda                                                      
# -> └─sda1 ext4   root  1234-5678-90ab-cdef                  /

# 3.3 Información de Topología y Bytes
# '-b': Muestra el tamaño en bytes exactos (útil para scripts).
# '-o': Output columns específicas (NAME, SIZE, MODEL, SERIAL).
echo "--- 3.3 lsblk: Columnas específicas ---"
lsblk -o NAME,SIZE,MODEL,TYPE
# -> NAME    SIZE MODEL            TYPE
# -> sda      50G QEMU HARDDISK    disk
# -> └─sda1   50G                  part

# 3.4 Formato JSON (Automatización)
# '-J': Salida en JSON. Ideal para parsear con herramientas como 'jq' en scripts complejos.
echo "--- 3.4 lsblk: Salida JSON ---"
lsblk -J
# -> {
# ->    "blockdevices": [
# ->       {"name": "sda", "size": "50G", "type": "disk", "children": [ ... ]}
# ->    ]
# -> }

### --- Sección 4: Comandos de Diagnóstico Profundo y Otros ---

# 4.1 Comando 'stat' (Estado de archivo/FS)
# Proporciona información de bajo nivel sobre inodos, bloques y fechas.
# '-f': Muestra el estado del sistema de archivos en lugar del archivo.
echo "--- 4.1 stat: Info del FileSystem ---"
stat -f .
# ->   File: "."
# ->     ID: 80100000000 Namelen: 255     Type: ext2/ext3
# -> Block size: 4096       Fundamental block size: 4096
# -> Blocks: Total: 13107200   Free: 6553600    Available: 6000000
# -> Inodes: Total: 3276800    Free: 3126800

# 4.2 Buscar archivos grandes (find + du)
# Si 'du' es demasiado ruidoso, usamos 'find' para localizar archivos > 100MB.
# '-type f': Solo archivos.
# '-size +100M': Mayores a 100 Megabytes.
# '-exec': Ejecuta 'ls -lh' sobre los resultados.
echo "--- 4.2 find: Buscar archivos > 100MB ---"
find . -type f -size +100M -exec ls -lh {} \; 2>/dev/null
# -> -rw-r--r-- 1 user user 150M Oct 27 10:00 ./videos/pelicula_hd.mkv

# 4.3 NCDU (Nota Informativa)
# Si está instalado, 'ncdu' es una versión interactiva de 'du' basada en ncurses.
# Permite navegar por carpetas y borrar archivos interactivamente.
if command -v ncdu &> /dev/null; then
    echo "--- 4.3 ncdu está instalado: Ejecútalo para análisis interactivo ---"
    # ncdu
else
    echo "--- 4.3 ncdu no instalado (Recomendado: sudo apt install ncdu) ---"
fi
# -> (Abre una interfaz gráfica en terminal para navegar directorios por tamaño)






# ==============================================================================
# APUNTES DE BASH: GESTIÓN Y ANÁLISIS DE DISCO
# Archivo: apuntes_uso_disco.sh
# Propósito: Guía exhaustiva de comandos para analizar almacenamiento.
# ==============================================================================

### --- Sección 1: Comando 'df' (Disk Free) - Sistema de Archivos ---
# El comando 'df' reporta el uso del espacio en disco del sistema de archivos.
# Es la herramienta principal para ver cuánto espacio queda libre en las particiones montadas.

# 1.1 Uso Básico y Legibilidad Humana
# Por defecto, 'df' muestra bloques de 1K. Usamos '-h' (human-readable) para ver G (Giga), M (Mega).
echo "--- 1.1 df: Salida legible ---"
df -h
# -> Filesystem      Size  Used Avail Use% Mounted on
# -> /dev/sda1        50G   25G   25G  50% /
# -> tmpfs           4.0G     0  4.0G   0% /sys/fs/cgroup

# 1.2 Mostrar tipos de Sistema de Archivos
# La flag '-T' (Type) muestra si es ext4, xfs, tmpfs, nfs, etc.
# Útil para distinguir discos físicos de sistemas en memoria o red.
echo "--- 1.2 df: Tipos de FS ---"
df -hT
# -> Filesystem     Type      Size  Used Avail Use% Mounted on
# -> /dev/sda1      ext4       50G   25G   25G  50% /

# 1.3 Información sobre Inodos (Crucial para troubleshooting)
# A veces el disco no está lleno en espacio (GB), pero sí en inodos (cantidad de archivos).
# La flag '-i' muestra el uso de inodos.
echo "--- 1.3 df: Uso de Inodos ---"
df -i
# -> Filesystem      Inodes IUsed   IFree IUse% Mounted on
# -> /dev/sda1      3276800 150000 3126800    5% /

# 1.4 Filtrado y Totales
# '--total': Agrega una fila al final con la suma de todo.
# '-t ext4': Muestra solo sistemas de archivos de tipo ext4.
# '-x tmpfs': Excluye sistemas de archivos temporales (limpia la visualización).
echo "--- 1.4 df: Totales y Exclusiones ---"
df -h --total -x tmpfs -x devtmpfs
# -> Filesystem      Size  Used Avail Use% Mounted on
# -> /dev/sda1        50G   25G   25G  50% /
# -> total            50G   25G   25G  50% -

# 1.5 Personalización de Salida
# '--output': Permite seleccionar columnas específicas.
# Opciones: source, fstype, itotal, iused, avail, pcent, target.
echo "--- 1.5 df: Columnas personalizadas ---"
df -h --output=source,pcent,target
# -> Filesystem      Use% Mounted on
# -> /dev/sda1        50% /

### --- Sección 2: Comando 'du' (Disk Usage) - Directorios y Archivos ---
# El comando 'du' estima el espacio usado por archivos y directorios.
# Es recursivo por defecto.

# 2.1 Resumen de un directorio (Lo más usado)
# '-s' (summarize): Muestra solo el total del argumento, no el desglose interno.
# '-h' (human-readable): Muestra K, M, G.
echo "--- 2.1 du: Resumen del directorio actual ---"
du -sh .
# -> 150M    .

# 2.2 Control de Profundidad
# Si quieres ver qué carpetas ocupan más pero solo en el primer nivel.
# '--max-depth=N': Nivel de recursividad a mostrar.
# '-c': Muestra un 'total' al final.
echo "--- 2.2 du: Primer nivel de subdirectorios ---"
du -h -c --max-depth=1 .
# -> 50M     ./imagenes
# -> 100M    ./videos
# -> 150M    .
# -> 150M    total

# 2.3 Uso Avanzado: Ordenar por tamaño (Diagnóstico de espacio)
# Combinación con 'sort' para encontrar los directorios más pesados.
# 'du -ah': '-a' (all) incluye archivos, no solo directorios.
# 'sort -rh': '-r' (reverse), '-h' (human-numeric-sort, entiende 1G > 500M).
# 'head -n 5': Muestra solo el top 5.
echo "--- 2.3 du + sort: Top 5 elementos más pesados ---"
# Nota: Usamos stderr redireccionado (2>/dev/null) para evitar errores de permiso.
du -ah . 2>/dev/null | sort -rh | head -n 5
# -> 150M    .
# -> 100M    ./videos/pelicula.mp4
# -> 100M    ./videos
# -> 50M     ./imagenes
# -> 10M     ./imagenes/foto_raw.tiff

# 2.4 Exclusión de patrones
# '--exclude': Ignora archivos que coincidan con el patrón.
# Útil para medir proyectos de código ignorando 'node_modules' o '.git'.
echo "--- 2.4 du: Excluyendo archivos ocultos ---"
du -sh --exclude=".*" .
# -> 140M    .

# 2.5 Uso con Marcas de Tiempo
# '--time': Muestra la fecha de última modificación del archivo/directorio junto al tamaño.
echo "--- 2.5 du: Con fecha de modificación ---"
du -sh --time .
# -> 150M    2023-10-27 10:00    .

### --- Sección 3: Comando 'lsblk' (List Block Devices) - Estructura de Dispositivos ---
# Muestra información sobre todos los dispositivos de bloque (discos duros, SSD, USB)
# y su estructura de árbol (particiones). No requiere sudo para ver, pero sí para detalles.

# 3.1 Vista de Árbol Básica
# Muestra nombre, número mayor:menor, si es removible (RM), tamaño, solo lectura (RO), tipo y punto de montaje.
echo "--- 3.1 lsblk: Árbol de dispositivos ---"
lsblk
# -> NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
# -> sda      8:0    0    50G  0 disk 
# -> └─sda1   8:1    0    50G  0 part /

# 3.2 Información de Sistema de Archivos y UUID
# '-f' (fs): Muestra el tipo de sistema de archivos (ext4, swap) y el UUID (identificador único).
# Fundamental para configurar /etc/fstab.
echo "--- 3.2 lsblk: UUID y Filesystems ---"
lsblk -f
# -> NAME   FSTYPE LABEL UUID                                 MOUNTPOINT
# -> sda                                                      
# -> └─sda1 ext4   root  1234-5678-90ab-cdef                  /

# 3.3 Información de Topología y Bytes
# '-b': Muestra el tamaño en bytes exactos (útil para scripts).
# '-o': Output columns específicas (NAME, SIZE, MODEL, SERIAL).
echo "--- 3.3 lsblk: Columnas específicas ---"
lsblk -o NAME,SIZE,MODEL,TYPE
# -> NAME    SIZE MODEL            TYPE
# -> sda      50G QEMU HARDDISK    disk
# -> └─sda1   50G                  part

# 3.4 Formato JSON (Automatización)
# '-J': Salida en JSON. Ideal para parsear con herramientas como 'jq' en scripts complejos.
echo "--- 3.4 lsblk: Salida JSON ---"
lsblk -J
# -> {
# ->    "blockdevices": [
# ->       {"name": "sda", "size": "50G", "type": "disk", "children": [ ... ]}
# ->    ]
# -> }

### --- Sección 4: Comandos de Diagnóstico Profundo y Otros ---

# 4.1 Comando 'stat' (Estado de archivo/FS)
# Proporciona información de bajo nivel sobre inodos, bloques y fechas.
# '-f': Muestra el estado del sistema de archivos en lugar del archivo.
echo "--- 4.1 stat: Info del FileSystem ---"
stat -f .
# ->   File: "."
# ->     ID: 80100000000 Namelen: 255     Type: ext2/ext3
# -> Block size: 4096       Fundamental block size: 4096
# -> Blocks: Total: 13107200   Free: 6553600    Available: 6000000
# -> Inodes: Total: 3276800    Free: 3126800

# 4.2 Buscar archivos grandes (find + du)
# Si 'du' es demasiado ruidoso, usamos 'find' para localizar archivos > 100MB.
# '-type f': Solo archivos.
# '-size +100M': Mayores a 100 Megabytes.
# '-exec': Ejecuta 'ls -lh' sobre los resultados.
echo "--- 4.2 find: Buscar archivos > 100MB ---"
find . -type f -size +100M -exec ls -lh {} \; 2>/dev/null
# -> -rw-r--r-- 1 user user 150M Oct 27 10:00 ./videos/pelicula_hd.mkv

# 4.3 NCDU (Nota Informativa)
# Si está instalado, 'ncdu' es una versión interactiva de 'du' basada en ncurses.
# Permite navegar por carpetas y borrar archivos interactivamente.
if command -v ncdu &> /dev/null; then
    echo "--- 4.3 ncdu está instalado: Ejecútalo para análisis interactivo ---"
    # ncdu
else
    echo "--- 4.3 ncdu no instalado (Recomendado: sudo apt install ncdu) ---"
fi
# -> (Abre una interfaz gráfica en terminal para navegar directorios por tamaño)