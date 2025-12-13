#!/bin/bash

### --- Sección 1: Sintaxis Básica y Listado de Montajes ---

# El comando 'mount' sin argumentos lista todos los sistemas de archivos montados actualmente.
# Muestra el dispositivo, el punto de montaje, el tipo de sistema de archivos y las opciones de montaje (rw, ro, etc.).
mount
# -> sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime)
# -> proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
# -> /dev/sda1 on / type ext4 (rw,relatime,errors=remount-ro)

# Sintaxis básica para montar un dispositivo: mount -t [tipo] [dispositivo] [punto_de_montaje]
# Nota: Requiere privilegios de superusuario (sudo) para ejecutar cambios.
# En este ejemplo, montamos la partición /dev/sdb1 en el directorio /mnt/usb.
# Si no se especifica '-t', mount intentará adivinar el tipo de sistema de archivos.
sudo mount /dev/sdb1 /mnt/usb
# -> (Sin salida si el comando es exitoso. El código de retorno es 0)

### --- Sección 2: Gestión de Tipos y Opciones Comunes (-t, -o) ---

# Uso de la flag '-t' para especificar explícitamente el tipo de sistema de archivos (ext4, ntfs, vfat, nfs, etc.).
# Esto es útil para asegurar que se usa el controlador correcto.
sudo mount -t ext4 /dev/sdc1 /mnt/datos
# -> (Sin salida si es exitoso)

# Uso de la flag '-o' para pasar opciones específicas separadas por comas (sin espacios).
# 'ro': Montar en modo 'Read-Only' (solo lectura). Útil para proteger datos o analizar discos comprometidos.
sudo mount -o ro /dev/sdb1 /mnt/seguro
# -> mount: /mnt/seguro: WARNING: device write-protected, mounted read-only.

# 'rw': Montar en modo 'Read-Write' (lectura y escritura). Es el comportamiento por defecto.
# 'uid' y 'gid': Asigna propietario y grupo a los archivos montados (común en sistemas FAT/NTFS que no manejan permisos POSIX nativos).
sudo mount -o rw,uid=1000,gid=1000 /dev/sdb2 /mnt/windows
# -> (Sin salida si es exitoso)

### --- Sección 3: Operaciones Avanzadas (Remount, Bind, Loop) ---

# La opción 'remount' permite cambiar las opciones de un sistema de archivos ya montado sin desmontarlo primero.
# Muy utilizado para cambiar una partición de solo lectura a escritura en modo de recuperación.
sudo mount -o remount,rw /
# -> (Sin salida. El sistema raíz pasa a modo escritura)

# '--bind' (o -B): Permite montar un directorio existente en otro lugar del árbol de directorios.
# Crea un "espejo" del directorio. Ambos directorios mostrarán el mismo contenido.
sudo mount --bind /var/www/html /home/usuario/web-dev
# -> (Sin salida. Acceder a /home/usuario/web-dev ahora muestra el contenido de /var/www/html)

# '-o loop': Permite montar un archivo como si fuera un dispositivo de bloque.
# Es el método estándar para acceder al contenido de imágenes ISO sin quemarlas en un disco.
sudo mount -o loop archivo_imagen.iso /mnt/iso
# -> mount: /mnt/iso: WARNING: device write-protected, mounted read-only.

### --- Sección 4: Automatización y Fstab (-a) ---

# La flag '-a' (all) monta todos los sistemas de archivos definidos en /etc/fstab que no tengan la opción 'noauto'.
# Es el comando que ejecuta el sistema al arrancar, o se usa para probar la configuración de fstab después de editarlo.
sudo mount -a
# -> (Sin salida si todo en /etc/fstab es correcto. Si hay errores, los mostrará aquí)

# Combinación con '-t' para montar solo tipos específicos definidos en fstab.
# Ejemplo: Montar solo los recursos de red NFS definidos en fstab.
sudo mount -a -t nfs
# -> (Intenta montar solo las entradas NFS del archivo de configuración)

### --- Sección 5: Diagnóstico y Verificación (-v, -f) ---

# La flag '-v' (verbose) activa el modo detallado. Muestra qué está haciendo el comando.
# Útil para depurar por qué un montaje está fallando.
sudo mount -v /dev/sdb1 /mnt/usb
# -> mount: /dev/sdb1 mounted on /mnt/usb.

# La flag '-f' (fake) simula el montaje pero no lo realiza realmente.
# Se usa junto con '-v' para verificar qué haría el comando sin riesgo de errores o corrupción.
# También actualiza /etc/mtab sin realizar la llamada al sistema (uso muy técnico).
sudo mount -f -v /dev/sdb1 /mnt/prueba
# -> /dev/sdb1 on /mnt/prueba type ext4 (rw)

# Verificación final: Usar 'findmnt' (comando moderno relacionado) o grep sobre mount para confirmar.
mount | grep sdb1
# -> /dev/sdb1 on /mnt/usb type ext4 (rw,relatime)





### --- Sección 1: Sintaxis Básica de Desmontaje ---

# El comando 'umount' desconecta un sistema de archivos de la jerarquía de directorios.
# Se puede invocar usando el punto de montaje (directorio) O el nombre del dispositivo.
# Nota: Es vital salir del directorio que se quiere desmontar antes de ejecutar el comando.

# Desmontar usando la ruta del directorio (punto de montaje).
sudo umount /mnt/usb
# -> (Sin salida si es exitoso. El directorio /mnt/usb queda vacío)

# Desmontar usando el nombre del dispositivo.
sudo umount /dev/sdb1
# -> (Sin salida si es exitoso)

# Desmontar múltiples puntos a la vez separados por espacios.
sudo umount /mnt/datos /mnt/backup
# -> (Sin salida si es exitoso)

### --- Sección 2: Diagnóstico de Errores (Device is busy) ---

# Error común: Intentar desmontar un disco que está siendo usado por un proceso o usuario.
sudo umount /mnt/datos
# -> umount: /mnt/datos: target is busy.

# Solución 1: Usar 'lsof' (List Open Files) para ver qué procesos bloquean el montaje.
# Muestra el ID del proceso (PID) y el usuario que está usando archivos en ese punto.
lsof +f -- /mnt/datos
# -> COMMAND  PID  USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
# -> bash     1234 root   cwd  DIR  8,1    4096     2    /mnt/datos

# Solución 2: Usar 'fuser' para identificar y, opcionalmente, matar procesos bloqueantes.
# La flag '-m' especifica el montaje y '-v' modo verbose.
fuser -mv /mnt/datos
# ->                      USER        PID ACCESS COMMAND
# -> /mnt/datos:          root       1234 ..c.. bash

### --- Sección 3: Desmontaje Forzado y Perezoso (-f, -l) ---

# Flag '-l' (Lazy unmount): Desmontaje "perezoso".
# Desconecta el sistema de archivos de la jerarquía inmediatamente para el sistema,
# pero limpia las referencias a los archivos abiertos solo cuando los procesos terminan de usarlos.
# Es la opción MÁS SEGURA Y RECOMENDADA para dispositivos locales trabados.
sudo umount -l /mnt/disco_trabado
# -> (Sin salida. El prompt vuelve inmediatamente, el sistema limpia en segundo plano)

# Flag '-f' (Force): Desmontaje forzado.
# Principalmente útil para sistemas de archivos de RED (NFS) inalcanzables.
# ADVERTENCIA: Usar esto en sistemas de archivos locales puede causar corrupción de datos.
sudo umount -f /mnt/nfs_caido
# -> (Intenta forzar la desconexión aunque el servidor no responda)

### --- Sección 4: Desmontaje Recursivo y de Todo (-R, -a) ---

# Flag '-R' (Recursive): Desmonta el directorio especificado y todo lo que haya montado dentro de él.
# Útil si tienes montajes --bind o submontajes dentro de una carpeta.
sudo umount -R /mnt/contenedor
# -> (Desmonta /mnt/contenedor y cualquier sub-montaje interno secuencialmente)

# Flag '-a' (All): Desmonta todos los sistemas de archivos listados en /etc/mtab.
# Generalmente se usa durante el apagado del sistema.
# Se suele combinar con '-t' para desmontar todos los de un tipo específico.
sudo umount -a -t cifs
# -> (Desmonta todas las unidades de red Samba/Windows activas)

### --- Sección 5: Verificación Final ---

# Confirmar que el dispositivo ya no aparece en la lista de montajes.
findmnt /mnt/usb
# -> (Sin salida si se desmontó correctamente. Retorno no-cero)