#!/bin/bash

# ==============================================================================
# 📘 APUNTES DE BASH: GESTIÓN AVANZADA DEL JOURNAL (SYSTEMD)
# ==============================================================================
# Este script cubre:
# 1. logger: Envío manual de mensajes al log del sistema.
# 2. journalctl (Admin): Revisión de estado y verificación de integridad.
# 3. journalctl (Mantenimiento): Limpieza (vacuum) y rotación de logs.
# ==============================================================================

### --- Sección 1: Introducción manual de mensajes (logger) ---

# 📝 Comando básico para enviar un mensaje al log del sistema (syslog/journal).
# Por defecto, usa la prioridad 'user.notice'.
logger "Mensaje de prueba simple al journal"
# -> (No produce salida en pantalla. Se escribe en /var/log/syslog o el journal)

# 🏷️ Uso de etiquetas (-t / --tag) para identificar el origen del mensaje.
# Muy útil para filtrar luego con: journalctl -t MiScriptBackup
logger -t MiScriptBackup "Iniciando respaldo de base de datos..."
# -> (Entrada en journal: "Nov 26 10:00:00 hostname MiScriptBackup: Iniciando respaldo...")

# 🎚️ Definición de prioridad y facilidad (-p / --priority).
# Formato: facilidad.nivel
# Facilidades comunes: auth, cron, daemon, kern, user, local0-7.
# Niveles (de alto a bajo): emerg, alert, crit, err, warning, notice, info, debug.
logger -p local0.err "Error crítico en el módulo de procesamiento"
# -> (Registra el mensaje con nivel de error, útil para configurar alertas automáticas)

# 🆔 Incluir el Process ID (-i / --id) del script que genera el log.
# Añade el PID entre corchetes después de la etiqueta.
logger -i -t MiApp "El servicio se ha detenido inesperadamente"
# -> (Entrada: "MiApp[12345]: El servicio se ha detenido...")

# 📄 Enviar el contenido de un archivo línea por línea al journal (-f / --file).
# Útil para volcar logs de aplicaciones que no usan syslog nativamente.
# logger -f /var/log/mi_app_propia.log
# -> (Lee el archivo y envía cada línea como una entrada al journal)

# 🔌 Uso de Stdin (-s) y Pipes para logging de comandos.
# Captura la salida de un comando y la envía al log, mostrando también en pantalla (-s).
echo "Actualización completada" | logger -s -t UpdateSystem
# -> <13>Nov 26 10:05:00 UpdateSystem: Actualización completada (Salida en Stderr y Journal)

### --- Sección 2: Administración y Estado del Journal ---

# 💾 Comprobar el uso de disco ocupado por el journal.
# Muestra cuánto espacio están ocupando los logs archivados y activos.
journalctl --disk-usage
# -> Archived and active journals take up 1.2G in the file system.

# 🏥 Verificar la integridad de los archivos del journal.
# Escanea los archivos de log en busca de corrupciones internas.
# Flags: --verify (Revisa checksums y estructura).
journalctl --verify
# -> PASS: /var/log/journal/.../system.journal
# -> ...

# ⚙️ Ver información de cabecera y configuración interna.
# Muestra detalles sobre cuándo empezó el journal, UUIDs y límites.
journalctl --header | head -n 5
# -> File Path: /var/log/journal/.../system.journal
# -> File ID: ...
# -> Machine ID: ...

### --- Sección 3: Mantenimiento y Limpieza (Vacuum & Rotate) ---
# NOTA: Estos comandos requieren permisos de superusuario (sudo).

# 🔄 Rotación de logs (--rotate).
# Fuerza al sistema a cerrar los archivos de log activos y abrir nuevos.
# Esto archiva los actuales inmediatamente, marcándolos como listos para limpieza si es necesario.
sudo journalctl --rotate
# -> (No retorna texto si tiene éxito, simplemente realiza la acción)

# 🧹 Limpieza por TIEMPO (--vacuum-time).
# Borra todos los logs archivados que sean más antiguos que el tiempo especificado.
# Formatos aceptados: s, m, h, days, weeks, months, years.
sudo journalctl --vacuum-time=2weeks
# -> Vacuuming done, freed 0B of archived journals from /var/log/journal/...
# -> Deleted archived journal /var/log/journal/... (si hubiera antiguos)

# 🧹 Limpieza por TAMAÑO (--vacuum-size).
# Reduce el tamaño total de los logs retenidos hasta alcanzar el tamaño especificado.
# Elimina los archivos más antiguos primero.
sudo journalctl --vacuum-size=500M
# -> Vacuuming done, freed 1.1G of archived journals from /var/log/journal/...

# 🧹 Limpieza por CANTIDAD DE ARCHIVOS (--vacuum-files).
# Limita el número de archivos de journal archivados a una cantidad específica.
sudo journalctl --vacuum-files=5
# -> Vacuuming done, freed 0B of archived journals...

# 🗑️ Limpieza radical (solo para casos extremos).
# Combina rotación y vacuum inmediato para dejar solo los logs activos actuales.
# 1. Rota.
# 2. Vacía todo lo que tenga más de 1 segundo de antigüedad (efectivamente todo lo archivado).
sudo journalctl --rotate
sudo journalctl --vacuum-time=1s
# -> (Deja el sistema con el journal prácticamente vacío y limpio)