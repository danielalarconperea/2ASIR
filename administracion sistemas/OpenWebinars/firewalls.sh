#!/bin/bash

# ==============================================================================
# 🛡️ APUNTES DE BASH: GESTIÓN DE FIREWALLS EN LINUX
# ==============================================================================
# Este script cubre los 4 sistemas principales:
# 1. UFW (Uncomplicated Firewall) - Estándar en Debian/Ubuntu
# 2. Firewalld - Estándar en RHEL/CentOS/Fedora
# 3. Nftables - El sucesor moderno del backend de filtrado
# 4. Iptables - El sistema legacy (aún muy usado)
# ==============================================================================

### --- Sección 1: UFW (Uncomplicated Firewall) - Debian/Ubuntu ---
# UFW es una interfaz simplificada para iptables/nftables via línea de comandos.
# Diseñado para ser fácil de usar y configurar rápidamente.

# 1.1 Verificación de estado y diagnóstico básico
# Comprueba si el servicio está activo y las reglas cargadas.
sudo ufw status verbose
# -> Status: active
# -> Logging: on (low)
# -> Default: deny (incoming), allow (outgoing), disabled (routed)
# -> New profiles: skip

# 1.2 Configuración de reglas básicas (Puertos y Servicios)
# Permitir tráfico SSH (Puerto 22) para no perder conexión remota.
# Se puede usar el nombre del servicio o el número de puerto.
sudo ufw allow ssh
# -> Rule added
# -> Rule added (v6)

# Permitir un rango de puertos específico (útil para servidores pasivos FTP o rangos VNC).
# Es necesario especificar el protocolo (tcp/udp).
sudo ufw allow 6000:6007/tcp
# -> Rule added
# -> Rule added (v6)

# 1.3 Reglas Avanzadas: Restricción por IP de origen
# Permitir acceso al puerto 3306 (MySQL) SOLO desde una IP específica (ej. 192.168.1.50).
# Esto es crucial para la seguridad en bases de datos expuestas.
sudo ufw allow from 192.168.1.50 to any port 3306
# -> Rule added

# 1.4 Gestión del servicio
# Habilitar el firewall (Cuidado: asegúrate de haber permitido SSH antes).
# El comando --dry-run muestra qué pasaría sin aplicar cambios.
sudo ufw enable
# -> Firewall is active and enabled on system startup

# 1.5 Borrado y Reset
# Eliminar una regla específica. Primero listamos con números para identificarla.
sudo ufw status numbered
# -> [ 1] 22/tcp                   ALLOW IN    Anywhere
# -> [ 2] 6000:6007/tcp            ALLOW IN    Anywhere

# Borrar la regla número 2
sudo ufw delete 2
# -> Deleting:
# -> allow 6000:6007/tcp
# -> Proceed with operation (y|n)? y
# -> Rule deleted

### --- Sección 2: Firewalld - RHEL/CentOS/Fedora/SUSE ---
# Firewalld usa el concepto de "Zonas" (Public, Home, Work, etc.) para definir
# niveles de confianza de las interfaces de red. Es dinámico (sin reiniciar conexiones).

# 2.1 Diagnóstico y Estado
# Verificar el estado del demonio.
sudo firewall-cmd --state
# -> running

# Listar toda la configuración de la zona activa actual.
sudo firewall-cmd --list-all
# -> public (active)
# ->   target: default
# ->   icmp-block-inversion: no
# ->   interfaces: eth0
# ->   sources:
# ->   services: cockpit dhcpv6-client ssh
# ->   ports:
# ->   protocols:

# 2.2 Añadir reglas en caliente (Runtime) vs Permanente
# Permitir servicio HTTP temporalmente (se pierde al reiniciar).
sudo firewall-cmd --zone=public --add-service=http
# -> success

# Hacer una regla PERMANENTE (--permanent) para HTTPS.
# Nota: Las reglas permanentes no se aplican inmediatamente, requieren reload.
sudo firewall-cmd --zone=public --add-service=https --permanent
# -> success

# 2.3 Aplicar cambios permanentes
# Recarga la configuración para aplicar las reglas --permanent pendientes.
sudo firewall-cmd --reload
# -> success

# 2.4 Configuración Avanzada: "Panic Mode"
# Corta todo el tráfico de red inmediatamente (útil en caso de ataque detectado).
# ⚠️ CUIDADO: Te desconectará si estás por SSH.
# sudo firewall-cmd --panic-on
# -> success

# Verificar si el modo pánico está activo.
sudo firewall-cmd --query-panic
# -> no

### --- Sección 3: Nftables (El Estándar Moderno) ---
# Nftables reemplaza a iptables, ip6tables, arptables y ebtables.
# Utiliza una sintaxis más lógica y unificada, y es más performante.

# 3.1 Listar reglas existentes
# Muestra todo el conjunto de reglas (ruleset) actual.
sudo nft list ruleset
# -> table inet filter {
# ->     chain input {
# ->         type filter hook input priority 0; policy accept;
# ->     }
# -> }

# 3.2 Crear una tabla y una cadena (Estructura básica)
# Las tablas contienen cadenas, las cadenas contienen reglas.
# "inet" cubre tanto IPv4 como IPv6.
sudo nft add table inet mi_tabla
# -> (Sin salida si es exitoso)

# Crear una cadena base para filtrar tráfico de entrada.
sudo nft add chain inet mi_tabla input { type filter hook input priority 0 \; }
# -> (Sin salida si es exitoso)

# 3.3 Añadir reglas (Sintaxis concisa)
# Acepta tráfico SSH en la cadena input de mi_tabla.
sudo nft add rule inet mi_tabla input tcp dport 22 accept
# -> (Sin salida si es exitoso)

# Bloquear tráfico ICMP (Ping) - Ejemplo de "drop".
sudo nft add rule inet mi_tabla input ip protocol icmp drop
# -> (Sin salida si es exitoso)

# 3.4 Automatización y Persistencia
# Exportar la configuración actual a un archivo para backup o persistencia.
sudo nft list ruleset > /etc/nftables.conf.backup
# -> (Crea el archivo con el contenido del ruleset)

### --- Sección 4: Iptables (Legacy/Backend Clásico) ---
# Aunque obsoleto por nftables, sigue siendo omnipresente y usado por Docker/K8s.
# Trabaja con cadenas: INPUT, OUTPUT, FORWARD.

# 4.1 Listar reglas con detalles
# -L: Listar, -v: Verbose (ver contadores de paquetes), -n: Numérico (no resolver DNS).
sudo iptables -L -v -n
# -> Chain INPUT (policy ACCEPT 105 packets, 8040 bytes)
# ->  pkts bytes target     prot opt in     out     source               destination

# 4.2 Añadir reglas (Append -A)
# Permitir tráfico entrante en el puerto 8080 (TCP).
sudo iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
# -> (Sin salida si es exitoso, usar -L para verificar)

# 4.3 Insertar reglas (Insert -I)
# Inserta una regla en la posición 1 (al principio de la lista).
# Es vital porque iptables lee secuencialmente; la primera coincidencia gana.
sudo iptables -I INPUT 1 -s 10.0.0.5 -j DROP
# -> (Bloquea todo tráfico de la IP 10.0.0.5 inmediatamente)

# 4.4 Diagnóstico: Ver qué regla está haciendo match
# Muestra los números de línea para poder borrar reglas específicas.
sudo iptables -L --line-numbers
# -> Chain INPUT (policy ACCEPT)
# -> num  target     prot opt source               destination
# -> 1    DROP       all  --  10.0.0.5             0.0.0.0/0
# -> 2    ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0            tcp dpt:8080

# 4.5 Borrar reglas
# Borrar la regla número 1 de la cadena INPUT.
sudo iptables -D INPUT 1
# -> (Regla eliminada)