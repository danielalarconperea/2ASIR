## 1\. 🖥️ Configuración del Servidor (Ubuntu)

### Paso 1: Instalar VSFTPD
sudo apt update
sudo apt install vsftpd


### Paso 2: Configurar el Firewall (UFW)
sudo ufw allow 20/tcp
sudo ufw allow 21/tcp
sudo ufw allow 40000:50000/tcp
sudo ufw enable
sudo ufw status

### Paso 3: Configurar VSFTPD

# copia de seguridad
sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.bak

sudo nano /etc/vsftpd.conf

# Deshabilitar acceso anónimo
anonymous_enable=NO
# Permitir que los usuarios locales (del sistema) inicien sesión
local_enable=YES
# Permitir que los usuarios suban archivos
write_enable=YES
# Enjaular (chroot) a los usuarios en su directorio home. Es una medida de seguridad clave.
chroot_local_user=YES
# Esta línea es necesaria si 'chroot_local_user' está en YES, para permitir que el home sea escribible.
allow_writeable_chroot=YES

# --- Configuración de puertos pasivos ---
# (Estos deben coincidir con los que abrimos en el firewall)
pasv_min_port=40000
pasv_max_port=50000

# (Opcional pero recomendado) Para asegurar que los usuarios vean los archivos con la hora local
use_localtime=YES

### Paso 4: Reiniciar el servicio
sudo systemctl restart vsftpd


### Paso 5: (Opcional) Crear un usuario FTP dedicado
# Crea un usuario (ej: 'ftpuser') y su directorio home. Puedes usar tu propio usuario de Ubuntu, pero es más limpio crear un usuario específico para FTP.
sudo adduser ftpuser

# (Opcional) Crea un directorio específico para los archivos compartidos dentro de su home
sudo mkdir /home/ftpuser/archivos
sudo chown ftpuser:ftpuser /home/ftpuser/archivos


### Paso 6: Obtener la IP del servidor
ip -c a
sudo nano 


# 2\. 🌐 Configuración del Acceso por Dominio
# En el Cliente ubuntu:
sudo nano /etc/hosts

192.168.1.10   servidor-ftp

# En el Cliente Windows:

# Ve a C:\Windows\System32\drivers\etc\hosts dale permisos de edición y lo editas
192.168.1.10   servidor-ftp


## 3\. 💻 Conexión desde el Cliente Ubuntu cliente FTP (FileZilla)
sudo apt install filezilla`
# abrelo
    Servidor: servidor-ftp
    Nombre de usuario: ftpuser
    Contraseña: La contraseña del usuario
    Puerto: 21
# Haz clic en "Conexión rápida".

-----

## 4\. 🪟 Conexión desde el Cliente Windows

Windows también tiene dos métodos sencillos.

### Método A: Explorador de Archivos


# Haz clic en la **barra de direcciones** (donde pone "Este equipo" o la ruta de la carpeta).
    ftp://servidor-ftp
# Aparecerá una ventana pidiendo **Nombre de usuario** y **Contraseña**. Introdúcelos.
# Podrás ver y arrastrar archivos como si fuera una carpeta más de Windows.





## 5\. 📜 Creación de usuarios

# 1. Crea el usuario y su home (/home/pepe)
sudo adduser pepe

# 2. Quita el permiso de escritura a su carpeta home (esto es REQUERIDO por vsftpd para el chroot)
sudo chmod u-w /home/pepe

# 3. Crea una carpeta "archivos" DENTRO de su home donde SÍ podrá escribir
sudo mkdir /home/pepe/archivos

# 4. Asigna la propiedad de esa carpeta al usuario
sudo chown pepe:pepe /home/pepe/archivos

# 5. (Opcional) Crea un archivo de prueba
sudo touch /home/pepe/archivos/pepe.txt


# 1. Crea el usuario y su home (/home/marcelo)
sudo adduser marcelo

# 2. Quita el permiso de escritura a su carpeta home
sudo chmod u-w /home/marcelo

# 3. Crea su carpeta interna para subir archivos
sudo mkdir /home/marcelo/archivos

# 4. Asigna la propiedad
sudo chown marcelo:marcelo /home/marcelo/archivos

# 5. (Opcional) Crea un archivo de prueba
sudo touch /home/marcelo/archivos/hola_marcelo.txt




