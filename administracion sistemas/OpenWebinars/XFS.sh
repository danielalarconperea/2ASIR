#!/bin/bash

### --- Sección 1: Creación y Formateo (mkfs.xfs) ---

# XFS brilla por su capacidad de ajuste en el momento de la creación.
# Definimos variables para los ejemplos (Disco y Punto de Montaje).
DISCO="/dev/sdX1"
MONTAJE="/mnt/datos_xfs"

# 1. Creación estándar.
# La flag '-f' fuerza la creación si ya existe un sistema de archivos previo.
sudo mkfs.xfs -f $DISCO
# -> meta-data=/dev/sdX1              isize=512    agcount=4, agsize=65536 blks
# ->          =                       sectsz=512   attr=2, projid32bit=1
# -> data     =                       bsize=4096   blocks=262144, imaxpct=25
# -> ...

# 2. Creación Avanzada para RAID (Optimización de rendimiento).
# XFS debe saber la geometría del RAID subyacente para alinear los datos y evitar penalizaciones de escritura.
# '-d': Opciones de datos.
# 'su': Stripe Unit (tamaño del chunk del RAID, ej. 64k).
# 'sw': Stripe Width (número de discos de datos en el RAID, ej. 4 discos en RAID 5).
sudo mkfs.xfs -f -d su=64k,sw=4 $DISCO
# -> (Salida similar pero indicando "sunit=128 swidth=512")

# 3. Creación con inodos más grandes.
# '-i size=1024': Aumenta el tamaño del inodo. Útil si vas a usar muchos atributos extendidos (SELinux, ACLs complejas).
sudo mkfs.xfs -f -i size=1024 $DISCO
# -> ... isize=1024 ...

### --- Sección 2: Información y Administración de Metadatos (xfs_info, xfs_admin) ---

# Una vez montado, usamos 'xfs_info' para ver la geometría del sistema.
# IMPORTANTE: xfs_info trabaja sobre el PUNTO DE MONTAJE, no el dispositivo.
sudo mount $DISCO $MONTAJE
xfs_info $MONTAJE
# -> meta-data=/dev/sdX1              isize=512    agcount=4, agsize=65536 blks
# -> data     =                       bsize=4096   blocks=262144, imaxpct=25

# 'xfs_admin' permite modificar parámetros sin reformatear (requiere disco DESMONTADO).
sudo umount $MONTAJE

# Cambiar la etiqueta (Label) del disco (-L).
sudo xfs_admin -L "Backups_XFS" $DISCO
# -> writing all SBs
# -> new label = "Backups_XFS"

# Cambiar el UUID (-U) o habilitar Lazy Counters (-c 1) para mejorar rendimiento de montaje.
sudo xfs_admin -U generate -c 1 $DISCO
# -> Clearing log and setting UUID
# -> writing all SBs
# -> new UUID = ...

### --- Sección 3: Redimensionamiento (xfs_growfs) ---

# REGLA CRÍTICA DE XFS:
# 1. Se puede aumentar de tamaño (Grow) en caliente (montado).
# 2. NO SE PUEDE REDUCIR (Shrink). Nunca. Si necesitas reducir, debes reformatear.

# Primero, montamos de nuevo.
sudo mount $DISCO $MONTAJE

# Expandir el sistema de archivos para ocupar todo el espacio disponible en el dispositivo subyacente.
# (Asumimos que agrandaste la partición o el LVM antes de ejecutar esto).
# La flag '-d' indica expandir la sección de datos al máximo.
sudo xfs_growfs -d $MONTAJE
# -> meta-data=/dev/sdX1 ...
# -> data blocks changed from 262144 to 524288

### --- Sección 4: Copias de Seguridad y Restauración (xfsdump, xfsrestore) ---

# XFS tiene sus propias herramientas de backup que preservan atributos extendidos, ACLs y cuotas.
# Son más robustas que 'tar' para este sistema de archivos.

# Instalar herramientas si no están (paquete 'xfsdump').

# Nivel 0: Copia completa (Full Backup).
# '-L': Etiqueta de la sesión (nombre del backup).
# '-M': Etiqueta del medio (nombre de la cinta/disco).
# '-f': Archivo de destino.
sudo xfsdump -l 0 -L "Backup_Total_Enero" -M "Disco_Externo" -f /tmp/backup_full.dump $MONTAJE
# -> xfsdump: using file dump (drive_simple) strategy
# -> xfsdump: level 0 dump of hostname:/mnt/datos_xfs
# -> xfsdump: Dump Status: SUCCESS

# Nivel 1: Copia Incremental (solo lo cambiado desde el nivel 0).
sudo xfsdump -l 1 -L "Backup_Incremental_Dia1" -M "Disco_Externo" -f /tmp/backup_inc.dump $MONTAJE
# -> xfsdump: level 1 dump...

# Restaurar contenido ('xfsrestore').
# '-f': Archivo de origen.
# Directorio final: Dónde se restaurarán los datos.
sudo xfsrestore -f /tmp/backup_full.dump /mnt/restore_dir
# -> xfsrestore: restore Status: SUCCESS

# Ver el inventario de backups realizados.
xfsdump -I
# -> file system 0:
# -> fs id: ...
# -> session 0: level 0, label "Backup_Total_Enero"...

### --- Sección 5: Gestión de Cuotas (xfs_quota) ---

# XFS gestiona cuotas directamente en el kernel, no en archivos como ext4.
# Requiere montar con opciones 'uquota' (usuario), 'gquota' (grupo) o 'pquota' (proyecto).

# Remontar activando cuotas para el ejemplo.
sudo mount -o remount,uquota,pquota $MONTAJE

# Usamos el modo experto (-x) y pasamos comandos (-c).

# 1. Establecer un límite blando (soft) de 100M y duro (hard) de 120M para el usuario 'juan'.
sudo xfs_quota -x -c 'limit bsoft=100m bhard=120m juan' $MONTAJE
# -> (Sin salida si es exitoso)

# 2. Reporte de cuotas.
sudo xfs_quota -x -c 'report -h' $MONTAJE
# -> User quota on /mnt/datos_xfs (/dev/sdX1)
# ->              Blocks
# -> User ID      Used   Soft   Hard  Warn/Grace
# -> ---------- ---------------------------------
# -> root            0      0      0   00 [------]
# -> juan         50M    100M   120M   00 [------]

### --- Sección 6: Mantenimiento y Desfragmentación (xfs_fsr) ---

# Aunque XFS resiste bien la fragmentación, con el tiempo (años) o con bases de datos, puede fragmentarse.

# 'xfs_fsr' (File System Reorganizer) desfragmenta en caliente.
# Sin argumentos, revisa todos los XFS montados y trabaja por 2 horas máximo por defecto.
sudo xfs_fsr
# -> (Salida del proceso de reorganización)

# Desfragmentar un solo archivo específico.
sudo xfs_fsr /mnt/datos_xfs/archivo_gigante.db
# -> extents before: 520, after: 1, DONE ...

### --- Sección 7: Congelado para Snapshots (xfs_freeze) ---

# Útil antes de hacer un snapshot de hardware o LVM para asegurar consistencia de datos.

# Congelar (Suspende toda escritura).
sudo xfs_freeze -f $MONTAJE
# -> (El sistema de archivos ahora es de solo lectura efectiva, las escrituras se bloquean en RAM)

# Descongelar (Permite que las escrituras continúen).
sudo xfs_freeze -u $MONTAJE
# -> (Operación normal restaurada)