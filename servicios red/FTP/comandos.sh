sudo apt update 
sudo apt-get update 

sudo apt install vsftpd 
sudo apt-get install vsftpd 

sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.original 

sudo ufw status 

sudo apt-get install ufw 

sudo ufw enable 

sudo ufw allow 20/tcp 
sudo ufw allow 21/tcp 
sudo ufw allow 990/tcp 
sudo ufw allow 40000:50000/tcp 

sudo adduser prueba 
sudo mkdir /home/prueba/ftp 

sudo chown nobody:nogroup /home/prueba/ftp 
sudo chmod a-w /home/prueba/ftp 

sudo ls -la /home/prueba/ftp 

sudo mkdir /home/prueba/ftp/files 
sudo chown prueba:prueba /home/prueba/ftp/files 

echo "ejemplo ftp" | sudo tee /home/prueba/ftp/files/prueba.txt 

ls /home/prueba/ftp/files 

sudo nano /etc/vsftpd.conf 

echo "prueba" | sudo tee -a /etc/vsftpd.userlist 
cat /etc/vsftpd.userlist 

sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/vsftpd.pem -out /etc/ssl/private/vsftpd.pem 

sudo apt install filezilla 

ip addr show





📄 /etc/vsftpd.conf

write_enable=YES 


chroot_local_user=YES 


user_sub_token=$USER 

local_root=/home/$USER/ftp 

pasv_min_port=40000 

pasv_max_port=50000 


userlist_enable=YES 

userlist_file=/etc/vsftpd.userlist 

userlist_deny=NO 


rsa_cert_file=/etc/ssl/private/vsftpd.pem 

rsa_private_key_file=/etc/ssl/private/vsftpd.pem 


ssl_enable=YES 


allow_anon_ssl=NO 

force_local_data_ssl=YES 

force_local_logins_ssl=YES 

ssl_tlsv1=YES 

ssl_sslv2=NO 

ssl_sslv3=NO 

require_ssl_reuse=NO 

ssl_ciphers=HIGH 
