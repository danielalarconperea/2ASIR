R1(config)# license boot module c1900 technology-package securityk9

R1(config)# access-list 110 permit ip 192.168.1.0 0.0.0.255 192.168.3.0 0.0.0.255

R1(config)# crypto isakmp policy 10 
R1(config-isakmp)# encryption aes 256 
R1(config-isakmp)# authentication pre-share 
R1(config-isakmp)# group 5 
R1(config-isakmp)# exit
R1(config)# crypto isakmp key vpnpa55 address 10.2.2.2

R1(config)# crypto ipsec transform-set VPN-SET esp-aes esp-sha-hmac
R1(config)# crypto map VPN-MAP 10 ipsec-isakmp
R1(config-crypto-map)# set peer 10.2.2.2 
R1(config-crypto-map)# set transform-set VPN-SET 
R1(config-crypto-map)# match address 110 
R1(config-crypto-map)# exit

R1(config)# interface s0/0/0
R1(config-if)# crypto map VPN-MAP




R3(config)# access-list 110 permit ip 192.168.3.0 0.0.0.255 192.168.1.0 0.0.0.255

R3(config)# crypto isakmp policy 10
R3(config-isakmp)# encryption aes 256
R3(config-isakmp)# authentication pre-share
R3(config-isakmp)# group 5
R3(config-isakmp)# exit
R3(config)# crypto isakmp key vpnpa55 address 10.1.1.2

R3(config)# crypto ipsec transform-set VPN-SET esp-aes esp-sha-hmac
R3(config)# crypto map VPN-MAP 10 ipsec-isakmp
R3(config-crypto-map)# set peer 10.1.1.2 
R3(config-crypto-map)# set transform-set VPN-SET 
R3(config-crypto-map)# match address 110 
R3(config-crypto-map)# exit

R3(config)# interface s0/0/1
R3(config-if)# crypto map VPN-MAP