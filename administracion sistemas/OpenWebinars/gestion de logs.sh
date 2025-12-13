cat /etc/rsyslog.conf
ls -l /etc/rsyslog.d/
cat /etc/rsyslog.d/50-default.conf

cat /etc/logrotate.conf
ls -l /etc/logrotate.d/
cat /etc/logrotate.d/rsyslog

sudo nano /etc/rsyslog.d/10-cron-custom.conf
 # Fichero /etc/rsyslog.d/10-cron-custom.conf
 # 3.1: info o menor (debug, info)
 cron.<=info     /var/log/cron.info.log
 # 3.2: entre notice y err (notice, warning, err)
 cron.>=notice;cron.<=err     /var/log/cron.err.log
 # 4: Adicionalmente, warning en cron.warning.log
 # Esta regla no tiene un "stop" (~) por lo que 'warning'
 # también irá al fichero cron.err.log (cumpliendo 3.2)
 cron.=warn      /var/log/cron.warning.log
 # 3.3: El resto (crit, alert, emerg)
 cron.>=crit     /var/log/cron.emerg.log
 # 5: Desactiva el registro de cron en otros ficheros (syslog)
 # La tilde (~) descarta los mensajes de cron después de esto.
 cron.* ~
 #
 # O
 #
 # Sintaxis moderna (RainerScript) para los logs de cron
 # 3a: info o menor (prioridad 7-debug, 6-info)
 if $programname == 'cron' and $syslogpriority <= 6 then {
     action(type="omfile" file="/var/log/cron.info.log")
 }
 # 3d: Adicionalmente, warning (prioridad = 4)
 if $programname == 'cron' and $syslogpriority == 4 then {
     action(type="omfile" file="/var/log/cron.warning.log")
 }
 # 3b: entre notice y err (prioridad 5-notice, 4-warning, 3-err)
 if $programname == 'cron' and ($syslogpriority >= 3 and $syslogpriority <= 5) then {
     action(type="omfile" file="/var/log/cron.err.log")
 }
 # 3c: El resto (prioridad 2-crit, 1-alert, 0-emerg)
 if $programname == 'cron' and $syslogpriority <= 2 then {
     action(type="omfile" file="/var/log/cron.emerg.log")
 }
 # 3e: Desactiva el registro de cron en otros ficheros
 # Esto reemplaza a la tilde (~) y usa el 'stop' recomendado
 if $programname == 'cron' then {
     stop
 }


# a. Info o menor (Info y Debug)
cron.=info;cron.=debug      /var/log/cron.info.log

# b. Entre notice y err (Notice, Warning, Error)
# Lógica: Todo lo que sea notice o superior, PERO ignorando critico o superior.
cron.notice;cron.!crit      /var/log/cron.err.log

# c. El resto (Crit, Alert, Emerg)
cron.crit                   /var/log/cron.emerg.log

# d. Adicionalmente Warning en su propio fichero
cron.=warning               /var/log/cron.warning.log
sudo systemctl restart rsyslog

logger -t cron -p cron.info "Mensaje de prueba INFO"
tail /var/log/cron.info.log
tail /var/log/syslog
logger -t cron -p cron.notice "Mensaje de prueba NOTICE"
tail /var/log/cron.err.log
logger -t cron -p cron.warn "Mensaje de prueba WARNING"
tail /var/log/cron.err.log
tail /var/log/cron.warning.log
logger -t cron -p cron.err "Mensaje de prueba ERROR"
tail /var/log/cron.err.log
logger -t cron -p cron.emerg "Mensaje de prueba EMERGENCIA"
tail /var/log/cron.emerg.log


/var/log/cron.info.log
/var/log/cron.err.log
/var/log/cron.emerg.log
/var/log/cron.warning.log
{
    rotate 10           # Guardar ultimos 10 ficheros
    weekly              # Rotar cada 7 días
    missingok           # No dar error si falta el archivo
    notifempty          # No rotar si está vacío
    nocompress          # Sin comprimir (punto g)
    dateext             # (Punto h) Añade la fecha al nombre del archivo rotado
                        # (ej. cron.info.log-20231123), guardando "copia del día anterior"
    copytruncate 
    sharedscripts
    postrotate
        /usr/lib/rsyslog/rsyslog-rotate
    endscript
}



sudo nano /etc/logrotate.d/cron-custom
 /var/log/cron.info.log
 /var/log/cron.err.log
 /var/log/cron.warning.log
 /var/log/cron.emerg.log {
     weekly          # 8: Rotado cada 7 días (semanal)
     nocompress      # 8: Sin comprimir
     rotate 10       # 8: Guardar los últimos 10
     copytruncate    # 9: Guarda copia y trunca el original (para que rsyslog siga escribiendo)
     missingok       # No da error si falta un fichero
     notifempty }     # No rota si el fichero está vacío
sudo logrotate -d /etc/logrotate.conf
sudo logrotate -f /etc/logrotate.conf

sudo nano /etc/rsyslog.d/70-local-alerts.conf
 # 10.1: local1 a todos los terminales
 local1.* *
 # 10.2: local2 a un usuario específico (ej: pepe)
 local2.* :omusrmsg:pepe
sudo systemctl restart rsyslog

# Esto debe aparecer en TODOS los terminales
logger -p local1.warn "MENSAJE PARA TODOS"
# Esto debe aparecer SÓLO en los terminales de 'pepe'
logger -p local2.warn "MENSAJE PRIVADO PARA PEPE"
sudo nano /etc/rsyslog.conf
module(load="imudp")
input(type="imudp" port="514")
sudo nano /etc/rsyslog.d/60-remote.conf
# 11.1: Guardar logs de local5
local5.* /var/log/remote-local5.log
sudo systemctl restart rsyslog
sudo ufw allow 514/udp
# o si usas firewalld (CentOS/RHEL):
# sudo firewall-cmd --add-port=514/udp --permanent
# sudo firewall-cmd --reload
sudo nano /etc/rsyslog.d/99-send-remote.conf
# 11.2: Enviar local5 al servidor (la @ simple es para UDP)
local5.* @IP_DEL_SERVIDOR:514
sudo systemctl restart rsyslog
tail -f /var/log/remote-local5.log
logger -p local5.info "PRUEBA DE LOG REMOTO DESDE EL CLIENTE"
last reboot | head -n 5
# Salida de ejemplo:
# reboot   system boot  5.15.0-50-gener Thu Oct 20 10:30
last reboot | head -n 5 | awk '{print $4, $5, $6, $7}'
journalctl -u cron.service --since "30 days ago" --until "29 days ago"
journalctl -k -u mysql.service --since "today 08:00" --until "today 12:00" -p info -o json-pretty
systemctl list-units | grep mysql

sudo journalctl -u mysql -p info --since "2025-11-23 08:00" --until "2025-11-23 12:00" -o json-pretty

sudo journalctl -u mysql -p info --since "5 minutes ago" -o json-pretty







sudo journalctl -u mysql + _TRANSPORT=kernel -p info --since "2025-11-23 08:00" --until "2025-11-23 12:00" -o json-pretty
sudo journalctl -u mysql -p info --since "2025-11-23 08:00" --until "2025-11-23 12:00" -o json-pretty
sudo journalctl -k -p info --since "2025-11-23 08:00" --until "2025-11-23 12:00" -o json-pretty
sudo journalctl -u mysql + -k -p info --since "2025-11-23 08:00" --until "2025-11-23 12:00" -o json-pretty
sudo journalctl -u mysql + -k -p info --since "2025-11-23 08:00" --until "2025-11-23 12:00" -o json-pretty

 
