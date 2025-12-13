network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s3:
      dhcp4: false
      addresses:
        - 172.16.114.113/23
    enp0s8:
      dhcp4: false
      addresses:
        - 192.168.1.10/16
        - "2001:db8:2::10/64"
      routes:
        - to: 0.0.0.0/0
          via: 192.168.1.254
        - to: "::/0"
          via: "2001:db8:2::99"
      nameservers:
        search:
          - dns.asir
        addresses:
          - 8.8.8.8
