enable
configure terminal

# 1- Configura los etherchannel

#### CORE
! Enlace hacia SW1
interface range g1/0/1-2
 channel-group 1 mode active
! Enlace hacia SW2
interface range g1/0/3-4
 channel-group 2 mode active
exit
#### SW1
! Enlace hacia CORE
interface range g1/0/1-2
 channel-group 1 mode active
! Enlace hacia SW2
interface range fa0/23-24
 channel-group 3 mode active
exit
#### SW2
! Enlace hacia CORE
interface range g1/0/1-2
 channel-group 2 mode active
! Enlace hacia SW1
interface range fa0/23-24
 channel-group 3 mode active
exit

# 2- configura STP, CORE es el puente raiz

#### CORE
spanning-tree vlan 1,10,20,30,99 root primary
spanning-tree portfast default 
#### SW1
spanning-tree vlan 1,10,20,30,99 root secondary
spanning-tree portfast default 
#### SW2
spanning-tree portfast default 


# 3- Crea las VLAN 10,20,30,99(nativa) y ponles nombre.

#### CORE, SW1, SW2
vlan 10
 name VLAN10_CYAN
exit
vlan 20
 name VLAN20_VERDE
exit
vlan 30
 name VLAN30_NARANJA
exit
vlan 99
 name NATIVA
exit
vlan 255
 name APAGADA
exit

# 4- Asigna varios puertos a cada VLAN en cada Switch. Cada color en una VLAN

#### CORE
interface range g1/0/5-10
 switchport mode access
 switchport access vlan 10
interface range g1/0/10-15
 switchport mode access
 switchport access vlan 20
exit
#### SW1, SW2
interface range fa0/1-4
 switchport mode access
 switchport access vlan 10
interface range fa0/5-9
 switchport mode access
 switchport access vlan 20
interface range fa0/10-14
 switchport mode access
 switchport access vlan 30
interface range fa0/15-22
 shutdown
 exit

# 5- configura los troncales necesarios

#### CORE, SW1, SW2
interface port-channel1
 switchport mode trunk
 switchport trunk native vlan 99
interface port-channel2
 switchport mode trunk
 switchport trunk native vlan 99
exit

# 6- Configura servidores DHCP en el CORE

#### CORE
! Excluir las direcciones de los gateways para que no se asignen
ip dhcp excluded-address 172.16.0.1
ip dhcp excluded-address 172.16.32.1
ip dhcp excluded-address 172.16.64.1

! Pool de DHCP para VLAN 10
ip dhcp pool VLAN10_POOL
 network 172.16.0.0 255.255.224.0
 default-router 172.16.0.1
 dns-server 8.8.8.8
exit
! Pool de DHCP para VLAN 20
ip dhcp pool VLAN20_POOL
 network 172.16.32.0 255.255.224.0
 default-router 172.16.32.1
 dns-server 8.8.8.8
exit
! Pool de DHCP para VLAN 30
ip dhcp pool VLAN30_POOL
 network 172.16.64.0 255.255.224.0
 default-router 172.16.64.1
 dns-server 8.8.8.8
exit

# 7- Confiura la salida a internet con un puerto de router en el CORE

#### CORE
! Convertir el puerto en una interfaz enrutada (Capa 3)
interface Gig1/0/24
 no switchport
 ip address 172.7.7.2 255.255.255.252
 no shutdown
exit

# 8- Configura la ruta por defecto.

#### CORE
! Ruta estática para dirigir todo el tráfico desconocido hacia Internet
ip route 0.0.0.0 0.0.0.0 209.7.7.1

# 9- Habilita el enrutamiento entre VLAN

#### CORE
ip routing

! Creación de Interfaces Virtuales (Gateways para cada VLAN)
interface Vlan10
 ip address 172.16.0.1 255.255.224.0
 no shutdown
exit
interface Vlan20
 ip address 172.16.32.1 255.255.224.0
 no shutdown
exit
interface Vlan30
 ip address 172.16.64.1 255.255.224.0
 no shutdown
exit


enable secret cisco



copy run tftp
172.7.7.1


































enable secret cisco
username admin password cisco
ip domain-name terra.com
crypto key generate rsa 
1024
ip ssh version 2
line vty 0 4
transport input ssh
login local
exit

































exit
interface Port-channel2
 switchport mode trunk
 switchport trunk native vlan 99
exit

! --- 9. Habilitar Enrutamiento entre VLANs (SVIs) ---
ip routing
interface Vlan10
 ip address 172.16.0.1 255.255.224.0
 no shutdown
exit
interface Vlan20
 ip address 172.16.32.1 255.255.224.0
 no shutdown
exit
interface Vlan30
 ip address 172.16.64.1 255.255.224.0
 no shutdown
exit

! --- 7. Configuración de Salida a Internet ---
interface Gig1/0/24
 no switchport
 ip address 209.7.7.2 255.255.255.252
 no shutdown
exit

! --- 6. Configuración de Servidores DHCP en CORE ---
ip dhcp excluded-address 172.16.0.1
ip dhcp excluded-address 172.16.32.1
ip dhcp excluded-address 172.16.64.1
ip dhcp pool VLAN10_POOL
 network 172.16.0.0 255.255.224.0
 default-router 172.16.0.1
 dns-server 8.8.8.8
exit
ip dhcp pool VLAN20_POOL
 network 172.16.32.0 255.255.224.0
 default-router 172.16.32.1
 dns-server 8.8.8.8
exit
ip dhcp pool VLAN30_POOL
 network 172.16.64.0 255.255.224.0
 default-router 172.16.64.1
 dns-server 8.8.8.8
exit

! --- 8. Configuración de la Ruta por Defecto ---
ip route 0.0.0.0 0.0.0.0 209.7.7.1

end
write memory


! ##################################################################
! ############      CONFIGURACIÓN SWITCH SW_ACCESO_0      ############
! ##################################################################

enable
configure terminal

hostname SW_ACCESO_0

! --- Configuración de acceso remoto SSH ---
ip domain-name mi.red.local
crypto key generate rsa modulus 2048
username admin secret TuContraseñaSegura
ip ssh version 2
! Se necesita una SVI para la gestión remota
interface Vlan99
 ip address 172.16.96.2 255.255.224.0 ! IP de gestión en la subred de la nativa
exit
ip default-gateway 172.16.96.1 ! Gateway para el switch
line vty 0 15
 transport input ssh
 login local
exit

! --- 3. Creación y Nombre de VLANs ---
vlan 10
 name VLAN10_CYAN
exit
vlan 20
 name VLAN20_VERDE
exit
vlan 30
 name VLAN30_NARANJA
exit
vlan 99
 name NATIVA
exit

! --- 1. Configuración de EtherChannel ---
interface range Fa0/23 - 24
 channel-group 1 mode active
 exit

! --- 4. Asignación de Puertos a VLANs ---
interface Fa0/1
 switchport mode access
 switchport access vlan 10
exit
interface Fa0/10
 switchport mode access
 switchport access vlan 20
exit
interface Fa0/15
 switchport mode access
 switchport access vlan 30
exit

! --- 5. Configuración de Troncales ---
interface Port-channel1
 switchport mode trunk
 switchport trunk native vlan 99
exit

end
write memory


! ##################################################################
! ############      CONFIGURACIÓN SWITCH SW_ACCESO_1      ############
! ##################################################################

enable
configure terminal

hostname SW_ACCESO_1

! --- Configuración de acceso remoto SSH ---
ip domain-name mi.red.local
crypto key generate rsa modulus 2048
username admin secret TuContraseñaSegura
ip ssh version 2
! Se necesita una SVI para la gestión remota
interface Vlan99
 ip address 172.16.96.3 255.255.224.0 ! IP de gestión en la subred de la nativa
exit
ip default-gateway 172.16.96.1 ! Gateway para el switch
line vty 0 15
 transport input ssh
 login local
exit

! --- 3. Creación y Nombre de VLANs ---
vlan 10
 name VLAN10_CYAN
exit
vlan 20
 name VLAN20_VERDE
exit
vlan 30
 name VLAN30_NARANJA
exit
vlan 99
 name NATIVA
exit

! --- 1. Configuración de EtherChannel ---
interface range Fa0/23 - 24
 channel-group 2 mode active
 exit

! --- 4. Asignación de Puertos a VLANs ---
interface Fa0/1
 switchport mode access
 switchport access vlan 10
exit
interface Fa0/5
 switchport mode access
 switchport access vlan 20
exit
interface Fa0/10
 switchport mode access
 switchport access vlan 30
exit

! --- 5. Configuración de Troncales ---
interface Port-channel2
 switchport mode trunk
 switchport trunk native vlan 99
exit

end
write memory