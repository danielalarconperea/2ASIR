¡Hola\! Claro, aquí tienes una guía detallada para configurar la red según tus especificaciones, junto con la explicación del enrutamiento y los comandos necesarios.

### **Ruta de los Paquetes**

Primero, respondiendo a tu pregunta principal sobre el camino que seguirán los paquetes, este será determinado por el protocolo de enrutamiento **OSPF**. OSPF siempre elegirá la ruta con el menor "coste" (generalmente la más rápida o directa).

  * **De Red A a Red C y Red D:** Los paquetes saldrán de un PC en la Red A, pasarán por el **Switch0**, llegarán al router **Alpedrete**, cruzarán por el enlace directo hacia el **Router2**, y desde allí serán enviados a través del **Switch1** a la VLAN correcta (VLAN 10 para Red C o VLAN 20 para Red D).

      * **Ruta:** `PC_A -> Switch0 -> Alpedrete -> Router2 -> Switch1 -> PC_C / Servidor_D`

  * **De Red A a Red B:** Los paquetes saldrán de la Red A, pasarán por el **Switch0**, llegarán al router **Alpedrete**, este los enviará al router **Chapetón**, que finalmente los dirigirá a través del **Switch2** hacia la Red B.

      * **Ruta:** `PC_A -> Switch0 -> Alpedrete -> Chapetón -> Switch2 -> PC_B`

-----

### **Paso 1: Configuración del Direccionamiento IP**

Asignaremos las direcciones IP a las interfaces de los routers y a los equipos finales. Los routers suelen usar la primera IP disponible de la subred como su puerta de enlace.

| Dispositivo | Interfaz | Red | Dirección IP | Máscara de Subred | Default Gateway |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Router Alpedrete** | Gig0/0 | Red\_A | `192.168.0.1` | `255.255.255.0` | - |
| | Ser0/1/0 | Enlace WAN | `192.168.255.93` | `255.255.255.252` | - |
| | Gig0/2 | Enlace WAN | `192.168.255.4` | `255.255.255.252` | - |
| **Router Chapetón** | Gig0/1 | Red\_B | `192.168.1.1` | `255.255.255.0` | - |
| | Gig0/0 | Red\_Adm | `192.168.255.129`| `255.255.255.128`| - |
| | Gig0/2 | Enlace WAN | `192.168.255.5` | `255.255.255.252` | - |
| **Router2** | Ser0/1/0 | Enlace WAN | `192.168.255.94` | `255.255.255.252` | - |
| | Gig0/0.10 | VLAN 10 | `192.168.2.1` | `255.255.255.0` | - |
| | Gig0/0.20 | VLAN 20 | `192.168.3.1` | `255.255.255.0` | - |
| **PC-A1** | Fa0 | Red\_A | `192.168.0.2` | `255.255.255.0` | `192.168.0.1` |
| **PC-B1** | Fa0 | Red\_B | `192.168.1.2` | `255.255.255.0` | `192.168.1.1` |
| **PC-C1** | Fa0 | Red\_C | `192.168.2.2` | `255.255.255.0` | `192.168.2.1` |
| **Server-D13** | Fa0 | Red\_D | `192.168.3.2` | `255.255.255.0` | `192.168.3.1` |
| **PC-Adm** | Gig0 | Red\_Adm | `192.168.255.130`| `255.255.255.128`| `192.168.255.129`|

-----

### **Paso 2: Configuración de VLANs en Switch1 (Titulcia)**

En el Switch1, creamos las VLANs y asignamos los puertos. La conexión con el Router2 debe ser un enlace troncal para que pueda transportar el tráfico de ambas VLANs.

```bash
// Entrar en modo de configuración
enable
conf t

// Crear VLANs
vlan 10
 name RED_C
vlan 20
 name RED_D
exit

// Asignar puertos a las VLANs
interface range FastEthernet0/1 - 12 // O los puertos correspondientes
 switchport mode access
 switchport access vlan 10
!
interface range FastEthernet0/13 - 24 // O los puertos correspondientes
 switchport mode access
 switchport access vlan 20

// Configurar el puerto hacia el Router2 como troncal
interface GigabitEthernet0/1 // O el puerto correspondiente
 switchport mode trunk
```

En el **Router2**, configuramos las subinterfaces para que actúen como puerta de enlace de cada VLAN (configuración conocida como "Router on a Stick").

```bash
// Entrar en modo de configuración
enable
conf t

// Subinterfaz para VLAN 10 (Red C)
interface GigabitEthernet0/0.10
 encapsulation dot1Q 10
 ip address 192.168.2.1 255.255.255.0
!
// Subinterfaz para VLAN 20 (Red D)
interface GigabitEthernet0/0.20
 encapsulation dot1Q 20
 ip address 192.168.3.1 255.255.255.0
!
// Activar la interfaz física
interface GigabitEthernet0/0
 no shutdown
```

-----

### **Paso 3: Configuración de OSPF de Área Única (Área 0)**

Configuramos OSPF en todos los routers para que compartan sus rutas. Usaremos el ID de proceso 1 y el área 0 en todos ellos.

**En Router Alpedrete:**

```bash
router ospf 1
 network 192.168.0.0 0.0.0.255 area 0
 network 192.168.255.92 0.0.0.3 area 0
 network 192.168.255.4 0.0.0.3 area 0
```

**En Router Chapetón:**

```bash
router ospf 1
 network 192.168.1.0 0.0.0.255 area 0
 network 192.168.255.128 0.0.0.127 area 0
 network 192.168.255.4 0.0.0.3 area 0
```

**En Router2:**

```bash
router ospf 1
 network 192.168.2.0 0.0.0.255 area 0
 network 192.168.3.0 0.0.0.255 area 0
 network 192.168.255.92 0.0.0.3 area 0
```

-----

### **Paso 4: Protección de Acceso (SSH)**

Para proteger los routers y switches, configuraremos SSH y lo restringiremos para que solo el PC de administración pueda acceder. Esto se debe hacer en todos los routers y switches gestionables.

```bash
// 1. Configuración básica de seguridad
hostname Alpedrete // Cambiar en cada dispositivo
ip domain-name mi.red
crypto key generate rsa
username admin secret TuContraseñaSegura

// 2. Crear ACL para permitir solo al PC Admin
access-list 1 permit host 192.168.255.130

// 3. Aplicar a las líneas de terminal virtual (VTY)
line vty 0 4
 transport input ssh
 login local
 access-class 1 in
```

-----

### **Paso 5: Configuración de Listas de Control de Acceso (ACL)**

Aplicaremos las reglas de filtrado de tráfico en los routers más cercanos al origen del tráfico para optimizar el rendimiento.

#### **ACL para Red A (Aplicada en Alpedrete)**

Esta ACL se aplica en la interfaz `GigabitEthernet0/0` del router Alpedrete, en sentido de entrada (`in`).

```bash
// En Router Alpedrete
conf t
access-list 101 permit tcp 192.168.0.0 0.0.0.255 192.168.2.0 0.0.0.255 lt 1024
access-list 101 permit udp 192.168.0.0 0.0.0.255 192.168.2.0 0.0.0.255 lt 1024
access-list 101 permit ip 192.168.0.0 0.0.0.255 192.168.1.0 0.0.0.255
! La denegación del resto es implícita al final de la ACL

interface GigabitEthernet0/0
 ip access-group 101 in
```

#### **ACL para Red B (Aplicada en Chapetón)**

Esta ACL se aplica en la interfaz `GigabitEthernet0/1` del router Chapetón, en sentido de entrada (`in`).

```bash
// En Router Chapetón
conf t
! Denegar tráfico a los equipos .30 y .31 de Red_C
access-list 102 deny ip 192.168.1.0 0.0.0.255 host 192.168.2.30
access-list 102 deny ip 192.168.1.0 0.0.0.255 host 192.168.2.31
! Denegar tráfico al rango .32 al .63 de Red_C
access-list 102 deny ip 192.168.1.0 0.0.0.255 192.168.2.32 0.0.0.31

! Permitir solo tráfico WEB (HTTP y HTTPS) a Red_D
access-list 102 permit tcp 192.168.1.0 0.0.0.255 192.168.3.0 0.0.0.255 eq 80
access-list 102 permit tcp 192.168.1.0 0.0.0.255 192.168.3.0 0.0.0.255 eq 443

! Permitir todo el resto del tráfico
access-list 102 permit ip any any

interface GigabitEthernet0/1
 ip access-group 102 in
```

-----

### **Paso 6: Comprobación de Conectividad y ACLs**

Para verificar que todo funciona como se espera, puedes realizar las siguientes pruebas:

1.  **Conectividad básica:**

      * Desde un PC en Red A (`PC-A1`), haz `ping 192.168.1.2` (a `PC-B1`). Debería funcionar.
      * Desde un PC en Red A (`PC-A1`), haz `ping 192.168.2.2` (a `PC-C1`). Debería fallar por la ACL (solo permite puertos \< 1024).

2.  **Comprobación de ACL de Red A:**

      * Desde `PC-A1`, intenta acceder a un servicio web en `PC-C1` (puerto 80). `telnet 192.168.2.2 80`. Debería funcionar.
      * Desde `PC-A1`, intenta hacer `ping 192.168.3.2` (a `Server-D13`). Debería ser denegado por la ACL.

3.  **Comprobación de ACL de Red B:**

      * Desde `PC-B1`, haz `ping 192.168.2.2` (a `PC-C1`). Debería funcionar.
      * Desde `PC-B1`, haz `ping 192.168.2.35`. Debería fallar, ya que está en el rango denegado.
      * Desde `PC-B1`, intenta acceder al servidor web en `Server-D13` (puerto 80). `telnet 192.168.3.2 80`. Debería funcionar.
      * Desde `PC-B1`, haz `ping 192.168.3.2` (a `Server-D13`). Debería fallar, ya que la ACL solo permite tráfico web (TCP 80/443).

4.  **Verificar SSH:**

      * Desde `PC-Adm`, intenta `ssh admin@192.168.0.1`. Debería pedirte la contraseña.
      * Desde `PC-A1`, intenta `ssh admin@192.168.0.1`. Debería ser bloqueado.

Para ver los contadores de las ACL y comprobar si están funcionando (cuántos paquetes coinciden con cada regla), usa el comando `show access-lists` en el router correspondiente.