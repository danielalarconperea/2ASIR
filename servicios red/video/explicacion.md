[cite\_start]Aunque el documento que has subido es una guía específica para **Jellyfin**[cite: 1], mencionas que quieres hacerlo con **Plex**. [cite\_start]Curiosamente, tu propio documento menciona a Plex como una alternativa que ofrece mayor comodidad aunque menor privacidad[cite: 10, 434].

Aquí tienes los pasos detallados para instalar y configurar **Plex Media Server** en **Ubuntu 24.04**, adaptando la lógica del manual que subiste (instalación, red y permisos) pero con los comandos específicos para Plex.

### 1\. Preparación del Sistema

[cite\_start]Al igual que en el manual de Jellyfin, primero debemos actualizar el sistema y asegurarnos de tener herramientas básicas (como `curl` y `wget` mencionadas en tu PDF [cite: 20]).

Abre la terminal y ejecuta:

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install curl wget gnupg2 -y
```

### 2\. Añadir el Repositorio de Plex

Plex no está en los repositorios predeterminados de Ubuntu de la misma forma abierta que otros paquetes. Debemos añadir su repositorio oficial (similar al proceso descrito en la página 4 de tu documento para Jellyfin).

1.  **Descargar la clave GPG de Plex:**
    En Ubuntu 24.04 se recomienda guardar las llaves en `/usr/share/keyrings`.

    ```bash
    curl -fsSL https://downloads.plex.tv/plex-keys/PlexSign.key | sudo gpg --dearmor -o /usr/share/keyrings/plex-archive-keyring.gpg
    ```

2.  **Añadir el repositorio a la lista de fuentes:**

    ```bash
    echo "deb [signed-by=/usr/share/keyrings/plex-archive-keyring.gpg] https://downloads.plex.tv/repo/deb public main" | sudo tee /etc/apt/sources.list.d/plexmediaserver.list
    ```

### 3\. Instalación de Plex Media Server

Ahora que tenemos el repositorio, actualizamos la lista de paquetes e instalamos el servicio.

```bash
sudo apt update
sudo apt install plexmediaserver -y
```

### 4\. Verificación del Servicio

[cite\_start]Vamos a comprobar que Plex se ha levantado correctamente, tal como se hacía en el paso de verificación de tu manual[cite: 76].

```bash
sudo systemctl status plexmediaserver
```

Deberías ver un estado en verde que dice **`active (running)`**. Si no está arrancado, usa:

```bash
sudo systemctl enable --now plexmediaserver
```

### 5\. Configuración del Firewall (Opcional pero recomendado)

Si tienes el firewall `ufw` activado en Ubuntu, necesitas permitir el tráfico. Plex usa varios puertos, pero el principal es el 32400.

```bash
sudo ufw allow 32400/tcp
sudo ufw reload
```

### 6\. Configuración Inicial vía Web

Aquí es donde cambia el puerto respecto a tu manual. [cite\_start]Jellyfin usa el 8096[cite: 115], pero **Plex usa el 32400**.

1.  Abre Firefox o tu navegador en la máquina virtual.
2.  Ingresa a la siguiente dirección:
    `http://localhost:32400/web`
3.  Tendrás que iniciar sesión con una cuenta de Plex (Google, Facebook, Email). A diferencia de Jellyfin, Plex requiere una cuenta centralizada para funcionar bien.
4.  Sigue el asistente de configuración ("Wizard") para darle nombre a tu servidor.

### 7\. Permisos y Carpetas (Punto Crítico)

[cite\_start]En tu manual de Jellyfin, se movían los archivos a `/var/lib/jellyfin` o se cambiaban los propietarios con `chown`[cite: 388, 390]. **En Plex esto es vital**, ya que el usuario `plex` no tiene permiso para leer tus carpetas personales (como `/home/tu_usuario/Videos`) por defecto.

Tienes dos opciones:

**Opción A (Recomendada para principiantes - Estilo de tu manual):**
Crear una carpeta específica donde Plex tenga control total y mover allí las películas.

```bash
# Crear directorio para películas
sudo mkdir -p /opt/plexmedia/peliculas

# Cambiar el dueño al usuario 'plex'
sudo chown -R plex:plex /opt/plexmedia

# Mover tu video (ejemplo)
sudo mv /home/tu_usuario/Descargas/video.mp4 /opt/plexmedia/peliculas/
```

### 8\. Crear la Biblioteca

1.  En la interfaz web de Plex (`http://localhost:32400/web`).
2.  Ve a **Añadir Biblioteca** (Add Library).
3.  Selecciona **Películas**.
4.  Busca la carpeta que creamos en el paso anterior (ej. `/opt/plexmedia/peliculas`).
5.  Haz clic en **Añadir Biblioteca**.

### Resumen de diferencias clave con tu documento:

| Característica | Jellyfin (Tu PDF) | Plex (Instrucciones nuevas) |
| :--- | :--- | :--- |
| **Puerto Web** | [cite\_start]8096 [cite: 132] | 32400 |
| **Cuenta** | [cite\_start]Local (creada en el wizard) [cite: 147] | Requiere cuenta de Plex.tv |
| **Privacidad** | [cite\_start]Totalmente privado [cite: 11] | Recopila datos de uso (ajustable) |
| **Apps** | [cite\_start]Gratis (Open Source) [cite: 431] | App móvil requiere pago único (Plex Pass) |

¿Te gustaría que te explique cómo configurar la IP estática en Ubuntu 24.04 para que no cambie al reiniciar, tal como se muestra en la página 5 de tu memoria?