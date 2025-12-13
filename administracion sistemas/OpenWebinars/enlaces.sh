#!/bin/bash

# ==============================================================================
# APUNTES DE BASH: GESTIÓN DE ENLACES (LINKS) 🔗
# Comando principal: ln
# Propósito: Crear enlaces entre archivos (duros y simbólicos)
# ==============================================================================

### --- Sección 0: Preparación del Entorno (Setup) ---

# Creamos un archivo original con contenido para realizar las pruebas 📄
echo "Hola, soy el archivo original" > archivo_origen.txt
# -> (Crea archivo_origen.txt con 26 bytes de datos)

# Creamos un directorio de prueba bh
mkdir -p directorio_prueba
# -> (Crea la carpeta si no existe)


### --- Sección 1: Enlaces Duros (Hard Links) ---

# ℹ️ Concepto: Un enlace duro es otro nombre para el mismo archivo físico (mismo inodo).
# No ocupan espacio extra. Si borras el original, el enlace duro MANTIENE el contenido.
# Limitación: No pueden cruzar sistemas de archivos ni enlazar directorios (generalmente).

# Sintaxis básica: ln [archivo_existente] [nombre_nuevo_enlace]
ln archivo_origen.txt enlace_duro.txt
# -> (Crea 'enlace_duro.txt'. Ambos archivos son indistinguibles a nivel de datos)

# Verificación de inodos (identificador único del archivo en disco) 🔍
# La flag '-i' en ls muestra el número de inodo.
ls -li archivo_origen.txt enlace_duro.txt
# -> 11223344 -rw-r--r-- 2 usuario grupo 26 fecha archivo_origen.txt
# -> 11223344 -rw-r--r-- 2 usuario grupo 26 fecha enlace_duro.txt
# (Nota: El número 11223344 es idéntico en ambos)


### --- Sección 2: Enlaces Simbólicos (Soft / Symbolic Links) ---

# ℹ️ Concepto: Un enlace simbólico es un archivo especial que "apunta" a la ruta de otro.
# Es como un acceso directo en Windows.
# Si borras el original, el enlace simbólico se rompe (dangling link).
# Ventaja: Pueden enlazar directorios y cruzar sistemas de archivos.

# Flag clave: '-s' (symbolic)
ln -s archivo_origen.txt enlace_simbolico.txt
# -> (Crea 'enlace_simbolico.txt' que apunta a -> archivo_origen.txt)

# Verificación visual del enlace simbólico 👁️
ls -l enlace_simbolico.txt
# -> lrwxrwxrwx 1 usuario grupo 18 fecha enlace_simbolico.txt -> archivo_origen.txt


### --- Sección 3: Forzar y Reemplazar Enlaces ---

# Intentar crear un enlace que ya existe dará error por defecto.
# ln -s archivo_origen.txt enlace_simbolico.txt
# -> ln: failed to create symbolic link 'enlace_simbolico.txt': File exists

# Flag '-f' (force): Fuerza la creación borrando el destino si ya existe ⚠️
ln -sf archivo_origen.txt enlace_simbolico.txt
# -> (Sobreescribe enlace_simbolico.txt sin preguntar)

# Flag '-i' (interactive): Pregunta antes de sobreescribir (seguridad) 🛡️
ln -si archivo_origen.txt enlace_simbolico.txt
# -> ln: replace 'enlace_simbolico.txt'? (y/n)


### --- Sección 4: Opciones Avanzadas y Backups ---

# Flag '-v' (verbose): Muestra detalladamente qué está haciendo el comando 🗣️
ln -sv archivo_origen.txt otro_link.txt
# -> 'otro_link.txt' -> 'archivo_origen.txt'

# Flag '-b' (backup): Crea una copia de seguridad del archivo destino si ya existe
# antes de sobreescribirlo. Útil para no perder enlaces previos. 💾
# Primero creamos un conflicto artificial:
touch link_conflicto.txt
ln -sb link_conflicto.txt enlace_con_backup.txt # Primer enlace
# Ahora forzamos otro enlace sobre el mismo nombre con backup:
ln -sfvb archivo_origen.txt enlace_con_backup.txt
# -> 'enlace_con_backup.txt' -> 'archivo_origen.txt' (backup: 'enlace_con_backup.txt~')


### --- Sección 5: Enlaces a Directorios y Rutas Relativas ---

# Solo los enlaces simbólicos pueden apuntar a directorios.
ln -s directorio_prueba link_a_dir
# -> (Crea acceso directo a la carpeta)

# ⚠️ Problema común: Rutas absolutas vs relativas.
# Flag '-r' (relative): Calcula la ruta relativa automáticamente.
# Muy útil si planeas mover la carpeta que contiene los enlaces a otro lugar.
ln -sr directorio_prueba/ruta_profunda link_relativo_seguro
# -> (Crea el enlace calculando ../directorio_prueba/ruta_profunda automáticamente)


### --- Sección 6: Limpieza (Opcional) ---

# Eliminar enlaces (se usa rm, igual que con archivos normales) 🗑️
rm enlace_duro.txt enlace_simbolico.txt link_a_dir
# -> (Borra los enlaces, el archivo original 'archivo_origen.txt' PERMANECE intacto)