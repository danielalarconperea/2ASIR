#!/bin/bash
# -------------------------------------------------------------------------------------
# Apuntes de Bash: Herramienta fsck (File System Check and Repair)
# Creado para estudio y referencia rápida en VSCode.
# -------------------------------------------------------------------------------------

### --- Sección 1: Sintaxis Básica y Uso Común de fsck ---

# 💻 Función: fsck se usa para verificar y reparar sistemas de archivos de Linux (y otros)
# ⚙️ Uso: Típicamente se ejecuta sobre un dispositivo de bloque (partición) **desmontado**.
# ⚠️ ¡ADVERTENCIA! Nunca ejecutes fsck en una partición montada, a menos que uses la opción -M
#    (que algunos sistemas de archivos ignoran). Hacerlo puede causar corrupción de datos.
# 🚩 Flags Comunes:
#    -A: Comprueba todos los sistemas de archivos en /etc/fstab (excepto los marcados como 'pass' 0).
#    -a: Repara automáticamente, asumiendo respuestas seguras (generalmente no recomendado).
#    -y: Asume 'sí' a todas las preguntas (para reparación automática sin -a).
#    -N: Simula la ejecución, no escribe nada, solo muestra qué se haría.
#    -V: Muestra mensajes detallados (verbose).

# Sintaxis básica: Comprueba el sistema de archivos en la partición /dev/sdb1.
# Requiere permisos de root (sudo).
fsck /dev/sdb1
# -> /dev/sdb1: 123/123456 files (1.2%), 12345/123456 blocks (1.2%)
# -> /dev/sdb1: clean
# -> (La salida varía según el sistema de archivos específico, ej. e2fsck para ext4)

# Comprobación de una partición ext4, asumiendo 'sí' para reparaciones, en modo detallado.
# Esto intentará reparar automáticamente los errores que encuentre.
fsck -V -y /dev/sda2
# -> fsck from util-linux 2.37.2
# -> e2fsck 1.46.5 (30-Dec-2021)
# -> /dev/sda2: Inode 123 has duplicate blocks. Fix? yes
# -> /dev/sda2: ***** FILE SYSTEM WAS MODIFIED *****
# -> /dev/sda2: 1234/123456 files (0.9%), 12345/123456 blocks (9.0%)

# Simulación: Muestra qué se haría si se ejecutara fsck en todas las particiones de fstab
# marcadas para ser comprobadas, sin realizar ninguna acción real.
fsck -A -N
# -> fsck from util-linux 2.37.2
# -> /dev/sdb1: Would run e2fsck -y -f /dev/sdb1
# -> /dev/sda5: Would run xfs_check /dev/sda5

### --- Sección 2: Uso Avanzado y Automatización (Modo No Interactivo) ---

# 🛠️ Modo Avanzado: Forzar comprobación y seleccionar el comando fsck específico.
# El comando fsck es un 'wrapper' que llama al programa específico (ej. fsck.ext4 o fsck.xfs).
# 🚩 Flags Adicionales:
#    -t <tipo>: Especifica el tipo de sistema de archivos (ej. ext4, xfs).
#    -f: Fuerza la comprobación incluso si el sistema de archivos parece limpio.
#    -C: Muestra el progreso de la comprobación (si es soportado por el verificador).

# Forzar la comprobación de un sistema de archivos ext4 en modo detallado.
fsck -f -V -t ext4 /dev/sdc1
# -> e2fsck 1.46.5 (30-Dec-2021)
# -> Pass 1: Checking inodes, blocks, and sizes
# -> Pass 2: Checking directory structure
# -> ... (Comprobación completa)

# Usando pipes para buscar la partición y comprobarla.
# ⚠️ Esto es un ejemplo de automatización. **Asegúrate de que la partición NO esté montada antes de ejecutar.**
# 1. Busca la partición por su etiqueta (LABEL).
# 2. Extrae el nombre del dispositivo (e.g., /dev/sdd1).
# 3. Pasa el nombre a fsck para una comprobación forzada con reparación automática.

DEVICE_TO_CHECK=$(lsblk -o NAME,LABEL | grep 'DataBackup' | awk '{print "/dev/"$1}')
echo "Comprobando dispositivo: $DEVICE_TO_CHECK"
fsck -f -y "$DEVICE_TO_CHECK"
# -> Comprobando dispositivo: /dev/sdd1
# -> /dev/sdd1: 123/123456 files (1.2%), 12345/123456 blocks (1.2%)
# -> /dev/sdd1: clean

### --- Sección 3: Opciones de Diagnóstico y Errores ---

# 🔍 Diagnóstico: Usar -V para ver qué utilidad de verificación se está llamando
# y cómo está progresando. Es clave para depurar errores.

# Simulación de diagnóstico en un sistema de archivos desconocido o corrupto.
fsck -V /dev/sdx9
# -> fsck from util-linux 2.37.2
# -> fsck: error 2 while executing fsck.ext2 for /dev/sdx9
# # -> El código de error (2) indica que fsck no encontró el verificador específico para el FS
# #    o que el sistema de archivos estaba seriamente corrupto o no inicializado.

# Códigos de Salida (Exit Codes) de fsck (Regla importante):
# 0: Sin errores
# 1: Errores del sistema de archivos corregidos
# 2: El sistema debe ser reiniciado
# 4: Errores del sistema de archivos no corregidos
# 8: Error de operación
# 16: Error de uso o sintaxis
# 32: fsck cancelado por el usuario
# 128: Error de librería compartida

# Ejemplo de uso en un script para verificar si se requiere un reinicio:
# Se comprueba la partición y se evalúa el código de salida ($?).
if fsck -a /dev/sde1 ; then
    echo "Comprobación finalizada. Sin errores graves o corregidos sin necesidad de reiniciar."
else
    EXIT_CODE=$?
    if [ "$EXIT_CODE" -eq 2 ]; then
        echo "🚨 ¡ADVERTENCIA! Código $EXIT_CODE. El sistema de archivos fue modificado y requiere un **reinicio**."
    elif [ "$EXIT_CODE" -eq 4 ]; then
        echo "❌ ¡ERROR! Código $EXIT_CODE. Errores no corregidos. Se requiere intervención manual."
    else
        echo "ℹ️ Código $EXIT_CODE. Consulte la tabla de códigos para más detalles."
    fi
fi
# -> Comprobación finalizada. Sin errores graves o corregidos sin necesidad de reiniciar.









#!/bin/bash

### --- Sección 1: Diagnóstico y Estructura GPT ---

# Listar la tabla de particiones de un disco usando gdisk
# A diferencia de fdisk, gdisk verifica la integridad de las cabeceras GPT (Main y Backup).
# Muestra el 'Disk GUID' (identificador único del disco) y el estado del MBR protector.
sudo gdisk -l /dev/sdb
# -> GPT fdisk (gdisk) version 1.0.5
# -> Partition table scan:
# ->   MBR: protective
# ->   BSD: not present
# ->   APM: not present
# ->   GPT: present
# -> Found valid GPT with protective MBR; using GPT.
# -> Disk /dev/sdb: 20971520 sectors, 10.0 GiB
# -> Disk identifier (GUID): A1B2C3D4-E5F6-...

### --- Sección 2: Modo Interactivo (Comandos y Códigos) ---

# Iniciar gdisk en modo interactivo.
# El menú es muy similar a fdisk, pero adaptado a GPT.
# Comandos internos clave:
#   ? -> Ayuda.
#   n -> (New) Nueva partición (1 a 128 particiones posibles).
#   c -> (Change name) Asignar una ETIQUETA/NOMBRE a la partición (exclusivo de GPT).
#   t -> (Type) Cambiar tipo. Usa códigos de 4 dígitos (ej: 8300 Linux, EF00 EFI, 8200 Swap).
#   i -> (Info) Información detallada (UUID de partición, atributos).
#   w -> (Write) Escribir cambios y salir.
#   o -> (Create) Crea una tabla GPT vacía (borra todo).
sudo gdisk /dev/sdb
# -> Command (? for help): 

### --- Sección 3: Ejemplo de Flujo Completo (Crear + Nombrar) ---

# Automatización: Crear una partición, definir tipo y ponerle NOMBRE.
# Secuencia explicada:
#   n       -> Nueva partición
#   2       -> Número de partición (ej: 2)
#           -> (Enter) Primer sector por defecto
#   +2G     -> (Fin) Tamaño de 2GB
#   8300    -> Tipo de sistema de archivos (8300 = Linux Filesystem). 
#              Nota: En gdisk no es solo '83', es '8300'. EF00 es para arranque EFI.
#   c       -> Cambiar nombre (Change name)
#   2       -> Seleccionar partición 2
#   MisDatos-> Nombre de la partición (Visible en /dev/disk/by-partlabel/)
#   p       -> Print (verificar)
#   w       -> Write (guardar)
#   Y       -> Confirmar escritura (Yes)
echo -e "n\n2\n\n+2G\n8300\nc\n2\nMisDatos\np\nw\nY" | sudo gdisk /dev/sdb
# -> Current type is 'Linux filesystem'
# -> Changed partition name to 'MisDatos'
# -> OK; writing new GUID partition table (GPT) to /dev/sdb.
# -> The operation has completed successfully.



### --- Sección 4: Recuperación y Opciones Avanzadas ---

# GPT guarda una copia de seguridad de la tabla al final del disco.
# Si la tabla principal se corrompe, gdisk detecta el error y ofrece usar la backup.
# Menú 'r' (Recovery and transformation options):
# Dentro de gdisk, al pulsar 'r' accedes a un submenú para recuperar datos.
#   b -> Usar cabecera de backup.
#   d -> Usar cabecera principal.
#   h -> Reconstruir cabecera principal desde la backup.
# (Este comando es solo demostrativo del acceso, requiere interacción real en caso de desastre)
echo -e "r\n?" | sudo gdisk /dev/sdb
# -> Recovery/transformation command (? for help):

### --- Sección 5: Alternativa para Scripts (sgdisk) ---

# NOTA IMPORTANTE: Aunque podemos usar 'echo' con gdisk, existe 'sgdisk'.
# 'sgdisk' (Scriptable gdisk) es la versión diseñada específicamente para scripts,
# sin menús interactivos, usando solo flags. Es más seguro para automatizar.
# Ejemplo: Borrar todo (-Z), crear partición 1 de 1GB (-n), tipo Linux (-t), nombre "Boot" (-c)
sudo sgdisk -Z -n 1:0:+1G -t 1:8300 -c 1:"Boot" /dev/sdb
# -> Creating new GPT entries.
# -> The operation has completed successfully.

# Verificar el resultado del script anterior
sudo gdisk -l /dev/sdb
# -> Number  Start (sector)    End (sector)  Size       Code  Name
# ->    1            2048         2099199   1024.0 MiB  8300  Boot