#!/bin/bash

# ==============================================================================
# 📘 MASTER APUNTES: GESTIÓN DE USUARIOS, GRUPOS Y PERMISOS
# ==============================================================================
# 
# 🎯 Propósito: Script de referencia rápida y estudio para la administración
#    de usuarios y grupos en sistemas Linux.
# 
# 📋 Índice de Contenidos:
#    1. Anatomía de archivos (/etc/passwd y /etc/group).
#    2. Gestión de Usuarios (Creación, Modificación, Borrado).
#    3. Gestión de Grupos (Creación y Modificación).
#    4. Gestión de Membresía (Añadir usuarios a grupos).
#    5. Automatización, Scripting y Diagnóstico Avanzado.
# ==============================================================================

### --- Sección 1: Anatomía de los Archivos de Configuración ---

# 📂 1.1 El archivo /etc/passwd (Usuarios)
# Base de datos de texto plano. Permisos 644 (lectura global).
# Formato: usuario:x:UID:GID:comentario:home:shell
# 'x' indica que la pass está en /etc/shadow.

# 👁️ Ver la entrada del usuario root:
grep "^root:" /etc/passwd
# -> root:x:0:0:root:/root:/bin/bash

# 📂 1.2 El archivo /etc/group (Grupos)
# Define los grupos y sus miembros secundarios.
# Formato: nombre_grupo:x:GID:lista_usuarios

# 👁️ Ver la entrada del grupo sudo:
grep "^sudo" /etc/group
# -> sudo:x:27:usuario1,usuario_admin

# 🔍 1.3 Filtrado útil con AWK
# Extrae Usuario y Shell para auditoría rápida.
awk -F: '{ print "User: " $1 " | Shell: " $7 }' /etc/passwd | head -n 3
# -> User: root | Shell: /bin/bash
# -> User: daemon | Shell: /usr/sbin/nologin
# -> User: bin | Shell: /usr/sbin/nologin


### --- Sección 2: Gestión de Usuarios (Ciclo de Vida) ---

# 🆕 2.1 Creación de Usuarios (useradd)
# Binario de bajo nivel, ideal para scripts.
# -m: Crea el directorio HOME.
# -s: Define la shell (/bin/bash).
# -c: Comentario (Nombre completo/Rol).
# -u: Asigna un UID específico manual.
sudo useradd -m -s /bin/bash -c "Desarrollador Backend" -u 2050 usuario_pro
# -> (Sin salida si es exitoso)

# 🤖 2.2 Usuarios de Sistema (System Users)
# -r: Crea cuenta de sistema (UID < 1000), sin home, sin caducidad de pass.
# Esencial para ejecutar demonios/servicios de forma segura.
sudo useradd -r -s /bin/false servicio_app
# -> (Sin salida)

# 🔑 2.3 Gestión de Contraseñas (passwd & chpasswd)
# Automatización (Modo No Interactivo): Ideal para aprovisionamiento masivo.
# Lee usuario:pass desde stdin.
echo "usuario_pro:ContrasenaSegura123!" | sudo chpasswd
# -> (Sin salida si es exitoso)

# 🔒 2.4 Bloqueo y Expiración
# -l: Lock (bloquea el acceso poniendo '!' en shadow).
# -e: Expire (fuerza el cambio de contraseña en el siguiente login).
sudo passwd -l usuario_pro
# -> passwd: password expiry information changed.

# ⚙️ 2.5 Modificación de atributos de Usuario (usermod general)
# -m -d: Mueve (-m) el contenido del home actual a una nueva ruta (-d).
sudo usermod -m -d /home/nuevo_home usuario_pro
# -> (Sin salida)

# 🗑️ 2.6 Borrado de Usuarios (userdel)
# -r: (Remove) CRÍTICO. Borra también el directorio home y el spool de correo.
sudo userdel -r usuario_pro
# -> userdel: usuario_pro mail spool not found
# -> (El usuario y su carpeta home son eliminados)


### --- Sección 3: Gestión de Grupos ---

# ✨ 3.1 Creación de Grupos (groupadd)
# -g: Fuerza un GID específico (útil para consistencia entre servidores NFS).
sudo groupadd -g 5000 devops_team
# -> (Grupo creado con GID 5000)

# ✏️ 3.2 Modificación de Grupos (groupmod)
# -n: Cambia el nombre del grupo (NuevoNombre ViejoNombre).
sudo groupmod -n equipo_sre devops_team
# -> (El grupo 'devops_team' ahora se llama 'equipo_sre')


### --- Sección 4: Membresía (Usuarios <-> Grupos) ---

# ⚠️ REGLA DE ORO: Al usar 'usermod' para grupos secundarios, SIEMPRE usa '-a'.
# -G solo: SOBRESCRIBE los grupos (borra los anteriores).
# -aG: AGREGA (Append) a los grupos existentes.

# ➕ 4.1 Añadir usuario a grupos secundarios (Método usermod)
sudo usermod -aG docker,sudo $USER
# -> (Sin salida. Requiere re-login para aplicar efectos)

# 👥 4.2 Gestión granular con gpasswd (Alternativa)
# A diferencia de usermod, gpasswd edita /etc/group directamente de forma segura.
# -a: Add user.
# -d: Delete user (Sacar usuario de un grupo específico).
sudo gpasswd -d $USER equipo_sre
# -> Removing user (tu_usuario) from group equipo_sre

# 🔄 4.3 Aplicar cambios de grupo SIN cerrar sesión (newgrp)
# Abre una sub-shell con el nuevo GID efectivo.
newgrp docker
# -> (Ahora tienes permisos de docker en esta terminal sin hacer logout)


### --- Sección 5: Diagnóstico, Scripting y Verificación ---

# 🆔 5.1 Verificar identidad completa
# Muestra UID, GID primario y lista de grupos secundarios (números y nombres).
id $USER
# -> uid=1000(mi_user) gid=1000(mi_user) groups=1000(mi_user),27(sudo),999(docker)

# 🕵️ 5.2 Consultar "Fuente de la Verdad" (getent)
# Consulta bases de datos del sistema (archivos locales + LDAP/SSSD si existen).
getent passwd root
# -> root:x:0:0:root:/root:/bin/bash

# 🩺 5.3 Auditoría de Integridad (grpck)
# Verifica que no haya grupos corruptos o usuarios inexistentes dentro de grupos.
sudo grpck
# -> (Solo muestra output si encuentra errores/inconsistencias)

# 🤖 5.4 Scripting: Verificación condicional de membresía
# Snippet útil para scripts de setup (idempotencia).
TARGET_GROUP="docker"
if groups "$USER" | grep -q "\b$TARGET_GROUP\b"; then
    echo "✅ El usuario ya pertenece al grupo $TARGET_GROUP."
else
    echo "🔧 Añadiendo usuario al grupo $TARGET_GROUP..."
    sudo usermod -aG "$TARGET_GROUP" "$USER"
fi
# -> ✅ El usuario ya pertenece al grupo docker.

# 📊 5.5 Reporte: Listar grupos vacíos (sin miembros) con awk
# Campo 4 ($4) es la lista de usuarios. Si está vacío, imprime el nombre ($1).
awk -F: '$4 == "" {print "Grupo vacío: " $1}' /etc/group | head -n 3
# -> Grupo vacío: root
# -> Grupo vacío: daemon
# -> Grupo vacío: bin