#!/bin/bash

### --- Sección 1: Inicialización y Argumentos ---

# Mostramos el PID actual para referencia de depuración.
echo "Iniciando proceso con ID (PID): $$"
# -> Iniciando proceso con ID (PID): 12345

# Capturamos el nombre del script ($0) y el primer argumento ($1) que será el directorio a auditar.
script_name=$0
target_dir=$1

echo "Ejecutando script: $script_name"
# -> Ejecutando script: ./auditor.sh

echo "Objetivo de la auditoría: $target_dir"
# -> Objetivo de la auditoría: /var/www (o vacío si no se pasó argumento)

# Mostramos cuántos argumentos totales se han pasado.
echo "Total de parámetros recibidos: $#"
# -> 1

### --- Sección 2: Manipulación de Strings (Generación de Claves) ---

# Variable base para el usuario actual.
usuario_actual=$USER
echo "Usuario detectado: $usuario_actual"
# -> usuario

# Slicing: Extraemos los primeros 3 caracteres del usuario para un prefijo.
prefijo=${usuario_actual:0:3}
echo "Prefijo de seguridad: $prefijo"
# -> usu

# Slicing: Extraemos los últimos 2 caracteres para un sufijo (usando índices negativos).
sufijo=${usuario_actual: -2}
echo "Sufijo de seguridad: $sufijo"
# -> io

# Calculamos la longitud del nombre de usuario.
longitud=${#usuario_actual}
echo "Longitud de la clave: $longitud"
# -> 7

### --- Sección 3: Aritmética Avanzada (Cálculo de Recursos) ---

# Definimos valores base simulados para espacio en disco (en MB).
espacio_total=1024
espacio_usado=450

# Cálculo aritmético usando $((...)) para obtener el espacio libre.
espacio_libre=$((espacio_total - espacio_usado))
echo "Espacio libre calculado: $espacio_libre MB"
# -> 574 MB

# Uso de 'let' para calcular un umbral de alerta (20% del total).
# Nota: Bash solo maneja enteros, así que multiplicamos y dividimos.
let "umbral = espacio_total * 20 / 100"
echo "Umbral de alerta calculado: $umbral MB"
# -> 204 MB

# Incrementamos el contador de operaciones realizadas (estilo C).
ops=0
((ops++))
((ops=ops+5))
echo "Operaciones de cálculo realizadas: $ops"
# -> 6

### --- Sección 4: Arrays (Gestión de Archivos Críticos) ---

# Creamos un array con archivos críticos por defecto.
archivos_criticos=(config.xml database.db server.log)

# Mostramos todos los archivos a procesar.
echo "Archivos en cola: ${archivos_criticos[*]}"
# -> config.xml database.db server.log

# Añadimos un archivo dinámico basado en los argumentos pasados ($@).
# Convertimos todos los argumentos extra en un nuevo array.
extras=($@)
# Añadimos el segundo argumento recibido (índice 1 de extras) al array original.
archivos_criticos[3]=${extras[1]}

echo "Nueva lista de archivos: ${archivos_criticos[@]}"
# -> config.xml database.db server.log (y el argumento 2 si existe)

# Modificamos el primer elemento para marcarlo como procesado.
archivos_criticos[0]="config.xml.bak"
echo "Estado actual del array: ${archivos_criticos[*]}"
# -> config.xml.bak database.db server.log ...

### --- Sección 5: Interactividad (Confirmación de Usuario) ---

echo "--- Pausa de Seguridad ---"
# read -p para solicitar confirmación en la misma línea.
read -p "Ingrese el nombre del responsable para firmar el reporte: " responsable
# -> (Espera input, ej: Admin)

# read -sp para solicitar una clave de autorización (oculta).
read -sp "Ingrese PIN de autorización (4 dígitos): " pin_auth
echo "" # Salto de línea estético tras el input oculto.
# -> (Espera input oculto)

echo "Reporte firmado por: $responsable"
# -> Reporte firmado por: Admin

### --- Sección 6: Finalización y Variables Especiales ---

# Ejecutamos un comando final dummy para verificar estado.
echo "Finalizando auditoría..." > /dev/null

# Comprobamos el estado de salida del último comando ejecutado.
status=$?
echo "Estado de finalización (0=Éxito): $status"
# -> 0

# Usamos $_ para recuperar el último argumento del comando anterior (que fue el mensaje del echo implícito o status).
echo "Confirmación del sistema: $_"
# -> Estado de finalización (0=Éxito): 0 (varía según shell, suele traer el último arg)

# Generación del ID único de reporte sumando PID + PIN.
id_reporte=$(( $$ + pin_auth ))
echo "ID ÚNICO DE REPORTE: REC-$id_reporte"
# -> ID ÚNICO DE REPORTE: REC-13580 (ejemplo)