#!/bin/bash

# ==============================================================================
# 📘 TÍTULO: GUÍA MAESTRA DE SYSTEMD Y SYSTEMCTL
# 🎯 OBJETIVO: Comprender el sistema de inicio (Init System), gestión de servicios
#              y análisis de logs con SystemD.
# ==============================================================================

### --- Sección 1: Conceptos Fundamentales y Estado del Sistema ---

# ℹ️ SystemD es el primer proceso que inicia el kernel (PID 1).
# Su función es inicializar el espacio de usuario y gestionar todos los procesos posteriores.
# Reemplaza al antiguo SysVinit, permitiendo el arranque en paralelo y gestión de dependencias.

# 🔍 Verificar si el sistema utiliza SystemD
# Comprobamos el proceso con PID 1.
ps -p 1 -o comm=
# -> systemd

# 📊 Estado general del sistema
# Muestra si el sistema está "running", "degraded" (algún servicio falló) o "maintenance".
systemctl is-system-running
# -> running

# 🌲 Ver la jerarquía de control de grupos (cgroups)
# SystemD organiza los procesos en grupos de control. Este comando visualiza el árbol.
systemd-cgls --no-pager | head -n 10
# -> Control group /:
# -> -.slice
# -> ├─user.slice
# -> │ ├─user-1000.slice
# -> ...

### --- Sección 2: Gestión Básica de Servicios (Systemctl) ---

# 🚀 Sintaxis: systemctl [acción] [nombre_servicio]
# Las acciones comunes son: start, stop, restart, reload (recargar config sin detener), status.

# 🟢 Ver el estado detallado de un servicio (ej: ssh)
# Muestra si está activo, su PID, uso de memoria, últimas líneas de log y ruta del archivo .service.
systemctl status ssh --no-pager
# -> ● ssh.service - OpenBSD Secure Shell server
# ->      Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: enabled)
# ->      Active: active (running) since Wed 2023-10-25 10:00:00 UTC; 2h ago
# ->    Main PID: 1234 (sshd)
# ->       Tasks: 1 (limit: 4915)
# ->      Memory: 5.2M
# -> ...

# 🔄 Reiniciar un servicio (Stop + Start)
# Útil cuando se cambia la configuración o el servicio se cuelga.
sudo systemctl restart ssh
# -> (Sin salida si el comando es exitoso)

# 🛑 Detener un servicio temporalmente (hasta el próximo reinicio)
sudo systemctl stop nginx
# -> (Sin salida si el comando es exitoso)

### --- Sección 3: Persistencia y Arranque (Enable/Disable) ---

# 🔌 Habilitar un servicio para que inicie automáticamente con el sistema
# Esto crea un enlace simbólico (symlink) en /etc/systemd/system/multi-user.target.wants/
sudo systemctl enable docker
# -> Created symlink /etc/systemd/system/multi-user.target.wants/docker.service → /lib/systemd/system/docker.service.

# 🚫 Deshabilitar el arranque automático
# Elimina el enlace simbólico. El servicio aún puede iniciarse manualmente.
sudo systemctl disable apache2
# -> Removed /etc/systemd/system/multi-user.target.wants/apache2.service.

# 🕵️ Comprobar si un servicio está habilitado sin ver todo el estado
systemctl is-enabled ufw
# -> enabled

### --- Sección 4: Unidades, Archivos y Edición ---

# ℹ️ SystemD maneja "Unidades" (Units). Las más comunes son:
# .service (servicios), .socket (sockets de red), .timer (cronjobs), .target (grupos de unidades).

# 📋 Listar todas las unidades activas de tipo "servicio"
systemctl list-units --type=service --state=running | head -n 5
# -> UNIT              LOAD   ACTIVE SUB     DESCRIPTION
# -> accounts.service  loaded active running Accounts Service
# -> cron.service      loaded active running Regular background program processing daemon
# -> dbus.service      loaded active running D-Bus System Message Bus

# 📂 Ver el contenido del archivo de configuración de una unidad (sin editar)
systemctl cat ssh.service
# -> # /lib/systemd/system/ssh.service
# -> [Unit]
# -> Description=OpenBSD Secure Shell server
# -> ...

# 🎭 Enmascarar (Mask) un servicio
# Esto apunta la unidad a /dev/null, impidiendo que se inicie incluso manualmente o por dependencia.
# Es más fuerte que "disable".
sudo systemctl mask bluetooth
# -> Created symlink /etc/systemd/system/bluetooth.service → /dev/null.

### --- Sección 5: Diagnóstico y Logs (Journalctl) ---

# ℹ️ SystemD tiene su propio sistema de logs binarios llamado "journal".
# Reemplaza o complementa a syslog.

# 📜 Ver todos los logs del servicio SSH (desde el inicio del registro actual)
journalctl -u ssh --no-pager -n 20
# -> Oct 25 12:00:00 server sshd[1234]: Server listening on 0.0.0.0 port 22.
# -> Oct 25 12:01:00 server sshd[1235]: Accepted publickey for user...

# 🔴 Ver solo los logs de prioridad "Error" o superior (-p 3) del arranque actual (-b)
journalctl -p 3 -b
# -> Oct 25 09:00:05 server kernel: [Hardware Error]: ...

# ⏱️ Monitorizar logs en tiempo real (como tail -f)
# journalctl -u nginx -f
# -> (Salida continua de logs a medida que ocurren)

### --- Sección 6: Análisis de Rendimiento (Boot Analysis) ---

# ℹ️ SystemD permite analizar qué procesos ralentizan el inicio del sistema.

# ⏱️ Ver el tiempo total de arranque
systemd-analyze
# -> Startup finished in 2.414s (kernel) + 1.832s (userspace) = 4.246s
# -> graphical.target reached after 1.820s in userspace

# 🐢 "Culpables": Lista ordenada de servicios por tiempo de inicialización
systemd-analyze blame | head -n 5
# -> 1.203s cloud-init-local.service
# ->  850ms snapd.service
# ->  320ms udisks2.service
# -> ...

# 🎨 Generar un gráfico SVG con la cascada de arranque (Comando avanzado)
# systemd-analyze plot > boot_analysis.svg
# -> (Genera un archivo .svg visualizable en navegador)

### --- Sección 7: Automatización Avanzada (Timers y Ejecución Ad-hoc) ---

# ⏲️ Listar "Timers" (la alternativa de SystemD a Cron)
# Muestra cuándo fue la última ejecución y cuándo será la próxima.
systemctl list-timers --all | head -n 5
# -> NEXT                        LEFT       LAST                        PASSED       UNIT                         ACTIVATES
# -> Wed 2023-10-25 14:00:00 UTC 15min left Wed 2023-10-25 13:00:00 UTC 44min ago    fwupd-refresh.timer          fwupd-refresh.service

# 🏃 Ejecutar un comando como un servicio transitorio (Ad-hoc)
# Útil para ejecutar procesos largos en background gestionados por systemd sin crear un archivo .service.
# sudo systemd-run --unit=mi-backup-rapido rsync -av /source /dest
# -> Running as unit: mi-backup-rapido.service