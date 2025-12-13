#!/bin/bash

### ============================================================================
### TÍTULO: CONVENCIONES DE NOMBRAMIENTO (USUARIOS Y GRUPOS)
### DESCRIPCIÓN: Guía técnica y práctica sobre las reglas POSIX y Linux
###              para la creación segura de nombres de usuario y grupos.
### ============================================================================

### --- Sección 1: Reglas Fundamentales (Sintaxis y Caracteres) ---

# 📝 Explicación:
# Los nombres de usuario y grupo en Linux deben seguir reglas estrictas para evitar
# conflictos con el sistema de archivos y comandos.
# 
# Regla básica (Portable filename character set):
# 1. Debe comenzar con una letra minúscula o un guion bajo (_).
# 2. Puede contener letras minúsculas (a-z), dígitos (0-9), guiones (-) y guiones bajos (_).
# 3. NO se permiten espacios, puntos (generalmente desaconsejado aunque a veces posible), ni caracteres especiales.
# 4. Regex estándar: ^[a-z_][a-z0-9_-]*$

# Vamos a validar un nombre correcto usando expresiones regulares (regex).
nombre_correcto="dev_user-01"
if [[ "$nombre_correcto" =~ ^[a-z_][a-z0-9_-]*$ ]]; then echo "Válido"; else echo "Inválido"; fi
# -> Válido

# ⚠️ Explicación:
# Intentar usar mayúsculas o caracteres ilegales suele resultar en error o advertencia,
# ya que Linux es Case Sensitive, pero por convención los usuarios son lowercase.
nombre_incorrecto="User.Name!"
if [[ "$nombre_incorrecto" =~ ^[a-z_][a-z0-9_-]*$ ]]; then echo "Válido"; else echo "Inválido"; fi
# -> Inválido

### --- Sección 2: Longitud del Nombre (Límites del Sistema) ---

# 📏 Explicación:
# Históricamente, el límite era de 8 caracteres. En sistemas modernos (Linux 2.6+),
# el límite estándar es de 32 caracteres.
# El comando 'getconf' nos permite consultar este límite en el sistema actual.
getconf LOGIN_NAME_MAX
# -> 256 (En muchos sistemas modernos puede ser 256, aunque useradd suele limitar a 32 por compatibilidad).

# 🧪 Prueba técnica: Creación de una variable para verificar longitud segura.
# Si usas 'useradd', te avisará si excedes los 32 chars.
longitud_nombre=$(echo -n "este_es_un_nombre_extremadamente_largo_para_linux" | wc -c)
echo "Longitud: $longitud_nombre caracteres"
# -> Longitud: 47 caracteres

### --- Sección 3: Usuarios del Sistema vs. Usuarios Regulares (UID/GID) ---

# 🆔 Explicación:
# Linux distingue tipos de usuarios por su UID (User ID).
# - UID 0: root (Administrador absoluto).
# - UID 1-999: Usuarios del sistema (servicios como apache, sshd, docker).
# - UID 1000+: Usuarios regulares (personas).
#
# Esta configuración se define en /etc/login.defs.
# Usamos 'grep' para filtrar las definiciones de UID mínimos y máximos.
grep -E "^UID_MIN|^UID_MAX|^SYS_UID_MIN|^SYS_UID_MAX" /etc/login.defs
# -> SYS_UID_MIN               201
# -> SYS_UID_MAX               999
# -> UID_MIN                  1000
# -> UID_MAX                 60000

### --- Sección 4: Creación de Usuarios y Grupos (Aplicando Convenciones) ---

# 🛠️ Explicación:
# Comando 'useradd'. Al crear un usuario estándar, se debe usar minúsculas.
# Si intentas usar mayúsculas, 'useradd' lanzará un error a menos que fuerces la opción.
# Flag '-m': Crear home directory.
# Flag '-s': Definir shell (ej. /bin/bash).
# Nota: Este comando requiere sudo/root. (Simulado aquí con echo para seguridad del script).
echo "sudo useradd -m -s /bin/bash desarrollador1"
# -> (Crea el usuario 'desarrollador1' con UID >= 1000)

# ⚙️ Explicación Avanzada (Bypass de reglas):
# A veces es necesario migrar usuarios de otros sistemas (ej. Active Directory) que usan Mayúsculas.
# Se puede forzar la creación con '--badname' (o configurando /etc/adduser.conf en Debian/Ubuntu).
# Úsalo con extrema precaución.
echo "sudo useradd --badname -m UsuarioImportado"
# -> (Permite la creación a pesar de no cumplir la regex estándar)

# 👥 Explicación Grupos:
# Las mismas reglas de nombrado aplican a 'groupadd'.
# Se recomienda usar prefijos para identificar el propósito del grupo.
echo "sudo groupadd dev_backend_team"
# -> (Crea el grupo 'dev_backend_team')

### --- Sección 5: Diagnóstico y Validación Automática ---

# 🔍 Explicación:
# Verificar si un nombre ya existe o está reservado antes de crearlo.
# El comando 'id' es la forma más rápida de validar existencia y ver IDs.
usuario_check="root"
id "$usuario_check"
# -> uid=0(root) gid=0(root) groups=0(root)

# 🤖 Explicación Automatización:
# Script rápido para validar si un string es seguro para usar como nombre de usuario
# antes de intentar crearlo en un script de aprovisionamiento.
candidato="nuevo-usuario_23"

# Comprobamos: 
# 1. Longitud <= 32.
# 2. Regex válida.
# 3. No existe previamente.

if [[ ${#candidato} -le 32 ]] && \
   [[ "$candidato" =~ ^[a-z_][a-z0-9_-]*$ ]] && \
   ! id "$candidato" &>/dev/null; then
   echo "El nombre '$candidato' es válido y está disponible."
else
   echo "El nombre '$candidato' NO cumple las convenciones o ya existe."
fi
# -> El nombre 'nuevo-usuario_23' es válido y está disponible.