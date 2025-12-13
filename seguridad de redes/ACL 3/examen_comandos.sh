*******************************************
ALPEDRETE
********************************************
en
conf t
hostname   ALPEDRETE 
int g0/0/0 
ip address 172.20.0.1 255.255.255.0 
no sh
int g0/0/1
ip address 172.20.255.1 255.255.255.252
no sh
****************************************
SW2
****************************************
en 
conf t
hostname SW2
int g1/0/24
no sw 
ip address 17.20.255.2 255.255.255.252
int g1/1/1 
no sw
ip address 172.20.255.6 255.255.255.252
int g1/0/23 
no sw 
ip address 172.20.1.1 255.255.255.0
int g1/0/21
no sw
ip address 172.20.254.1 255.255.255.0
int g1/0/22
no sw
ip address 172.20.255.10 255.255.255.252
exit
*******************************************
HABILITAR OSFP EN SW2
******************************************
ip routing
router ospf 10
net 172.20.255.0 0.0.0.3 area 0
net 172.20.255.4 0.0.0.3 area 0
net 172.20.254.0 0.0.0.255 area 0
net 172.20.1.0 0.0.0.255 area 0
net 172.20.255.8 0.0.0.3 area 0
clear ospf process(comando para ver info)
******************************************
ALPEDRETE
*****************************************
router ospf 10
net 172.20.0.0 0.0.0.255 area 0
net 172.20.255.0 0.0.0.3 area 0
net 192.168.255.0 0.0.0.3 area 0
exit
line console 0  
logging synchronous 
show ip route(para ver informacion)
**************************************
TITULCIA
**************************************
en 
conf t
hostname TITULCIA
router ospf 10
net 192.168.255.0 0.0.0.3 area 0
net 172.20.2.0 0.0.0.255 area 0
net 172.20.3.0 0.0.0.255 area 0
net 172.20.255.4 0.0.0.3 area 0
show running-config
clear ip ospf process
int g0/0/0.10 
ip address 172.20.2.1 255.255.255.0
int g0/0.20
ip address 172.20.3.1 255.255.255.0

int g0/0/2
ip ospf network point-to-point
show clock
sh ntp associations

conf t
ntp server 172.20.254.10
service timestamps log datatime msec
**************************************
ISP
***************************************
router ospf 10
net 172.20.255.8 0.0.0.3 area 0
ruta por defecto(info)
default-information originate
ip route 0.0.0.0 0.0.0.0 g0/0/1
****************************


PC-PT PC-A1:
ip-172.20.0.2
mask- 255.255.255.0 
gatewey-172.20.0.1

PC_TP PC-A13:
ip-172.20.0.3
mask- 255.255.255.0 
gatewey-172.20.0.1


****************************************
ALPEDRETE
*************************************
en
conf t
access-list 100 permit icmp 172.20.0.0 0.0.0.255 any 
access-list 100 deny ip 172.20.0.0 0.0.0.255 172.20.2.0 0.0.0.255 
access-list 100 deny ip 172.20.0.0 0.0.0.255 172.20.3.0 0.0.0.255 
acces-list100 permit ip any deny
int g0/0/0 
ip access-group 100 in
show access-list

***********************************
SW2
************************************
access-list 100 deny icmp 172.20.1.0 0.0.0.255 172.20.3.0 0.0.0.255
access-list 100 deny tcp 172.20.1.0 0.0.0.255 172.20.0.0 0.0.0.63 eq 20
access-list 100 deny tcp 172.20.1.0 0.0.0.255 172.20.0.0 0.0.0.63 eq 21
access-list 100 deny udp 172.20.1.0 0.0.0.255 172.20.0.0 0.0.0.63 eq 69
acces-list 100 permit ip any any
int g1/0/23 
ip access-group 100 in


ip access-list extended AInternet
permit icmp 172.20.0.0 0.0.255.255 any 
permit tcp any any eq 80 
permit tcp any any eq 443
permit tcp any any eq 20
permit tcp any any eq 21
permit tcp any any eq 53
permit udp any any eq 53
deny ip any any 
exit
int g1/0/22 
ip access-group AInternet out

****************
ISP
*************
access-list DeInternet
ip access-list ext DeInternet
permit ip 





