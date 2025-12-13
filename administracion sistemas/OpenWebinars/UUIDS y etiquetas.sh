#!/bin/bash

### --- Sección 1: Identificación y Visualización de UUIDs y Etiquetas ---

# 📝 Concepto:
# - UUID: Identificador único universal (hexadecimal). Persiste aunque cambies el disco de puerto SATA/USB. Es el método más seguro para montar discos.
# - LABEL (Etiqueta): Nombre legible por humanos asignado a una partición (ej: "Datos", "Backup"). Es más fácil de recordar pero debe ser único manualmente.

# 🔍 Listar todos los dispositivos de bloque mostrando sus sistemas de archivos, UUIDs y Etiquetas.
# La opción '-f' (fs) es crucial para ver estos metadatos específicos.
lsblk -f
# -> NAME   FSTYPE LABEL  UUID                                 MOUNTPOINT
# -> sda
# -> ├─sda1 ext4   Raiz   a1b2c3d4-e5f6-7890-1234-567890abcdef /
# -> └─sda2 swap          11223344-5566-7788-9900-aabbccddeeff [SWAP]
# -> sdb
# -> └─sdb1 ntfs   Datos  1234-5678                            /mnt/datos

# 🔍 Comando clásico para obtener atributos de dispositivos de bloque.
# Muestra TYPE, UUID, LABEL y PARTUUID. Útil para copiar y pegar en /etc/fstab.
blkid
# -> /dev/sda1: LABEL="Raiz" UUID="a1b2c3d4-e5f6-7890-1234-567890abcdef" TYPE="ext4" PARTUUID="000a1b2c-01"
# -> /dev/sdb1: LABEL="Datos" UUID="1234-5678" TYPE="ntfs" PARTUUID="000a1b2c-02"

# 🔍 Filtrar la salida de blkid para buscar un dispositivo específico.
# '-o value' muestra solo el valor, '-s UUID' muestra solo el campo UUID.
blkid -s UUID -o value /dev/sda1
# -> a1b2c3d4-e5f6-7890-1234-567890abcdef

### --- Sección 2: Uso Práctico en Montaje (Mount) ---

# 📂 Montar un sistema de archivos utilizando su UUID.
# Sintaxis: mount -U <uuid> <punto_de_montaje>
# Es preferible sobre '/dev/sdb1' porque el nombre del dispositivo puede cambiar al reiniciar.
# (Nota: Requiere privilegios de root o sudo).
mount -U a1b2c3d4-e5f6-7890-1234-567890abcdef /mnt/mi_disco
# -> (Sin salida si es exitoso, código de retorno 0)

# 📂 Montar un sistema de archivos utilizando su Etiqueta (Label).
# Sintaxis: mount -L <etiqueta> <punto_de_montaje>
# Muy útil para discos externos USB que quieres identificar por nombre ("Backup").
mount -L Datos /mnt/usb
# -> (Sin salida si es exitoso)

# 📄 Visualizar cómo se usan en la configuración de arranque persistente (/etc/fstab).
# Aquí es donde los UUIDs son críticos para evitar fallos de arranque.
grep "UUID" /etc/fstab
# -> UUID=a1b2c3d4-e5f6-7890-1234-567890abcdef /               ext4    errors=remount-ro 0       1
# -> UUID=11223344-5566-7788-9900-aabbccddeeff none            swap    sw              0       0

### --- Sección 3: Búsqueda y Automatización (Scripting) ---

# 🤖 Encontrar un sistema de archivos por etiqueta (útil en scripts de automatización).
# Devuelve la ruta del dispositivo (/dev/sdX) que coincide con la etiqueta.
findfs LABEL=Datos
# -> /dev/sdb1

# 🤖 Encontrar un sistema de archivos por UUID.
# Verifica si un disco específico está conectado antes de intentar una operación.
findfs UUID=a1b2c3d4-e5f6-7890-1234-567890abcdef
# -> /dev/sda1

# 📂 Explorar los enlaces simbólicos creados por el sistema automáticamente.
# Linux mantiene directorios dinámicos que apuntan a los discos por su ID o Label.
ls -l /dev/disk/by-uuid/
# -> total 0
# -> lrwxrwxrwx 1 root root 10 nov 25 09:00 a1b2c3d4... -> ../../sda1
# -> lrwxrwxrwx 1 root root 10 nov 25 09:00 1234-5678 -> ../../sdb1

ls -l /dev/disk/by-label/
# -> total 0
# -> lrwxrwxrwx 1 root root 10 nov 25 09:00 Datos -> ../../sdb1
# -> lrwxrwxrwx 1 root root 10 nov 25 09:00 Raiz -> ../../sda1

### --- Sección 4: Modificación y Gestión (Avanzado) ---

# ⚠️ ¡Cuidado! Cambiar UUIDs en sistemas vivos puede romper el arranque si no actualizas /etc/fstab.

# 🏷️ Cambiar o poner una Etiqueta a un sistema de archivos EXT2/3/4.
# Sintaxis: e2label <dispositivo> <nueva_etiqueta>
e2label /dev/sdb1 NuevoNombre
# -> (Sin salida, cambio inmediato)

# 🆔 Generar un nuevo UUID aleatorio para una partición EXT2/3/4.
# Útil si clonaste un disco con 'dd' y ahora tienes dos discos con el mismo UUID (conflicto).
uuidgen # Genera un string UUID válido para usar
# -> 550e8400-e29b-41d4-a716-446655440000

# Aplicar un nuevo UUID a una partición (El sistema de archivos debe estar desmontado).
tune2fs -U random /dev/sdb1
# -> tune2fs 1.45.5 (07-Jan-2020)
# -> Setting the file system UUID to 550e8400-e29b-41d4-a716-446655440000

# 🆔 Para sistemas de archivos XFS (común en RHEL/CentOS), se usa xfs_admin.
# xfs_admin -U generate /dev/sdb1
# -> (Salida específica de herramientas XFS)

# 🆔 Para sistemas de archivos Swap (Intercambio).
# mkswap -U <uuid> /dev/sdX (Al formatear) o cambiarlo después.
swaplabel -L MiSwap /dev/sda2
# -> (Sin salida, etiqueta cambiada)