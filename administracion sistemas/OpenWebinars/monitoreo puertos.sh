#!/bin/bash

### --- Sección 1: lsof (List Open Files) ---

# ℹ️ EXPLICACIÓN:
# lsof es una herramienta versátil porque en Unix/Linux "todo es un archivo", incluidas las conexiones de red.
# Es ideal para identificar qué proceso exacto (PID) y usuario están ocupando un puerto.

# 🔍 1.1 Listado básico de puertos de red
# Muestra todos los archivos de red (-i) abiertos.
# -P: No convierte números de puerto a nombres (ej. muestra 80 en lugar de http).
# -n: No convierte direcciones IP a nombres de host (hace el comando mucho más rápido).
sudo lsof -i -P -n
# -> COMMAND   PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
# -> sshd      854 root    3u  IPv4  20456      0t0  TCP *:22 (LISTEN)
# -> docker-pr 920 root    4u  IPv6  23100      0t0  TCP *:8080 (LISTEN)

# 🎯 1.2 Buscar un puerto específico
# Útil cuando intentas levantar un servicio y obtienes el error "Address already in use".
# Sintaxis: -i :<puerto>
sudo lsof -i :22
# -> COMMAND PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
# -> sshd    854 root    3u  IPv4  20456      0t0  TCP *:ssh (LISTEN)

# 📡 1.3 Filtrar por protocolo (TCP vs UDP)
# Muestra solo conexiones TCP activas.
sudo lsof -i tcp
# -> COMMAND   PID  USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
# -> nginx    1050  root    6u  IPv4  25100      0t0  TCP *:80 (LISTEN)

# ⚡ 1.4 Caso Avanzado: Automatización y Kill
# Imagina que quieres "matar" lo que sea que esté escuchando en el puerto 8080.
# -t: Modo 'terse' (solo imprime el PID sin cabeceras).
# xargs: Pasa el PID al comando kill.
# ⚠️ Cuidado: Esto cerrará el proceso inmediatamente.
sudo lsof -t -i :8080 | xargs kill -9
# -> (No produce salida en consola si tiene éxito, pero el proceso habrá terminado)

# --------------------------------------------------------------------------------

### --- Sección 2: netstat (Network Statistics) ---

# ℹ️ EXPLICACIÓN:
# Herramienta clásica (aunque 'ss' es su sucesor moderno, netstat sigue siendo estándar en muchos exámenes y sistemas legacy).
# Proporciona estadísticas de red, tablas de enrutamiento y conexiones.

# 🛠️ 2.1 El combo estándar de diagnóstico: -tulpn
# Esta combinación es la más usada para ver qué escucha el servidor.
# -t: TCP
# -u: UDP
# -l: Listening (solo puertos a la escucha, ignora conexiones establecidas salientes)
# -p: Program (muestra el PID y nombre del programa, requiere sudo)
# -n: Numeric (IPs y puertos numéricos)
sudo netstat -tulpn
# -> Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
# -> tcp        0      0 0.0.0.0:22              0.0.0.0:* LISTEN      854/sshd
# -> udp        0      0 127.0.0.53:53           0.0.0.0:* 600/systemd-resolve

# 📊 2.2 Estadísticas continuas
# -c: Continuous. Ejecuta el comando cada segundo. Útil para ver conexiones en tiempo real mientras pruebas una app.
# (Debes cancelar con Ctrl+C)
# netstat -atc
# -> (Actualiza la lista de conexiones TCP cada segundo...)

# 🔎 2.3 Filtrar con Grep (Uso común)
# Buscar si un servicio específico (ej. mysql) está escuchando.
sudo netstat -pn | grep mysql
# -> tcp6       0      0 :::3306                 :::* LISTEN      1120/mysqld

# --------------------------------------------------------------------------------

### --- Sección 3: nmap (Network Mapper) ---

# ℹ️ EXPLICACIÓN:
# A diferencia de lsof/netstat que ven el sistema "desde dentro", nmap lo audita "desde fuera" (o hacia otros hosts).
# Es la herramienta estándar para auditoría de seguridad y descubrimiento de redes.

# 🏠 3.1 Escaneo básico de host (Localhost o Remoto)
# Escanea los 1000 puertos más comunes.
nmap localhost
# -> Starting Nmap 7.80 ( https://nmap.org )
# -> Nmap scan report for localhost (127.0.0.1)
# -> PORT     STATE SERVICE
# -> 22/tcp   open  ssh
# -> 80/tcp   open  http
# -> 3306/tcp open  mysql

# 🕵️ 3.2 Detección de Versiones y Servicios (-sV)
# Crucial para saber QUÉ versión de software corre en el puerto (ej. Apache 2.4.41).
# Interroga a los puertos abiertos para obtener banners y firmas.
nmap -sV localhost
# -> PORT   STATE SERVICE VERSION
# -> 22/tcp open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
# -> 80/tcp open  http    Apache httpd 2.4.41 ((Ubuntu))

# 🚀 3.3 Escaneo Rápido (-F) y Puertos Específicos (-p)
# -F: Fast mode (escanea menos puertos que el default).
# -p-: Escanea TODOS los 65535 puertos (lento pero exhaustivo).
# -p 22,80,443: Escanea solo esa lista.
nmap -F 192.168.1.1
# -> (Escaneo rápido de los puertos más comunes en el router/host)

# 🛡️ 3.4 Escaneo de Sistema Operativo (-O)
# Intenta adivinar el SO del objetivo basándose en cómo responde la pila TCP/IP.
# Requiere privilegios de root para enviar paquetes raw.
sudo nmap -O localhost
# -> Device type: general purpose
# -> Running: Linux 4.X|5.X
# -> OS CPE: cpe:/o:linux:linux_kernel:5.4
# -> OS details: Linux 4.15 - 5.6

# 🔍 3.5 Diagnóstico: ¿Está el puerto filtrado por firewall?
# nmap distingue entre 'open' (abierto), 'closed' (cerrado, pero responde) y 'filtered' (firewall bloquea/descarta paquete).
nmap -p 8080 google.com
# -> PORT     STATE    SERVICE
# -> 8080/tcp filtered http-proxy
# -> (Indica que un firewall está bloqueando el tráfico a este puerto, no llega respuesta)