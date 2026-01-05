#!/bin/bash

# ==============================================================================
# 📚 APUNTES DE BASH: PLANIFICACIÓN DE TAREAS ÚNICAS (AT & BATCH)
# ==============================================================================
# 📄 Basado en: Comando at.pdf
# 🎯 Objetivo: Ejecución de comandos en momentos específicos o según carga de CPU.

### --- SECCIÓN 1: REQUISITOS Y ESTADO DEL SERVICIO ---

# ⚙️ Para usar 'at', el paquete debe estar instalado y el demonio 'atd' corriendo[cite: 7].
# Verificamos el estado del servicio antes de empezar.
service atd status
# -> atd start / running, proceso 540 [cite: 13]

# 🚀 Si el servicio no está corriendo, se debe iniciar (requiere root).
# service atd start [cite: 12]
# -> atd start / running...

### --- SECCIÓN 2: COMANDO 'AT' (SINTAXIS BÁSICA Y TIEMPO) ---

# 🕒 'at' programa comandos para ejecutarse una vez en el futuro[cite: 15].
# Se puede usar de modo interactivo (escribiendo el comando y cerrando con Ctrl-D)
# o mediante tuberías (pipes) para automatización en scripts.

# Ejemplo A: Programar una tarea usando una tubería (equivalente no interactivo).
# Sintaxis: echo "comando" | at TIEMPO
# Formatos de tiempo admitidos: HHMM, midnight, noon, now + X units[cite: 21].
echo "echo 'Reunión importante' > /dev/pts/0" | at 10:00
# -> warning: commands will be executed using /bin/sh [cite: 36]
# -> job 2 at Mon Feb 9 10:00:00 2019 [cite: 39]

# Ejemplo B: Uso de tiempo relativo (now + tiempo).
# Ejecuta el comando dentro de 2 horas desde el momento actual[cite: 42, 43].
echo "echo 'Aviso en 2 horas' > /dev/pts/0" | at now + 2 hours
# -> job 3 at Mon Feb 9 09:28:00 2019 [cite: 47]

# 📅 Otros formatos de tiempo válidos para referencia[cite: 21]:
# at midnight       (00:00 del día siguiente)
# at noon           (12:00 del día actual/siguiente)
# at 4:30 PM Mar 20 (Fecha y hora explícita)
# at now + 7 days   (Dentro de una semana)

### --- SECCIÓN 3: EJECUCIÓN DESDE FICHEROS Y OPCIONES ---

# 📂 Opción -f: Leer los comandos desde un archivo en lugar de escribirlos manualmente.
# Útil para scripts de backup o tareas complejas predefinidas[cite: 48].
# Supongamos que existe un archivo 'backup_script.txt'.
# at -f backup_script.txt 10pm Mar 22 [cite: 49]
# -> job 4 at Mon Mar 22 22:00:00 2019 [cite: 51]

# 📧 Opción -m: Enviar notificación por correo al usuario al finalizar.
# Se envía incluso si el comando no genera salida por pantalla[cite: 52].
# at -m -f backup_script.txt 10pm Mar 22 [cite: 53]
# -> job 5 at Mon Mar 22 22:00:00 2019

### --- SECCIÓN 4: GESTIÓN DE COLAS (LISTAR Y ELIMINAR) ---

# 📋 Comando 'atq': Lista los trabajos pendientes en la cola.
# Muestra: ID del trabajo, Fecha/Hora de ejecución, Cola (a-z), y Usuario[cite: 59, 63].
# Si eres root, ves los trabajos de todos; si no, solo los tuyos[cite: 60].
atq
# -> 2 Mon Feb 9 09:26:00 2019 a usuario [cite: 62]
# -> 3 Mon Feb 9 09:28:00 2019 a usuario
# -> 4 Mon Feb 9 09:31:00 2019 a usuario

# 🗑️ Comando 'atrm': Elimina un trabajo pendiente usando su ID.
# Solo puedes borrar tus propios trabajos, salvo que seas root[cite: 66, 69].
atrm 2
# -> (Sin salida, el trabajo 2 desaparece de la cola) [cite: 68]

# Verificamos que el trabajo 2 ya no existe.
atq
# -> 3 Mon Feb 9 09:28:00 2019 a usuario
# -> 4 Mon Feb 9 09:31:00 2019 a usuario

### --- SECCIÓN 5: COMANDO 'BATCH' (EJECUCIÓN POR CARGA DE CPU) ---

# 📉 'batch' es similar a 'at', pero NO requiere especificar una hora.
# Ejecuta el comando automáticamente cuando la carga media del sistema (CPU load execution)
# cae por debajo de 0.8 (80%)[cite: 107, 108].

# Útil para tareas pesadas (como ordenar big data) sin ralentizar el servidor.
# Se usa igual que 'at' (interactivo o por pipe).
echo "sort ~/marketing_data" | batch
# -> job 5 at Mon Feb 9 09:26:00 2019 [cite: 116]

### --- SECCIÓN 6: CONTROL DE ACCESO (ALLOW / DENY) ---

# 🛡️ El acceso a 'at' y 'batch' se controla mediante dos archivos en /etc/.
# Las reglas de precedencia son idénticas a las de cron[cite: 82].

# 1. Si existe /etc/at.allow: SOLO los usuarios listados pueden usar 'at'.
# 2. Si existe /etc/at.deny: Los usuarios listados NO pueden usarlo (el resto sí).
# 3. Si no existe ninguno: Solo root puede usarlo (comportamiento habitual en algunas distros)[cite: 83].
# 4. Por defecto en Linux suele existir un at.deny vacío (todos tienen permiso)[cite: 94].

# Ver usuarios denegados explícitamente:
cat /etc/at.deny
# -> (Lista de usuarios, uno por línea) [cite: 81]

# ⚠️ Si un usuario bloqueado intenta usar el comando:
# at 1000
# -> You do not have permission to use at. [cite: 98]