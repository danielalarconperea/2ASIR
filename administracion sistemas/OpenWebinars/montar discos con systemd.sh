#!/bin/bash

### --- Sección 1: Conceptos Básicos y Naming Convention ---

# ℹ️ Systemd utiliza "unidades" para gestionar montajes, reemplazando o complementando a /etc/fstab.
# ⚠️ REGLA CRÍTICA DE NOMBRADO: El nombre del archivo .mount DEBE coincidir con la ruta del punto de montaje.
# Las barras '/' se cambian por guiones '-'.
# Ejemplo: Ruta "/mnt/datos" -> Archivo "mnt-datos.mount"

# 📝 Definimos variables para el ejemplo (Simulación)
MOUNT_POINT="/mnt/datos"
UNIT_NAME="mnt-datos.mount"
DEVICE="/dev/sdb1"

# 🛠️ Creamos el directorio del punto de montaje si no existe
sudo mkdir -p $MOUNT_POINT
# -> (Sin salida si se crea correctamente)

### --- Sección 2: Creación de la Unidad de Montaje (.mount) ---

# ℹ️ A continuación, generamos el archivo de configuración de la unidad.
# 'What': Qué dispositivo montar (UUID es recomendado, aquí usamos path por simplicidad).
# 'Where': Dónde montarlo (Debe coincidir con el nombre del archivo).
# 'Type': Sistema de archivos (ext4, xfs, nfs, etc.).

# 📝 Escribimos el archivo de unidad en /etc/systemd/system/
sudo bash -c "cat <<EOF > /etc/systemd/system/$UNIT_NAME
[Unit]
Description=Montaje persistente de disco de datos
Documentation=man:systemd.mount(5)
After=network.target

[Mount]
What=$DEVICE
Where=$MOUNT_POINT
Type=ext4
Options=defaults
# TimeoutSec=30 # Opcional: Tiempo de espera antes de fallar

[Install]
WantedBy=multi-user.target
EOF"
# -> (Archivo escrito en /etc/systemd/system/mnt-datos.mount)

### --- Sección 3: Gestión y Activación del Montaje ---

# ℹ️ Siempre que creamos o modificamos archivos de unidad, debemos recargar el demonio.
sudo systemctl daemon-reload
# -> (Sin salida, systemd actualiza su índice)

# 🚀 Iniciamos el montaje inmediatamente (equivalente a 'mount /mnt/datos')
sudo systemctl start $UNIT_NAME
# -> (Sin salida si es exitoso)

# 🔒 Habilitamos el montaje para que arranque con el sistema (persistente)
sudo systemctl enable $UNIT_NAME
# -> Created symlink /etc/systemd/system/multi-user.target.wants/mnt-datos.mount -> /etc/systemd/system/mnt-datos.mount.

# 🔍 Verificamos el estado detallado de la unidad de montaje
systemctl status $UNIT_NAME --no-pager
# -> ● mnt-datos.mount - Montaje persistente de disco de datos
# ->      Loaded: loaded (/etc/systemd/system/mnt-datos.mount; enabled; vendor preset: enabled)
# ->      Active: active (mounted) since Tue 2023-10-27 10:00:00 UTC; 5s ago
# ->       Where: /mnt/datos
# ->        What: /dev/sdb1

### --- Sección 4: Automount (Montaje bajo demanda) ---

# ℹ️ Systemd permite montar el disco SOLO cuando se accede a la carpeta.
# Esto ahorra recursos y acelera el arranque. Requiere una unidad .automount separada.
# El nombre debe ser igual que el .mount pero con extensión .automount.

AUTOMOUNT_NAME="mnt-datos.automount"

# 📝 Creamos la unidad .automount
sudo bash -c "cat <<EOF > /etc/systemd/system/$AUTOMOUNT_NAME
[Unit]
Description=Automontaje de disco de datos bajo demanda

[Automount]
Where=$MOUNT_POINT
# TimeoutIdleSec=600 # Desmonta después de 10 min de inactividad

[Install]
WantedBy=multi-user.target
EOF"
# -> (Archivo escrito en /etc/systemd/system/mnt-datos.automount)

# ⚠️ Para usar automount, debemos deshabilitar el .mount y habilitar el .automount
sudo systemctl stop $UNIT_NAME
sudo systemctl disable $UNIT_NAME
sudo systemctl enable --now $AUTOMOUNT_NAME
# -> Created symlink .../mnt-datos.automount -> ...

# 🧪 Prueba: El disco no está montado hasta que hacemos un 'ls'
ls $MOUNT_POINT
# -> (El sistema monta el disco automáticamente en este instante y muestra los archivos)

### --- Sección 5: Diagnóstico y Logs ---

# ℹ️ Si el montaje falla, systemd guarda logs específicos en el journal.

# 🐞 Ver logs filtrados por la unidad de montaje específica
journalctl -u $UNIT_NAME -xe --no-pager
# -> Oct 27 10:05:00 host systemd[1]: Mounting Montaje persistente...
# -> Oct 27 10:05:01 host mount[1234]: mount: /mnt/datos: wrong fs type... (Ejemplo de error)

# 🐞 Ver todas las unidades de montaje activas en el sistema
systemctl list-units --type=mount
# -> UNIT                          LOAD   ACTIVE SUB     DESCRIPTION
# -> -.mount                       loaded active mounted Root Mount
# -> boot.mount                    loaded active mounted /boot
# -> mnt-datos.mount               loaded active mounted Montaje persistente...

# ℹ️ Systemd convierte las entradas de /etc/fstab en unidades dinámicas al arranque.
# Puedes ver estas unidades generadas aquí:
ls -l /run/systemd/generator/*.mount
# -> -rw-r--r-- 1 root root 350 Oct 27 09:00 boot.mount
# -> -rw-r--r-- 1 root root 410 Oct 27 09:00 -.mount