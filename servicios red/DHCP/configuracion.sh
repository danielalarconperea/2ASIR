sudo apt update
sudo apt install net-tools
sudo apt install isc-dhcp-server

172.16.114.133/23 172.16.115.255 


network:
  version: 2
  ethernets:
    enp0s3:
      dhcp4: no
      addresses:
        - 172.16.114.133/23
      routes:
        - to: 0.0.0.0/0
          via: 172.16.114.1
      nameservers:
        addresses:
          - 8.8.8.8
          - 8.8.4.4
    enp0s8:
      dhcp4: no
      addresses:
        - 172.16.0.24/16