#!/bin/bash
# Script de Apuntes de Bash: Gestión de Espacio de Intercambio (Swap)
# Propósito: Demostrar los comandos fundamentales para crear, activar, desactivar y monitorear el espacio de swap en sistemas Linux.
# Optimizado para visualización y estudio en VSCode.

### --- Sección 1: Monitoreo del Espacio de Swap ---
# El comando 'free -h' se utiliza para mostrar la memoria total, usada y libre en el sistema.
# La opción '-h' (human-readable) muestra los tamaños en un formato fácil de leer (e.g., K, M, G).
# Es la forma más común y rápida de verificar si hay espacio de swap configurado y cuánto se está utilizando.
free -h
# ->               total        used        free      shared  buff/cache   available
# -> Mem:           7.8G        1.2G        5.0G        180M        1.6G        6.3G
# -> Swap:          2.0G          0B        2.0G

# 'swapon -s' muestra un resumen más específico sobre los dispositivos de swap activos.
# Incluye el nombre del archivo o partición, el tipo y el tamaño utilizado/libre.
swapon -s
# -> Filename				Type		Size	Used	Priority
# -> /dev/sda5               partition	2097148	0	-2
# NOTA: En muchos sistemas modernos, la información de swap se muestra en 'free -h', pero 'swapon -s' es más directo.

---

### --- Sección 2: Creación de un Archivo de Swap (File Swap) ---
# Paso 1: Crear un archivo vacío para usar como swap. Se usa 'fallocate' para una asignación instantánea de espacio.
# 'fallocate -l 2G /swapfile' crea un archivo de 2 Gigabytes (2G).
# Si 'fallocate' no está disponible (sistemas antiguos/mínimos), se puede usar 'dd' (lento): 'dd if=/dev/zero of=/swapfile bs=1M count=2048'
# Reemplaza 2G por el tamaño deseado (ej: 1G, 4G).
sudo fallocate -l 2G /swapfile
# -> (No hay salida visible si es exitoso)

# Paso 2: Restringir los permisos del archivo de swap a solo el usuario root (600).
# Esto es crucial por motivos de seguridad; el swap contiene datos sensibles de la memoria.
sudo chmod 600 /swapfile
# -> (No hay salida visible si es exitoso)

# Paso 3: Inicializar el archivo como área de swap.
# 'mkswap /swapfile' escribe la cabecera del sistema de archivos swap en el archivo.
sudo mkswap /swapfile
# -> Setting up swapspace version 1, size = 2 GiB (2147479552 bytes)
# -> no label, UUID=01a2b3c4-d5e6-7f8g-9h0i-j1k2l3m4n5o6

---

### --- Sección 3: Activación y Desactivación de Swap ---
# El comando 'swapon' se usa para activar un área de swap.
# La opción '-a' (all) puede usarse para activar todos los swaps listados en /etc/fstab.
# Para activar el archivo que acabamos de crear:
sudo swapon /swapfile
# -> (No hay salida visible si es exitoso)

# Verificar el estado después de la activación (Usando el comando de la Sección 1):
free -h
# ->               total        used        free      shared  buff/cache   available
# -> Mem:           7.8G        1.2G        5.0G        180M        1.6G        6.3G
# -> Swap:          4.0G          0B        4.0G  <- Muestra la suma del nuevo swap.

# El comando 'swapoff' se usa para desactivar un área de swap.
# Se debe especificar el archivo o partición.
sudo swapoff /swapfile
# -> (No hay salida visible si es exitoso)

# Verificar el estado después de la desactivación:
free -h
# ->               total        used        free      shared  buff/cache   available
# -> Mem:           7.8G        1.2G        5.0G        180M        1.6G        6.3G
# -> Swap:          2.0G          0B        2.0G  <- Vuelve al estado inicial.

---

### --- Sección 4: Persistencia y Configuración Avanzada (swappiness) ---
# Para que el swap sea permanente después de reiniciar, debe agregarse al archivo '/etc/fstab'.
# Esto es un comando de automatización avanzado usando 'echo' y 'sudo tee -a'.
# La línea indica: archivo/partición, punto de montaje (none), tipo (swap), opciones (defaults), y prioridades de volcado/chequeo (0 0).
echo '/swapfile none swap defaults 0 0' | sudo tee -a /etc/fstab
# -> /swapfile none swap defaults 0 0

# 'sysctl vm.swappiness' muestra la tendencia del kernel a usar swap.
# Un valor bajo (ej: 10) significa que el kernel intentará mantener más datos en la RAM y solo usará swap si es absolutamente necesario.
# El valor por defecto es 60, lo que significa que el kernel comienza a usar swap cuando el 40% de la RAM está libre.
sysctl vm.swappiness
# -> vm.swappiness = 60

# Para cambiar el valor de 'swappiness' de forma temporal a 10:
sudo sysctl vm.swappiness=10
# -> vm.swappiness = 10

# Para que el cambio de 'swappiness' sea permanente, se añade al archivo de configuración del sistema.
# Usa 'echo' y 'sudo tee -a' para añadir la línea al final de '/etc/sysctl.conf'.
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
# -> vm.swappiness=10