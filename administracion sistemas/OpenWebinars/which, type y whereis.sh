#!/bin/bash

# 📚 APUNTES DE BASH: LOCALIZACIÓN E IDENTIFICACIÓN DE COMANDOS
# =============================================================
# Temas: which, type, whereis
# Objetivo: Entender las diferencias entre buscar en el PATH, 
# identificar tipos de comandos (alias/builtin) y localizar binarios/manuales.

### --- Sección 1: Comando 'which' ---
# ℹ️ Descripción:
# El comando 'which' busca el archivo ejecutable asociado a un comando.
# ⚠️ Importante: Solo busca en los directorios definidos en la variable $PATH.
# No detecta funciones de shell ni alias (dependiendo de la versión/OS, pero generalmente es solo para binarios).

# 1.1 Sintaxis básica
# Muestra la ruta absoluta del ejecutable que se lanzaría si escribes el comando.
which python3
# -> /usr/bin/python3

# 1.2 Mostrar todas las coincidencias (Flag -a)
# 🔍 Por defecto, 'which' solo muestra el primero que encuentra.
# Con '-a', muestra todas las ubicaciones en el $PATH que coinciden.
which -a touch
# -> /usr/bin/touch
# -> /bin/touch

# 1.3 Verificación de éxito (Exit Codes)
# Útil en scripts para verificar si un programa está instalado.
# Si devuelve 0, existe. Si devuelve 1, no se encontró.
which programa_inexistente_123
# -> (No muestra salida en stdout, pero el exit code es 1)
echo $?
# -> 1


### --- Sección 2: Comando 'type' ---
# ℹ️ Descripción:
# 'type' es un "shell builtin" (parte del propio Bash). Es más completo que 'which'.
# Explica cómo se interpretará un comando: si es un alias, una función, un builtin o un archivo en disco.

# 2.1 Identificar un comando interno (Builtin)
# 🧠 'cd' no es un archivo, es una función interna del shell. 'which' fallaría aquí o daría resultados confusos.
type cd
# -> cd is a shell builtin

# 2.2 Identificar un Alias
# 🏷️ Muy útil para saber si un comando tiene opciones predefinidas (como colores en ls).
type ls
# -> ls is aliased to `ls --color=auto'

# 2.3 Identificar ubicación física (si existe)
type grep
# -> grep is /usr/bin/grep

# 2.4 Mostrar TODAS las definiciones (Flag -a)
# 🔍 Muestra todas las capas: si es alias, y también dónde está el archivo.
# Es la forma más robusta de entender qué pasa cuando ejecutas un comando.
type -a ls
# -> ls is aliased to `ls --color=auto'
# -> ls is /usr/bin/ls
# -> ls is /bin/ls

# 2.5 Modo "Tipo de dato" para scripts (Flag -t)
# 🤖 Devuelve una sola palabra: 'alias', 'keyword', 'function', 'builtin', o 'file'.
# Ideal para condicionales 'if' en scripts.
type -t if
# -> keyword
type -t pwd
# -> builtin
type -t cat
# -> file

# 2.6 Forzar búsqueda de ruta (Flag -p)
# Actúa similar a 'which', ignorando alias y funciones, buscando solo el archivo en disco.
type -p ls
# -> /usr/bin/ls


### --- Sección 3: Comando 'whereis' ---
# ℹ️ Descripción:
# Busca los binarios, archivos de código fuente y páginas de manual de un comando.
# ⚠️ No busca solo en $PATH, sino en una lista de directorios estándar del sistema (/bin, /usr/man, etc.).

# 3.1 Búsqueda completa (Binario + Fuente + Manual)
# Devuelve todo lo que encuentra relacionado con 'ssh'.
whereis ssh
# -> ssh: /usr/bin/ssh /usr/lib/ssh /usr/share/man/man1/ssh.1.gz

# 3.2 Buscar SOLO el binario (Flag -b)
# 🎯 Útil si solo quieres saber dónde está el ejecutable y te da igual el manual.
whereis -b bash
# -> bash: /usr/bin/bash /bin/bash /etc/bash.bashrc

# 3.3 Buscar SOLO el manual (Flag -m)
# 📖 Encuentra la ubicación del archivo de documentación (manpage).
whereis -m gcc
# -> gcc: /usr/share/man/man1/gcc.1.gz

# 3.4 Buscar SOLO fuentes (Flag -s)
# 📦 Útil para desarrolladores que tienen el código fuente instalado en el sistema.
whereis -s python
# -> python: (Generalmente vacío a menos que tengas src instalados)