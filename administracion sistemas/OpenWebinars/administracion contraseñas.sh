#!/bin/bash

# ==============================================================================
# 📘 APUNTES DE BASH: ADMINISTRACIÓN DE CONTRASEÑAS
# ==============================================================================
# Este script cubre el comando 'passwd', gestión de caducidad con 'chage',
# y métodos de automatización segura para scripts (batch processing).
# ==============================================================================

### --- Sección 1: Comando 'passwd' (Uso Básico y Bloqueo) ---

# 1. Cambiar la contraseña del usuario actual.
# 🔑 Solicita la contraseña actual, luego la nueva y su confirmación.
passwd
# -> Changing password for user1.
# -> (current) UNIX password: 
# -> Enter new UNIX password: 
# -> Retype new UNIX password: 
# -> passwd: password updated successfully

# 2. (Root) Cambiar la contraseña de otro usuario sin saber la anterior.
# ⚠️ Requiere privilegios de superusuario.
sudo passwd usuario_objetivo
# -> Enter new UNIX password:
# -> Retype new UNIX password:
# -> passwd: password updated successfully

# 3. Diagnóstico: Ver el estado de la contraseña de una cuenta (-S / --status).
# ℹ️ Muestra: Nombre, Estado (P=Usable, L=Locked, NP=No Password), fecha cambio, mín/máx días, aviso, inactividad.
sudo passwd -S usuario_objetivo
# -> usuario_objetivo P 11/26/2023 0 99999 7 -1

# 4. Bloquear una cuenta (-l / --lock).
# 🔒 Previene el inicio de sesión insertando un '!' en el hash de /etc/shadow.
sudo passwd -l usuario_objetivo
# -> passwd: password expiry information changed.

# 5. Desbloquear una cuenta (-u / --unlock).
# 🔓 Reactiva la contraseña permitiendo el login de nuevo.
sudo passwd -u usuario_objetivo
# -> passwd: password expiry information changed.

# 6. Forzar el cambio de contraseña en el próximo inicio de sesión (-e / --expire).
# 🔄 Útil para cuentas recién creadas o reseteos administrativos.
sudo passwd -e usuario_objetivo
# -> passwd: password expiry information changed.

### --- Sección 2: Comando 'chage' (Políticas de Caducidad/Aging) ---

# 1. Listar la información actual de envejecimiento de contraseña (-l).
# 📅 Muestra fechas exactas de caducidad, último cambio y configuraciones de inactividad.
sudo chage -l usuario_objetivo
# -> Last password change					: Nov 26, 2023
# -> Password expires					: never
# -> Password inactive					: never
# -> Account expires						: never
# -> Minimum number of days between password change		: 0
# -> Maximum number of days between password change		: 99999
# -> Number of days of warning before password expires	: 7

# 2. Establecer el número máximo de días antes de requerir cambio (-M).
# ⏳ La contraseña caducará cada 90 días.
sudo chage -M 90 usuario_objetivo
# -> (No output, éxito silencioso)

# 3. Establecer días de aviso previos a la caducidad (-W).
# ⚠️ El usuario recibirá advertencias 10 días antes de que caduque.
sudo chage -W 10 usuario_objetivo
# -> (No output, éxito silencioso)

# 4. Establecer fecha de expiración absoluta de la CUENTA (-E).
# 🚫 La cuenta se deshabilita totalmente en la fecha (YYYY-MM-DD). Poner '0' la bloquea inmediatamente.
sudo chage -E 2025-12-31 usuario_objetivo
# -> (No output, éxito silencioso)

### --- Sección 3: Automatización y Generación de Hashes (Batch & Scripting) ---

# 1. Automatización masiva con 'chpasswd' (Ideal para scripts).
# 🚀 Lee pares 'usuario:contraseña' desde la entrada estándar (stdin) y actualiza los hashes.
# La opción -e indica que la contraseña ya viene encriptada (opcional), sin flags asume texto plano.
echo "usuario_objetivo:NuevaPass123!" | sudo chpasswd
# -> (No output, actualiza /etc/shadow directamente)

# 2. Generar un hash de contraseña seguro con OpenSSL.
# 🛡️ Útil para pre-generar contraseñas para Ansible, Kickstart o 'useradd -p'.
# -6 indica algoritmo SHA-512 (estándar actual en Linux). -salt define la sal aleatoria.
openssl passwd -6 -salt xyz TuContraseñaSegura
# -> $6$xyz$LR... (Hash largo SHA-512 resultante)

# 3. Uso de tuberías (pipes) con passwd (Menos seguro, pero común en legacy).
# ⚠️ --stdin es una opción específica de RHEL/CentOS, no siempre disponible en Debian/Ubuntu.
# echo "NuevaPass" | sudo passwd --stdin usuario_objetivo
# -> Changing password for user usuario_objetivo.
# -> passwd: all authentication tokens updated successfully.

### --- Sección 4: Archivos Críticos del Sistema ---

# 1. Visualizar el archivo de hashes (Solo lectura para root/shadow).
# 📂 /etc/shadow contiene: usuario:$id$salt$hash:días...
sudo cat /etc/shadow | grep usuario_objetivo
# -> usuario_objetivo:$6$Yn...:19687:0:99999:7:::