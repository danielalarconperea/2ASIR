# Shell Script Básicos

# Realiza los siguientes scripts sin parámetros:

# 1. Haz que los scripts puestos en la carpeta ejercicios de tu directorio de conexión se puedan ejecutar desde cualquier ruta sin indicar el directorio. (añadir PATH a .basrc)

mkdir ejercicios

nano ~/.bashrc
export PATH=$PATH:~/ejercicios

#!/bin/bash


# 2. usuarios.sh: Que nos muestre la lista de usuarios que no sean del sistema
# 3. quiensoy.sh: Que nos muestre el usuario que lo está ejecutando, su directorio de conexión y los datos referentes a fecha de caducidad de la contraseña y del usuario.
# 4. dimecron.sh: Que nos muestre las configuraciones activas del cron (sin comentarios)
# 5. numusu.sh: Que muestre cuantos usuarios hay conectados en el sistema
# 6. masmemoria.sh: Muestre los 3 procesos que más consumen memoria en el sistema.
# 7. modi_cron.sh: Que muestre cuantas veces se ha modificado el cron desde que se inicio el sistema y las fechas y horas de dichas modificaciones.

# Realiza los siguientes scripts utilizando parámetros por teclado:

# 8. hola.sh: Pide un nombre de usuario y muestra un mensaje de saludo para él.
# 9. calc.sh: Pide dos números y muestra el resultado de las 4 operaciones básicas
# 10. tama_dir.sh: Pide el nombre de un usuario y muestre en pantalla el tamaño del directorio de conexión de este
# 11. grupos_usu.sh: Pide el nombre de un usuario y muestre los grupos a los que pertenece (uno en cada línea)
# 12. usu_grupo.sh: Pide el nombre de un grupo y muestre los usuarios que pertenecen a ese grupo (separados por punto y coma)
# 13. nuevos.sh: Pida un día muestre los ficheros con fecha superior a ese día
# 14. cron_usuario.sh: pida un usuario y muestre su crontab.

# Realiza los siguientes scripts utilizando parámetros en la llamada:

# 15. Repite los ejemplos del bloque anterior pero con parámetros en la llamada.
# 16. pon_numeros.sh: Recoja un nombre de fichero y añada una numeración a las líneas de dicho fichero
# 17. busca_fichero.sh: Recoja un nombre de un fichero y lo busque en el sistema.
# 18. ejecutar.sh: que recoja un nombre de fichero y le añada permisos de ejecución.