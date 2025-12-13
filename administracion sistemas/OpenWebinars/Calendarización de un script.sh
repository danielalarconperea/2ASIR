#!/bin/bash

# ==============================================================================
# 📝 APUNTES DE BASH: CALENDARIZACIÓN Y AUTOMATIZACIÓN (CRON & AT)
# ==============================================================================
# Este script cubre la gestión temporal de procesos en Linux.
# Se divide en dos herramientas principales:
# 1. Cron: Para tareas repetitivas/periódicas.
# 2. At: Para tareas de ejecución única en el futuro.

### --- Sección 1: Entendiendo la Sintaxis de Cron (Crontab) ---

# ℹ️ EXPLICACIÓN VISUAL DE LOS CAMPOS DE CRON
# El demonio 'cron' verifica cada minuto si hay tareas por ejecutar.
# La sintaxis estricta consta de 5 asteriscos (campos de tiempo) seguidos del comando.
#
#   ┌───────────── minuto (0 - 59)
#   │ ┌───────────── hora (0 - 23)
#   │ │ ┌───────────── día del mes (1 - 31)
#   │ │ │ ┌───────────── mes (1 - 12) O jan,feb,mar...
#   │ │ │ │ ┌───────────── día de la semana (0 - 6) (Domingo=0 o 7) O sun,mon...
#   │ │ │ │ │
#   * * * * * comando_a_ejecutar
#
# 

# 🛠️ COMANDOS DE GESTIÓN DE CRONTAB
# Muestra la tabla de cron (lista de tareas programadas) del usuario actual.
# Si no hay tareas, mostrará un mensaje indicándolo.
crontab -l
# -> no crontab for user (Si el usuario no tiene tareas definidas)

# ⚠️ NOTA: Los siguientes comandos se muestran como 'echo' para no abrir el editor real
# o borrar tu crontab accidentalmente durante la ejecución de este script de apuntes.

# El comando para EDITAR la tabla de cron. Abre el editor por defecto (vi, nano, etc.).
echo "Comando para editar: crontab -e"
# -> Comando para editar: crontab -e

# El comando para ELIMINAR todas las tareas programadas del usuario (¡Cuidado!).
echo "Comando para borrar todo: crontab -r"
# -> Comando para borrar todo: crontab -r

### --- Sección 2: Ejemplos de Sintaxis y Operadores en Cron ---

# A continuación, se muestran ejemplos de líneas válidas para un archivo crontab.
# Se usan 'echo' para simular cómo se verían escritas dentro del archivo.

# 1. EJECUCIÓN CADA MINUTO
# Los asteriscos puros significan "siempre" o "cada".
echo "* * * * * /home/usuario/scripts/backup.sh"
# -> Ejecuta backup.sh cada minuto de cada día.

# 2. HORA EXACTA (Ej: 03:30 AM todos los días)
echo "30 03 * * * /home/usuario/scripts/limpieza_diaria.sh"
# -> Ejecuta a las 03:30 AM, todos los días del mes, todos los meses.

# 3. LISTAS Y RANGOS (Operadores ',' y '-')
# Ejecutar en el minuto 0 y 30 (lista), de las horas 9 a 17 (rango), de lunes a viernes.
echo "0,30 09-17 * * 1-5 /usr/bin/notificar_trabajo.sh"
# -> Ejecuta a las en punto y a y media, durante horario laboral, solo entre semana.

# 4. PASOS O INTERVALOS (Operador '/')
# Ejecutar cada 5 minutos (step values).
echo "*/5 * * * * /usr/bin/check_status.sh"
# -> Ejecuta en el minuto 0, 5, 10, 15, etc.

### --- Sección 3: Manejo de Salidas y Logs (Crucial para Debugging) ---

# ℹ️ IMPORTANTE: Cron no tiene terminal. Si un script genera output (echo) o errores,
# cron intentará enviar un email al usuario local. Esto suele llenar el buzón de spam local.
# SIEMPRE se debe redirigir la salida estándar (STDOUT) y la de error (STDERR).

# Opción A: Descartar todo (Silencio absoluto).
# 1> /dev/null : Manda la salida estándar al agujero negro.
# 2>&1         : Manda los errores (canal 2) al mismo sitio que el canal 1 (agujero negro).
echo "0 0 * * * /script/mantenimiento.sh > /dev/null 2>&1"
# -> Se ejecuta a medianoche y no deja rastro ni notificaciones.

# Opción B: Logging profesional (Recomendado).
# Redirige todo a un archivo de log con fecha (append >>).
echo "0 0 * * * /script/backup.sh >> /var/log/mi_backup.log 2>&1"
# -> Guarda el historial de ejecución y errores en un archivo de texto.

### --- Sección 4: Atajos Especiales (Special Strings) ---

# Cron permite usar palabras clave que reemplazan a los 5 asteriscos para facilitar la lectura.

# Ejecutar una única vez justo cuando el servidor se enciende o reinicia.
# Muy útil para levantar servicios o demonios personalizados.
echo "@reboot /home/usuario/iniciar_bot.sh"
# -> Ejecuta al arrancar el sistema.

# Alias de periodicidad:
# @yearly   (0 0 1 1 *)
# @monthly  (0 0 1 * *)
# @weekly   (0 0 * * 0)
# @daily    (0 0 * * *)
# @hourly   (0 0 * * * * - error común, es realmente al minuto 0 de cada hora)
echo "@daily /home/usuario/rotar_logs.sh"
# -> Ejecuta una vez al día (usualmente a las 00:00).

### --- Sección 5: System-wide Cron (Cron del Sistema) ---

# Además del crontab de usuario (`crontab -e`), existe el crontab del sistema.
# Ubicación: /etc/crontab
# ℹ️ DIFERENCIA CLAVE: En /etc/crontab se debe especificar EL USUARIO que ejecuta el comando.
# Formato: m h dom mon dow USUARIO comando

# Mostramos las últimas líneas del archivo de configuración del sistema como ejemplo.
tail -n 3 /etc/crontab 2>/dev/null || echo "No tienes permisos de lectura en /etc/crontab"
# -> (Ejemplo de salida esperada)
# -> 17 * * * * root    cd / && run-parts --report /etc/cron.hourly
# -> 25 6    * * * root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.daily )

### --- Sección 6: Comando 'at' (Programación Única) ---

# 'at' se usa para tareas que se ejecutan UNA SOLA VEZ en el futuro, no periódicamente.
# Requiere que el servicio 'atd' esté corriendo.

# 1. PROGRAMAR UNA TAREA (Ejemplo práctico)
# Usamos 'echo' y tubería (|) para enviar el comando a 'at'.
# Programamos un 'ls' para dentro de 1 minuto.
echo "ls -l > /tmp/lista_archivos_at.txt" | at now + 1 minute 2>/dev/null
# -> warning: commands will be executed using /bin/sh
# -> job N at Mon Nov 25 20:35:00 2024 (Muestra el ID del trabajo y la fecha)

# 2. LISTAR TAREAS PENDIENTES (Cola de trabajos)
# Muestra los trabajos en cola programados por el usuario.
atq
# -> 10  Mon Nov 25 20:35:00 2024 a usuario (ID, Fecha, Cola, Usuario)

# 3. ELIMINAR UNA TAREA PENDIENTE
# Se usa 'atrm' seguido del ID del trabajo (obtenido con atq).
# (Comentado para evitar errores si no hay ID 10 real).
# atrm 10
# -> (No produce salida si tiene éxito, simplemente borra la tarea).

# 4. FORMATOS DE TIEMPO FLEXIBLES EN 'AT'
# 'at' es muy inteligente interpretando el tiempo humano en inglés.
echo "Ejemplos de sintaxis para 'at':"
echo "  at 5pm"
echo "  at 10:00am July 31"
echo "  at now + 2 days"
echo "  at 4pm + 3 days"
echo "  at teatime (suele ser las 16:00)"
# -> Muestra opciones de lenguaje natural para programar tareas.