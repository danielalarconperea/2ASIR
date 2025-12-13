#!/bin/bash

### --- Sección 1: Bitácoras Estándar (Archivos de Texto) ---
# La mayoría de los logs tradicionales se almacenan en texto plano en /var/log.

# 📝 Ver las últimas 10 líneas del log principal del sistema (Syslog).
# En sistemas basados en Debian/Ubuntu se usa 'syslog', en RHEL/CentOS suele ser 'messages'.
tail /var/log/syslog
# -> Nov 26 10:00:01 hostname CRON[123]: (root) CMD (command execution) ...

# 📝 Monitorizar un log de autenticación en tiempo real (-f / --follow).
# Muestra intentos de login, sudo, y conexiones SSH a medida que ocurren.
# (Comando comentado para evitar bloqueo del script, descomentar para usar).
# tail -f /var/log/auth.log
# -> Nov 26 19:05:22 hostname sshd[456]: Accepted publickey for user admin ...

### --- Sección 2: Journalctl (Systemd Journal) - Reglas de Filtrado ---
# Journalctl consulta la base de datos binaria de logs de systemd. Es el estándar moderno.

# 📝 1. Sintaxis Básica: Ver logs del arranque actual (-b / --boot).
# Filtra todo el historial antiguo y muestra solo lo ocurrido desde el último reinicio.
journalctl -b --no-pager | head -n 5
# -> Nov 26 08:00:00 hostname kernel: Linux version 6.1.0-13-amd64 ...
# -> Nov 26 08:00:00 hostname kernel: Command line: BOOT_IMAGE=/boot/vmlinuz ...

# 📝 2. Filtrado por Unidad (-u): Ver logs de un servicio específico.
# Útil para depurar por qué falló un servicio (ej. ssh, apache2, docker).
journalctl -u ssh --no-pager -n 5
# -> Nov 26 12:00:00 hostname systemd[1]: Started OpenBSD Secure Shell server.
# -> Nov 26 12:00:05 hostname sshd[789]: Server listening on 0.0.0.0 port 22.

# 📝 3. Filtrado por Prioridad (-p): Reglas de severidad.
# Niveles: 0=emerg, 1=alert, 2=crit, 3=err, 4=warning, 5=notice, 6=info, 7=debug. ------------------------
# Aquí mostramos solo errores (3) y niveles más graves.
journalctl -p err -b --no-pager
# -> Nov 26 14:30:00 hostname app_service[999]: Error: Connection to database failed.

# 📝 4. Filtrado por Tiempo (--since, --until).
# Acepta formatos como "yesterday", "today", "1 hour ago" o fechas "YYYY-MM-DD HH:MM".
journalctl --since "1 hour ago" --no-pager | head -n 3
# -> Nov 26 18:04:00 hostname systemd[1]: Starting Cleanup of Temporary Directories...

# 📝 5. Formato de Salida (-o).
# 'json-pretty' es ideal para inspeccionar todos los metadatos disponibles de un evento.
journalctl -n 1 -o json-pretty
# -> {
# ->   "__CURSOR" : "s=34a1...",
# ->   "__REALTIME_TIMESTAMP" : "1700000000000",
# ->   "MESSAGE" : "Session 5 logged out. Waiting for processes to exit.",
# ->   "PRIORITY" : "6",
# ->   "SYSLOG_IDENTIFIER" : "systemd-logind",
# ->   ...
# -> }

### --- Sección 3: Logs del Kernel (Dmesg) ---
# Buffer circular del kernel, crucial para hardware y drivers.

# 📝 Mostrar mensajes del kernel con marcas de tiempo legibles (-T) y coloreado (-L).
# Sin -T, muestra segundos desde el inicio (uptime), difícil de leer para humanos.
dmesg -T -L | tail -n 3
# -> [Wed Nov 26 19:00:00 2025] usb 1-1: new high-speed USB device number 4 using xhci_hcd
# -> [Wed Nov 26 19:00:00 2025] usb 1-1: New USB device found, idVendor=abcd, idProduct=1234
# -> [Wed Nov 26 19:00:00 2025] usb-storage 1-1:1.0: USB Mass Storage device detected

### --- Sección 4: Mantenimiento y Rotación (Logrotate) ---
# Reglas que evitan que los logs llenen el disco duro.

# 📝 Verificar la configuración principal de rotación de logs.
# Aquí se definen reglas globales como frecuencia (weekly) y retención (rotate 4).
cat /etc/logrotate.conf | grep -v "^#" | head -n 5
# -> weekly
# -> rotate 4
# -> create
# -> include /etc/logrotate.d

# 📝 Forzar una rotación manual (modo debug -d) para verificar reglas sin ejecutar cambios.
logrotate -d /etc/logrotate.conf 2>&1 | head -n 3
# -> reading config file /etc/logrotate.conf
# -> including /etc/logrotate.d
# -> reading config file /etc/logrotate.d/apt