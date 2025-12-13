sudo apt update
sudo apt install apache2
sudo systemctl status apache2
sudo nano /var/www/html/index.html

ip addr
sudo nano /etc/netplan/50-cloud-init.yaml
sudo netplan apply

sudo nano /etc/apache2/ports.conf
sudo nano /etc/apache2/sites-available/000-default.conf
sudo systemctl restart apache2

sudo nano /etc/hosts

sudo mkdir -p /var/www/ReplicaAliexpress.pepe/public_html

sudo mv /var/www/html/* /var/www/ReplicaAliexpress.pepe/public_html/

sudo chown -R www-data:www-data /var/www/ReplicaAliexpress.pepe
sudo chmod -R 755 /var/www/ReplicaAliexpress.pepe
sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/ReplicaAliexpress.pepe.conf
sudo nano /etc/apache2/sites-available/ReplicaAliexpress.pepe.conf

'''
ServerName ReplicaAliexpress.pepe
DocumentRoot /var/www/ReplicaAliexpress.pepe/public_html
'''

sudo a2ensite ReplicaAliexpress.pepe.conf
sudo systemctl reload apache2

'''
http://ReplicaAliexpress.pepe:8080
'''

sudo a2enmod ssl
sudo mkdir /etc/apache2/ssl
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/apache.key -out /etc/apache2/ssl/apache.crt

sudo nano /etc/apache2/sites-available/ReplicaAliexpress.pepe.conf

<VirtualHost *:8080>
    ServerName ReplicaAliexpress.pepe
    # Redirige todo el tráfico de http (puerto 8080) a https
    Redirect / https://ReplicaAliexpress.pepe/
</VirtualHost>

<VirtualHost *:443>
    ServerAdmin webmaster@localhost
    ServerName ReplicaAliexpress.pepe
    DocumentRoot /var/www/ReplicaAliexpress.pepe/public_html

    # Habilita el motor SSL
    SSLEngine on

    # Rutas al certificado y la clave
    SSLCertificateFile      /etc/apache2/ssl/apache.crt
    SSLCertificateKeyFile   /etc/apache2/ssl/apache.key

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>

sudo a2ensite default-ssl.conf
sudo systemctl reload apache2




