sudo apt update && sudo apt upgrade -y 
sudo apt install curl wget gnupg2 -y 
curl -fsSL https://downloads.plex.tv/plex-keys/PlexSign.key | sudo gpg --dearmor -o /usr/share/keyrings/plex-archive-keyring.gpg 
echo "deb [signed-by=/usr/share/keyrings/plex-archive-keyring.gpg] https://downloads.plex.tv/repo/deb public main" | sudo tee /etc/apt/sources.list.d/plexmediaserver.list 
sudo apt update 
sudo apt install plexmediaserver -y 
sudo systemctl status plexmediaserver 
sudo systemctl enable --now plexmediaserver 
sudo ufw allow 32400/tcp 
sudo ufw reload
# Crear directorio para películas
sudo mkdir -p /opt/plexmedia/peliculas
# Cambiar el dueño al usuario 'plex'
sudo chown -R plex:plex /opt/plexmedia
# Mover tu video (ejemplo)
sudo mv /home/usuario/Descargas/video.mp4 /opt/plexmedia/peliculas/

## Comandos finales de gestión de Plex Media Server
rm /etc/resolv.conf
sudo echo "nameserver 192.168.1.10" | sudo tee /etc/resolv.conf

sudo systemctl status nginx
sudo systemctl status plexmediaserver
sudo cp /home/usuario/Descargas/video2.mp4 /opt/plexmedia/peliculas/
sudo rm /opt/plexmedia/peliculas/video2.mp4

