#!/bin/bash

### --- Sección 1: Fundamentos y Sintaxis Básica de 'find' ---

# ℹ️ El comando 'find' busca archivos en una jerarquía de directorios.
# Sintaxis: find [ruta] [opciones] [expresión]

# 🔍 1. Búsqueda básica por nombre exacto (-name)
# Busca en el directorio actual (.) un archivo llamado 'documento.txt'.
find . -name "documento.txt"
# -> ./documento.txt

# 🔡 2. Búsqueda insensible a mayúsculas/minúsculas (-iname)
# Encuentra 'Foto.JPG', 'foto.jpg', 'FOTO.jpg', etc.
find /home/usuario/imagenes -iname "foto.jpg"
# -> /home/usuario/imagenes/Foto.JPG

# 📂 3. Filtrar por tipo de archivo (-type)
# Tipos comunes: f (fichero regular), d (directorio), l (enlace simbólico).
# Aquí buscamos solo directorios llamados 'config'.
find /etc -type d -name "config"
# -> /etc/ssh/config (ejemplo hipotético de un directorio)

# 🔗 4. Buscar enlaces simbólicos rotos (Diagnóstico básico)
# -xtype l verifica enlaces que apuntan a rutas inexistentes.
find . -xtype l
# -> ./enlace_roto (si existiera alguno)

### --- Sección 2: Criterios de Tamaño, Tiempo y Permisos ---

# 📦 5. Búsqueda por tamaño (-size)
# Unidades: k (kilobytes), M (megabytes), G (gigabytes).
# '+' significa "mayor que", '-' significa "menor que".
# Busca archivos mayores a 100 Megabytes en /var/log.
find /var/log -type f -size +100M
# -> /var/log/syslog.1

# 🕒 6. Búsqueda por fecha de modificación (-mtime)
# -mtime usa días (n*24 horas).
# -7: modificado en los últimos 7 días.
# +30: modificado hace más de 30 días.
find . -type f -mtime -7
# -> ./trabajo_reciente.docx

# ⏱️ 7. Búsqueda por fecha de acceso en minutos (-amin)
# Útil para saber qué archivos se han tocado en la última hora (60 min).
find . -type f -amin -60
# -> ./script_ejecutado.sh

# 🔐 8. Búsqueda por permisos (-perm)
# Busca archivos que tengan permisos 777 (lectura/escritura/ejecución para todos).
# Es útil para auditorías de seguridad.
find . -type f -perm 777
# -> ./archivo_inseguro.sh

# 👤 9. Búsqueda por propietario (-user / -group)
# Encuentra archivos que pertenecen al usuario 'root'.
find /home -user root
# -> /home/usuario/archivo_creado_por_sudo.txt

### --- Sección 3: Control de Profundidad y Lógica ---

# ⬇️ 10. Limitar la profundidad de recursión (-maxdepth / -mindepth)
# -maxdepth 1: Busca solo en el directorio actual, sin entrar en subcarpetas.
# Importante: Poner estas flags justo después de la ruta para optimizar velocidad.
find . -maxdepth 1 -name "*.conf"
# -> ./nginx.conf

# 🔀 11. Operadores lógicos (-o / -not)
# Busca archivos que terminen en .c O .h (código fuente C o cabeceras).
# Se usan paréntesis escapados \( ... \) para agrupar.
find . \( -name "*.c" -o -name "*.h" \)
# -> ./main.c
# -> ./utils.h

# 🚫 12. Excluir patrones (Lógica NOT)
# Busca todos los archivos en el directorio actual EXCEPTO los .git.
find . -type f -not -path "./.git/*"
# -> ./proyecto/readme.md

### --- Sección 4: Acciones Avanzadas y Automatización (-exec) ---

# ⚙️ 13. Ejecutar comandos sobre los resultados (-exec)
# Estructura: -exec comando {} \;
# {} : Representa el archivo encontrado.
# \; : Indica el final del comando a ejecutar.
# Ejemplo: Cambiar permisos a 644 en todos los archivos HTML encontrados.
find /var/www -name "*.html" -exec chmod 644 {} \;
# -> (No muestra salida, pero aplica el chmod a cada archivo encontrado)

# 🗑️ 14. Borrado directo (-delete)
# ⚠️ PELIGROSO: Borra inmediatamente lo que encuentra.
# Siempre ejecutar primero sin -delete para verificar.
# Borra archivos temporales (.tmp).
find . -name "*.tmp" -delete
# -> (Archivos .tmp eliminados)

# 📝 15. Formato de salida personalizado (-printf)
# Imprime: Permisos, Usuario y Nombre del archivo con un salto de línea (\n).
find . -maxdepth 1 -name "*.txt" -printf "Permisos: %m Usuario: %u Archivo: %f\n"
# -> Permisos: 644 Usuario: juan Archivo: notas.txt

### --- Sección 5: Diagnóstico y Manejo de Espacios ---

# 🧹 16. Buscar archivos vacíos (-empty)
# Encuentra directorios o archivos que tienen 0 bytes.
find . -empty
# -> ./carpeta_sin_uso

# 🚀 17. Optimización para archivos con espacios (-print0)
# Si un archivo se llama "mi foto.jpg", los comandos tradicionales fallan al procesarlo.
# -print0 usa el carácter NULL como separador en lugar de salto de línea.
# Se combina usualmente con 'xargs -0'.
# Ejemplo: Contar líneas de todos los archivos .txt, incluso si tienen espacios en el nombre.
find . -name "*.txt" -print0 | xargs -0 wc -l
# -> 15 ./mis notas.txt
# -> 15 total