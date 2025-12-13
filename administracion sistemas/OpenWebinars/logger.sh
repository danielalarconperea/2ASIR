#!/bin/bash

### --- Sección 1: Sintaxis Básica y Funcionamiento General ---

# 📝 El comando 'logger' es una interfaz para el sistema de logs del sistema (syslog/journald).
# Permite enviar mensajes a los archivos de registro del sistema (normalmente /var/log/syslog o journalctl).
# Uso básico: Envía un mensaje simple al log con la prioridad por defecto (user.notice).
logger "Inicio del script de pruebas"
# -> (En /var/log/syslog): Nov 26 10:00:00 hostname user: Inicio del script de pruebas

# 🖥️ Flag -s (stderr):
# Envía el mensaje al log del sistema Y TAMBIÉN a la salida de error estándar (pantalla).
# Útil para depurar scripts mientras se ejecutan manualmente.
logger -s "Este mensaje sale en pantalla y en el log"
# -> (Pantalla): <user.notice> Nov 26 10:01:00 user: Este mensaje sale en pantalla y en el log
# -> (Log): Nov 26 10:01:00 hostname user: Este mensaje sale en pantalla y en el log

### --- Sección 2: Metadatos y Etiquetado (Tags) ---

# 🏷️ Flag -t (tag):
# Añade una etiqueta específica al mensaje. Crucial para filtrar logs posteriormente.
# Sin esta flag, el tag por defecto es el nombre del usuario o comando.
logger -t MI_APP "Iniciando servicio de base de datos"
# -> (Log): Nov 26 10:05:00 hostname MI_APP: Iniciando servicio de base de datos

# 🆔 Flag -i (id):
# Registra el PID (Process ID) del proceso que invoca al logger.
# Es fundamental para rastrear ejecuciones específicas de un script en entornos concurrentes.
logger -i -t MI_SCRIPT "Proceso iniciado"
# -> (Log): Nov 26 10:06:00 hostname MI_SCRIPT[12345]: Proceso iniciado

### --- Sección 3: Prioridades y Facilidades (Flag -p) ---

# 🎚️ Flag -p (priority):
# Define la categoría (facility) y la severidad (level) del mensaje.
# Formato: facility.level
# Facilities comunes: auth, cron, daemon, kern, local0-local7, user, mail.
# Levels comunes: debug, info, notice, warning, err, crit, alert, emerg.

# Ejemplo: Registrar un error crítico de autenticación.
logger -p auth.crit "Fallo crítico en la autenticación del usuario root"
# -> (Log auth.log): Nov 26 10:10:00 hostname auth: Fallo crítico en la autenticación del usuario root

# Ejemplo: Usar facilidades locales (local0 a local7) para logs personalizados de aplicaciones.
logger -p local0.info -t BACKUP "Copia de seguridad completada con éxito"
# -> (Log syslog/messages): Nov 26 10:11:00 hostname BACKUP: Copia de seguridad completada con éxito

### --- Sección 4: Automatización y Entrada de Archivos ---

# 📂 Flag -f (file):
# Lee el contenido de un archivo y envía cada línea al log.
# Útil para volcar logs temporales de aplicaciones al sistema central.
echo "Error línea 1" > errores_temp.txt
echo "Error línea 2" >> errores_temp.txt
logger -p local0.err -t IMPORTADOR -f errores_temp.txt
# -> (Log): Nov 26 10:15:00 hostname IMPORTADOR: Error línea 1
# -> (Log): Nov 26 10:15:00 hostname IMPORTADOR: Error línea 2

# 🔗 Integración con Pipes (Tuberías):
# Logger puede leer directamente de la entrada estándar (stdin).
# Esto permite loguear la salida de otros comandos.
df -h | grep "/dev/sda1" | logger -t DISCO_ESPACIO
# -> (Log): Nov 26 10:16:00 hostname DISCO_ESPACIO: /dev/sda1       50G   25G   25G  50% /

### --- Sección 5: Opciones Avanzadas de Diagnóstico y Red ---

# 🌐 Logging Remoto (UDP/TCP):
# Logger puede enviar mensajes a un servidor syslog remoto en lugar de localmente.
# Flag -n: Servidor remoto.
# Flag -P: Puerto (por defecto 514).
# Flag -d: Usar datagramas (UDP) en lugar de TCP (comportamiento varía según versión de logger/sistema).
# Nota: Esto requiere que el firewall y el servidor remoto acepten tráfico syslog.
# logger -n 192.168.1.50 -P 514 -t REMOTO "Mensaje enviado al servidor central"
# -> (En servidor 192.168.1.50): Nov 26 10:20:00 hostname REMOTO: Mensaje enviado al servidor central

# 📏 Limitar tamaño del mensaje (--size):
# Establece el tamaño máximo del mensaje permitido.
logger --size 50 "Mensaje muy largo que podría ser truncado si excede el límite"
# -> (Log): Nov 26 10:21:00 hostname user: Mensaje muy largo que podría ser truncado si excede el límite

### --- Sección 6: Verificación de Resultados ---

# 🔍 Cómo ver los logs generados:
# En sistemas modernos con systemd, usamos journalctl filtrando por el TAG que usamos.
# El siguiente comando es para verificar el ejemplo de la Sección 2.
journalctl -t MI_APP --since "1 hour ago"
# -> -- Logs begin at ... --
# -> Nov 26 10:05:00 hostname MI_APP: Iniciando servicio de base de datos