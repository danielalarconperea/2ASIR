#!/bin/bash
# ----------------------------------------------------------------------------------
# APUNTES DE BASH AVANZADOS: VARIABLES, ENTORNOS Y CICLO DE VIDA
# Nivel: Detallado / Avanzado
# 
# Instrucciones:
# 1. Copia este contenido a un archivo (ej: apuntes_bash.sh).
# 2. Ábrelo en VSCode para leer los comentarios con resaltado de sintaxis.
# 3. Puedes ejecutar bloques de código en tu terminal para ver los resultados.
# ----------------------------------------------------------------------------------


### --- Sección 1: Variables de Entorno (Environment Variables) 🌍 ---
# DEFINICIÓN:
# Son variables globales definidas a nivel del Sistema Operativo. Su característica principal
# es la HERENCIA: se pasan del shell padre a cualquier proceso hijo (scripts, programas, sub-shells).
# Convención: Se escriben siempre en MAYÚSCULAS (ej: PATH, USER).

# 1.1 Listar variables exportadas
# 'printenv' es a menudo preferible a 'env' para ver valores específicos, aunque ambos sirven.
printenv | head -n 5
# -> SHELL=/bin/bash
# -> PWD=/home/usuario/proyectos
# ...

# 1.2 Diferencia crítica: Alcance (Scope)
# Vamos a demostrar cómo una variable normal NO pasa a un hijo, y una exportada SÍ.

VAR_TEST="Soy local"
export VAR_ENV="Soy global"

# Lanzamos un sub-shell (bash -c) para intentar leerlas:
bash -c 'echo "Dentro del hijo: Local=$VAR_TEST, Global=$VAR_ENV"'
# -> Dentro del hijo: Local=, Global=Soy global
# (Nota como VAR_TEST llega vacía al proceso hijo).

# 1.3 Variables de Entorno Comunes y Vitales
echo "Usuario actual: $USER"
echo "Directorio personal: $HOME"
echo "Editor por defecto: $EDITOR"
echo "Shell actual: $SHELL"
echo "Idioma del sistema: $LANG"

# 1.4 Modificar el PATH (Ruta de búsqueda de ejecutables)
# El PATH es una lista de directorios separados por ':' donde bash busca comandos.
# Para añadir una ruta personalizada (ej: scripts propios en ~/bin):
export PATH=$PATH:$HOME/bin
echo $PATH
# -> /usr/bin:/bin:....:/home/usuario/bin

# 1.5 Persistencia
# Si ejecutas 'export' aquí, la variable muere al cerrar la terminal.
# Para hacerla permanente, debes añadirla a .bashrc (ver Sección 3).


### --- Sección 2: Variables del Shell (Shell Variables) 🐚 ---
# DEFINICIÓN:
# Son variables internas, visibles SOLO en la instancia actual de Bash.
# Permiten almacenar datos temporales, resultados de comandos o configuraciones de script.

# 2.1 Asignación y Reglas de Sintaxis
# REGLA DE ORO: No puede haber espacios alrededor del '='.
# CORRECTO:
mi_variable="valor"
# INCORRECTO: mi_variable = "valor" (Bash creerá que 'mi_variable' es un comando).

# 2.2 Tipos de Comillas (¡Muy Importante!)
nombre="Juan"

# Comillas Dobles (" "): Permiten interpolación de variables.
echo "Hola, $nombre"
# -> Hola, Juan

# Comillas Simples (' '): Son literales (todo es texto).
echo 'Hola, $nombre'
# -> Hola, $nombre

# 2.3 Command Substitution (Guardar resultado de un comando)
# Se usa la sintaxis $(comando). Evita usar las comillas invertidas `comando` (obsoleto).
archivos_txt=$(ls *.txt 2>/dev/null) # Intenta listar txt, ignora errores
echo "Archivos encontrados: $archivos_txt"

# 2.4 Variables Especiales y Mágicas (Read-only)
# $0  -> Nombre del script actual.
# $$  -> PID (Process ID) del shell actual.
# $?  -> Exit Code del último comando ejecutado (0 = éxito, 1-255 = error).

ls /archivo_inexistente 2>/dev/null
echo "El código de error del comando anterior fue: $?"
# -> El código de error del comando anterior fue: 2

# 2.5 Expansión Aritmética
# Bash maneja enteros nativamente con $((...))
num=5
doble=$(( num * 2 ))
echo "El doble es $doble"
# -> El doble es 10

# 2.6 Hacer una variable de solo lectura (Constante)
readonly PI=3.1416
# PI=3.15 -> Daría error: "PI: readonly variable"


### --- Sección 3: Archivo de Configuración .BASHRC ⚙️ ---
# UBICACIÓN: ~/.bashrc
# PROPÓSITO: Configuración para shells interactivos que NO son de login (ej: abrir terminal en GUI).
# Es el "cerebro" de tu personalización diaria.

# 3.1 Anatomía típica de un .bashrc
# (Nota: No ejecutes 'cat' aquí si tu archivo es gigante, usamos 'grep' para buscar ejemplos).

# A) Alias (Atajos de teclado)
# Crear un alias para no escribir comandos largos.
alias ll='ls -alF --color=auto'
alias update='sudo apt update && sudo apt upgrade'

# B) Prompt (PS1)
# Define cómo se ve tu línea de comandos (usuario@host:ruta$).
# \u=usuario, \h=host, \w=workdir, \[\033[...\]=colores ANSI
# export PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "

# C) Funciones (Mejor que los alias para lógica compleja)
# Esta función crea un directorio y entra en él automáticamente.
mkcd() {
    mkdir -p "$1"
    cd "$1"
}

# 3.2 Cargar cambios
# Si editas ~/.bashrc, los cambios no se ven hasta reiniciar la terminal o ejecutar:
# source ~/.bashrc   (o su abreviatura: . ~/.bashrc)


### --- Sección 4: Archivos de Inicio y Orden de Ejecución 📁 ---
# Bash decide qué archivo leer basándose en CÓMO entras al sistema.
# Hay dos modos principales: "Login Shell" vs "Non-Login Shell".

# 4.1 Login Shells (Cuando te logueas: SSH, TTY física, o terminal con --login)
# ORDEN DE LECTURA (Bash lee el PRIMERO que encuentra y para):
# 1. /etc/profile        (Configuración global para todos los usuarios)
# 2. ~/.bash_profile     (Específico del usuario)
# 3. ~/.bash_login       (Si no existe el anterior)
# 4. ~/.profile          (Fallback estándar, compatible con Debian/Ubuntu)

# Verificar si tienes .bash_profile o .profile:
ls -l ~/.bash_profile ~/.profile 2>/dev/null

# NOTA: Por convención, ~/.bash_profile suele contener esto para cargar también el .bashrc:
# [[ -f ~/.bashrc ]] && . ~/.bashrc

# 4.2 Non-Login Interactive Shells (Abrir una pestaña de terminal en GNOME/KDE/VSCode)
# ORDEN DE LECTURA:
# 1. /etc/bash.bashrc    (Configuración global específica de Bash)
# 2. ~/.bashrc           (Tu configuración personal)

# 4.3 Otros Archivos Importantes

# ~/.bash_logout
# Se ejecuta al SALIR de una shell de login (ej: al escribir 'exit' en SSH).
# Útil para limpiar pantallas, borrar claves SSH temporales, etc.
cat ~/.bash_logout 2>/dev/null

# ~/.bash_history y $HISTFILE
# Almacena el historial persistente.
# Variables relacionadas que suelen estar en .bashrc:
# HISTSIZE=1000      (Cuántos comandos recuerda en memoria)
# HISTFILESIZE=2000  (Cuántos guarda en el archivo)
echo "Tu historial se guarda en: $HISTFILE"

# /etc/skel/ (Skeleton)
# Contiene los archivos base (.bashrc, .profile) que se copian al HOME de un usuario NUEVO
# cuando se crea con 'useradd'.
ls -la /etc/skel/
# -> .bashrc
# -> .profile
# -> .bash_logout

# 4.4 Resumen visual del flujo de carga típico en Linux:
# Login (SSH) -> /etc/profile -> ~/.profile -> ~/.bashrc
# GUI Terminal -> /etc/bash.bashrc -> ~/.bashrc