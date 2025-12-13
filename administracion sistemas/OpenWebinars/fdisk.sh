#!/bin/bash

### --- Sección 1: Diagnóstico y Listado de Discos ---

# Listar todos los dispositivos de bloque y sus tablas de particiones
# La opción '-l' (list) es la más básica para ver qué discos hay conectados.
sudo fdisk -l
# -> Disk /dev/sda: 931.5 GiB, 1000204886016 bytes, 1953525168 sectors
# -> Device     Boot    Start       End   Sectors   Size Id Type
# -> /dev/sda1           2048 1953525167 1953523120 931.5G 83 Linux

# Visualizar la tabla de particiones usando sectores como unidad
# La opción '-u' (units) fuerza la salida en sectores (recomendado) o cilindros (obsoleto).
# Útil para alineación precisa de particiones.
sudo fdisk -l -u=sectors /dev/sdb
# -> Disk /dev/sdb: 10 GiB, 10737418240 bytes, 20971520 sectors
# -> Units: sectors of 1 * 512 = 512 bytes

# Mostrar el tamaño de una partición específica en bloques (método legacy)
# La opción '-s' da el tamaño directamente, útil para scripts antiguos de validación.
sudo fdisk -s /dev/sda1
# -> 976761560

### --- Sección 2: Modo Interactivo (Referencia de Estudio) ---

# Iniciar fdisk en modo interactivo sobre un disco específico.
# NOTA: Al ejecutar esto, entras en un menú propio. Las teclas clave son:
#   m -> Muestra el menú de ayuda.
#   p -> (Print) Imprime la tabla actual (siempre haz esto primero).
#   n -> (New) Crea una nueva partición (pide tipo, número, sector inicio/fin).
#   d -> (Delete) Borra una partición.
#   t -> (Type) Cambia el ID del sistema (ej: 82 para Swap, 83 para Linux).
#   a -> (Active) Marca la partición como arrancable (Bootable).
#   w -> (Write) Escribe cambios al disco y sale (¡Peligroso/Definitivo!).
#   q -> (Quit) Sale SIN guardar cambios.
sudo fdisk /dev/sdb
# -> Command (m for help): 

# Forzar al sistema operativo a releer la tabla de particiones
# Obligatorio tras usar 'w' en fdisk si no quieres reiniciar el PC.
sudo partprobe -s
# -> /dev/sdb: msdos partitions 1 2

### --- Sección 3: Automatización (Ejemplos Prácticos "Scriptables") ---

# CASO 1: Crear una partición NUEVA de 1GB automáticamente
# Explicación del flujo inyectado con 'echo':
#   n    -> Nueva partición
#   p    -> Primaria
#   1    -> Número de partición 1
#        -> (Enter vacío) Acepta el primer sector por defecto
#   +1G  -> Define el último sector añadiendo 1 GB de tamaño
#   w    -> Escribir y guardar
echo -e "n\np\n1\n\n+1G\nw" | sudo fdisk /dev/sdb
# -> Created a new partition 1 of type 'Linux' and of size 1 GiB.
# -> The partition table has been altered.



# CASO 2: Cambiar el tipo de partición a SWAP (Intercambio)
# Explicación del flujo:
#   t    -> Cambiar tipo (Type)
#   1    -> Selecciona la partición 1 (si hay varias, fdisk pregunta)
#   82   -> Código Hexadecimal para 'Linux swap / Solaris'
#   w    -> Guardar
echo -e "t\n82\nw" | sudo fdisk /dev/sdb
# -> Changed type of partition 'Linux' to 'Linux swap / Solaris'.
# -> The partition table has been altered.

# CASO 3: Borrar la partición creada (Limpieza)
# Explicación del flujo:
#   d    -> Delete (si solo hay una, la borra directamente; si hay más, pide número)
#   w    -> Guardar cambios
echo -e "d\nw" | sudo fdisk /dev/sdb
# -> Partition 1 has been deleted.
# -> The partition table has been altered.

### --- Sección 4: Verificación Final ---

# Verificar que los cambios se aplicaron correctamente
sudo fdisk -l /dev/sdb
# -> Disk /dev/sdb: 10 GiB...
# -> (Debería mostrar la estructura final según el último comando ejecutado)