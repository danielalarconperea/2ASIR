#!/bin/bash

### --- Sección 1: Concepto del Anillo del Kernel (Ring Buffer) ---

# 🧠 ¿Qué es el Kernel Ring Buffer?
# Es una estructura de datos cíclica en memoria de tamaño fijo.
# Almacena mensajes del kernel (arranque, hardware, drivers) incluso antes de que syslog dæmon inicie.
# Al ser "cíclico", cuando se llena, los mensajes nuevos sobrescriben a los más antiguos.

# 📦 Comando principal: dmesg
# Se utiliza para leer, controlar y limpiar este buffer.

### --- Sección 2: Lectura Básica y Formato de Tiempo ---

# 📄 Visualizar todo el contenido del buffer (puede ser muy largo).
# Se suele usar con 'less' o 'grep' para filtrar.
dmesg | head -n 3
# -> [    0.000000] Linux version 5.15.0-100-generic (buildd@lcy02-amd64-001) ...
# -> [    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-5.15.0-100-generic ...
# -> [    0.000000] KERNEL supported cpus:

# 🕒 Opción -T (--ctime): Muestra marcas de tiempo legibles por humanos.
# Sin esto, muestra segundos desde el inicio del sistema [    0.000000].
# Nota: La precisión puede variar si el sistema se suspendió.
dmesg -T | tail -n 3
# -> [Wed Nov 26 10:15:01 2025] usb 1-1: New USB device found, idVendor=1d6b, idProduct=0002
# -> [Wed Nov 26 10:15:01 2025] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
# -> [Wed Nov 26 10:15:01 2025] mass_storage 1-1:1.0: USB Mass Storage device detected

# 🎨 Opción -L (--color): Colorea la salida para distinguir alertas, errores y advertencias.
# (Generalmente es el default en terminales modernas).
dmesg -L | head -n 2
# -> [    0.000000] Linux version... (en color verde/blanco según tema)

### --- Sección 3: Filtrado y Diagnóstico Avanzado ---

# ⚠️ Opción -l (--level): Filtrar por nivel de severidad.
# Niveles comunes: emerg, alert, crit, err, warn, notice, info, debug.
# Útil para encontrar fallos de hardware o drivers rápidamente.
dmesg --level=err,warn | head -n 3
# -> [    2.403121] piix4_smbus 0000:00:07.3: SMBus Host Controller not enabled!
# -> [    5.120033] Error: Driver 'pcspkr' is already registered, aborting...

# 🔍 Opción -u (--userspace): Mostrar solo mensajes generados por espacio de usuario.
# 🔍 Opción -k (--kernel): Mostrar solo mensajes del kernel (default).
dmesg --userspace | head -n 2
# -> [   15.200100] systemd[1]: Starting Network Service...

### --- Sección 4: Monitoreo en Tiempo Real y Mantenimiento ---

# 📡 Opción -w (--follow): Espera y muestra nuevos mensajes conforme llegan al buffer.
# Similar a 'tail -f'. Útil para conectar un USB y ver qué pasa al instante.
# (Comando comentado para evitar bloqueo del script, descomentar para usar)
# dmesg -w
# -> [ 3400.123456] usb 2-1: USB disconnect, device number 3

# 🧹 Opción -C (--clear): Limpia el buffer del anillo.
# Requiere privilegios sudo. Útil antes de realizar una prueba para aislar nuevos logs.
# sudo dmesg -C
# -> (Sin salida, el buffer queda vacío)

# 🧹 Opción -c (minúscula): Lee todo el contenido y LUEGO lo limpia.
# sudo dmesg -c > boot_logs_backup.txt
# -> (Guarda el log actual en archivo y vacía la memoria)

### --- Sección 5: Archivos Relacionados ---

# 📂 /var/log/dmesg: Archivo donde se suele guardar el log del boot inicial.
# head /var/log/dmesg
# -> [    0.000000] Linux version...

# 📂 /dev/kmsg: Interfaz de dispositivo para el buffer (lectura/escritura).