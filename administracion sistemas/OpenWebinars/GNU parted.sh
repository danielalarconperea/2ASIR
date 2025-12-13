#!/bin/bash
# Script de Apuntes de Bash - GNU PARTED
# Creado para documentación y estudio de comandos.
# Los comandos están listos para ejecutarse (sin comentar).

### --- Sección 1: Introducción y Sintaxis Básica de PARTED ---
#
# GNU Parted es una herramienta de línea de comandos para manipular tablas de particiones.
# A diferencia de fdisk, parted soporta particiones de más de 2 TiB y se usa comúnmente
# para trabajar con tablas GPT, aunque también soporta MBR.
# Su sintaxis básica es: parted [opciones] [DISPOSITIVO [COMANDO [ARGUMENTOS...]]]
#
# Uso más común: parted /dev/sdX, para entrar en modo interactivo.
# Uso directo de comandos (modo no interactivo) es ideal para scripts de automatización.

# Muestra la versión de parted instalada. Flag -v es una opción estándar.
parted -v
# -> parted (GNU parted) 3.5
# -> Copyright (C) 2021 Free Software Foundation, Inc.
# -> ... (el resultado variará según la versión)

# Muestra la tabla de particiones actual del primer disco duro (ejemplo: /dev/sda).
# El comando 'print' se ejecuta directamente sin entrar en modo interactivo.
# IMPORTANTE: Reemplaza /dev/sdX por tu disco real (ej. /dev/sda, /dev/vda, /dev/nvme0n1).
# El resultado incluye información de la tabla (msdos, gpt), tamaño del disco, y lista de particiones.
parted /dev/sda print
# -> Modelo: ATA VBOX HARDDISK (scsi)
# -> Disco /dev/sda: 21.5GB
# -> Tamaño de sector (lógico/físico): 512B/512B
# -> Tabla de particiones: gpt
# -> Banderas de disco:
# ->
# -> Número  Inicio  Fin     Tamaño  Sistema de archivos  Nombre  Banderas
# -> 1       1049kB  21.5GB  21.5GB  ext4                 primary

# Muestra la información de las particiones con un formato de salida más amigable
# y legible para humanos (unidades más grandes).
parted /dev/sda unit MiB print
# -> Modelo: ATA VBOX HARDDISK (scsi)
# -> Disco /dev/sda: 20480MiB
# -> Tamaño de sector (lógico/físico): 512B/512B
# -> Tabla de particiones: gpt
# -> ... (la salida usa MiB/GiB en lugar de B/KB)


### --- Sección 2: Creación, Eliminación y Manipulación de Particiones ---
#
# PARTED es peligroso; los comandos se ejecutan inmediatamente.
# La flag '-s' (silent) se usa para modo no interactivo/scripting.
# La flag '-a opt' (alignment) se usa para alinear particiones a límites óptimos.

# 2.1. Configurar la Etiqueta de Disco (Tabla de Particiones)
# Establece una nueva tabla de particiones 'gpt' en el disco /dev/sdX (peligroso, borra todo).
parted -s /dev/sdX mklabel gpt
# -> (No hay salida si es exitoso con -s)

# 2.2. Crear una Nueva Partición Primaria (GPT)
# Sintaxis: mkpart [nombre] [sistema de archivos] inicio fin
# Crea una partición EXT4 llamada 'DATOS' que comienza en 1MiB y termina en 10GiB.
# PARTED crea la entrada en la tabla; el formato (mkfs) debe hacerse después.
parted -s -a opt /dev/sdX mkpart DATOS ext4 1MiB 10GiB
# -> (No hay salida si es exitoso con -s)

# 2.3. Eliminar una Partición
# Sintaxis: rm NÚMERO
# Elimina la partición con el número 2.
parted -s /dev/sdX rm 2
# -> (No hay salida si es exitoso con -s)

# 2.4. Redimensionar una Partición
# Sintaxis: resizepart NÚMERO FIN_NUEVO
# Redimensiona la partición 1 para que termine en el final del disco (porcentaje).
# Esto puede ser complejo y depende de si el FS está montado o soporta resizable.
# Mover el inicio requiere desmontar el FS y usar herramientas externas como resize2fs.
parted -s /dev/sdX resizepart 1 100%
# -> (No hay salida si es exitoso con -s)


### --- Sección 3: Funcionalidades Avanzadas y Diagnóstico ---
#
# Usos avanzados que son cruciales para la automatización de la configuración de discos.

# 3.1. Obtener Información Específica del Disco (Machine Readable Output)
# La flag '-m' (machine readable) es esencial para el scripting, proporcionando
# una salida estándar (CSV) que es fácil de parsear con herramientas como 'awk' o 'cut'.
parted -m /dev/sda print
# -> /dev/sda:21.5GB:scsi:512:512:gpt:ATA VBOX HARDDISK:;
# -> 1:1049kB:21.5GB:21.5GB:ext4::primary:;

# 3.2. Verificar una Partición (check)
# El comando 'check NÚMERO' verifica si el sistema de archivos de la partición es válido.
# Esto no reemplaza a 'fsck', sino que verifica la consistencia de la partición en la tabla.
# Nota: La utilidad 'check' ha sido marcada como obsoleta y se recomienda usar herramientas
# específicas del sistema de archivos (ej. e2fsck, xfs_repair).
parted /dev/sda check 1
# -> Error: La partición está ocupada. Desmontarla antes de verificar.
# -> (Si es exitoso: 'Error: La partición 1 no tiene errores')

# 3.3. Configurar Banderas (Flags) de Partición
# Sintaxis: set NÚMERO BANDERA [on|off]
# La bandera 'boot' (arranque) es crucial para las particiones de arranque (MBR/Legacy BIOS).
# En GPT, se usa la bandera 'esp' (EFI System Partition) para el arranque UEFI.
# Activa la bandera 'boot' en la partición 1 (ej. para un sistema MBR o legacy).
parted -s /dev/sda set 1 boot on
# -> (No hay salida si es exitoso con -s)

# 3.4. Uso en Scripting (Automatización con Redirección y Pipes)
# Ejemplo de script de aprovisionamiento: crea tabla GPT, crea partición, establece bandera.
# Nota: /dev/sdb es un ejemplo de disco nuevo que no debe tener datos importantes.
# Se usa 'mkpart primary' para compatibilidad, sin especificar FS.
# El comando 'mkpart' requiere que se especifique el tipo ('primary', 'logical', 'extended').
parted -s /dev/sdb \
  mklabel gpt \
  mkpart primary ext4 0% 100% \
  set 1 lvm on
# -> (No hay salida. El disco /dev/sdb ahora tiene una única partición GPT lista para LVM).
# El comando 'parted -s /dev/sdb print' mostraría la nueva estructura.

# Ejemplo de diagnóstico: Usar '-m' con 'grep' para obtener el tamaño del disco.
parted -m /dev/sda print | grep '^/dev' | cut -d ':' -f 2
# -> 21.5GB