#!/bin/bash

### ============================================================================
### 📘 APUNTES DE BASH: GESTIÓN Y ROTACIÓN DE LOGS (LOGROTATE)
### ============================================================================

### --- Sección 1: Introducción y Sintaxis Básica ------------------------------

# ℹ️ Concepto:
# logrotate es la herramienta estándar en Linux para administrar archivos de log.
# Permite rotar, comprimir, eliminar y enviar logs por correo automáticamente,
# evitando que los archivos de registro llenen el disco duro.

# 1.1 Verificar versión e instalación
# Es útil confirmar que la herramienta está instalada y ver su versión actual.
logrotate --version
# -> logrotate 3.19.0
# ->     Default mail command: /usr/bin/mail
# ->     Default compress command: /bin/gzip
# -> ...

### --- Sección 2: Creación de una Configuración (Ejemplo Práctico) ------------

# ℹ️ Estructura de Configuración:
# Aunque la configuración global vive en /etc/logrotate.conf, lo ideal es crear
# archivos individuales en /etc/logrotate.d/.
# A continuación, generamos un archivo de configuración de ejemplo "demo.conf"
# para explicar cada directiva clave.

# 📝 Explicación de directivas usadas en el ejemplo:
# - daily: Rotar una vez al día.
# - rotate 7: Mantener 7 archivos antiguos antes de borrar el más viejo.
# - compress: Comprimir los logs rotados (usualmente .gz) para ahorrar espacio.
# - delaycompress: Pospone la compresión al siguiente ciclo (útil si el programa sigue escribiendo).
# - missingok: No arrojar error si el archivo de log no existe.
# - notifempty: No rotar si el archivo de log está vacío.
# - create: Crea un nuevo archivo de log vacío con permisos/dueño específicos tras rotar.
# - postrotate/endscript: Ejecuta comandos de shell después de la rotación (ej: recargar servicios).

cat <<EOF > ./demo_app_logrotate.conf
/var/log/mi_aplicacion/*.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    create 0640 www-data www-data
    sharedscripts
    postrotate
        echo "🔄 Logs rotados. Recargando servicio ficticio..."
        # systemctl reload mi_aplicacion
    endscript
}
EOF
# -> (Crea el archivo './demo_app_logrotate.conf' en el directorio actual con el contenido arriba)

### --- Sección 3: Diagnóstico y Modo 'Dry-Run' (Depuración) -------------------

# ℹ️ Modo Debug (-d):
# Esta es la opción MÁS IMPORTANTE para aprender y probar.
# La flag '-d' simula la rotación sin hacer cambios reales en el disco.
# Te dice exactamente qué haría logrotate según tu configuración.

logrotate -d ./demo_app_logrotate.conf
# -> reading config file ./demo_app_logrotate.conf
# -> Handling 1 logs
# -> rotating pattern: /var/log/mi_aplicacion/*.log  after 1 days (7 rotations)
# -> empty log files are not rotated, old logs are removed
# -> ...
# -> would run postrotate script

### --- Sección 4: Ejecución Manual y Forzada ----------------------------------

# ℹ️ Modo Verbose (-v) y Force (-f):
# -v: Muestra en pantalla todo lo que está haciendo (verbose).
# -f: Fuerza la rotación AHORA MISMO, ignorando si ya se rotó hoy o si el archivo es pequeño.
# Útil cuando acabas de configurar un logrotate y quieres verificar que funciona ya.

# Nota: El comando puede fallar aquí si no tienes logs reales en la ruta del ejemplo anterior.
# logrotate -v -f ./demo_app_logrotate.conf
# -> reading config file ./demo_app_logrotate.conf
# -> Reading state from file: /var/lib/logrotate/status
# -> ...
# -> Rotating log /var/log/mi_aplicacion/error.log, log->rotateCount is 7
# -> ...
# -> compressing log with: /bin/gzip

### --- Sección 5: Verificación de Estado (Persistencia) -----------------------

# ℹ️ Archivo de Estado:
# logrotate guarda la fecha de la última rotación de cada archivo en un registro de estado.
# Esto es vital para saber por qué un log no rota (quizás logrotate cree que ya lo hizo hoy).

cat /var/lib/logrotate/status | head -n 5
# -> logrotate state -- version 2
# -> "/var/log/syslog" 2023-11-26-10:00:00
# -> "/var/log/dpkg.log" 2023-11-01-12:00:00
# -> "/var/log/auth.log" 2023-11-26-10:00:00

### --- Sección 6: Limpieza (Opcional) -----------------------------------------

# Borramos el archivo de configuración de ejemplo creado en la Sección 2.
rm ./demo_app_logrotate.conf
# -> (Archivo eliminado)