#!/bin/bash

# ==============================================================================
# 📝 APUNTES DE BASH: CRON Y CRONTAB
# ==============================================================================
# Este script cubre el uso del planificador de tareas 'cron'.
# Desde la gestión básica hasta la automatización avanzada y diagnóstico.

### --- Sección 1: Gestión Básica de Crontab ---

# ℹ️ Listar las tareas programadas para el usuario actual.
# Es el primer paso para verificar qué está corriendo actualmente.
# Si no hay crontab, mostrará un mensaje de error estándar.
crontab -l
# -> no crontab for usuario (o listado de tareas: * * * * * comando...)

# ℹ️ Editar el archivo crontab del usuario actual.
# ⚠️ Este comando es INTERACTIVO. Abre el editor por defecto (vi, nano).
# No se debe ejecutar en un script automatizado sin precauciones.
# crontab -e
# -> (Abre la interfaz de edición de texto)

# ℹ️ Eliminar el archivo crontab del usuario actual.
# ⚠️ ¡Cuidado! Borra TODAS las tareas programadas sin confirmación (dependiendo de la versión)
# o pide confirmación con -i.
# crontab -r -i
# -> crontab: really delete user's crontab? (y/n)

### --- Sección 2: Sintaxis y Estructura del Cron ---

# ℹ️ La sintaxis de una línea de cron se compone de 5 campos de tiempo y el comando.
# Estructura: m h dom mon dow command
# m:   Minuto (0-59)
# h:   Hora (0-23)
# dom: Día del mes (1-31)
# mon: Mes (1-12)
# dow: Día de la semana (0-6) (0=Domingo)

# 

# ℹ️ Ejemplo de cómo se vería una línea para ejecutar un backup a las 03:30 AM todos los días.
echo "30 03 * * * /home/usuario/scripts/backup.sh"
# -> 30 03 * * * /home/usuario/scripts/backup.sh

# ℹ️ Uso de cadenas especiales (Atajos) para reemplazar los 5 asteriscos.
# @reboot: Se ejecuta una vez al iniciar el sistema.
# @daily:  Equivale a 0 0 * * *
# @hourly: Equivale a 0 * * * *
echo "@reboot /home/usuario/scripts/iniciar_servidor.sh"
# -> @reboot /home/usuario/scripts/iniciar_servidor.sh

### --- Sección 3: Automatización y Edición No Interactiva ---

# ℹ️ Añadir una tarea nueva SIN abrir el editor de texto (Scripting/Automation).
# Técnica: Volcar el crontab actual, añadir la nueva línea y volver a cargarlo.
# Usamos 2>/dev/null para evitar errores si el crontab está vacío inicialmente.
(crontab -l 2>/dev/null; echo "*/5 * * * * echo 'Hola cada 5 min' >> /tmp/cron_test.log") | crontab -
# -> (No muestra salida, pero actualiza la tabla de cron silenciosamente)

# ℹ️ Verificación de que la tarea se añadió correctamente mediante automatización.
crontab -l | grep "cron_test"
# -> */5 * * * * echo 'Hola cada 5 min' >> /tmp/cron_test.log

# ℹ️ Crear un backup del crontab actual antes de modificarlo (Buena práctica).
crontab -l > "crontab_backup_$(date +%F).txt"
# -> (Crea un archivo de texto con el contenido actual del crontab)

### --- Sección 4: Directorios del Sistema y Logs (Diagnóstico) ---

# ℹ️ Verificar el estado del servicio cron (daemon).
# Es fundamental saber si el "motor" está encendido.
systemctl status cron --no-pager
# -> Active: active (running) since ...

# ℹ️ Ver los logs de ejecución de cron en tiempo real.
# Útil para depurar por qué una tarea no corrió.
# Nota: Requiere permisos de sudo/root habitualmente.
# grep CRON /var/log/syslog | tail -n 5
# -> Nov 25 10:00:01 hostname CRON[12345]: (root) CMD (command...)

# ℹ️ Listar directorios de cron del sistema (System-wide).
# Aquí se guardan scripts que corren periódicamente sin necesidad de añadirlos a un crontab de usuario.
ls -d /etc/cron.*
# -> /etc/cron.d  /etc/cron.daily  /etc/cron.hourly  /etc/cron.monthly  /etc/cron.weekly

# ℹ️ Inspeccionar el crontab global del sistema (Define el entorno de ejecución).
cat /etc/crontab
# -> SHELL=/bin/sh
# -> PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
# -> ... (listado de tareas del sistema)