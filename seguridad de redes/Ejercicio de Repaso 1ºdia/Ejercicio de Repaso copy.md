! ##################################################################
! ############        CONFIGURACIÓN SWITCH CORE           ############
! ##################################################################

enable
configure terminal

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

! --- 2. Configuración de STP (Spanning Tree Protocol) ---
! Se configura como raíz primario para todas las VLANs
spanning-tree vlan 1,10,20,30,99 root primary

! --- 1. Configuración de EtherChannel ---
! Grupo 1 hacia SW_ACCESO_0
interface range Gig1/0/1 - 2
 channel-group 1 mode active
 exit
! Grupo 2 hacia SW_ACCESO_1
interface range Gig1/0/3 - 4
 channel-group 2 mode active
 exit

! --- 4. Asignación de Puertos a VLANs ---
! Asignación para PC6 y PC7 conectados directamente al CORE
interface Gig1/0/15
 switchport mode access
 switchport access vlan 10
exit
interface Gig1/0/17
 switchport mode access
 switchport access vlan 20
exit

! --- 5. Configuración de Troncales ---
interface Port-channel1
 switchport mode trunk
 switchport trunk native vlan 99
exit
interface Port-channel2
 switchport mode trunk
 switchport trunk native vlan 99
exit

! --- 9. Habilitar Enrutamiento entre VLANs (SVIs) ---
! Habilitar enrutamiento globalmente
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

! --- 7. Configuración de Salida a Internet ---
! Convertir el puerto en una interfaz enrutada (Capa 3)
interface Gig1/0/24
 no switchport
 ip address 209.7.7.2 255.255.255.252
 no shutdown
exit

! --- 6. Configuración de Servidores DHCP en CORE ---
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

! --- 8. Configuración de la Ruta por Defecto ---
! Ruta estática para dirigir todo el tráfico desconocido hacia Internet
ip route 0.0.0.0 0.0.0.0 209.7.7.1

end
write memory


! ##################################################################
! ############         CONFIGURACIÓN SWITCH SW1         ############
! ##################################################################

enable
configure terminal

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
! Grupo 1 hacia CORE
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
! Suponiendo que PC2 está en Fa0/15
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
! ############         CONFIGURACIÓN SWITCH SW2         ############    
! ##################################################################

enable
configure terminal

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
! Grupo 2 hacia CORE
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