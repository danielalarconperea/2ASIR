#!/bin/bash

# ==============================================================================================
# 📘 APUNTES MAESTROS: GESTIÓN DE PERMISOS, PROPIETARIOS Y ATRIBUTOS ESPECIALES EN LINUX
# ==============================================================================================
#
# Este script cubre:
# 1. Lectura de permisos (ls -l, stat).
# 2. Modificación simbólica y octal (chmod).
# 3. Gestión de propietarios y grupos (chown, chgrp).
# 4. Permisos Especiales (SUID, SGID, Sticky Bit).
# 5. Máscaras por defecto (umask).
# 6. Diagnóstico y comandos avanzados.
#
# ⚠️  NOTA: Para ejecutar los ejemplos de 'chown' se requiere sudo/root.
#     Se crea un entorno de prueba en /tmp para no afectar tu sistema.

# 🛠️ PREPARACIÓN DEL ENTORNO DE PRÁCTICA
mkdir -p /tmp/permisos_demo
cd /tmp/permisos_demo
touch archivo_ejemplo.txt script_demo.sh
mkdir carpeta_demo

### --- Sección 1: Diagnóstico y Lectura de Permisos ---

# ℹ️ El comando 'ls -l' es la base para leer permisos.
# Estructura de salida: -rwxr-xr--
# [Tipo] [Usuario(u)] [Grupo(g)] [Otros(o)]
# -      rwx          r-x        r--
#
# Tipos: (-) archivo, (d) directorio, (l) enlace simbólico.
# Modos: (r) lectura, (w) escritura, (x) ejecución.
ls -l archivo_ejemplo.txt
# -> -rw-r--r-- 1 usuario grupo 0 nov 25 10:00 archivo_ejemplo.txt

# ℹ️ 'stat': Una herramienta más precisa para ver permisos en formato octal y humano.
# -c: Formato personalizado.
# %a: Permisos en octal (ej. 644).
# %A: Permisos en formato legible (ej. -rw-r--r--).
# %U: Nombre del dueño.
# %G: Nombre del grupo.
stat -c "Octal: %a | Humano: %A | Dueño: %U | Grupo: %G" archivo_ejemplo.txt
# -> Octal: 644 | Humano: -rw-r--r-- | Dueño: tu_usuario | Grupo: tu_grupo


### --- Sección 2: Modificación de Permisos (Modo Simbólico) ---

# ℹ️ Sintaxis: chmod [quien][operador][permiso] archivo
# Quién: u (user), g (group), o (others), a (all/todos).
# Operador: + (añadir), - (quitar), = (asignar exacto).

# 🔹 Ejemplo 1: Añadir ejecución al dueño (u) y lectura al grupo (g).
chmod u+x,g+r script_demo.sh
ls -l script_demo.sh
# -> -rwxr--r-- ... script_demo.sh

# 🔹 Ejemplo 2: Quitar permisos de escritura y ejecución a 'otros'.
chmod o-wx script_demo.sh
# -> (Los permisos de 'otros' quedarán solo como lectura o ninguno si no tenía 'r')

# 🔹 Ejemplo 3: Asignar permisos exactos (sobreescribe lo anterior).
# Aquí decimos: El grupo SOLO tendrá lectura.
chmod g=r script_demo.sh
# -> -rwxr--r-- ... script_demo.sh


### --- Sección 3: Modificación de Permisos (Modo Octal / Numérico) ---

# ℹ️ El modo octal es más rápido y común en scripts.
# Lectura (r) = 4
# Escritura (w) = 2
# Ejecución (x) = 1
#
# Suma los valores para cada entidad (u, g, o).
# 7 (4+2+1) = rwx (Control total)
# 6 (4+2)   = rw- (Leer y escribir)
# 5 (4+1)   = r-x (Leer y ejecutar)
# 4 (4)     = r-- (Solo lectura)
# 0         = --- (Sin acceso)

# 🔹 Configuración clásica para scripts/binarios: 755
# Dueño: rwx (7), Grupo: r-x (5), Otros: r-x (5)
chmod 755 script_demo.sh
stat -c "%a" script_demo.sh
# -> 755

# 🔹 Configuración clásica para archivos de configuración sensibles: 600
# Dueño: rw- (6), Grupo: --- (0), Otros: --- (0)
chmod 600 archivo_ejemplo.txt
stat -c "%a" archivo_ejemplo.txt
# -> 600

# 🔹 Permiso "peligroso" (acceso total a todos): 777
chmod 777 archivo_ejemplo.txt
# -> -rwxrwxrwx ...


### --- Sección 4: Cambio de Propietarios (chown y chgrp) ---

# ℹ️ chown cambia el dueño y/o el grupo del archivo.
# Sintaxis: chown usuario:grupo archivo
# Requiere permisos de superusuario (sudo) generalmente.

# 🔹 Cambiar solo el dueño.
# sudo chown root archivo_ejemplo.txt
# -> El dueño ahora es root.

# 🔹 Cambiar dueño y grupo a la vez.
# sudo chown root:sys script_demo.sh
# -> Dueño: root, Grupo: sys.

# 🔹 Cambiar solo el grupo (alternativa a chgrp).
# sudo chown :users archivo_ejemplo.txt
# -> El grupo ahora es 'users'.

# ℹ️ chgrp: Comando específico para cambiar solo el grupo.
# sudo chgrp adm archivo_ejemplo.txt
# -> El grupo ahora es 'adm'.


### --- Sección 5: Permisos Recursivos (Automatización) ---

# ℹ️ La flag -R aplica los cambios a un directorio y todo su contenido.
# ⚠️ Cuidado con usar -R en chmod 777 o chown root.

# 🔹 Cambiar dueño de carpeta y todo su contenido.
# sudo chown -R tu_usuario:tu_grupo carpeta_demo/
# -> Todos los archivos dentro ahora te pertenecen.

# 🔹 Asignar permisos estándar a todo un árbol de directorios.
chmod -R 755 carpeta_demo/
# -> La carpeta y sus hijos tienen permisos 755.


### --- Sección 6: Permisos Especiales (SUID, SGID, Sticky Bit) ---

# Estos bits añaden un cuarto dígito al inicio del modo octal (ej. 4755).

# 🛡️ 1. SUID (Set User ID) - Valor Octal: 4000
# Función: El archivo se ejecuta con los permisos del DUEÑO, no del usuario que lo lanza.
# Uso típico: Comandos como 'passwd' (necesita ser root para escribir en /etc/shadow).
# Visual: Aparece una 's' (o 'S') en la posición del dueño (rws------).

chmod u+s script_demo.sh
# O en octal: chmod 4755 script_demo.sh
ls -l script_demo.sh
# -> -rwsr-xr-x 1 ... (Nota la 's' en lugar de 'x' en el primer bloque)

# 👥 2. SGID (Set Group ID) - Valor Octal: 2000
# En archivos: Se ejecuta con los permisos del GRUPO.
# En directorios (Más útil): Los archivos creados dentro heredan el grupo del directorio padre, no del usuario creador.
# Visual: Aparece una 's' (o 'S') en la posición del grupo (---rws---).

chmod g+s carpeta_demo/
# O en octal: chmod 2755 carpeta_demo/
ls -ld carpeta_demo/
# -> drwxr-sr-x ... (Nota la 's' en el bloque del grupo)

# 📌 3. Sticky Bit - Valor Octal: 1000
# Función: En directorios compartidos (como /tmp), impide que un usuario borre archivos de otro usuario, aunque tenga permisos de escritura en la carpeta.
# Visual: Aparece una 't' (o 'T') en la posición de otros (------rwt).

chmod +t carpeta_demo/
# O en octal: chmod 1777 carpeta_demo/
ls -ld carpeta_demo/
# -> drwxrwxrwt ... (Nota la 't' al final)


### --- Sección 7: Máscara por Defecto (umask) ---

# ℹ️ umask define los permisos que SE RESTAN cuando se crea un archivo nuevo.
# Base archivos: 666 (rw-rw-rw-)
# Base carpetas: 777 (rwxrwxrwx)
#
# Si umask es 022 (valor por defecto común):
# Archivo nuevo: 666 - 022 = 644 (rw-r--r--)
# Carpeta nueva: 777 - 022 = 755 (rwxr-xr-x)

# 🔹 Ver umask actual
umask
# -> 0022

# 🔹 Cambiar umask temporalmente para mayor seguridad (solo dueño tiene acceso).
# 077 significa: quitar todo (7) al grupo y quitar todo (7) a otros.
umask 077
touch archivo_secreto.txt
ls -l archivo_secreto.txt
# -> -rw------- 1 usuario grupo ... (600)

# 🔄 Restaurar umask (ejemplo)
umask 0022


### --- Sección 8: Casos Avanzados y Tips ---

# ℹ️ Copiar permisos de un archivo a otro (reference).
# Útil cuando quieres replicar una configuración exacta sin calcular el octal.
chmod --reference=script_demo.sh archivo_ejemplo.txt
# -> archivo_ejemplo.txt ahora tiene los mismos permisos que script_demo.sh

# ℹ️ Hacer inmutable un archivo (root).
# Ni siquiera root podrá borrarlo o modificarlo hasta quitar el atributo.
# Requiere comando 'chattr'.
# sudo chattr +i archivo_ejemplo.txt
# lsattr archivo_ejemplo.txt
# -> ----i--------- archivo_ejemplo.txt

# Limpieza del entorno de prueba
cd ..
rm -rf /tmp/permisos_demo
# -> Entorno limpio.