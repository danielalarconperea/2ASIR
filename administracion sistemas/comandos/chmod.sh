#!/bin/bash

# ==========================================================
#         APUNTES Y EJEMPLOS DE CHMOD EN BASH
# ==========================================================
#
# Abre este archivo en VS Code (o tu editor favorito)
# para ver los apuntes.
#
# Puedes ejecutar este script en tu terminal con:
# bash apuntes_chmod.sh
#
# ¡PERO TEN CUIDADO! Este script CREA Y BORRA
# archivos y directorios de ejemplo en la carpeta
# donde lo ejecutes.
#
# ==========================================================

# --- Configuración inicial ---
# Creamos archivos y directorios para los ejemplos
touch archivo_texto.txt
touch script_ejecutable.sh
mkdir directorio_ejemplo
touch directorio_ejemplo/archivo_interno.txt

# ==================================================
#  PARTE 1: ¿QUÉ SON LOS PERMISOS? (Teoría)
# ==================================================

# Cuando haces 'ls -l', ves algo como esto:
#   -rw-r--r--  1 usuario grupo 1024 oct 23 12:30 archivo.txt

# La primera parte '-rw-r--r--' define los permisos.

#   Primer carácter:
#     - : Es un archivo
#     d : Es un directorio

#   Los 9 caracteres siguientes se agrupan de 3 en 3:
#     Grupo 1 (Caracteres 2-4): Permisos del DUEÑO (User - 'u')
#     Grupo 2 (Caracteres 5-7): Permisos del GRUPO (Group - 'g')
#     Grupo 3 (Caracteres 8-10): Permisos de OTROS (Others - 'o')

#   Significado de las letras (Permisos):
#     r : Read (Lectura)    - Ver el contenido.
#     w : Write (Escritura) - Modificar el contenido.
#     x : Execute (Ejecución) - Ejecutar el archivo (si es un script) o entrar al directorio.

#   Ejemplo: -rw-r--r--
#     -     : Es un archivo.
#     rw-   : El DUEÑO (u) puede Leer y Escribir (r, w).
#     r--   : El GRUPO (g) solo puede Leer (r).
#     r--   : OTROS (o) solo pueden Leer (r).


# ==================================================
#  PARTE 2: MODO SIMBÓLICO (Letras)
# ==================================================
# Usas letras para gestionar permisos. Es más intuitivo.
# Sintaxis: chmod [quién] [acción] [permiso] archivo

#   [Quién]
#     u : User (dueño)
#     g : Group (grupo)
#     o : Others (otros)
#     a : All (todos - u, g y o)

#   [Acción]
#     + : AÑADIR permiso
#     - : QUITAR permiso
#     = : ASIGNAR permiso exacto (borra los anteriores)

# --- EJEMPLOS (Modo Simbólico) ---

# EJEMPLO 2.1: Añadir ejecución al dueño (u+x)
# Esto es lo más común para hacer un script ejecutable.
# -> EJEMPLO 2.1: Hacer nuestro script ejecutable (chmod u+x)
# Permisos actuales de 'script_ejecutable.sh':
ls -l script_ejecutable.sh
# Ejecutando: chmod u+x script_ejecutable.sh
chmod u+x script_ejecutable.sh
# Nuevos permisos:
ls -l script_ejecutable.sh
# (Nota la 'x' que apareció para el dueño)

# EJEMPLO 2.2: Quitar lectura a 'otros' (o-r)
# -> EJEMPLO 2.2: Quitar permiso de lectura a 'otros' (chmod o-r)
# Permisos actuales de 'archivo_texto.txt':
ls -l archivo_texto.txt
# Ejecutando: chmod o-r archivo_texto.txt
chmod o-r archivo_texto.txt
# Nuevos permisos:
ls -l archivo_texto.txt
# (Nota que la 'r' del final desapareció)

# EJEMPLO 2.3: Asignar permisos exactos (=)
# -> EJEMPLO 2.3: Asignar permisos exactos (chmod u=rw,go=r)
#    (Dueño lee/escribe, grupo y otros solo leen. Borra permisos previos)
# Permisos actuales de 'archivo_texto.txt':
ls -l archivo_texto.txt
# Ejecutando: chmod u=rw,go=r archivo_texto.txt
chmod u=rw,go=r archivo_texto.txt
# Nuevos permisos:
ls -l archivo_texto.txt
# (Ahora tiene exactamente rw-r--r--)

# EJEMPLO 2.4: Recursividad (-R)
# -> EJEMPLO 2.4: Aplicar permisos recursivamente a un directorio (-R)
#    (Añadir escritura al grupo en el directorio Y SU CONTENIDO)
# Permisos actuales del directorio y su contenido:
ls -ld directorio_ejemplo
ls -l directorio_ejemplo/
# Ejecutando: chmod -R g+w directorio_ejemplo
chmod -R g+w directorio_ejemplo
# Nuevos permisos:
ls -ld directorio_ejemplo
ls -l directorio_ejemplo/
# (Nota como la 'w' se añadió al grupo en ambos)

# ==================================================
#  PARTE 3: MODO OCTAL (Números)
# ==================================================
# Es más rápido pero menos intuitivo. Se basa en la suma de valores:
#   4 = r (Lectura)
#   2 = w (Escritura)
#   1 = x (Ejecución)
#   0 = - (Ningún permiso)

# Se usan 3 dígitos: [Dueño] [Grupo] [Otros]
# Cada dígito es la SUMA de los permisos para ese rol:
#   7 = rwx (4+2+1)
#   6 = rw- (4+2+0)
#   5 = r-x (4+0+1)
#   4 = r-- (4+0+0)
#   ...etc.

#   PERMISOS COMUNES:
#     755 (rwxr-xr-x): Scripts y directorios. Dueño total, resto lee/ejecuta.
#     644 (rw-r--r--): Archivos de texto. Dueño lee/escribe, resto solo lee.
#     600 (rw-------): Archivos privados. Solo el dueño puede leer/escribir.
#     700 (rwx------): Directorios privados. Solo el dueño puede entrar.
#     777 (rwxrwxrwx): ¡PELIGRO! Todos pueden hacer todo. Evitar si es posible.

# --- EJEMPLOS (Modo Octal) ---


# EJEMPLO 3.1: Permiso 644 (Archivos de texto comunes)
# -> EJEMPLO 3.1: Asignar permisos '644' (rw-r--r--)
# Permisos actuales de 'archivo_texto.txt':
ls -l archivo_texto.txt
# Ejecutando: chmod 644 archivo_texto.txt
chmod 644 archivo_texto.txt
# Nuevos permisos:
ls -l archivo_texto.txt

# EJEMPLO 3.2: Permiso 755 (Scripts ejecutables)
# -> EJEMPLO 3.2: Asignar permisos '755' (rwxr-xr-x)
# Permisos actuales de 'script_ejecutable.sh':
ls -l script_ejecutable.sh
# Ejecutando: chmod 755 script_ejecutable.sh
chmod 755 script_ejecutable.sh
# Nuevos permisos:
ls -l script_ejecutable.sh

# EJEMPLO 3.3: Permiso 600 (Archivo privado)
# -> EJEMPLO 3.3: Asignar permisos '600' (rw-------)
#    (Muy usado para claves SSH o archivos sensibles)
# Permisos actuales de 'archivo_texto.txt':
ls -l archivo_texto.txt
# Ejecutando: chmod 600 archivo_texto.txt
chmod 600 archivo_texto.txt
# Nuevos permisos:
ls -l archivo_texto.txt
# (Ahora solo el dueño puede leerlo o escribirlo)

# --- Limpieza ---
# -------------------------------------------------
rm archivo_texto.txt
rm script_ejecutable.sh
rm directorio_ejemplo/archivo_interno.txt
rmdir directorio_ejemplo

# Archivos y directorios de ejemplo eliminados.
ls -l
# ### FIN DE LOS APUNTES ###