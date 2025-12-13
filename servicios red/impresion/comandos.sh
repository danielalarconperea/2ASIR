sudo apt install cups
sudo apt install cups-pdf
sudo systemctl status cups
sudo usermod -aG lpadmin usuario
sudo nano /etc/cups/cupsd.conf
 Listen 0.0.0.0:631
 Listen /run/cups/cups.sock
 Listen 127.0.0.1:631
 Listen 192.168.1.10:10631
 Browsing Yes
 Browse LocalProtocols dnssd
 <Location />
  Order allow,deny
  Allow all
 </Location>
 <Location /admin>
  AuthType Default
  Require user @SYSTEM
  Order allow,deny
  Allow all
 </Location>

ln -s /var/spool/cups-pdf/ANONYMOUS/ ~/ImpresionesPDF

sudo systemctl restart cups
sudo ufw allow 631

sudo nano /etc/hosts
 127.0.0.1 localhost
 127.0.1.1 usuario
 192.168.1.10 impresoradani
