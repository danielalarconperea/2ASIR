#!/bin/bash

### --- Sección 1: Prerrequisitos y Servicio (Daemon) ---

# ℹ️ Antes de usar 'at', debemos asegurarnos de que el paquete esté instalado y el servicio (daemon) 'atd' esté activo.
# 'at' no funcionará si el daemon no está corriendo en segundo plano.

# 🔍 Verificar el estado del servicio
systemctl status atd
# -> ● atd.service - Deferred execution scheduler
# ->    Active: active (running) since Tue 2023-10-27 10:00:00 CEST; ...

# ▶️ Iniciar el servicio si no está activo (requiere sudo)
sudo systemctl start atd
# -> (Sin salida si se ejecuta correctamente)

# 🚀 Habilitar para que inicie con el sistema
sudo systemctl enable atd
# -> Synchronizing state of atd.service with SysV service script with /lib/systemd/systemd-sysv-install.

### --- Sección 2: Sintaxis Básica y Programación de Tareas ---

# ℹ️ La forma más común de usar 'at' en scripts es mediante "pipes" (tuberías).
# Esto evita entrar en el modo interactivo de la shell.
# Sintaxis: echo "comando" | at [TIEMPO]

# ⏰ Programar una tarea para dentro de 1 minuto
# El comando 'touch' creará un archivo vacío como prueba.
echo "touch /tmp/prueba_at.txt" | at now + 1 minute
# -> warning: commands will be executed using /bin/sh
# -> job 1 at Tue Nov 25 21:50:00 2025

# 📅 Programar una tarea a una hora específica (formato HH:MM)
# Si la hora ya pasó, lo programará para mañana.
echo "wall 'Es hora de descansar'" | at 23:00
# -> warning: commands will be executed using /bin/sh
# -> job 2 at Tue Nov 25 23:00:00 2025

### --- Sección 3: Formatos de Tiempo Avanzados ---

# ℹ️ 'at' es muy flexible con el lenguaje natural para definir el tiempo.

# 🌙 Ejecutar a medianoche
echo "tar -czf backup.tar.gz /home/user/docs" | at midnight
# -> job 3 at Wed Nov 26 00:00:00 2025

# ☕ Usando palabras clave como 'teatime' (16:00) o fechas específicas
# Formato de fecha: MMDDYY o DD.MM.YY
echo "echo 'Revisión mensual'" | at 08:00 122525
# -> job 4 at Thu Dec 25 08:00:00 2025

# ⏳ Usando unidades de tiempo relativas (minutes, hours, days, weeks)
echo "rm /tmp/archivos_temporales/*" | at now + 2 days
# -> job 5 at Thu Nov 27 21:48:00 2025

### --- Sección 4: Gestión de la Cola de Trabajos (Queue) ---

# 📋 Listar los trabajos pendientes en la cola
# Muestra: ID del trabajo, Fecha/Hora de ejecución, Cola (a=default), Usuario
atq
# -> 1 Tue Nov 25 21:50:00 2025 a usuario
# -> 2 Tue Nov 25 23:00:00 2025 a usuario
# -> 3 Wed Nov 26 00:00:00 2025 a usuario

# 🗑️ Eliminar un trabajo específico de la cola
# Se utiliza el comando 'atrm' seguido del ID del trabajo (obtenido con atq)
atrm 2
# -> (Sin salida, pero el trabajo 2 desaparece de la cola)

# 🔍 Ver el contenido exacto (comandos) de un trabajo programado antes de que se ejecute
# Flag -c: Muestra el entorno y el script que se ejecutará para el job ID.
at -c 3
# -> #!/bin/sh
# -> # atrun uid=1000 gid=1000
# -> ... (variables de entorno) ...
# -> tar -czf backup.tar.gz /home/user/docs

### --- Sección 5: Uso Avanzado, Archivos y Redirecciones ---

# 📂 Ejecutar comandos desde un archivo externo en lugar de escribirlos en línea
# Flag -f: Especifica el archivo script a leer.
# Supongamos que tenemos un script llamado 'mantenimiento.sh'.
# at -f ./mantenimiento.sh now + 1 hour
# -> job 6 at Tue Nov 25 22:50:00 2025

# 📧 Gestión de la Salida (Output)
# Por defecto, 'at' envía la salida (stdout/stderr) por email al usuario local (/var/mail/usuario).
# Flag -m: Fuerza el envío de correo incluso si no hubo salida.
# Flag -M: Nunca enviar correo.

# 🛠️ Truco Pro: Redirigir salida a un archivo de log para evitar el sistema de mail.
# Esto es crucial en servidores modernos sin servidor de correo configurado.
echo "ls -la /root > /tmp/reporte_root.log 2>&1" | at now + 5 minutes
# -> job 7 at Tue Nov 25 21:53:00 2025

# ⚡ Flag -b: Alias para 'batch'.
# Ejecuta el trabajo solo cuando la carga del sistema (load average) es baja (menor a 1.5 por defecto).
echo "find / -name '*.log'" | at -b now
# -> job 8 at Tue Nov 25 21:49:00 2025