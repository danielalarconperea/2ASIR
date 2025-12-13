#!/bin/bash

# ==============================================================================
# 📝 APUNTES DE BASH: MONITOREO DE USUARIOS Y SESIONES
# Herramientas: who, w, last
# Objetivo: Identificar quién está conectado, qué hace y el historial de accesos.
# ==============================================================================

### --- Sección 1: Comando 'who' (Visión General de Usuarios) ---
# El comando 'who' es la forma más directa de listar usuarios logueados actualmente.
# Consulta el archivo /var/run/utmp.

# 1.1. Uso básico
# Muestra: Nombre de usuario, terminal (tty/pts), fecha y hora de login, e IP (si es remoto).
who
# -> usuario1 tty1         2023-11-26 09:00
# -> admin    pts/0        2023-11-26 10:15 (192.168.1.50)

# 1.2. Añadir cabeceras para legibilidad (-H)
# Útil para entender qué es cada columna rápidamente 📊.
who -H
# -> NOMBRE   LÍNEA        TIEMPO           COMENTARIO
# -> usuario1 tty1         2023-11-26 09:00
# -> admin    pts/0        2023-11-26 10:15 (192.168.1.50)

# 1.3. Mostrar todo (-a / --all)
# Incluye estado de arranque, nivel de ejecución (runlevel) y procesos muertos.
who -a
# ->           sistema arranque 2023-11-26 08:30
# ->           nivel de ejéc 5  2023-11-26 08:30
# -> LOGIN     tty1         2023-11-26 09:00              1234 id=1
# -> usuario1  + tty7       2023-11-26 09:01  00:10       1450 (:0)

# 1.4. Conteo rápido de usuarios (-q)
# Muestra solo los nombres y el total de usuarios conectados 🔢.
who -q
# -> usuario1 admin
# -> # usuarios=2

# 1.5. Ver última hora de arranque del sistema (-b)
# Ideal para saber cuándo se reinició el servidor por última vez 🚀.
who -b
# -> arranq del sist  2023-11-26 08:30

### --- Sección 2: Comando 'w' (Usuarios + Actividad del Sistema) ---
# 'w' es más detallado que 'who'. Muestra quién está, dónde, y QUÉ están ejecutando.
# También muestra la carga del sistema (Load Average) en la cabecera.

# 2.1. Uso estándar
# Cabecera: Hora actual, uptime, usuarios, load average (1, 5, 15 min).
# Columnas: USER, TTY, FROM, LOGIN@, IDLE (tiempo inactivo), JCPU (tiempo CPU total), PCPU (tiempo comando actual), WHAT.
w
# ->  19:40:15 up 11:10,  2 users,  load average: 0.05, 0.03, 0.00
# -> USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
# -> usuario1 tty1     -                09:00    2:00m  0.15s  0.01s -bash
# -> admin    pts/0    192.168.1.50     10:15    1.00s  0.50s  0.05s vi /etc/hosts

# 2.2. Formato corto (-s / --short)
# Omite las columnas de tiempo de login, JCPU y PCPU para una vista más compacta 📉.
w -s
# ->  19:40:15 up 11:10,  2 users,  load average: 0.05, 0.03, 0.00
# -> USER     TTY      FROM              IDLE WHAT
# -> usuario1 tty1     -                 2:00m -bash
# -> admin    pts/0    192.168.1.50      1.00s vi /etc/hosts

# 2.3. Ocultar cabecera (-h)
# Útil si vas a procesar la salida con scripts y solo quieres las filas de usuarios.
w -h
# -> usuario1 tty1     -                09:00    2:00m  0.15s  0.01s -bash
# -> admin    pts/0    192.168.1.50     10:15    1.00s  0.50s  0.05s vi /etc/hosts

# 2.4. Mostrar IP en lugar de hostname (si aplica) (-i)
# Fuerza el uso de direcciones IP en la columna FROM.
w -i
# -> USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
# -> admin    pts/0    192.168.1.50     10:15    1.00s  0.50s  0.05s w -i

### --- Sección 3: Comando 'last' (Historial de Conexiones) ---
# Lee el archivo /var/log/wtmp para mostrar un histórico de logins y reboots.
# Es fundamental para auditoría de seguridad 🛡️.

# 3.1. Uso básico
# Muestra logins recientes, reboots y sesiones cerradas.
last
# -> admin    pts/0        192.168.1.50     Wed Nov 26 10:15   still logged in
# -> usuario1 tty1                          Wed Nov 26 09:00   still logged in
# -> reboot   system boot  5.15.0-generic   Wed Nov 26 08:30   still running
# -> admin    pts/0        192.168.1.50     Tue Nov 25 18:00 - 18:45  (00:45)

# 3.2. Limitar el número de líneas (-n)
# Para no saturar la pantalla con todo el historial histórico.
last -n 3
# -> admin    pts/0        192.168.1.50     Wed Nov 26 10:15   still logged in
# -> usuario1 tty1                          Wed Nov 26 09:00   still logged in
# -> reboot   system boot  5.15.0-generic   Wed Nov 26 08:30   still running

# 3.3. Traducir IPs a Hostnames (-d) vs Mostrar IPs (-i)
# -i muestra siempre la IP (útil si el DNS falla o tarda).
last -i -n 2
# -> admin    pts/0        192.168.1.50     Wed Nov 26 10:15   still logged in
# -> usuario1 tty1         0.0.0.0          Wed Nov 26 09:00   still logged in

# 3.4. Filtrar por usuario específico
# Simplemente se pasa el nombre del usuario como argumento.
last admin
# -> admin    pts/0        192.168.1.50     Wed Nov 26 10:15   still logged in
# -> admin    pts/0        192.168.1.50     Tue Nov 25 18:00 - 18:45  (00:45)

# 3.5. Ver intentos fallidos de login (lastb)
# IMPORTANTE: Requiere permisos de root (sudo). Lee /var/log/btmp 🚫.
# sudo lastb
# -> hacker   ssh:notty    10.0.0.5         Wed Nov 26 03:00 - 03:00  (00:00)

### --- Sección 4: Casos Avanzados y Diagnóstico Automático ---
# Combinación de comandos con pipes (|) para extracción de datos.

# 4.1. Obtener solo la lista de usuarios activos (sin duplicados)
# Usamos 'who', cortamos la primera columna (nombres) y ordenamos únicos.
who | awk '{print $1}' | sort | uniq
# -> admin
# -> usuario1

# 4.2. Detectar terminales inactivos (Zombies o sesiones olvidadas)
# Usamos 'w' con cabecera oculta (-h), filtramos si el tiempo IDLE es alto.
# Ejemplo: mostrar usuarios con más de 1 hora de inactividad (depende del formato de w).
w -h | awk '$4 ~ /m/ || $4 ~ /h/ {print "Usuario inactivo: " $1 " Tiempo: " $4}'
# -> Usuario inactivo: usuario1 Tiempo: 2:00m

# 4.3. Auditar accesos en fechas específicas
# Usamos 'last' y filtramos con 'grep' por un día concreto (ej. "Nov 25").
last -F | grep "Nov 25" | head -n 5
# -> admin    pts/0        192.168.1.50     Tue Nov 25 18:00:00 2023 - Tue Nov 25 18:45:00 2023  (00:45)

# 4.4. Contar cuántas veces se ha logueado un usuario este mes
last | grep "^admin" | wc -l
# -> 15