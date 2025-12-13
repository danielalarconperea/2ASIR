myorigin = $myhostname 
# mydestination = $myhostname localhost.localdomain localhost 
# mynetworks = 127.0.0.0/8 192.168.1.0/24 # relay_domains = $mydestination 


sudo apt update && sudo apt upgrade -y

sudo apt install postfix #

sudo nano /etc/postfix/main.cf

See /usr/share/postfix/main.cf.dist for a commented, more complete version # 

Debian specific: Specifying a file name will cause the first # 


line of that file to be used as the name.
# 

The Debian default is /etc/mailname.
# 
#myorigin = /etc/mailname # smtpd_banner = $myhostname ESMTP $mail_name (Debian/GNU) # biff = no # 



appending domain is the MUA's job.
# 
append_dot_mydomain = no # 

Uncomment the next line to generate "delayed mail" warnings # 

#delay_warning_time 4h # readme_directory = no # 


TLS parameters # 

smtpd_tls_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem # smtpd_tls_key_file=/etc/ssl/private/ssl-cert-snakeoil.key # smtpd_use_tls=yes # smtpd_tls_session_cache_database = btree:${data_directory}/smtpd_scache #  smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache # 




See /usr/share/doc/postfix/TLS_README.gz in the postfix-doc package for # 


information on enabling SSL in the smtp client.
# 
myhostname = mortadelo.tia.com # alias_maps = hash:/etc/aliases # alias_database = hash:/etc/aliases # myorigin = /etc/mailname # mydestination = $myhostname, localhost, localhost.localdomain # relayhost = # mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128 # mailbox_command = procmail -a "$EXTENSION" # mailbox_size_limit = 0 # recipient_delimiter = + # inet_interfaces = all # 





mail usuario # 

Subject: Asunto # 

Prueba de envío local # 

[CTRL-D] # 

Cc: # 

Salida log (/var/log/mail.log):
postfix/pickup [7199]: E8B8C34675: uid=0 from=<root> # 

postfix/cleanup [7295]: E8B8C34675: message-id=20081125104513.E8B8C34675@mortadelo # 

postfix/qmgr [7201]: E8B8C34675: from=root@mortadelo.tia.com, size=315, nrcpt 1 (queue active) # 

postfix/local [7297]: E8B8C34675: to=usuario@mortadelo.tia.com, orig_to=<usuario>, relay=local, delay=0.12, delays 0.04/0.02/0/0.06, dsn=2.0.0, status=sent (delivered to command: procmail -a "$EXTENSION") # 

postfix/qmgr [7201]: E8B8C34675: removed # 

tail -f /var/log/mail.log # 

Salida archivo correo (/var/mail/usuario):
N 1 root@localhost # 

Thu Nov 25 11:45 14/479 # 

Asunto # 

Salida log (Recepción externa):
postfix/smtpd [7402]: connect from mail-bw0-f20.google.com [209.85.218.20] # 

postfix/smtpd [7402]: F037834676: client-mail-bw0-f20.google.com [209.85.218.20] # 

postfix/cleanup [7407]: F037834676:message-id=d752a77a0812250308s15414d9vecc61628ed4fed03@mail.gmail.com # 

postfix/qmgr [7201]: F037834676: from=unacuenta@gmail.com, size=2136, nrcpt=1 (queue active) # 

postfix/local [7408]: F037834676: to=usuario@mortadelo.tia.com, relay=local, delay=0.42, delays 0.36/0.01/0/0.05, dsn=2.0.0, status=sent (delivered to command: procmail a "$EXTENSION") # 

postfix/qmgr [7201]: F037834676: removed # 

Salida log (Envío externo):
postfix/pickup [5933]: 7539434680: uid=1000 from=<alberto> # 

postfix/cleanup [5940]: 7539434680: message-id=20081231121556.7539434680@mortadelo # 

postfix/qmgr [5935]: 7539434680: from=alberto@mortadelo.tia.com, size=306, nrcpt=1 (queue active) # 

postfix/smtp [5942]: 7539434680: to unacuenta@gmail.com, delay=3.1, delays=0.04/0.06/1.7/1.3, dsn=2.0.0, status sent (250 2.0.0 OK 12307259715sm2551300eyf.47) # 

postfix/qmgr [5935]: 7539434680: removed # 

Salida log (Error IP dinámica):
postfix/pickup [6804]: 09B0634680: uid=1000 from=<alberto> # 

postfix/cleanup [6810]: 09B0634680:message-id=20081231154700.0980634680@mortadelo # 

postfix/qmgr [6802]: 09B0634680: from=alberto@mortadelo.tia.com, size=307, nrcpt 1 (queue active) # 

postfix/smtp [6812]: 09B0634680: to=una@hotmail.com, relay=mx2.hotmail.com[65.54.244.40]:25, delay=1.3, delays 0.03/0.04/0.92/0.3, dsn=5.0.0, status bounced ... # 

postfix/smtp[6812]: 09B0634680: lost connection with mx2.hotmail.com [65.54.244.40] while sending RCPT TO # 

relayhost = [smtp.gmail.com]:587 # smtp_use_tls = yes # smtp_tls_CAfile = /etc/postfix/cacert.pem # smtp_sasl_auth_enable = yes # smtp_sasl_password_maps = hash:/etc/postfix/sasl/passwd # smtp_sasl_security_options = noanonymous # 





/etc/postfix/sasl/passwd
[smtp.gmail.com]:587 unacuenta@gmail.com:unacontraseña # 

chmod 600 /etc/postfix/sasl/passwd # postmap /etc/postfix/sasl/passwd # cat /etc/ssl/certs/Thawte_Premium_Server_CA.pem >> /etc/postfix/cacert.pem # 



Salida log (Relay autenticado):
postfix/pickup [6703]: 6AFF534680: uid=1000 from=<alberto> # 

postfix/cleanup [6786]: 6AFF534680: message-id=20081231154524.6AFF534680@mortadelo # 

postfix/qmgr [5935]: 6AFF534680: from=alberto@mortadelo.tia.com, size=310, nrcpt=1 (queue active) # 

postfix/smtp [6788]: 6AFF534680:to=unacuenta@hotmail.com,relay=smtp.gmail.com[66.249.93.111]:587, delay=2.8, delays 0.04/0.02/1.2/1.6, dsn=2.0.0 status sent (250 2.0.0 OK 1230738538 34sm19633915ugh.10) # 

postfix/qmgr [5935]: 6AFF534680: removed # 

aptitude install dovecot-imapd # netstat -putan | grep dovecot # 


Salida netstat:
tcp 0 0 0.0.0.0:993 0.0.0.0:* LISTEN 4396/dovecot # 

tcp 0 0 0.0.0.0:143 0.0.0.0:* LISTEN 4396/dovecot # 

Salida log (IMAP):
dovecot: imap-login: Login: user=<usuario>, method=PLAIN, rip=127.0.0.1, lip=127.0.0.1, secured # 

dovecot: imap-login: Login: user=<usuario>, method=PLAIN, rip=127.0.0.1, lip=127.0.0.1, TLS # 

Salida netstat:
tcp 0 0 127.0.0.1:56049 127.0.0.1:993 ESTABLISHED 3443/evolution # 


aptitude install dovecot-pop3d # netstat -putan | grep dovecot # 


Salida netstat:
tcp 0 0 0.0.0.0:993 0.0.0.0:* LISTEN 4210/dovecot # 

tcp 0 0 0.0.0.0:995 0.0.0.0:* LISTEN 4210/dovecot # 

tcp 0 0 0.0.0.0:110 0.0.0.0:* LISTEN 4210/dovecot # 

tcp 0 0 0.0.0.0:143 0.0.0.0:* LISTEN 4210/dovecot # 

/etc/dovecot/dovecot.conf




protocols = imaps pop3s # 

apt-get install squirrelmail # /etc/init.d/apache2 restart # /etc/squirrelmail/conf.pl #