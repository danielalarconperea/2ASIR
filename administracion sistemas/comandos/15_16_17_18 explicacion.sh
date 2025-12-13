# Apuntes Corregidos: Gestión de Usuarios y Grupos en Ubuntu/Linux
# Versión actualizada basada en tu consulta. 
# PROBLEMA IDENTIFICADO: Los comandos con 'su' (switch user) por defecto intentan cambiar a root, 
# lo que requiere la contraseña de root. Si no la tienes configurada o no eres root, da "Authentication failure".
# SOLUCIÓN: 
# 1. Ejecuta como root (usa 'sudo -i' primero para entrar como root).
# 2. Para ejemplos de 'su', usa equivalentes con 'sudo -u usuario' (no pide pass de root si tienes sudoers).
# 3. He ajustado los ejemplos: Agregué 'sudo' donde aplica para no-root, y notas para 'su'.
# 4. Prueba en una VM; asume usuario con sudo (como en Ubuntu default).
# Copia esto en VSCode como .sh o .md para estudiar/probar.

###########################################
# PREPARACIÓN: Verifica privilegios (ejecuta como tu usuario normal)
###########################################
# Verifica si tienes sudo
sudo whoami
# Resultado esperado: 'root' (si tienes privilegios sudo, no pide pass o pide la tuya)

# Entra temporalmente como root (usa tu pass)
sudo -i
# Resultado: prompt cambia a root@... . Usa 'exit' para salir.

# Si no tienes sudo/root, configura primero (no incluido aquí por seguridad).

###########################################
# 1. Cambio de Usuario (su) - switch user
# NOTA: 'su' requiere pass del TARGET user (root por default). Usa 'sudo -u' como alternativa segura.
# Cambia al usuario especificado, carga entorno con su -/-l/--login
###########################################

# ORIGINAL: Cambia a root con login completo (requiere pass root)
# su -
# Resultado: prompt cambia a root, entorno cargado

# CORREGIDO: Usa sudo para simular (usa tu pass, no root's)
sudo -u root -i
# Resultado: shell como root. (Sal con 'exit')

# ORIGINAL: Sinónimo de su -
# su -l

# CORREGIDO:
sudo -u root -i -l  # Opcional -l para login, pero sudo -i ya lo hace

# ORIGINAL: Sinónimo de su -l
# su --login

# CORREGIDO: Igual que arriba
sudo -u root --login

# ORIGINAL: Cambiar específicamente a root
# su - root

# CORREGIDO:
sudo -u root -i

# ORIGINAL: Consultar el usuario actual (después de su)
# id
# Resultado típico tras su/sudo a root:
# uid=0(root) gid=0(root) groups=0(root)

# Otros ejemplos CORREGIDOS (usa sudo -u para evitar pass root):
sudo -u ubuntu whoami  # Cambia temporal a ubuntu y ejecuta whoami
# Resultado: 'ubuntu'

sudo -u developer -i -c "ls /home"  # Login como developer, lista /home
# Resultado: lista directorios como developer (e.g. developer sysadmin ubuntu)

sudo -u root -l -c "whoami; pwd"  # Como root, ejecuta comandos
# Resultado:
# root
# /

sudo -u nobody --login -c "id"  # Como nobody
# Resultado: uid=65534(nobody) gid=65534(nogroup) groups=65534(nogroup)

sudo -u root -i -c "date"  # Ejecuta date como root sin shell full
# Resultado: Mon Oct 27 10:54:00 CET 2025

# NOTA: Si quieres 'su' real, entra primero como root con 'sudo su -' (usa tu pass).

##############################################
# 2. Información de Usuarios Actuales y Sesiones
# Estos NO requieren root, ejecútalos como usuario normal.
##############################################

# Mostrar info uid/gid y grupos de root
id root
# Resultado típico: uid=0(root) gid=0(root) groups=0(root)

# Mostrar GID principal (sin nombre)
id -g

# Mostrar todos los GID a los que pertenece
id -G

# Usuarios logueados en sistema
who
# Resultado ejemplo: user pts/0 2025-10-27 10:00 (localhost)

# Muestra tiempo último boot y run-level
who -b -r
# Resultado: system boot 2025-10-27 09:00 \n run-level 5 2025-10-27 09:00

# Usuarios activos y lo que están haciendo
w
# Resultado ejemplo:
# USER TTY FROM LOGIN@ IDLE JCPU PCPU WHAT
# daniel pts/0 localhost 10:00 0.00s 0.03s 0.01s bash

# Últimos logins del sistema
last
# Resultado ejemplo: daniel pts/0 localhost Mon Oct 27 10:00 still logged in \n reboot system boot ...

# Ejemplos adicionales (sin root needed):
id -u daniel             # UID de daniel (tu usuario)
# Resultado: 1000 (típico)

id -a ubuntu            # Info completa de ubuntu
# Resultado: uid=1000(ubuntu) gid=1000(ubuntu) groups=... (sudo, etc.)

who -a                     # Info detallada de todas sesiones
# Resultado: Incluye console, pts, etc.

w -h daniel             # Info sin encabezado para daniel
# Resultado: daniel pts/0 localhost 10:15 0.05s 0.02s 0.01s bash

last -n 3                  # Muestra últimos 3 logins
# Resultado: daniel pts/0 ... \n ubuntu tty1 ... \n reboot ...

######################################################
# 3. Buscar usuarios y grupos en archivos y bases de datos
# Mayoría sin root; algunos como /etc/shadow necesitan sudo.
######################################################

# Busca sysadmin en archivo passwd (sin root)
grep sysadmin /etc/passwd
# Resultado si existe: sysadmin:x:1001:1001:Sysadmin:/home/sysadmin:/bin/bash

# Busca sysadmin a través del sistema (sin root)
getent passwd sysadmin
# Resultado: Igual que arriba si local.

# Buscar grupo mail (sin root)
grep mail /etc/group
# Resultado: mail:x:8:

getent group mail
# Resultado: Igual.

# Grupo root
grep root /etc/group
# Resultado: root:x:0:

getent group root
# Resultado: Igual.

# Buscar home de jane (sin root)
grep '/home/jane' /etc/passwd
# Resultado: Línea si existe, o nada.

# Más ejemplos (sin root, salvo nota):
grep -i admin /etc/passwd  # Case-insensitive
# Resultado: sysadmin:x:... \n adminuser:x:...

getent group | grep research  # Pipe para filtrar
# Resultado: research:x:1005:

grep -v root /etc/group  # Excluye root
# Resultado: daemon:x:1: \n bin:x:2: etc.

getent passwd | grep -E 'uid=[5-9]'  # Regex para UIDs bajos
# Resultado: sync:x:4:... etc. (nota: uid en output es campo 3)

# REQUIERE SUDO para shadow:
sudo grep -Ev '^#|^$' /etc/login.defs  # Config activas
# Resultado: PASS_MAX_DAYS 99999 \n PASS_MIN_DAYS 0 etc.

#############################################
# 4. Gestión de Grupos (groupadd, groupmod, groupdel)
# REQUIERE ROOT/SUDO para modificar.
#############################################

# Crea grupo con GID específico (usa sudo)
sudo groupadd -g 1005 research
sudo grep research /etc/group
# Resultado: research:x:1005:

# Crea con GID auto
sudo groupadd development
sudo grep development /etc/group
# Resultado: development:x:1006:

# Crea grupo sistema (GID bajo)
sudo groupadd -r sales
getent group sales  # Sin sudo
# Resultado: sales:x:998:

# Mostrar grupo de archivo (sin root, si accesible)
ls -l index.html
# Resultado: -rw-r--r-- 1 user sales 1024 ... index.html

# Renombra grupo
sudo groupmod -n clerks sales
ls -l index.html  # Actualizado si chown previo
sudo groupmod -g 10003 clerks
ls -l index.html

# Buscar archivos sin grupo (sin root, pero lento)
find / -nogroup 2>/dev/null  # Suprime errores de perm
# Resultado: Posiblemente nada, o /path/to/orphaned

# Elimina grupo
sudo groupdel clerks

# Ejemplos extras (con sudo):
sudo groupadd -g 2000 testers
sudo getent group testers  # Verificar

sudo groupmod -g 1500 -n qa testing
ls -l /shared/qa-file.txt  # Si existe, muestra nuevo GID

find /home -nogroup 2>/dev/null  # En home solo
# Resultado: /home/orphaned.txt si hay

sudo groupadd --system monitoring
sudo grep monitoring /etc/group
# Resultado: monitoring:x:999:

sudo groupdel -f oldgroup  # Fuerza, peligroso

# NOTA: Antes de groupmod, usa chgrp -R newgroup /dirs para actualizar archivos.

##################################################
# 5. Configuración por defecto de usuarios (useradd -D)
# REQUIERE ROOT para cambiar.
##################################################

# Muestra defaults (sin root)
useradd -D
# Resultado: GROUP=100 \n HOME=/home \n INACTIVE=-1 etc.

# Cambia inactivo (con sudo)
sudo useradd -D -f 30
useradd -D  # Verifica: INACTIVE=30

# Configuraciones activas (con sudo para full view si restricted)
sudo grep -Ev '^#|^$' /etc/login.defs
# Resultado: PASS_MAX_DAYS 99999 etc.

# Ejemplos con sudo:
sudo useradd -D -b /users -s /bin/zsh  # Cambia base y shell default
useradd -D  # Verifica cambios

sudo useradd -D -g users -k /etc/skel_dev  # Grupo y skel custom
sudo useradd -D -e 2025-12-31  # Expira cuenta
useradd -D  # Ver: EXPIRE=2025-12-31

sudo useradd -D --create-mail-spool no  # No crea mail
useradd -D  # Ver: CREATE_MAIL_SPOOL=no

#########################################################
# 6. Creación de usuarios (useradd) con opciones variadas
# REQUIERE ROOT/SUDO.
#########################################################

# Crea básico (con sudo)
sudo useradd jane
# Resultado: Sin output (no home)

sudo useradd -u 1000 jane  # UID específico
sudo useradd -g users jane  # Grupo principal
sudo useradd -G sales,research jane  # Secundarios

# Duplicado falla
sudo useradd jane  # useradd: user 'jane' already exists

grep '/home/jane' /etc/passwd  # Nada si no -m

sudo useradd -m jane  # Crea home
ls -ld /home/jane
# Resultado: drwxr-xr-x 2 jane jane 4096 ... /home/jane

sudo useradd -b /test jane  # Base /test (nota: usa mayúscula por default?)
ls -ld /test/Jane
# Resultado: drwxr-xr-x 2 jane jane ... /test/Jane

sudo useradd -d /test/jane jane  # Home exacto
ls -ld /test/jane
# Resultado: drwxr-xr-x 2 jane jane ... /test/jane

sudo useradd -k /home/sysadmin jane  # Skel de sysadmin
ls /home/jane  # Si -m previo
# Resultado: .bashrc .profile etc. copiados

sudo useradd -s /bin/bash jane  # Shell bash

# Completo
sudo useradd -u 1009 -g users -G sales,research -m -c 'Jane Doe' jane 
grep jane /etc/passwd
# Resultado: jane:x:1009:100:Jane Doe:/home/jane:/bin/bash

sudo grep jane /etc/shadow  # Requiere sudo
# Resultado: jane:!:19735:0:99999:7:::

grep jane /etc/group  # Sin sudo
# Resultado: sales:x:998:jane etc.

sudo grep jane /etc/gshadow
# Resultado: sales:!::jane

ls /var/spool/mail  # Mail spool si creado
# Resultado: jane sysadmin ...

ls /home  # Homes
# Resultado: jane ubuntu ...

# Set password después
sudo passwd jane  # Cambia pass de jane

sudo chage -M 60 jane  # Máx 60 días
sudo grep jane /etc/shadow | cut -d: -f1,5
# Resultado: jane:60

# Nuevos ejemplos (con sudo):
sudo useradd -u 1010 -g developers -G wheel,adm -m -d /opt/dev -s /bin/zsh -c 'Dev Team Lead' alice
id alice  # Verificar: uid=1010(alice) ...

sudo useradd -r -s /bin/false -d /var/nobody nobody2  # Sistema no-login
getent passwd nobody2  # Resultado: nobody2:x:99:99::/var/nobody:/bin/false

sudo useradd -m -k /etc/skel_web -G www-data bob  # Web user
ls /home/bob  # .htaccess etc.

sudo useradd -u 2001 -g 1006 -m -c 'Temp User' tempuser
grep tempuser /etc/passwd  # tempuser:x:2001:1006:...

sudo useradd -M -N guest  # Sin home ni grupo
grep guest /etc/passwd  # guest:x:1011:1011::/nonexistent:/bin/false

# NOTA: Después de useradd, usa sudo passwd user para set pass.

##############################################
# 7. Gestión de contraseñas y expiración (passwd, chage)
# REQUIERE ROOT para otros users.
##############################################

# Cambia pass de Jane (usa sudo si no eres ella)
sudo passwd jane
# Resultado: Enter new UNIX password: ... \n passwd: password updated successfully

sudo chage -M 60 jane
sudo grep jane /etc/shadow | cut -d: -f1,5
# Resultado: jane:60

# Ejemplos extra (con sudo):
sudo passwd -l jane  # Lock
# Resultado: password expiry changed. (Login falla)

sudo chage -m 7 -M 90 -W 14 jane  # Políticas
sudo chage -l jane  # Ver: Maximum:90 etc.

sudo passwd -e jane  # Fuerza cambio próximo login
# Resultado: Expiry changed.

sudo chage -I 30 jane  # Inactivo 30 días
sudo chage -l jane  # Ver inactivity.

sudo passwd -d alice  # Borra pass (inseguro)
# Resultado: Changed. Shadow: alice::...

# NOTA: Para tu propio user: passwd (sin sudo).

##############################
# 8. Modificación de usuarios (usermod)
# REQUIERE ROOT.
##############################

sudo usermod -aG development jane  # Agrega grupo
id jane  # Ver groups actualizado

# Nuevos ejemplos (con sudo):
sudo usermod -s /bin/sh -c 'Updated Comment' jane
grep jane /etc/passwd  # Ver cambios

sudo usermod -L jane  # Lock
# Resultado: Shadow con '!' prepend. su jane falla.

sudo usermod -U jane  # Unlock
# Remueve '!'.

sudo usermod -g marketing -G sales,hr jane  # Cambia principal/sec
id jane  # gid=... groups=...

sudo usermod -d /newhome -m jane  # Mueve home
ls -ld /newhome  # Ver moved.

# NOTA: Usuario no logueado durante usermod.

##############################
# 9. Eliminación de usuarios (userdel)
# REQUIERE ROOT.
##############################

sudo userdel jane  # Solo entrada (home queda)
# Resultado: Sin output.

sudo userdel -r jane  # Borra todo (home, mail)
# Resultado: Elimina /home/jane etc.

# Nuevos ejemplos (con sudo):
sudo userdel -r -f tempuser  # Fuerza (mata procesos)
ls /home  # No tempuser.

sudo userdel alice  # Sin -r, home huérfano
find /home -user alice  # Nada, pero dir existe.

sudo userdel -Z alice  # Limpia SELinux si aplica

# Limpia grupo post-del si vacío
sudo groupdel leftover

sudo userdel -r nobody2  # Usuario sistema

# NOTA: Verifica con getent passwd user post-del (debe fallar).



# Apuntes de Gestión de Permisos y Propiedades de Archivos en Linux (Tema 17)
# Usa este bloque directo en VSCode. Ejecútalo paso a paso en bash/terminal para practicar.

##############################################################
# 10. Información básica y creación de archivos de prueba
##############################################################

id                          # Muestra usuario y grupos actuales
# uid=1000(daniel) gid=1000(daniel) groups=1000(daniel),27(sudo)

touch /tmp/filetest1        # Crea archivo vacío

ls -l /tmp/filetest1        # Lista detallada del archivo
# -rw-r--r-- 1 daniel daniel 0 oct 27 12:00 /tmp/filetest1

ls -la /tmp                 # Lista todo en /tmp, incluyendo archivos ocultos
# drwxrwxrwt 10 root   root   4096 oct 27 12:00 .
# -rw-r--r--  1 daniel daniel    0 oct 27 12:00 filetest1
# ...más archivos...

##############################################################
# 11. Cambio de grupo temporal y consulta de grupos
##############################################################

groups                      # Lista los grupos propios
# daniel sudo users
id                          # Detalla UID, GID, grupos secundarios
# uid=1000(daniel) gid=1000(daniel) groups=1000(daniel),27(sudo)

# Cambiar de grupo activo (se necesita pertenecer al grupo target, aquí 'research'):
newgrp research             # Nuevo shell con grupo principal cambiado
# (Pide password, el prompt puede cambiar levemente, ahora grupo activo es 'research')

id                          # Ahora el grupo principal debe ser 'research'
# uid=1000(daniel) gid=1005(research) groups=1000(daniel),27(sudo),1005(research)

# (Para volver al grupo principal original cierra shell con 'exit')
touch /tmp/filetest2

ls -l /tmp/filetest2
# -rw-r--r-- 1 daniel research 0 oct 27 12:01 /tmp/filetest2

id
# uid=1000(daniel) gid=1005(research) groups=1000(daniel),27(sudo),1005(research)

exit                        # Salir del newgrp, regresas al grupo original

id
# uid=1000(daniel) gid=1000(daniel) groups=1000(daniel),27(sudo),1005(research)


##############################################################
# 12. Cambiar grupo de archivos (chgrp)
##############################################################

touch sample

ls -l sample                # Ver grupo propietario
# -rw-r--r-- 1 daniel daniel 0 oct 27 12:02 sample

chgrp research sample       # Cambia grupo a research

ls -l sample                # Debe mostrar grupo 'research'
# -rw-r--r-- 1 daniel research 0 oct 27 12:02 sample

# Con permisos, puedes cambiar grupo de archivos del sistema:
sudo chgrp development /etc/passwd      # Cambia grupo de /etc/passwd

ls -l /etc/passwd
# -rw-r--r-- 1 root development 2369 oct 27 09:21 /etc/passwd

sudo chgrp -R development test_dir      # Recursivo para directorios


# Ver detalles avanzados
stat /tmp/filetest1
# File: /tmp/filetest1
# Size: 0       Blocks: 0          IO Block: 4096 regular file
# Device: 802h/2050d  Inode: 393328  Links: 1
# Access: (0644/-rw-r--r--)  Uid: ( 1000/ daniel)   Gid: ( 1000/ daniel)
# Access, Modify, Change: fechas y horas

##############################################################
# 13. Cambiar propietario y grupo de archivos (chown)
##############################################################

sudo chown jane /tmp/filetest1          # Cambia propietario a jane

ls -l /tmp/filetest1
# -rw-r--r-- 1 jane daniel 0 oct 27 12:00 /tmp/filetest1

sudo chown jane:users /tmp/filetest2    # Cambia propietario a jane y grupo a users

ls -l /tmp/filetest2
# -rw-r--r-- 1 jane users 0 oct 27 12:01 /tmp/filetest2

sudo chown .users /tmp/filetest1        # Solo cambia grupo a users (propietario igual)

ls -l /tmp/filetest1
# -rw-r--r-- 1 jane users 0 oct 27 12:00 /tmp/filetest1

ls -l /etc/passwd                       # Ver propietario y grupo actual del archivo
# -rw-r--r-- 1 root development 2369 oct 27 09:21 /etc/passwd

##############################################################
# 14. Pruebas de permisos con archivos
##############################################################

touch abc.txt

ls -l abc.txt                           # Permisos iniciales
# -rw-r--r-- 1 daniel daniel 0 oct 27 12:03 abc.txt

chmod g+w abc.txt                       # Agrega permiso de escritura a grupo

ls -l abc.txt
# -rw-rw-r-- 1 daniel daniel 0 oct 27 12:03 abc.txt

chmod ug+x,o-r abc.txt                  # Agrega ejecución a user y grupo, quita lectura a otros

ls -l abc.txt
# -rwxrwx--x 1 daniel daniel 0 oct 27 12:03 abc.txt

chmod u=rx abc.txt                      # Asigna solo lectura y ejecución a propietario

ls -l abc.txt
# -r-xrwx--x 1 daniel daniel 0 oct 27 12:03 abc.txt

chmod 754 abc.txt                       # Numérico: u=rwx, g=r, o=r

ls -l abc.txt
# -rwxr-xr-- 1 daniel daniel 0 oct 27 12:03 abc.txt

stat /tmp/filetest1
# Muestra permisos, tamaño, usuario, grupo, detalles de acceso

##############################################################
# 15. Umask                                                  #
##############################################################

umask                                   # Muestra máscara actual (determina permisos por defecto)
# 0002

umask 027                               # Cambia umask (quita w a grupo, rwx a otros)

touch sample

ls -l sample                            # Debe mostrar permisos -rw-r-----
# -rw-r----- 1 daniel daniel 0 oct 27 12:04 sample

umask 027

mkdir test-dir

ls -ld test-dir                         # Debe ser drwxr-x---
# drwxr-x--- 2 daniel daniel 4096 oct 27 12:04 test-dir

##############################################################
# Notas y ejemplos adicionales                               #
##############################################################

# newgrp cambia el grupo principal solo en la shell activa (verifica con id)
# chgrp necesita pertenencia o permisos sudo para archivos ajenos
# chown solo root puede cambiar propietario normalmente
# chmod acepta tanto modos simbólicos (g+w, u=rx) como numéricos (754)
# stat brinda detalles completos e inode de archivos/dirs

# Otros:
# chmod -R g+w directorio          # Cambia permisos recursivamente
# chmod a+x script.sh              # Da ejecución a todos
# stat -c "%A %a %n" archivo       # Permiso en letras y número