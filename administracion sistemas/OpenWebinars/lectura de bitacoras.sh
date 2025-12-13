#!/bin/bash

# ==============================================================================
# 📘 APUNTES DE BASH: LECTURA Y MONITOREO DE BITÁCORAS (LOGS)
# ==============================================================================

### --- Sección 1: Lectura Estática (Archivos de texto plano) ---

# 1.1. Lectura paginada con 'less'
# 🧐 'less' es la herramienta estándar para leer logs largos sin cargar todo en memoria.
# Permite navegar con flechas. Se sale presionando 'q'.
# Flags útiles:
# -N : Muestra números de línea.
# +G : Abre el archivo directamente al final (útil para ver lo último).
less -N /var/log/syslog
# -> (Abre una interfaz interactiva mostrando el contenido del log con números de línea)

# 1.2. Ver las últimas líneas con 'tail'
# 🤏 Muestra por defecto las últimas 10 líneas del archivo.
# Flags útiles:
# -n 20 : Muestra las últimas 20 líneas específicamente.
tail -n 20 /var/log/auth.log
# -> May 20 10:00:01 server CRON[123]: (root) CMD (command)
# -> ... (Muestra solo las 20 entradas más recientes)

# 1.3. Ver las primeras líneas con 'head'
# 👆 Útil para ver cabeceras o cuándo rotó el log (fecha de inicio del archivo).
head -n 5 /var/log/dmesg
# -> [    0.000000] Linux version 5.15.0 ...
# -> ... (Muestra las primeras 5 líneas del arranque del kernel)

### --- Sección 2: Monitoreo en Tiempo Real (Live Tailing) ---

# 2.1. Seguimiento continuo con 'tail -f'
# ⏱️ El comando esencial para sysadmins. Mantiene el archivo abierto y muestra
# nuevas líneas conforme se escriben. Se cancela con Ctrl+C.
tail -f /var/log/syslog
# -> (La terminal espera... si ocurre un evento, aparece inmediatamente aquí)

# 2.2. Seguimiento de múltiples archivos
# 📂 Puedes monitorear varios logs a la vez. Bash indicará de qué archivo viene la línea.
tail -f /var/log/syslog /var/log/auth.log
# -> ==> /var/log/syslog <==
# -> (Log de sistema...)
# -> ==> /var/log/auth.log <==
# -> (Log de autenticación...)

### --- Sección 3: Systemd Journal (Sistemas Modernos) ---

# 3.1. Uso de 'journalctl'
# ⚙️ En distros con systemd (Ubuntu, CentOS 7+, Debian 8+), los logs son binarios.
# Se usa 'journalctl' para leerlos.
# Flags críticas:
# -x : Añade explicaciones y textos de ayuda a los errores (catálogo).
# -e : Salta inmediatamente al final (end) del paginador.
journalctl -xe
# -> (Muestra los logs del sistema, incluyendo servicios fallidos, con gran detalle)

# 3.2. Monitoreo en vivo con journalctl
# 🔄 Equivalente a 'tail -f' pero para systemd.
# -u ssh : Filtra solo los logs de una unidad específica (ej. servicio SSH).
# -f : Follow (seguir en tiempo real).
journalctl -u ssh -f
# -> (Muestra en tiempo real solo los intentos de conexión SSH)

# 3.3. Filtrado por tiempo
# 📅 Permite ver logs de un periodo específico usando lenguaje natural.
# --since "1 hour ago" : Muestra logs de la última hora.
journalctl --since "1 hour ago"
# -> (Lista todos los eventos ocurridos en los últimos 60 minutos)

### --- Sección 4: Búsqueda y Filtrado Avanzado (grep) ---

# 4.1. Filtrar errores específicos
# 🔍 Usamos tuberías (|) para pasar la salida de cat/tail a grep.
# -i : Case insensitive (ignora mayúsculas/minúsculas).
# 'error|fail' : Busca cualquiera de las dos palabras (expresión regular básica).
cat /var/log/syslog | grep -i "error\|fail"
# -> May 20 10:05:01 server app[99]: Critical Error in module X
# -> (Solo muestra las líneas que contienen problemas)

# 4.2. Filtrar y limpiar salida en vivo
# 🧹 Combina monitoreo en vivo excluyendo ruido.
# -v : Invertir búsqueda (mostrar lo que NO coincida).
tail -f /var/log/nginx/access.log | grep -v "Googlebot"
# -> (Muestra visitas al servidor web en tiempo real, ocultando las del bot de Google)