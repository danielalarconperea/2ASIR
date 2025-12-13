#!/bin/bash

# --- Btrfs (B-tree File System) ---
# Btrfs es un sistema de archivos moderno con características Copy-on-Write (CoW).
# Es conocido por sus instantáneas (snapshots), subvolúmenes, compresión transparente
# y gestión de volúmenes múltiples (RAID nativo).

### --- Sección 1: Crear y Montar un Sistema de Archivos Btrfs ---

# Comando para crear un nuevo sistema de archivos Btrfs en un dispositivo (ej: /dev/sdb).
# La opción '-f' fuerza la creación si ya existe un sistema de archivos.
# El sistema de archivos se crea con las características por defecto y el perfil DUP/single.
mkfs.btrfs -f /dev/sdb
# -> btrfs-progs vX.Y.Z
# -> See http://btrfs.wiki.kernel.org for more information.
# -> Turning warnings into errors due to bad sector count.
# -> Label: 
# -> UUID: XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX

# Comando básico para montar el sistema de archivos Btrfs.
# Típicamente se usa la opción 'defaults' y se especifica el punto de montaje.
mount /dev/sdb /mnt/btrfs_data
# -> (No hay salida visible si es exitoso. Verifica con 'mount' o 'df -h')

# Para desmontar el sistema de archivos (ejemplo).
umount /mnt/btrfs_data
# -> (No hay salida visible si es exitoso)

### --- Sección 2: Gestión de Subvolúmenes (Subvolumes) ---

# Los subvolúmenes actúan como puntos de montaje separados dentro de un FS Btrfs.
# Son la base de las instantáneas. Se crean dentro del punto de montaje principal.
btrfs subvolume create /mnt/btrfs_data/home_backup
# -> Create subvolume '/mnt/btrfs_data/home_backup'

# Listar todos los subvolúmenes existentes, mostrando su ID y ruta.
btrfs subvolume list /mnt/btrfs_data
# -> ID 256 gen 10 top level 5 path home_backup
# -> ID 257 gen 12 top level 5 path snapshots

# Montar un subvolumen específico. Se utiliza la opción '-o subvol=' en el montaje.
mount -o subvol=home_backup /dev/sdb /mnt/home
# -> (Monta solo el subvolumen 'home_backup' en /mnt/home)

# Eliminar un subvolumen. Requiere que no esté montado.
btrfs subvolume delete /mnt/btrfs_data/old_data
# -> Delete subvolume (commit): /mnt/btrfs_data/old_data

### --- Sección 3: Instantáneas (Snapshots) de Btrfs ---

# Una instantánea (snapshot) es una copia de solo lectura (RO) o de escritura (RW) de un subvolumen.
# Gracias a CoW, es instantánea y no consume espacio inicial.
# Crear una instantánea de solo lectura (útil para copias de seguridad estables).
btrfs subvolume snapshot -r /mnt/btrfs_data/home_backup /mnt/btrfs_data/snapshots/home_20251125_ro
# -> Create a readonly snapshot of '/mnt/btrfs_data/home_backup' in '/mnt/btrfs_data/snapshots/home_20251125_ro'

# Crear una instantánea de lectura/escritura (útil para probar cambios y luego hacer rollback).
btrfs subvolume snapshot /mnt/btrfs_data/home_backup /mnt/btrfs_data/snapshots/home_20251125_rw
# -> Create a writable snapshot of '/mnt/btrfs_data/home_backup' in '/mnt/btrfs_data/snapshots/home_20251125_rw'

### --- Sección 4: Mantenimiento y Diagnóstico ---

# Comprobar el estado del sistema de archivos, incluyendo información sobre el espacio usado
# por metadatos, datos y sistema. Es crucial para ver cómo Btrfs organiza el espacio.
btrfs filesystem df /mnt/btrfs_data
# -> Data, single: total=1.00GiB, used=500MiB
# -> System, DUP: total=32.00MiB, used=1.25MiB
# -> Metadata, DUP: total=128.00MiB, used=12.00MiB
# -> GlobalReserve, single: total=16.00MiB, used=0.00MiB

# Mostrar la estructura de uso de espacio y dispositivos. Útil para entornos RAID.
btrfs filesystem show /dev/sdb
# -> Label: 'data_volume'  uuid: XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
# -> 	Total devices 1 FS bytes used 513.25MiB
# -> 	devid 1 size 2.00GiB used 1.15GiB path /dev/sdb

# Optimizar la distribución del espacio libre y equilibrar chunks de datos.
# Es recomendado después de eliminar grandes cantidades de datos o subvolúmenes.
# La opción '-dusage' balancea los chunks de datos.
btrfs balance start -dusage=50 /mnt/btrfs_data
# -> Done, had 5 chunks balanced.
# -> (Puede ser un proceso largo dependiendo del tamaño del FS)

# Limpieza y deduplicación (con 'defrag').
# La opción '-r' es para hacerlo recursivamente, y '-v' para modo verbose (diagnóstico).
# No es deduplicación real, sino una desfragmentación con reasignación.
btrfs filesystem defrag -r -v /mnt/btrfs_data
# -> /mnt/btrfs_data/file1: de-fragmented, 1 extents saved
# -> /mnt/btrfs_data/dir/file2: de-fragmented, 0 extents saved

### --- Sección 5: Configuración Avanzada y Automatización (btrfs send/receive) ---

# btrfs send/receive permite enviar las diferencias entre dos instantáneas a otro lugar,
# lo que es ideal para copias de seguridad incrementales eficientes.

# 1. Crear la instantánea base (lectura/escritura).
btrfs subvolume snapshot /mnt/btrfs_data/data /mnt/btrfs_data/snaps/base
# -> Create a writable snapshot...

# 2. Crear la instantánea incremental más reciente.
btrfs subvolume snapshot /mnt/btrfs_data/data /mnt/btrfs_data/snaps/increment_1
# -> Create a writable snapshot...

# 3. Envío de la instantánea base (pipe a gzip y ssh para compresión y transmisión).
# Uso de '-' como dispositivo de salida para enviar a stdout, que es redirigido.
btrfs send /mnt/btrfs_data/snaps/base | gzip > /mnt/usb_backup/base_backup.gz
# -> At commit 98: Done.

# 4. Envío Incremental: La opción '-p' indica la instantánea padre.
# Esto solo envía las diferencias entre 'increment_1' y 'base'.
btrfs send -p /mnt/btrfs_data/snaps/base /mnt/btrfs_data/snaps/increment_1 | ssh user@remote_server "btrfs receive /backup/data"
# -> At commit 100: Done.
# -> (El servidor remoto recibe y reconstruye la instantánea incremental)

# 5. Diagnóstico de envíos: Usar el comando 'send' sin redirección para ver el flujo.
btrfs send -v /mnt/btrfs_data/snaps/base
# -> open_base base
# -> clone snap/file1
# -> update_extent snap/file2
# -> At commit 98: Done.

### --- Sección 6: Mantenimiento del Sistema de Archivos ---

# Comando para comprobar la integridad del FS (offline check).
# Requiere que el FS esté desmontado. La opción 'check' escanea y repara errores.
btrfs check /dev/sdb
# -> Opening filesystem to check...
# -> Checking filesystem structure (0%)...
# -> Found 1 FS errors.

# Comando para reparar el sistema de archivos (si 'check' encuentra errores).
# Úsalo con extrema precaución y siempre después de hacer una copia de seguridad.
btrfs check --repair /dev/sdb
# -> Starting repair. This can be dangerous...
# -> Repair finished successfully.