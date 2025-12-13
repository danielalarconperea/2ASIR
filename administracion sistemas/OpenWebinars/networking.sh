#!/bin/bash

# ==============================================================================
# 📝 APUNTES DE BASH: NETWORKING AVANZADO EN LINUX
# ==============================================================================
# Este script cubre los conceptos fundamentales de redes en Linux según el temario solicitado.
# Guárdalo como 'networking_study.sh' y ábrelo en VSCode con la extensión 'Bash IDE'.
# ==============================================================================

### --- Sección 1: El Servicio de Red en Linux 🌐 ---
# En Linux, la red es gestionada por demonios (servicios). Dependiendo de la distribución,
# esto puede ser 'NetworkManager', 'systemd-networkd' o el antiguo 'networking'.

# 1. Verificar el estado del servicio de red (NetworkManager es el más común en escritorio/RHEL).
# Muestra si el servicio está activo (running), inactivo o fallido.
systemctl status NetworkManager
# -> Active: active (running) since Fri 2023-10-27 10:00:00 CEST; ...

# 2. Reiniciar el servicio de red (útil tras cambiar configuraciones).
# ⚠️ Cuidado: Esto cortará momentáneamente la conexión.
sudo systemctl restart NetworkManager
# -> (Sin salida si el comando es exitoso, código de retorno 0)

# 3. Alternativa para sistemas antiguos (SysVinit) o servidores Debian/Ubuntu legacy.
sudo service networking status
# -> [ + ] networking is running


### --- Sección 2: Archivos Importantes de Networking 📂 ---
# Linux trata la configuración de red como archivos de texto. Aquí están los esenciales.

# 1. Resolución de nombres local (/etc/hosts).
# Mapea direcciones IP a nombres de host antes de consultar a un servidor DNS.
cat /etc/hosts
# -> 127.0.0.1      localhost
# -> 192.168.1.50   servidor-pruebas

# 2. Configuración de servidores DNS (/etc/resolv.conf).
# Define a quién preguntar para traducir 'google.com' a una IP.
cat /etc/resolv.conf
# -> nameserver 8.8.8.8
# -> nameserver 1.1.1.1

# 3. Orden de búsqueda de nombres (/etc/nsswitch.conf).
# Le dice al sistema: "primero mira en archivos locales (files), luego pregunta al DNS".
grep "hosts:" /etc/nsswitch.conf
# -> hosts:          files dns


### --- Sección 3: Comandos Ifconfig, Ping e Interconexión 📡 ---
# Herramientas básicas para verificar la interfaz y la conectividad.

# 1. ifconfig (Del paquete net-tools, considerado 'deprecated' pero muy usado).
# Muestra interfaces, IPs, Máscaras y MAC addresses.
# -a: Muestra todas las interfaces, incluso las que están abajo (down).
ifconfig -a
# -> eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
# ->       inet 192.168.1.15  netmask 255.255.255.0  broadcast 192.168.1.255

# 2. El sucesor moderno de ifconfig: 'ip' (iproute2).
# Es más potente y es el estándar actual.
# 'a' o 'addr': Muestra direcciones.
ip a show
# -> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 ... inet 192.168.1.15/24 ...

# 3. Ping: Verificar alcanzabilidad de una máquina remota (ICMP).
# -c 4: Envía solo 4 paquetes (en Linux el ping es infinito por defecto).
ping -c 4 8.8.8.8
# -> 64 bytes from 8.8.8.8: icmp_seq=1 ttl=115 time=14.2 ms
# -> --- 8.8.8.8 ping statistics ---
# -> 4 packets transmitted, 4 received, 0% packet loss

# 4. Ping avanzado: Especificar interfaz de salida.
# Útil si tienes varias tarjetas de red y quieres probar una específica (-I).
ping -I eth0 -c 2 google.com
# -> 64 bytes from ... (saliendo explícitamente por eth0)


### --- Sección 4: Cambio de IP Dinámica a Estática y Viceversa 🔄 ---
# Concepto:
# Dinámica (DHCP): El router te asigna la IP automáticamente.
# Estática: Tú defines la IP fija en el archivo de configuración.

# --- MODO 1: Gestión Dinámica (DHCP) desde CLI ---

# 1. Liberar la IP actual (quedarse sin IP).
# -r: Release (liberar).
sudo dhclient -r
# -> (La interfaz pierde su IP asignada, desconexión temporal)

# 2. Pedir una nueva IP al servidor DHCP.
# -v: Verbose (muestra el proceso de DORA: Discover, Offer, Request, Ack).
sudo dhclient -v
# -> DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 3...
# -> DHCPACK from 192.168.1.1... bound to 192.168.1.20

# --- MODO 2: Asignación Estática Temporal (sin editar archivos) ---

# 1. Añadir una IP manualmente a una interfaz.
# Formato CIDR (/24 es máscara 255.255.255.0).
sudo ip addr add 192.168.1.100/24 dev eth0
# -> (No devuelve salida, pero 'ip a' mostrará la nueva IP agregada)

# 2. Borrar una IP.
sudo ip addr del 192.168.1.100/24 dev eth0
# -> (IP eliminada)


### --- Sección 5: Herramientas y Comandos Útiles de Networking 🛠️ ---
# Diagnóstico avanzado y consultas DNS.

# 1. nslookup: Consultar DNS (básico).
nslookup wikipedia.org
# -> Server:		127.0.0.53
# -> Non-authoritative answer:
# -> Name:	wikipedia.org
# -> Address: 91.198.174.192

# 2. dig: Consultar DNS (Profesional/Detallado).
# +short: Muestra solo la IP resultante para scripts.
dig google.com +short
# -> 142.250.184.14

# 3. traceroute (o tracepath): Ver la ruta (saltos) hasta un destino.
# Muestra cada router por el que pasa el paquete.
traceroute 8.8.8.8
# -> 1  _gateway (192.168.1.1)  2.5 ms
# -> 2  10.0.0.1 (ISP)          10.1 ms
# -> ...
# -> 8  dns.google (8.8.8.8)    15.2 ms

# 4. curl: Probar conectividad HTTP/HTTPS (Capas 7).
# -I: Solo headers (Head request), ideal para ver si un servidor web responde rápido.
curl -I https://www.google.com
# -> HTTP/2 200 
# -> content-type: text/html; charset=ISO-8859-1 ...


### --- Sección 6: Puertos Importantes para Monitoreo 🛡️ ---
# Ver qué puertos están escuchando (Listening) es vital para seguridad y troubleshooting.
# Puertos comunes: 22 (SSH), 80 (HTTP), 443 (HTTPS), 53 (DNS), 3306 (MySQL).

# 1. netstat: Estadísticas de red (clásico).
# -t: TCP, -u: UDP, -l: Listening (escuchando), -n: Numérico (no resuelve nombres), -p: PID/Programa.
sudo netstat -tulpn
# -> Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
# -> tcp        0      0 0.0.0.0:22              0.0.0.0:* LISTEN      859/sshd
# -> tcp6       0      0 :::80                   :::* LISTEN      1024/apache2

# 2. ss: Socket Statistics (El estándar moderno, más rápido que netstat).
# Mismas banderas (flags) que netstat para facilitar la transición.
sudo ss -tulpn
# -> Netid State  Recv-Q Send-Q   Local Address:Port   Peer Address:Port   Process
# -> tcp   LISTEN 0      128            0.0.0.0:22          0.0.0.0:* users:(("sshd",pid=859,fd=3))

# 3. lsof: List Open Files (Todo en Linux es un archivo, incluye conexiones).
# -i: Lista archivos de red (Internet).
# :80: Filtra solo conexiones en el puerto 80.
sudo lsof -i :80
# -> COMMAND  PID     USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
# -> nginx   1234 www-data    6u  IPv4  23456      0t0  TCP *:http (LISTEN)

# --- Fin del Script de Apuntes ---