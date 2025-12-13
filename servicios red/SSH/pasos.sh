# SERVIDOR
sudo apt update && sudo apt upgrade
sudo apt install apenssh-server
sudo systemctl status ssh
ssh-keygen -t rsa -b 4096
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
sudo nano /etc/ssh/sshd_config
sudo systemctl restart ssh
sudo nano /etc/netplan/01-netcfg.yaml
sudo netplan apply
sudo ufw status
sudo ufw allow 356/tcp


# CLIENTE

sudo nano /etc/netplan/01-netcfg.yaml
sudo netplan apply
sudo apt install openssh-client -y
ssh-copy-id -p 356 usuario@192.168.1.10
ssh usuario@192.168.1.10 -p 356
# Extensión
sudo nano /etc/hosts
# 192.168.1.10 miservidor
ssh usuario@miservidor -p 356