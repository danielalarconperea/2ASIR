#!/bin/bash

### --- Sección 1: Creación y Listado de Sesiones ---

# Iniciar una sesión de screen anónima (básico)
screen
# -> [Se limpia la terminal y entras en una nueva shell dentro de screen]

# Iniciar una sesión con un nombre específico (Recomendado para identificarla luego)
screen -S backend_server
# -> [Entras en una nueva sesión llamada 'backend_server']

# Listar todas las sesiones de screen activas (detached o attached)
screen -ls
# -> There are screens on:
# ->     24501.backend_server    (Detached)
# ->     23999.pts-0.host        (Attached)
# -> 2 Sockets in /run/screen/S-usuario.

### --- Sección 2: Desconexión y Reconexión (Detach/Reattach) ---

# Desconectarse de la sesión actual sin cerrarla (Se hace DENTRO de screen)
# Nota: Esto es un comando de teclado, no de terminal, pero si necesitas forzarlo desde fuera:
screen -d backend_server
# -> [Remote detach on 24501.backend_server]

# Recuperar (Reattach) una sesión que está desconectada (Detached)
screen -r backend_server
# -> [Vuelves a ver la terminal del 'backend_server' exactamente como la dejaste]

# Recuperar una sesión que quedó abierta en otro lugar (Attached) forzando la desconexión allí
screen -dr backend_server
# -> [Desconecta la sesión remota y te la trae a tu terminal actual]

### --- Sección 3: Gestión y Limpieza ---

# Enviar un comando a una sesión activa sin entrar en ella (Ej: crear una ventana)
screen -S backend_server -X screen minicom
# -> [Crea una nueva ventana ejecutando minicom dentro de la sesión 'backend_server']

# Cerrar (Matar) una sesión específica desde fuera
screen -S backend_server -X quit
# -> [La sesión termina y se cierran todos los procesos dentro de ella]

# Limpiar sesiones muertas (Dead) que aparecen en la lista pero no existen
screen -wipe
# -> [Removed 1234.sesion_muerta from /run/screen/S-usuario]

### --- Sección 4: Atajos de Teclado (Cheat Sheet) ---
# Estos no son comandos para ejecutar, sino para pulsar DENTRO de screen.
# La tecla maestra siempre es CTRL + A seguida de otra tecla.

echo "Presiona CTRL+A y luego..."
# -> Esperando segunda tecla...

# d  -> Detach (Salir de screen dejando los procesos corriendo)
# c  -> Create (Crear una nueva ventana/pestaña dentro de la misma sesión)
# n  -> Next (Ir a la siguiente ventana)
# p  -> Previous (Ir a la ventana anterior)
# "  -> Window List (Ver lista vertical de ventanas para elegir)
# A  -> Title (Renombrar la ventana actual)
# k  -> Kill (Matar la ventana actual)
# ?  -> Help (Ver todos los atajos)
# [  -> Copy mode (Modo scroll para subir y ver historial con flechas)







### --- Sección 1: Arranque Avanzado y Logging ---

# Iniciar sesión guardando todo lo que sale en pantalla en un archivo (Logging)
screen -L -Logfile mi_log.txt -S sesion_auditada
# -> [Inicia sesión y crea 'mi_log.txt' que se actualiza en tiempo real]

# Iniciar sesión con un nombre de ventana inicial personalizado
screen -t "Compilacion" -S dev_session
# -> [Inicia sesión y la primera ventana (0) se llama "Compilacion" en lugar de "bash"]

### --- Sección 2: Gestión de Ventanas (Dentro de Screen) ---
# Comandos internos. Se ejecutan con CTRL+A seguido de la tecla.

echo "Gestión de Ventanas:"
# c -> Create: Crea nueva ventana.
# " -> Windowlist: Muestra lista interactiva para seleccionar.
# A -> Title: Cambia el nombre de la ventana actual.
# w -> Windows: Muestra una lista horizontal en la barra inferior.
# 0-9 -> Cambia directamente a la ventana número X.
# k -> Kill: Destruye la ventana actual.
# \ -> Quit: Mata TODAS las ventanas y cierra la sesión de screen.

### --- Sección 3: Regiones y División de Pantalla (Split) ---
# Screen permite dividir la terminal en varias áreas visibles a la vez.



echo "División de Pantalla (Splits):"
# S -> Split Horizontal: Divide la pantalla en dos (arriba/abajo).
# | -> Split Vertical: Divide la pantalla en dos (izquierda/derecha).
# TAB -> Focus: Moverse entre las regiones divididas.
# X -> Remove: Cierra la región actual (no mata el proceso, solo quita la división).
# Q -> Only: Hace que la región actual ocupe toda la pantalla (oculta las demás).

# NOTA: Al dividir, la nueva región aparece vacía. Debes hacer 'CTRL+A' + 'c' para crear una terminal en ella.

### --- Sección 4: Modo Copia y Scroll (Copy Mode) ---
# Fundamental para ver el historial (scrollback) y copiar texto sin ratón.

echo "Modo Copia / Scrollback:"
# [ -> Entrar en modo copia (permite moverte con flechas por el historial).
#      (Una vez dentro):
#      ESPACIO -> Marca el inicio del texto a copiar.
#      (Mover cursor al final)
#      ESPACIO -> Marca el final y copia al portapapeles interno de screen.
#      ESC -> Salir del modo copia.

echo "Pegar texto copiado:"
# ] -> Paste: Pega lo que hayas copiado con el método anterior.

### --- Sección 5: Seguridad y Bloqueo ---

# Bloquear la terminal actual con contraseña (útil si te levantas del sitio)
# CTRL+A + x
# -> [Screen used by miusuario... Password:]

### --- Sección 6: Configuración Persistente (.screenrc) ---
# Para no perder la configuración, crea este archivo en tu home.
# Este comando genera una configuración recomendada automáticamente:

cat <<EOF > ~/.screenrc
# Desactivar mensaje de bienvenida de copyright
startup_message off

# Habilitar scroll del ratón (si la terminal lo soporta)
termcapinfo xterm* ti@:te@

# Barra de estado inferior (Hardstatus) - Muestra: [Hora] [Nombre Sesión] [Lista Ventanas]
hardstatus alwayslastline
hardstatus string '%{= kG}[ %{G}%H %{g}][%= %{= kw}%?%-Lw%?%{r}(%{W}%n*%f%t%?(%u)%?%{r})%{w}%?%+Lw%?%?%= ][ %{g}%d/%m %{W}%c %{g}]'

# Aumentar el historial de líneas (scrollback) a 10.000 líneas
defscrollback 10000
EOF
# -> [Archivo .screenrc creado. La próxima vez que inicies screen, tendrás barra de estado y más historial]

### --- Sección 7: Comandos Avanzados de Sesión ---

# Enviar un comando a todas las ventanas de una sesión (Broadcast)
# Útil si tienes 4 servidores abiertos y quieres hacer 'apt update' en todos a la vez.
screen -S dev_session -X at "#" stuff "ls -la^M"
# -> [Ejecuta 'ls -la' simultáneamente en todas las ventanas de la sesión 'dev_session']
# -> Nota: ^M representa la tecla ENTER.