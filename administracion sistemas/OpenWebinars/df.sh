#!/bin/bash
# Script de Apuntes de Bash: Comando 'df' (Disk Free)
# Propósito: Este script es un recurso de estudio y referencia rápida, optimizado para VSCode.
# Contiene el comando 'df' con ejemplos listos para ejecutar y explicaciones detalladas en comentarios.

### --- Sección 1: Uso Básico del Comando 'df' ---
# 💾 Función: Reporta el espacio de disco utilizado y disponible de los sistemas de archivos montados.
# Es crucial para monitorear la capacidad de almacenamiento y prevenir fallos por falta de espacio.

# Muestra el uso de disco de todos los sistemas de archivos en bloques de 1KB por defecto.
df
# -> Filesystem     1K-blocks     Used Available Use% Mounted on
# -> /dev/sda1      104857600 45873024  58984576  44% /
# -> tmpfs             199464        0    199464   0% /dev/shm
# -> /dev/sdb1       52428800 20971520  31457280  40% /mnt/data

# 📏 Flag Común: '-h' (human-readable)
# Hace que los tamaños de disco se muestren en unidades fáciles de leer (KB, MB, GB, TB).
df -h
# -> Filesystem      Size  Used Avail Use% Mounted on
# -> /dev/sda1        100G   44G   56G  44% /
# -> tmpfs           195M     0  195M   0% /dev/shm
# -> /dev/sdb1         50G   20G   30G  40% /mnt/data

# 📊 Flag Común: '-T' (print-type)
# Muestra el tipo de sistema de archivos (ext4, XFS, tmpfs, etc.), esencial para el diagnóstico.
df -T
# -> Filesystem    Type     1K-blocks     Used Available Use% Mounted on
# -> /dev/sda1     ext4     104857600 45873024  58984576  44% /
# -> tmpfs         tmpfs       199464        0    199464   0% /dev/shm

# 🎯 Mostrar uso de disco para un sistema de archivos o ruta específica.
# Útil para comprobar una partición o punto de montaje en particular.
df -h /home
# -> Filesystem      Size  Used Avail Use% Mounted on
# -> /dev/sda1        100G   44G   56G  44% /

# 💾 Mostrar solo sistemas de archivos locales, excluyendo NFS, CDROM, etc.
# Flag '-l' (local)
df -hl
# -> Filesystem      Size  Used Avail Use% Mounted on
# -> /dev/sda1        100G   44G   56G  44% /

### --- Sección 2: Opciones Avanzadas y Filtros con 'df' ---
# 🚫 Excluir sistemas de archivos por tipo
# Flag '-x' (exclude-type): Útil para ignorar sistemas de archivos virtuales como 'tmpfs' o 'devtmpfs'.
df -h -x tmpfs -x devtmpfs
# -> Filesystem      Size  Used Avail Use% Mounted on
# -> /dev/sda1        100G   44G   56G  44% /
# -> /dev/sdb1         50G   20G   30G  40% /mnt/data

# 🔎 Incluir solo sistemas de archivos por tipo
# Flag '-t' (type): Muestra solo aquellos del tipo especificado, por ejemplo, solo particiones ext4.
df -ht ext4
# -> Filesystem      Size  Used Avail Use% Mounted on
# -> /dev/sda1        100G   44G   56G  44% /
# -> /dev/sdb1         50G   20G   30G  40% /mnt/data

# 📦 Mostrar el uso de Inodos (i-nodes) en lugar de bloques de disco
# Flag '-i' (inodes): Los inodos son estructuras de datos que describen un archivo;
# si se agotan, no se pueden crear nuevos archivos aunque haya espacio en disco.
df -hi
# -> Filesystem      Inodes  IUsed IFree IUse% Mounted on
# -> /dev/sda1         6.3M  1.4M  4.9M   23% /
# -> tmpfs            50K     1  50K    1% /dev/shm

# 🔢 Especificar el tamaño del bloque de salida
# Flag '-B' (block-size): Permite establecer el tamaño del bloque (ej: MB, GB).
# Útil para reportes automatizados que requieren un formato de tamaño específico.
df -B 1M
# -> Filesystem       1M-blocks      Used Available Use% Mounted on
# -> /dev/sda1           102400     44800     57600  44% /
# -> tmpfs                  195         0       195   0% /dev/shm

### --- Sección 3: Automatización y Diagnóstico con 'df' ---
# 🚨 Automatización: Encontrar particiones con más del 90% de uso
# Se usa 'awk' para procesar la salida, seleccionar la columna de uso ('Use%') y filtrar.
# Esta es una técnica común para scripts de monitoreo y alertas.
df -h | awk 'NR>1 && $5 ~ /^[0-9]+%$/ && $5 > "90%" { print "ALERTA: " $6 " está al " $5 }'
# -> (No hay salida si ninguna partición excede el 90%)
# -> ALERTA: /data está al 95% (Ejemplo de salida si se cumple la condición)

# 🔄 Usando 'df' en combinación con 'sort' para identificar la partición más grande
# Se usa '-k' para mantener la salida en 1KB bloques para un sort numérico fiable, luego se convierte a 'human-readable'.
# Se ordena inversamente ('-r') por el segundo campo ('2') que contiene el tamaño en bloques.
df -k | sort -r -k 2 | head -n 2
# -> Filesystem     1K-blocks     Used Available Use% Mounted on
# -> /dev/sda1      104857600 45873024  58984576  44% / (Encabezado + la partición más grande)

# 🧹 Diagnóstico: Mostrar todos los sistemas de archivos (incluyendo los 'pseudo')
# Flag '-a' (all): Muestra sistemas de archivos con 0 bloques, como proc, sysfs, etc.
# Útil para entender qué está montado en un sistema, incluso si no usa espacio en disco real.
df -a -h
# -> Filesystem      Size  Used Avail Use% Mounted on
# -> /dev/sda1        100G   44G   56G  44% /
# -> proc               0     0     0   -  /proc
# -> sysfs              0     0     0   -  /sys
# -> tmpfs           195M     0  195M   0% /dev/shm