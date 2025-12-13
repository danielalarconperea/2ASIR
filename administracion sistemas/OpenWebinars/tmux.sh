#!/bin/bash

### --- Sección 1: Gestión de Sesiones (Desde la Terminal) ---
# Estos comandos se ejecutan en una shell normal para entrar o gestionar tmux.

# Iniciar una nueva sesión con nombre (Fundamental para ordenarse)
tmux new -s backend
# -> [Entras a una barra verde inferior. Sesión 'backend' creada]

# Listar las sesiones activas
tmux ls
# -> backend: 1 windows (created Sat Nov 20 10:00:00 2023)
# -> frontend: 2 windows (created Sat Nov 20 10:05:00 2023)

# Recuperar (Attach) una sesión existente
tmux attach -t backend
# -> [Vuelves exactamente a donde dejaste la sesión 'backend']

# Matar una sesión específica desde fuera
tmux kill-session -t backend
# -> [La sesión 'backend' se cierra y desaparece de la lista]

# Matar el servidor de tmux completo (cierra TODAS las sesiones)
tmux kill-server
# -> [Todas las sesiones de tmux son destruidas inmediatamente]

### --- Sección 2: La Tecla Maestra (PREFIJO) ---
# IMPORTANTE: En tmux, casi todo se hace pulsando primero el PREFIJO.
# Por defecto es: CTRL + B
# Debes soltar ambas teclas antes de pulsar la siguiente.

echo "Recuerda: Primero CTRL+B, suelta, y luego la tecla de comando."
# -> Recordatorio en pantalla

### --- Sección 3: Paneles (Dividir la Pantalla) ---
# La gran potencia de tmux: ver múltiples terminales a la vez.



echo "Gestión de Paneles (Splits):"
# %  -> Dividir pantalla VERTICALMENTE (Izquierda / Derecha)
# "  -> Dividir pantalla HORIZONTALMENTE (Arriba / Abajo)
# <Flechas> -> Moverse entre paneles
# z  -> Zoom: Maximiza el panel actual (pulsa 'z' otra vez para restaurar)
# x  -> Cerrar el panel actual (pregunta confirmación y/n)
# {  -> Mover el panel actual a la izquierda
# }  -> Mover el panel actual a la derecha
# ESPACIO -> Cambiar entre diseños predefinidos (layout automático)

### --- Sección 4: Ventanas (Pestañas) ---
# Son como pestañas independientes dentro de una misma sesión.

echo "Gestión de Ventanas (Windows):"
# c  -> Create: Crear nueva ventana
# ,  -> Rename: Renombrar la ventana actual (muy útil para organizarse)
# w  -> Window List: Mostrar lista interactiva de ventanas y sesiones
# n  -> Next: Ir a la ventana siguiente
# p  -> Previous: Ir a la ventana anterior
# 0-9 -> Ir directamente a la ventana número X

### --- Sección 5: Scroll y Copia (Copy Mode) ---

echo "Modo Copia:"
# [  -> Entrar en 'Copy Mode' (aparece un contador de líneas arriba a la derecha).
#      (Una vez dentro):
#      <Flechas/RePág/AvPág> -> Hacer scroll hacia arriba/abajo.
#      ESPACIO -> Empezar selección de texto.
#      ENTER   -> Copiar texto seleccionado y salir del modo.

echo "Pegar:"
# ]  -> Pegar lo que acabas de copiar.

### --- Sección 6: Configuración Esencial (.tmux.conf) ---
# Tmux por defecto es feo y tosco. Este archivo lo hace moderno y usable.
# Ejecuta este bloque para crear una configuración recomendada (Mouse activado).

cat <<EOF > ~/.tmux.conf
# 1. Activar el ratón (Click para cambiar panel, scroll para subir, resize arrastrando)
set -g mouse on

# 2. Poner la barra de estado arriba (opcional, estilo moderno)
set-option -g status-position top

# 3. Aumentar historial de scroll a 10.000 líneas
set -g history-limit 10000

# 4. Colores reales (para que vim/neovim se vean bien)
set -g default-terminal "screen-256color"

# 5. Empezar a contar ventanas en 1 en vez de 0 (más lógico para el teclado)
set -g base-index 1
setw -g pane-base-index 1
EOF
# -> [Archivo .tmux.conf creado. Para aplicar cambios sin reiniciar:]
# -> tmux source ~/.tmux.conf

### --- Sección 7: Truco Pro (Sesiones anidadas) ---
# Si usas tmux dentro de otro tmux (ej: ssh a servidor), las teclas chocan.
# Solución: Pulsa CTRL+B dos veces para enviar el comando a la sesión remota.