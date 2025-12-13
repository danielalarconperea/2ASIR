#!/bin/bash

### --- Sección 1: Introducción a systemd-journald y journalctl ---
# 📘 El 'journal' es un componente de systemd que captura mensajes de syslog, 
# mensajes del kernel, logs de arranque inicial y salida estándar/error de servicios.
# A diferencia de los logs de texto plano tradicionales (/var/log/syslog), el journal 
# es binario, indexado y estructurado, lo que permite búsquedas mucho más rápidas y complejas.

# 🟢 Sintaxis básica: Muestra todos los logs recopilados en el sistema (puede ser muy largo).
# Utiliza un paginador (como less) por defecto.
journalctl
# -> (Salida paginada mostrando fecha, hora, host, proceso y mensaje)
# -> Nov 26 10:00:00 myhost systemd[1]: Started Session 1 of user root.

### --- Sección 2: Navegación y Filtrado Básico ---

# 📄 Muestra solo las últimas N líneas (útil para ver qué acaba de pasar).
# '-n' o '--lines': especifica el número de líneas.
journalctl -n 20
# -> (Muestra las últimas 20 entradas del log)

# 🔄 Modo "Follow" (Monitorización en tiempo real).
# Similar a 'tail -f'. Muestra nuevas entradas a medida que llegan.
# Requiere Ctrl+C para salir.
journalctl -f
# -> (El cursor se queda esperando nuevas líneas de log...)

# 🔙 Mostrar logs en orden inverso (lo más nuevo primero).
# '-r' o '--reverse': Útil para no tener que hacer scroll hasta el final.
journalctl -r
# -> (Muestra primero el último evento registrado)

# 🛑 Mostrar solo logs del arranque (boot) actual.
# '-b': Boot. Sin argumentos es el actual. '-b -1' es el anterior, etc.
journalctl -b
# -> -- Logs begin at Mon 2023-01-01 10:00:00 CET, end at ... --
# -> (Solo eventos desde el último reinicio)

### --- Sección 3: Filtrado Avanzado (Tiempo y Unidades) ---

# 🕒 Filtrar por tiempo (Logs recientes).
# '--since': Acepta "yesterday", "today", "now", "-1h", o fechas "YYYY-MM-DD HH:MM:SS".
journalctl --since "1 hour ago"
# -> (Logs generados en los últimos 60 minutos)

# 📅 Filtrar por un rango de tiempo específico.
# Combina '--since' y '--until'.
journalctl --since "2023-11-25 08:00:00" --until "2023-11-25 12:00:00"
# -> (Logs limitados estrictamente a esa ventana de 4 horas)

# ⚙️ Filtrar por Unidad de Systemd (Servicios específicos).
# '-u': Unit. Es el filtro más común para depurar servicios (ej. nginx, ssh, docker).
journalctl -u ssh
# -> Nov 26 12:00:00 host sshd[1234]: Accepted publickey for user...

# 🔢 Filtrar por PID (Process ID).
# Útil si sabes qué proceso específico falló. Sustituye 1234 por el PID real.
journalctl _PID=1234
# -> (Solo logs generados por ese proceso específico)

### --- Sección 4: Niveles de Prioridad y Kernel ---

# ⚠️ Filtrar por prioridad (syslog levels).
# '-p': Priority. Niveles: emerg (0), alert (1), crit (2), err (3), warning (4), notice (5), info (6), debug (7).
# Muestra el nivel indicado y los más graves (ej. 'err' muestra err, crit, alert, emerg).
journalctl -p err
# -> Nov 26 14:00:00 host nginx[555]: [error] ... (Solo errores o críticos)

# 🐧 Logs del Kernel (dmesg).
# '-k': Muestra solo mensajes del anillo de buffer del kernel.
journalctl -k
# -> (Mensajes de hardware, drivers, stack de red, etc.)

### --- Sección 5: Formatos de Salida y Automatización ---

# 🛠️ Salida en formato JSON (para parsear con herramientas externas).
# '-o': Output. Opciones: short, verbose, json, json-pretty, cat.
# Ideal para ingesta de logs en sistemas como ELK o scripts de Python.
journalctl -u nginx -o json-pretty
# -> {
# ->   "__CURSOR" : "s=...",
# ->   "MESSAGE" : "Started A high performance web server...",
# ->   "PRIORITY" : "6",
# ->   ...
# -> }

# 🤖 Ejemplo de Automatización: Buscar errores de SSH en la última hora y contar ocurrencias.
# Usamos '--no-pager' para evitar que se quede esperando input del usuario en scripts.
journalctl -u ssh --since "1 hour ago" -p err --no-pager | wc -l
# -> 5 (Número de líneas de error encontradas)

# 🧹 Salida limpia sin metadatos extra (timestamp/host).
# '-o cat': Muestra solo el mensaje en sí.
journalctl -u mi-script.service -o cat
# -> Iniciando proceso de backup...
# -> Backup completado.

### --- Sección 6: Mantenimiento y Gestión del Disco ---

# 💾 Ver cuánto espacio en disco están ocupando los logs.
journalctl --disk-usage
# -> Archived and active journals take up 3.2G in the file system.

# 🧹 Limpieza (Vacuum): Rotación y borrado de logs antiguos.
# '--vacuum-time': Borra logs más antiguos que X tiempo.
# '--vacuum-size': Borra los logs más antiguos hasta que el tamaño total sea X.
journalctl --vacuum-time=2d
# -> Vacuuming done, freed 1.2G of archived journals from /var/log/journal/DIR...

# 🛡️ Verificar la integridad de los ficheros del journal.
# Comprueba si los archivos binarios están corruptos.
journalctl --verify
# -> PASS: /var/log/journal/.../system.journal
# -> (Indica si hay corrupción en la base de datos de logs)