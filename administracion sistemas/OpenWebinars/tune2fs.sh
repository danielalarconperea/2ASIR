#!/bin/bash

### --- Sección 1: Introducción y Visualización de Parámetros ---

# El comando 'tune2fs' permite modificar los parámetros ajustables del sistema de archivos
# (tunable parameters) en sistemas ext2/ext3/ext4 sin necesidad de reformatear.

# Definimos un dispositivo de ejemplo para los comandos.
# IMPORTANTE: A diferencia de fsck, muchas operaciones de tune2fs se pueden hacer con el disco montado,
# pero cambiar características críticas (como el journal) requiere que esté desmontado.
DISCO_EJEMPLO="/dev/sdX1"

# 1. Listar el contenido del superbloque.
# La flag '-l' (list) es la más usada. Muestra toda la configuración actual:
# UUID, etiqueta, recuento de montajes, intervalos de revisión, bloques reservados, etc.
sudo tune2fs -l $DISCO_EJEMPLO
# -> tune2fs 1.45.5 (07-Jan-2020)
# -> Filesystem volume name:   <none>
# -> Last mounted on:          /mnt/data
# -> Filesystem UUID:          5b298a22-4e33-4a44-9900-123456789abc
# -> Filesystem state:         clean
# -> Errors behavior:          Continue
# -> Filesystem OS type:       Linux
# -> Inode count:              65536
# -> Block count:              262144
# -> Reserved block count:     13107 (5.00%)
# -> ...

### --- Sección 2: Gestión de Espacio Reservado (Root) ---

# Por defecto, Linux reserva el 5% del disco para el usuario root y servicios del sistema.
# En discos modernos de varios TB, el 5% es demasiado espacio desperdiciado.

# La flag '-m' (min_percent) cambia el porcentaje de bloques reservados.
# Aquí lo bajamos al 1% (útil para discos de datos grandes).
sudo tune2fs -m 1 $DISCO_EJEMPLO
# -> tune2fs 1.45.5 (07-Jan-2020)
# -> Setting reserved blocks percentage to 1% (2621 blocks)

# La flag '-r' (reserved_blocks) permite establecer un número exacto de bloques en lugar de un porcentaje.
# Útil si quieres reservar exactamente 0 bloques (no recomendado para partición de sistema).
sudo tune2fs -r 0 $DISCO_EJEMPLO
# -> Setting reserved blocks count to 0

### --- Sección 3: Políticas de Mantenimiento y Chequeo (fsck) ---

# El sistema de archivos fuerza un chequeo (fsck) basándose en tiempo o número de montajes.

# La flag '-c' (count) ajusta el número máximo de montajes antes de forzar un chequeo.
# Establecerlo en 20 significa que tras montar el disco 20 veces, se ejecutará fsck al inicio.
sudo tune2fs -c 20 $DISCO_EJEMPLO
# -> Setting maximal mount count to 20

# Para desactivar el chequeo basado en número de montajes, usamos '-1' o '0'.
sudo tune2fs -c -1 $DISCO_EJEMPLO
# -> Setting maximal mount count to -1

# La flag '-i' (interval) ajusta el tiempo máximo entre chequeos.
# Formato: d (días), m (meses), w (semanas).
# Aquí forzamos un chequeo cada 3 meses.
sudo tune2fs -i 3m $DISCO_EJEMPLO
# -> Setting interval between checks to 7776000 seconds

### --- Sección 4: Identificación y Etiquetas ---

# Cambiar los metadatos para facilitar el montaje en /etc/fstab.

# La flag '-L' (Label) asigna una etiqueta (nombre) al volumen.
# Máximo 16 caracteres.
sudo tune2fs -L "MIS_DATOS" $DISCO_EJEMPLO
# -> (Sin salida, operación silenciosa si tiene éxito)

# La flag '-U' permite cambiar el UUID (Identificador Único Universal).
# Usar 'random' genera uno nuevo aleatorio.
# CUIDADO: Si cambias el UUID, debes actualizar /etc/fstab y GRUB si es el disco de arranque.
sudo tune2fs -U random $DISCO_EJEMPLO
# -> (Sin salida, operación silenciosa)

### --- Sección 5: Comportamiento ante Errores Críticos ---

# La flag '-e' (error_behavior) define qué hace el kernel si detecta corrupción.
# Opciones: 'continue' (seguir), 'remount-ro' (montar solo lectura), 'panic' (kernel panic/reiniciar).

# Configurar para que se ponga en "Solo Lectura" es lo más seguro para servidores.
sudo tune2fs -e remount-ro $DISCO_EJEMPLO
# -> Setting error behavior to 2

### --- Sección 6: Características Avanzadas (Journaling) ---

# tune2fs puede agregar o quitar características del sistema de archivos con la flag '-O'.
# Usamos '^' para quitar una característica y '+' (o nada) para añadirla.

# Ejemplo: Añadir un journal (convierte ext2 en ext3/ext4) para proteger contra cortes de luz.
# Nota: 'has_journal' es la característica.
sudo tune2fs -O has_journal $DISCO_EJEMPLO
# -> Creating journal inode: done

# Ejemplo: Quitar el journal (bajar de ext3/4 a ext2).
# Requiere que el disco esté desmontado.
sudo tune2fs -O ^has_journal $DISCO_EJEMPLO
# -> (Salida confirmando la eliminación del inodo del journal)

### --- Sección 7: Guardado de parámetros de montaje por defecto ---

# La flag '-o' (mount_options) guarda opciones de montaje en el superbloque.
# Así, el disco se montará con estas opciones sin necesidad de especificarlas en /etc/fstab.

# Ejemplo: Añadir soporte de ACLs (listas de control de acceso) y compresión (si aplica).
# Nota: Usar '^' también funciona aquí para negar opciones.
sudo tune2fs -o acl,user_xattr $DISCO_EJEMPLO
# -> (Sin salida, se verifica luego con tune2fs -l)