#!/bin/bash

# ==============================================================================
# 📘 APUNTES DE BASH: SISTEMA DE LOGGING Y REGISTRO
# ==============================================================================
# Este script cubre:
# 1. Redirecciones de flujos estándar (stdout, stderr).
# 2. Uso exhaustivo del comando 'logger' (Syslog/Journald).
# 3. Logging simultáneo en pantalla y archivo con 'tee'.
# 4. Funciones personalizadas para scripts robustos.
# ==============================================================================

### --- Sección 1: Fundamentos de Flujos (Streams) y Redirecciones ---

# 📝 Concepto Básico:
# Bash tiene tres descriptores de archivo principales:
# 0: stdin (entrada), 1: stdout (salida estándar), 2: stderr (error estándar).
# Para "loguear", redirigimos estos flujos a archivos.

# 📝 1.1 Redirección básica (Sobreescritura vs Anexar)
# El operador '>' sobrescribe el archivo. El operador '>>' añade al final (append).
echo "Inicio del registro: $(date)" > app.log
# -> (Crea el archivo 'app.log' con la fecha actual. No muestra nada en pantalla)

echo "Segunda línea de registro" >> app.log
# -> (Añade esta línea al final de 'app.log')

# 📝 1.2 Separación de Errores (stderr)
# Intentamos listar un archivo inexistente. Redirigimos el error (2) a un log de errores.
ls archivo_inexistente.txt 2> error.log
# -> (El mensaje de error "No such file..." se guarda en 'error.log', no en pantalla)

# 📝 1.3 Fusión de Flujos (stdout + stderr en el mismo sitio)
# Útil para tener un log cronológico completo. '2>&1' redirige el descriptor 2 al destino del 1.
ls archivo_inexistente.txt > todo.log 2>&1
# -> (Tanto el éxito como el error se guardan en 'todo.log')

### --- Sección 2: El comando 'logger' (Integración con el Sistema) ---

# 📝 Descripción:
# 'logger' es la interfaz de shell para el sistema de logs (syslog o journald).
# Permite enviar mensajes a /var/log/syslog (o /var/log/messages) de manera estándar.

# 📝 2.1 Uso básico
# Envía un mensaje simple al log del sistema con el usuario actual.
logger "Este es un mensaje simple desde mi script"
# -> (No hay salida en pantalla. En /var/log/syslog aparecerá: "Nov 26 10:00:00 user: Este es un mensaje...")

# 📝 2.2 Añadir una etiqueta (Tag) para filtrar fácilmente (-t)
# La flag '-t' define el nombre del proceso o script que genera el log.
logger -t MI_SCRIPT_BACKUP "Iniciando copia de seguridad..."
# -> (En syslog: "Nov 26 10:05:00 MI_SCRIPT_BACKUP: Iniciando copia de seguridad...")

# 📝 2.3 Incluir el PID del proceso (-i)
# La flag '-i' registra el ID del proceso (PID) que envió el log. Crucial para depuración.
logger -i -t MI_APP "El servicio se ha detenido."
# -> (En syslog: "Nov 26 10:06:00 MI_APP[12345]: El servicio se ha detenido.")

# 📝 2.4 Salida dual: Sistema y Pantalla (-s)
# La flag '-s' (stderr) envía el mensaje al log del sistema Y a la salida de error estándar (pantalla).
logger -s -t MI_APP "Error crítico detectado"
# -> (Pantalla: "MI_APP: Error crítico detectado")
# -> (Syslog: "Nov 26 10:07:00 MI_APP: Error crítico detectado")

### --- Sección 3: Prioridades y Facilidades (Configuración Avanzada de Logger) ---

# 📝 Explicación Técnica:
# Syslog clasifica los mensajes por 'Facility' (origen: auth, cron, local0-7)
# y 'Priority' (severidad: debug, info, notice, warning, err, crit, alert, emerg).
# Sintaxis: -p facility.priority

# 📝 3.1 Registrando un Error (-p local0.err)
# Usamos 'local0' (reservado para uso custom) con prioridad 'err'.
logger -p local0.err -t MI_SCRIPT "Fallo en la conexión a la base de datos"
# -> (Dependiendo de la config de rsyslog/journald, esto podría ir a un archivo separado o resaltar en rojo en logs)

# 📝 3.2 Registrando información de depuración (-p user.debug)
# Mensajes de bajo nivel que normalmente se ignoran en producción pero sirven para dev.
logger -p user.debug -t MI_SCRIPT_DEV "Variable X tiene valor 50"
# -> (Generalmente visible en logs detallados o journalctl)

# 📝 3.3 Lectura de archivo línea por línea (-f)
# Si tienes un archivo de texto y quieres volcar su contenido al log del sistema.
logger -f /tmp/resumen_ejecucion.txt
# -> (Envía cada línea del archivo como una entrada de log individual)

### --- Sección 4: Logging con 'tee' (Visualización y Persistencia) ---

# 📝 El comando 'tee'
# Lee de la entrada estándar y escribe en la salida estándar Y en uno o más archivos.
# Es ideal para ver lo que pasa en tiempo real mientras guardas el registro.

# 📝 4.1 Uso básico (Sobreescribir)
echo "Proceso iniciado" | tee proceso.log
# -> (Pantalla: "Proceso iniciado")
# -> (Archivo proceso.log: "Proceso iniciado")

# 📝 4.2 Append mode (-a)
# Fundamental para logs continuos, usa '-a' para no borrar el contenido previo.
echo "Paso 2 completado" | tee -a proceso.log
# -> (Pantalla: "Paso 2 completado")
# -> (Archivo proceso.log: Contiene ahora ambas líneas)

# 📝 4.3 Redirección total con pipes
# Ejecutar un comando complejo, capturar todo y verlo.
ls -la /root | tee -a historial_root.log
# -> (Muestra el listado (o error de permiso) y lo guarda simultáneamente)

### --- Sección 5: Funciones de Logging Personalizadas (Best Practices) ---

# 📝 Definición de una función robusta
# Para scripts profesionales, se define una función que estandarice el formato:
# [FECHA HORA] [NIVEL] MENSAJE
log_message() {
    local NIVEL=$1
    shift # Desplaza los argumentos para que $@ contenga solo el mensaje
    local MENSAJE="$@"
    local FECHA=$(date +'%Y-%m-%d %H:%M:%S')
    
    # Imprime en pantalla con formato
    echo "[$FECHA] [$NIVEL] $MENSAJE"
    
    # Opcional: También enviar a un archivo
    echo "[$FECHA] [$NIVEL] $MENSAJE" >> script_execution.log
}

# 📝 5.1 Uso de la función para Información (INFO)
log_message "INFO" "Iniciando secuencia de carga..."
# -> (Pantalla/Archivo: "[2023-11-26 18:30:00] [INFO] Iniciando secuencia de carga...")

# 📝 5.2 Uso de la función para Errores (ERROR)
log_message "ERROR" "No se pudo encontrar el archivo de configuración."
# -> (Pantalla/Archivo: "[2023-11-26 18:30:05] [ERROR] No se pudo encontrar el archivo de configuración.")

### --- Sección 6: Inspección de Logs (Diagnóstico) ---

# 📝 6.1 Ver los logs del sistema en tiempo real (tail)
tail -f /var/log/syslog
# -> (Muestra las últimas líneas y se queda esperando nuevas entradas. Salir con Ctrl+C)

# 📝 6.2 Ver logs con systemd (journalctl)
# Muestra logs generados por nuestro script específico usando el TAG definido antes.
journalctl -t MI_SCRIPT_BACKUP
# -> (Muestra solo las entradas que coincidan con ese tag)

# 📝 6.3 Ver logs en tiempo real con journalctl
journalctl -f
# -> (Equivalente a tail -f pero para sistemas con systemd)