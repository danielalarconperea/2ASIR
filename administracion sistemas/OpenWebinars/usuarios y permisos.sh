cat /etc/passwd
cat /etc/group

sudo groupadd empleados
sudo groupadd jefes
sudo groupadd visitantes

sudo nano /etc/login.defs
# CREATE_HOME yes

sudo nano /etc/default/useradd
# SHELL=/bin/bash

mkdir /etc/skel/bin
echo 'export PATH="$HOME/bin:$PATH"' >> /etc/skel/.profile

useradd juan
echo 'echo "¡Bienvenido, Juan! Disfruta de la sesión."' >> /home/juan/.profile
# Comprobar en /etc/passwd
grep juan /etc/passwd
# Comprobar en /etc/shadow (requiere sudo/root)
grep juan /etc/shadow

passwd juan
usermod -g empleados juan
# Es posible que /home/usuario ya exista. Si no, créalo primero.
mkdir -p /home/usuario
chown juan:empleados /home/usuario
# Ahora mueve el home
usermod -d /home/usuario -m juan
id juan
grep juan /etc/passwd

useradd maria
usermod -aG jefes,empleados maria
chage -E $(date -d "+20 days" +%Y-%m-%d) maria
# Para ver los grupos
id maria
# Para ver la fecha de expiración
chage -l maria

su - maria
umask 0022
mkdir D1 D2
touch D1/f1
touch D2/f2
chmod 744 D1
chmod -R u=rwx,g=rx,o=r D2
ls -ld D1
chgrp jefes D1
echo "SOLO PARA JEFES" > D1/secreto.txt
chmod 751 D1/secreto.txt
chmod g+w D1/secreto.txt
chmod o+x D1
exit

ls -l /var/log/syslog
usermod -aG adm juan
su - juan
cat /var/log/syslog
exit

groupadd proyectos
usermod -aG proyectos juan
usermod -aG proyectos maria
mkdir /home/proyectos
#
# Cambia el grupo propietario de la carpeta
chgrp proyectos /home/proyectos
# Asigna permisos: rwx para propietario (root) y grupo (proyectos), nada para otros
chmod 770 /home/proyectos
# Añade el bit SetGID (g+s o 2000).
# Esto hace que todo lo creado dentro herede el grupo "proyectos"
chmod g+s /home/proyectos
# (El permiso total en numérico es 2770)
# ls -ld /home/proyectos  -> Debería mostrar 'drwxrws---'
# 
# Creamos la carpeta (heredará el grupo "proyectos" por el SetGID)
mkdir /home/proyectos/secreto
# Cambiamos el propietario a maria
chown maria /home/proyectos/secreto
# Asignamos permisos: solo rwx para maria, nada para nadie más.
chmod 700 /home/proyectos/secreto

getent group empleados

echo '#!/bin/bash' > hola.sh
echo 'echo Hola Mundo!' >> hola.sh
#
# Hacemos a juan el propietario
chown juan hola.sh
#
# Damos permisos rwx (leer, escribir, ejecutar) SOLO al propietario (juan)
chmod 700 hola.sh
#
# Prueba como juan (debería funcionar)
su - juan -c "$(pwd)/hola.sh"
#
# Prueba como maria (debería fallar)
su - maria -c "$(pwd)/hola.sh"

mkdir /home/maria/D2/D3
chown juan /home/maria/D2/D3

chmod 777 /home/maria/D2/D3
chmod +t /home/maria/D2/D3
# (El permiso numérico total es 1777)
# ls -ld /home/maria/D2/D3 -> Debería mostrar 'drwxrwxrwt'
#
# Juan crea un fichero
su - juan -c "touch /home/maria/D2/D3/fichero_juan"
#
# Maria crea un fichero
su - maria -c "touch /home/maria/D2/D3/fichero_maria"
#
# Maria intenta borrar el de Juan (Debería fallar)
echo "--- Intentando que Maria borre el de Juan (fallará) ---"
su - maria -c "rm /home/maria/D2/D3/fichero_juan"
#
# Maria borra el suyo (Debería funcionar)
echo "--- Intentando que Maria borre el suyo (funcionará) ---"
su - maria -c "rm /home/maria/D2/D3/fichero_maria"


su - juan -c "touch /home/maria/D2/D3/fichero_juan"

su - maria -c "touch /home/maria/D2/D3/fichero_maria"

su - maria -c "rm /home/maria/D2/D3/fichero_juan"

su - maria -c "rm /home/maria/D2/D3/fichero_maria"
