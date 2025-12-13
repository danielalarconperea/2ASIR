Hola. [cite\_start]La configuración consiste en establecer un túnel VPN IPsec de sitio a sitio entre el R1 y el R3, utilizando el R2 como un router de paso[cite: 9, 10, 11].

A continuación, se detallan los pasos de configuración basados en el documento proporcionado.

-----

## [cite\_start]Configuración en R1 [cite: 29]

[cite\_start]El objetivo es configurar el R1 para que el tráfico desde su LAN (192.168.1.0/24) hacia la LAN del R3 (192.168.3.0/24) sea encriptado[cite: 40, 41].

### 1\. Habilitar la licencia de seguridad (si es necesario)

[cite\_start]Primero, se debe verificar si el paquete de tecnología de seguridad está activo con `show version`[cite: 33]. [cite\_start]Si no lo está, se debe habilitar con los siguientes comandos, guardar la configuración y reiniciar el router[cite: 35, 36, 37]:

```
R1(config)# license boot module c1900 technology-package securityk9
```

### 2\. Definir el "Tráfico Interesante" (ACL)

Se crea una lista de acceso (ACL) para identificar el tráfico que debe ser encriptado. [cite\_start]En este caso, es el tráfico de la LAN de R1 a la LAN de R3[cite: 40].

```
[cite_start]R1(config)# access-list 110 permit ip 192.168.1.0 0.0.0.255 192.168.3.0 0.0.0.255 [cite: 44]
```

### 3\. Configurar IKE Fase 1 (ISAKMP)

[cite\_start]Esto establece el canal seguro para negociar las claves de la VPN[cite: 45].

  * [cite\_start]Se crea la política ISAKMP (política 10)[cite: 49].
  * [cite\_start]Se define la encriptación: **AES 256**[cite: 50].
  * [cite\_start]Se define la autenticación: **Clave pre-compartida (pre-share)**[cite: 51].
  * [cite\_start]Se define el grupo Diffie-Hellman: **Grupo 5**[cite: 52].
  * [cite\_start]Se configura la clave pre-compartida `vpnpa55` y la dirección IP del peer (el S0/0/1 de R3)[cite: 54].

<!-- end list -->

```
[cite_start]R1(config)# crypto isakmp policy 10 [cite: 49]
[cite_start]R1(config-isakmp)# encryption aes 256 [cite: 50]
[cite_start]R1(config-isakmp)# authentication pre-share [cite: 51]
[cite_start]R1(config-isakmp)# group 5 [cite: 52]
[cite_start]R1(config-isakmp)# exit [cite: 53]
[cite_start]R1(config)# crypto isakmp key vpnpa55 address 10.2.2.2 [cite: 54]
```

### 4\. Configurar IKE Fase 2 (IPsec)

[cite\_start]Esto define cómo se encriptarán los datos del usuario[cite: 55].

  * [cite\_start]Se crea el "transform-set" `VPN-SET` usando `esp-aes` y `esp-sha-hmac`[cite: 56, 57].
  * [cite\_start]Se crea el "crypto map" `VPN-MAP`[cite: 58, 60].
  * [cite\_start]Dentro del crypto map, se define el peer (R3): `10.2.2.2`[cite: 62].
  * [cite\_start]Se asocia el transform-set `VPN-SET`[cite: 63].
  * [cite\_start]Se asocia la ACL `110` que define el tráfico a encriptar[cite: 64].

<!-- end list -->

```
[cite_start]R1(config)# crypto ipsec transform-set VPN-SET esp-aes esp-sha-hmac [cite: 57]
[cite_start]R1(config)# crypto map VPN-MAP 10 ipsec-isakmp [cite: 60]
[cite_start]R1(config-crypto-map)# set peer 10.2.2.2 [cite: 62]
[cite_start]R1(config-crypto-map)# set transform-set VPN-SET [cite: 63]
[cite_start]R1(config-crypto-map)# match address 110 [cite: 64]
[cite_start]R1(config-crypto-map)# exit [cite: 65]
```

### 5\. Aplicar el Crypto Map a la Interfaz

[cite\_start]Finalmente, el crypto map se aplica a la interfaz de salida que se conecta a la red WAN (hacia R2)[cite: 66, 67].

```
[cite_start]R1(config)# interface s0/0/0 [cite: 68]
[cite_start]R1(config-if)# crypto map VPN-MAP [cite: 69]
```

-----

## [cite\_start]Configuración en R3 [cite: 70]

[cite\_start]La configuración en R3 es un espejo de la configuración de R1[cite: 75].

### 1\. Habilitar la licencia de seguridad (si es necesario)

[cite\_start]Al igual que en R1, se debe verificar y, si es necesario, habilitar el paquete de seguridad y reiniciar el router[cite: 72, 73].

### 2\. Definir el "Tráfico Interesante" (ACL)

[cite\_start]Se crea la ACL 110 para el tráfico de retorno: desde la LAN de R3 (192.168.3.0/24) a la LAN de R1 (192.168.1.0/24)[cite: 75, 76].

```
[cite_start]R3(config)# access-list 110 permit ip 192.168.3.0 0.0.0.255 192.168.1.0 0.0.0.255 [cite: 76]
```

### 3\. Configurar IKE Fase 1 (ISAKMP)

[cite\_start]Los parámetros deben coincidir con los de R1 (excepto la dirección del peer)[cite: 77, 78].

  * [cite\_start]Se crea la política 10 con **AES 256**, autenticación **pre-share** y **Grupo 5**[cite: 79, 80, 81, 82].
  * [cite\_start]Se configura la misma clave `vpnpa55`, pero apuntando a la IP del peer R1 (el S0/0/0 de R1)[cite: 84].

<!-- end list -->

```
[cite_start]R3(config)# crypto isakmp policy 10 [cite: 79]
[cite_start]R3(config-isakmp)# encryption aes 256 [cite: 80]
[cite_start]R3(config-isakmp)# authentication pre-share [cite: 81]
[cite_start]R3(config-isakmp)# group 5 [cite: 82]
[cite_start]R3(config-isakmp)# exit [cite: 83]
[cite_start]R3(config)# crypto isakmp key vpnpa55 address 10.1.1.2 [cite: 84]
```

### 4\. Configurar IKE Fase 2 (IPsec)

[cite\_start]Los parámetros deben coincidir[cite: 85].

  * [cite\_start]Se crea el "transform-set" `VPN-SET` (debe tener el mismo nombre) usando `esp-aes` y `esp-sha-hmac`[cite: 86, 87].
  * [cite\_start]Se crea el "crypto map" `VPN-MAP`[cite: 88, 90].
  * [cite\_start]Dentro del crypto map, se define el peer (R1): `10.1.1.2`[cite: 92].
  * [cite\_start]Se asocia el transform-set `VPN-SET`[cite: 93].
  * [cite\_start]Se asocia la ACL `110`[cite: 94].

<!-- end list -->

```
[cite_start]R3(config)# crypto ipsec transform-set VPN-SET esp-aes esp-sha-hmac [cite: 87]
[cite_start]R3(config)# crypto map VPN-MAP 10 ipsec-isakmp [cite: 90]
[cite_start]R3(config-crypto-map)# set peer 10.1.1.2 [cite: 92]
[cite_start]R3(config-crypto-map)# set transform-set VPN-SET [cite: 93]
[cite_start]R3(config-crypto-map)# match address 110 [cite: 94]
[cite_start]R3(config-crypto-map)# exit [cite: 95]
```

### 5\. Aplicar el Crypto Map a la Interfaz

[cite\_start]Se aplica el crypto map a la interfaz de salida S0/0/1 de R3[cite: 97].

```
[cite_start]R3(config)# interface s0/0/1 [cite: 98]
[cite_start]R3(config-if)# crypto map VPN-MAP [cite: 99]
```

-----

## [cite\_start]Verificación de la VPN [cite: 100]

1.  **Revisar antes del tráfico:** Ejecuta `show crypto ipsec sa` en R1. [cite\_start]Los contadores de paquetes (encapsulados/desencapsulados) deberían estar en 0[cite: 102, 103].
2.  [cite\_start]**Generar tráfico interesante:** Haz ping desde PC-A (192.168.1.3) a PC-C (192.168.3.3)[cite: 105].
3.  **Revisar después del tráfico:** Ejecuta `show crypto ipsec sa` en R1 nuevamente. [cite\_start]Los contadores de paquetes ahora deberían ser mayores que 0, lo que indica que el túnel está funcionando y encriptando tráfico[cite: 107, 108].
4.  [cite\_start]**Generar tráfico no interesante:** Haz ping desde PC-A a PC-B (192.168.2.3)[cite: 110].
5.  **Revisar de nuevo:** Ejecuta `show crypto ipsec sa` en R1. [cite\_start]Los contadores no deberían haber aumentado, verificando que este tráfico no se encriptó[cite: 112, 113].