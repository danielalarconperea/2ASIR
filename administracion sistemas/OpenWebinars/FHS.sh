#!/bin/bash

# ==============================================================================
# 📘 APUNTES DE BASH: FILESYSTEM HIERARCHY STANDARD (FHS)
# ==============================================================================
# Este script recorre y explica la estructura estándar de directorios en Linux.
# El FHS define el propósito de los directorios para asegurar compatibilidad
# entre diferentes distribuciones.
# ==============================================================================

### --- Sección 1: Documentación Oficial ---

# ℹ️ El comando por excelencia para entender la jerarquía en tu sistema específico.
# Muestra la descripción de la jerarquía del sistema de archivos.
man hier
# -> (Abre el manual detallando la función de cada directorio: /bin, /etc, /usr, etc.)

### --- Sección 2: El Directorio Raíz (/) ---

# 📂 La raíz del sistema. Todos los archivos y directorios parten de aquí.
# Solo el usuario root tiene permisos de escritura por defecto.
cd / && pwd
# -> /

# Listamos el contenido de la raíz para visualizar la estructura básica.
# -F: Añade un carácter para identificar tipos (/ para directorios, @ para enlaces).
ls -F -d */
# -> bin/ boot/ dev/ etc/ home/ lib/ lib64/ media/ mnt/ opt/ proc/ root/ run/ sbin/ srv/ sys/ tmp/ usr/ var/

### --- Sección 3: Binarios Esenciales (/bin y /sbin) ---

# 🛠️ /bin: Contiene comandos esenciales binarios (programas) disponibles para
# todos los usuarios (ej. ls, cat, cp, bash). Deben estar disponibles en modo 'single-user'.
ls -ld /bin
# -> drwxr-xr-x 2 root root 4096 ... /bin (o enlace simbólico a /usr/bin)

# 🛡️ /sbin: Contiene binarios esenciales del SISTEMA. Generalmente reservados
# para el superusuario/root para tareas de administración (ej. fdisk, ip, reboot).
ls -ld /sbin
# -> drwxr-xr-x 2 root root 4096 ... /sbin (o enlace simbólico a /usr/sbin)

### --- Sección 4: Configuración del Sistema (/etc) ---

# ⚙️ /etc: Archivos de configuración específicos del host.
# NO debe contener binarios. Aquí viven configs de red, usuarios, servicios, etc.
# Ejemplo: Visualizar las primeras líneas del archivo de usuarios.
head -n 3 /etc/passwd
# -> root:x:0:0:root:/root:/bin/bash
# -> daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
# -> bin:x:2:2:bin:/bin:/usr/sbin/nologin

### --- Sección 5: Datos de Usuario (/home y /root) ---

# 🏠 /home: Contiene los directorios personales de los usuarios estándar.
# Aquí se guardan documentos, descargas y configuraciones personales (.bashrc).
ls -ld /home
# -> drwxr-xr-x 4 root root 4096 ... /home

# 👑 /root: Es el directorio personal (home) del usuario 'root'.
# No se ubica dentro de /home para asegurar acceso incluso si /home falla al montarse.
ls -ld /root
# -> drwx------ 8 root root 4096 ... /root (Nota los permisos restrictivos 700)

### --- Sección 6: Archivos de Dispositivo y Arranque (/dev y /boot) ---

# 🔌 /dev: Contiene archivos de dispositivo (Device files).
# En Linux, "todo es un archivo", incluyendo hardware como discos (sda), terminales (tty) y null.
ls -l /dev/null
# -> crw-rw-rw- 1 root root 1, 3 ... /dev/null

# 🚀 /boot: Archivos estáticos del cargador de arranque (GRUB) y el Kernel (vmlinuz).
# Es vital para que el sistema inicie.
ls /boot | grep vmlinuz
# -> vmlinuz-5.15.0-generic (Ejemplo de imagen del kernel comprimida)

### --- Sección 7: Datos Variables (/var) ---

# 📈 /var: Archivos que cambian de tamaño o contenido frecuentemente durante la operación.
# Incluye: Logs (/var/log), colas de impresión (/var/spool), bases de datos, webs, etc.
# Ejemplo: Verificar el log del sistema (si tienes permisos o usas sudo).
tail -n 2 /var/log/syslog 2>/dev/null || echo "Requiere sudo para leer logs"
# -> Nov 25 10:00:01 hostname CRON[123]: (root) CMD (command) ...

### --- Sección 8: Sistemas de Archivos Virtuales (/proc y /sys) ---

# 🧠 /proc: Sistema de archivos virtual que documenta el estado del kernel y procesos.
# No ocupa espacio en disco, reside en RAM.
# Ejemplo: Ver información de la CPU.
cat /proc/cpuinfo | grep "model name" | head -n 1
# -> model name	: Intel(R) Core(TM) i7...

# 🖥️ /sys: Similar a /proc, pero estructurado para exponer información sobre
# dispositivos, drivers y características del kernel de forma jerárquica.
ls -d /sys/class/net/*
# -> /sys/class/net/eth0  /sys/class/net/lo (Interfaces de red detectadas)

### --- Sección 9: Librerías y Software Opcional (/lib, /opt, /usr) ---

# 📚 /lib (y /lib64): Librerías compartidas esenciales para los binarios en /bin y /sbin.
# Son análogas a las DLLs en Windows. Módulos del kernel también viven aquí (/lib/modules).
ls -d /lib/modules/$(uname -r)
# -> /lib/modules/5.15.0-generic

# 📦 /opt: Paquetes de software "Opcional" o add-ons.
# Generalmente usado para software propietario o externo que no sigue la paquetería estándar (ej. Chrome, Zoom).
ls -ld /opt
# -> drwxr-xr-x ... /opt

# 🌍 /usr (Unix System Resources): Jerarquía secundaria.
# Contiene utilidades y librerías compartidas por todos los usuarios (solo lectura).
# /usr/bin: Comandos de usuario no esenciales para el arranque (ej. python, grep, vim).
# /usr/local: Software instalado manualmente por el administrador (compilado localmente).
ls -F /usr/
# -> bin/ games/ include/ lib/ local/ sbin/ share/ src/

### --- Sección 10: Temporales y Montajes (/tmp, /mnt, /media) ---

# 🗑️ /tmp: Archivos temporales. El contenido suele borrarse al reiniciar.
# Cualquier usuario puede escribir aquí.
ls -ld /tmp
# -> drwxrwxrwt ... /tmp (El bit 't' o sticky bit impide que usuarios borren archivos de otros)

# 💾 /mnt: Punto de montaje genérico para sistemas de archivos temporales (admin).
# 💿 /media: Punto de montaje automático para medios extraíbles (USB, CD-ROM) gestionado por el OS.
echo "Diferencia: /mnt es manual (admin), /media es automático (usuario/OS)"
# -> Diferencia: /mnt es manual (admin), /media es automático (usuario/OS)