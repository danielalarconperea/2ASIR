#!/bin/bash

# ==============================================================================
# 📘 APUNTES DE BASH: GESTIÓN Y TIPOS DE BITÁCORAS (LOGS)
# ==============================================================================
# Propósito: Explicación técnica y práctica de los sistemas de logging en Linux.
# Estructura: Archivos planos (/var/log), Journald (systemd) y Kernel.
# ==============================================================================

### --- Sección 1: Bitácoras de Texto Plano (/var/log) ---
# En la mayoría de distribuciones (Debian/Ubuntu/RHEL), los logs principales
# se almacenan como archivos de texto en /var/log.
# ------------------------------------------------------------------------------

# 1.1 Bitácora del Sistema (Syslog) 🖥️
# Archivo: /var/log/syslog (Debian/Ubuntu) o /var/log/messages (RHEL/CentOS).
# Función: Registra actividad general del sistema, servicios y demonios que no
# tienen su propio archivo de log.
# Comando: 'tail' muestra las últimas 3 líneas para ver actividad reciente.
tail -n 3 /var/log/syslog
# -> Nov 26 10:00:01 hostname CRON[12345]: (root) CMD (command...)
# -> Nov 26 10:05:22 hostname systemd[1]: Started Session 42 of user root.
# -> Nov 26 10:10:05 hostname dhclient[890]: DHCPREQUEST for 192.168.1.50...

# 1.2 Bitácora de Autenticación y Seguridad 🔒
# Archivo: /var/log/auth.log (Debian/Ubuntu) o /var/log/secure (RHEL).
# Función: Crucial para auditar accesos. Registra intentos de login (SSH, local),
# uso de 'sudo', y creación de usuarios.
# Ejemplo: Buscamos intentos de 'sudo' recientes.
grep "sudo" /var/log/auth.log | tail -n 2
# -> Nov 26 10:15:00 hostname sudo: user : TTY=pts/0 ; PWD=/home/user ; USER=root ; COMMAND=/usr/bin/apt update
# -> Nov 26 10:15:05 hostname sudo: pam_unix(sudo:session): session opened for user root by (uid=0)

# 1.3 Bitácoras de Aplicaciones Específicas (Ejemplo: Apache/Nginx) 🌐
# Muchas aplicaciones crean su propio subdirectorio en /var/log.
# Aquí simulamos un listado del directorio de logs de un servidor web.
ls -l /var/log/apache2/ 2>/dev/null || echo "Apache no instalado"
# -> -rw-r----- 1 root adm 10240 Nov 26 10:00 access.log
# -> -rw-r----- 1 root adm  2048 Nov 26 10:00 error.log

### --- Sección 2: Bitácoras del Kernel (Ring Buffer) ---
# El kernel de Linux mantiene un buffer circular de mensajes en memoria,
# útil para diagnosticar hardware y drivers antes de que el sistema de archivos esté montado.
# ------------------------------------------------------------------------------

# 2.1 Comando 'dmesg' (Display Message) ⚙️
# Función: Muestra los mensajes del kernel ring buffer.
# Flag '-H': Habilita salida paginada y coloreada (Human readable).
# Flag '| head': Limitamos la salida para este ejemplo.
dmesg | head -n 3
# -> [    0.000000] Linux version 5.15.0-generic (buildd@lcy01-amd64-001) ...
# -> [    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-5.15.0-generic ...
# -> [    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'

# 2.2 Filtrado de Logs del Kernel
# Flag '-l' (level): Filtra por nivel de importancia (err, warn, info).
# Buscamos solo errores del kernel.
dmesg -l err
# -> [   12.345678] sd 0:0:0:0: [sda] No Caching mode page found
# -> [   12.345699] sd 0:0:0:0: [sda] Assuming drive cache: write through

### --- Sección 3: Systemd Journal (journalctl) ---
# El estándar moderno. 'systemd-journald' recolecta logs del kernel, servicios,
# y stdout/stderr de aplicaciones en un formato binario indexado.
# ------------------------------------------------------------------------------

# 3.1 Lectura Básica y Tiempo Real ⏱️
# Comando: 'journalctl'
# Flag '-f': Follow (seguir en tiempo real, similar a tail -f).
# Flag '-n 5': Muestra solo las últimas 5 entradas iniciales.
journalctl -n 5
# -> -- Journal begins at Mon 2024-01-01 10:00:00 CET, ends at ...
# -> Nov 26 11:00:01 hostname systemd[1]: Started User Manager for UID 1000.
# -> Nov 26 11:00:01 hostname sshd[555]: Accepted publickey for user...

# 3.2 Filtrado por Unidad (Servicio) 🛠️
# Muy útil para depurar un servicio específico sin ver "ruido" del resto del sistema.
# Flag '-u': Unit (ej. ssh, docker, cron).
# Flag '--no-pager': Muestra todo el texto sin paginar (útil para scripts).
journalctl -u cron --no-pager -n 2
# -> Nov 26 11:05:01 hostname CRON[777]: pam_unix(cron:session): session opened for user root
# -> Nov 26 11:05:01 hostname CRON[777]: (root) CMD (command...)

# 3.3 Filtrado por Prioridad y Tiempo 📅
# Flag '-p': Priority (0=emerg, 3=err, 4=warning, etc.).
# Flag '--since': Muestra logs desde un tiempo natural ("1 hour ago", "yesterday", "2023-11-26").
# Ejemplo: Ver errores (err) ocurridos desde hace 1 hora.
journalctl -p err --since "1 hour ago"
# -> Nov 26 10:30:00 hostname kernel: [Hardware Error]: ...
# -> Nov 26 10:45:12 hostname nginx[404]: [error] 123#123: *1 directory index of ... is forbidden

# 3.4 Logs del Kernel vía Journalctl 🧠
# Flag '-k': Equivalente a leer dmesg pero con las capacidades de filtrado de journalctl.
journalctl -k -n 2
# -> Nov 26 09:00:00 hostname kernel: Linux version ...
# -> Nov 26 09:00:00 hostname kernel: Command line: ...

# 3.5 Mantenimiento: Ver uso de disco de los logs 💾
# Journald guarda logs de forma persistente o volátil según configuración.
journalctl --disk-usage
# -> Archived and active journals take up 150.0M in the file system.

### --- Sección 4: Generación de Bitácoras Personalizadas (Logger) ---
# El comando 'logger' permite enviar mensajes al sistema de logs (syslog/journald)
# desde la terminal o scripts de shell.
# ------------------------------------------------------------------------------

# 4.1 Envío Simple de Mensaje 📨
# Envía un mensaje con la etiqueta de usuario actual.
logger "Inicio del script de respaldo manual"
# -> (En /var/log/syslog o journalctl): Nov 26 12:00:00 hostname user: Inicio del script de respaldo manual

# 4.2 Envío con Etiquetas y Prioridad (Scripting Avanzado) 🏷️
# Flag '-t': Tag (etiqueta para identificar el proceso o script).
# Flag '-p': Priority (facility.level, ej: local0.info, user.error).
# Flag '-s': Muestra el mensaje también en stderr (pantalla) además de enviarlo al log.
logger -s -t MI_SCRIPT_BACKUP -p user.error "Error crítico: No se encuentra el destino"
# -> (Salida en pantalla): <11>Nov 26 12:05:00 MI_SCRIPT_BACKUP: Error crítico: No se encuentra el destino
# -> (En journalctl): Nov 26 12:05:00 hostname MI_SCRIPT_BACKUP[123]: Error crítico: No se encuentra el destino