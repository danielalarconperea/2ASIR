#!/bin/bash

# ==============================================================================
# 📚 APUNTES DE BASH: PROGRAMADOR DE TAREAS (CRON Y ANACRON)
# ==============================================================================
# 📄 Basado en: Programador de tareas.pdf
# 🎯 Objetivo: Gestión de tareas programadas en sistemas Unix/Linux.

### --- SECCIÓN 1: GESTIÓN DEL DEMONIO CRON (SERVICIO) ---

# [cite_start]⚙️ Cron es un demonio que ejecuta tareas en segundo plano a intervalos regulares[cite: 6].
# [cite_start]Se inicia con el sistema, pero se puede controlar manualmente si tienes permisos (root)[cite: 7].
# El siguiente comando inicia el servicio (en distros basadas en SysVinit/scripts init.d):
/etc/init.d/crond start
# -> Iniciando el servicio crond... [OK]

# [cite_start]🛑 Para detener el servicio si es necesario realizar mantenimiento[cite: 214]:
/etc/init.d/crond stop
# -> Deteniendo el servicio crond... [OK]

# [cite_start]🔄 Para reiniciar el servicio (útil si se atasca, aunque cron recarga cambios automáticamente)[cite: 211, 214]:
/etc/init.d/crond restart
# -> Reiniciando crond... [OK]

### --- SECCIÓN 2: COMANDO CRONTAB DE USUARIO ---

# [cite_start]👤 Cada usuario tiene su propia tabla (crontab) almacenada en /var/spool/cron[cite: 123].
# [cite_start]⚠️ No se editan los archivos directamente, se usa el comando 'crontab'[cite: 122].

# ✏️ Editar tu archivo crontab actual. [cite_start]Si no existe, crea uno nuevo[cite: 126, 127].
# [cite_start]Abre el editor definido en la variable EDITOR (por defecto vi)[cite: 129].
# [cite_start]Al guardar y salir, cron verifica errores de sintaxis automáticamente[cite: 135].ñ
crontab -e
# -> (Abre la interfaz del editor de texto para añadir líneas de programación)

# [cite_start]📋 Listar el contenido de tu archivo crontab actual[cite: 144].
# Muestra las tareas programadas sin abrir el editor.
crontab -l
# -> 0 17 * * 5 /usr/bin/banner "¡Ya llegó el fin de semana!" > /dev/pts/0

# [cite_start]🗑️ Eliminar tu archivo crontab completo[cite: 145].
# ¡Cuidado! Borra todas las tareas programadas del usuario actual.
crontab -r
# -> (Sin salida, pero el archivo en /var/spool/cron/usuario ha sido borrado)

# 👮 Gestión administrativa (Solo Root):
# [cite_start]Root puede gestionar el crontab de otros usuarios con la flag '-u'[cite: 146].
# Ejemplo: Listar el crontab del usuario 'sysadmin'.
crontab -u sysadmin -l
# -> (Muestra las tareas programadas del usuario sysadmin)

### --- SECCIÓN 3: SINTAXIS Y FORMATO DE ENTRADAS CRON ---

# [cite_start]📐 El formato estándar de una línea en crontab tiene 6 campos[cite: 66, 67]:
# Minuto(0-59) Hora(0-23) Día_Mes(1-31) Mes(1-12) Día_Semana(0-7) Comando
# [cite_start]Nota: En Día_Semana, 0 y 7 son Domingo[cite: 70].

# [cite_start]👇 Ejemplo 1: Ejecutar una tarea a las 4:30 AM todos los lunes de enero[cite: 79, 80].
echo "30 04 * 1 1 /usr/bin/comando"
# -> 30 04 * 1 1 /usr/bin/comando

# [cite_start]👇 Ejemplo 2: Uso de rangos (-), listas (,) y pasos (/)[cite: 84, 86, 87].
# Minutos: 01 y 31. Horas: 04 y 05. Días del mes: 1 al 15. Meses: Enero y Junio.
echo "01,31 04,05 1-15 1,6 * /usr/bin/comando"
# -> 01,31 04,05 1-15 1,6 * /usr/bin/comando

# [cite_start]⚡ Palabras clave especiales (Atajos)[cite: 108, 110].
# @reboot: Se ejecuta una vez al inicio del sistema.
# @daily: Se ejecuta una vez al día (equivalente a 0 0 * * *).
echo "@daily /home/sysadmin/bin/daily-backup"
# -> @daily /home/sysadmin/bin/daily-backup

# [cite_start]📧 Variables dentro del crontab[cite: 96, 100].
# [cite_start]Cron no carga el entorno del usuario (.bashrc), por lo que definir PATH es crucial[cite: 103].
# [cite_start]MAILTO define a quién se envía la salida del comando (por defecto al usuario)[cite: 105, 107].
echo "MAILTO=databaseadmin"
# -> MAILTO=databaseadmin

### --- SECCIÓN 4: CRONTAB DEL SISTEMA Y DIRECTORIOS ---

# [cite_start]🖥️ El crontab del sistema permite tareas administrativas (root)[cite: 20].
# [cite_start]A diferencia del de usuario, este tiene un campo extra: el USUARIO que ejecuta el comando[cite: 39, 57].
# Ubicación: /etc/crontab.

# [cite_start]👀 Ver el contenido del crontab del sistema[cite: 157, 160].
cat /etc/crontab
# -> SHELL=/bin/bash
# -> PATH=/sbin:/bin:/usr/sbin:/usr/bin
# -> MAILTO=root
# -> # minuto hora día_mes mes día_sem usuario comando
# -> 0 23 * * * root /usr/root/bkup.sh

# [cite_start]📂 Directorios predefinidos para ejecución periódica[cite: 181, 191].
# Los scripts colocados aquí se ejecutan automáticamente por hora, día, semana o mes.
# [cite_start]Nota: En sistemas modernos, esto suele gestionarse mediante anacron[cite: 186].
ls -d /etc/cron.*
# -> /etc/cron.d
# -> /etc/cron.daily
# -> /etc/cron.hourly
# -> /etc/cron.monthly
# -> /etc/cron.weekly

# [cite_start]🧩 Directorio /etc/cron.d[cite: 187, 188].
# Usado por paquetes de software para instalar sus propias tareas cron sin tocar /etc/crontab.
ls /etc/cron.d
# -> (Lista de archivos específicos de aplicaciones instaladas, ej: sysstat)

### --- SECCIÓN 5: CONTROL DE ACCESO (ALLOW / DENY) ---

# [cite_start]🛡️ Root puede restringir quién usa 'crontab' mediante dos archivos[cite: 231].

# [cite_start]1️⃣ Si existe cron.allow: Solo los usuarios listados pueden usar cron[cite: 239].
# [cite_start]2️⃣ Si existe cron.deny: Los usuarios listados NO pueden usar cron (el resto sí)[cite: 240].
# [cite_start]3️⃣ Si existen ambos: cron.allow tiene preferencia[cite: 241].

# Ver lista de usuarios permitidos (si existe el fichero):
cat /etc/cron.allow 2>/dev/null
# -> (Lista de usuarios autorizados, uno por línea)

# [cite_start]Ver lista de usuarios denegados (si existe el fichero, suele estar vacío por defecto)[cite: 251]:
cat /etc/cron.deny 2>/dev/null
# -> (Lista de usuarios bloqueados)

### --- SECCIÓN 6: ANACRON (PARA EQUIPOS NO CONTINUOS) ---

# [cite_start]💻 Anacron es para sistemas que no están encendidos 24/7 (portátiles/desktops)[cite: 274, 303].
# [cite_start]Garantiza que las tareas (diarias/semanales) se ejecuten al encender el equipo si se perdieron[cite: 275].
# [cite_start]Granularidad mínima: Días (no minutos)[cite: 303].

# [cite_start]📄 Archivo de configuración: /etc/anacrontab[cite: 278].
# [cite_start]Formato: Periodo(días) Retardo(minutos) ID_Trabajo Comando[cite: 279].
cat /etc/anacrontab
# -> 1  5   cron.daily    nice run-parts /etc/cron.daily
# -> 7  25  cron.weekly   nice run-parts /etc/cron.weekly
# -> (Significa: Tareas diarias corren 5 min tras inicio si no se ejecutaron ayer)

# [cite_start]⚡ Forzar la ejecución de tareas anacron independientemente de la fecha[cite: 301].
# Útil para probar configuraciones o forzar mantenimiento.
# Flags: -f (force), -n (now/sin retardo). Requiere root.
anacron -f -n
# -> (Ejecuta los trabajos pendientes inmediatamente y actualiza las marcas de tiempo)