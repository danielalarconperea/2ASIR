

0 12  10 12 *   root    rm -rf /TMP/*

*/10 *  * * *   root    rm -rf $HOME/viejo && mv $HOME/nuevo $HOME/viejo && mkdir $HOME/nuevo

* 11    * * *   root    mkdir $HOME/dir_auto_$(date +\%M)

*  *    * * *   root    echo $(date +\%H-\%M-\%S) >> $HOME/cron.log

@reboot echo "Sistema Reiniciado" >> $HOME/cron.log

0  *    * * *   root    echo 'NUEVA HORA' >> $HOME/cron.log

0,30 8-15 * * 1,3,5     root    mv $HOME/cron.log $HOME/cron_$(date +\%d-\%m-\%Y_\%H-\%M-\%S)   



/home/daja/mi_crontab_sudo
crontab /home/daja/mi_crontab_sudo

/home/daja/mi_crontab_user
crontab /home/daja/mi_crontab_user


0 12  10 12 *    rm -rf /tmp/*

*/10 *  * * *    rm -rf $HOME/viejo && mv $HOME/nuevo $HOME/viejo && mkdir $HOME/nuevo

* 11    * * *    mkdir $HOME/dir_auto_$(date +\%M)

*  *    * * *    echo $(date +\%H-\%M-\%S) >> $HOME/cron.log

@reboot echo "Sistema Reiniciado" >> /home/daja/cron.log

0  *    * * *    echo 'NUEVA HORA' >> $HOME/cron.log

0,30 8-15 * * 1,3,5 mv $HOME/cron.log $HOME/cron_$(date +\%d-\%m-\%Y_\%H-\%M-\%S)   



sudo nano /etc/cron.allow
 root
 daja
 juan


sudo nano /etc/anacrontab
 # periodo  retraso  id_trabajo  comando
 7          15       borrar_escritorio   rm -rf /home/maria/Desktop/*

# Primero ejecutamos anacron una vez para que cree el registro (o lo creamos a mano)
sudo anacron -n

# Modificamos la fecha del timestamp (restamos 8 días para asegurar que toque ya)
# Suponiendo que el ID del trabajo en anacrontab es "borrar_escritorio"
sudo sed -i "s/^$(date +\%Y\%m\%d)/20250101/" /var/spool/anacron/borrar_escritorio
# Nota: O simplemente edita el fichero con nano y pon una fecha vieja (YYYYMMDD).

sudo systemctl restart apache2 | at 12:00


sudo nano /home/daja/comandos.sh
#!/bin/bash

apt-get update

apt-get upgrade -y

apt-get autoremove -y
apt-get clean

# 4. Registrar que se hizo la limpieza
echo "Mantenimiento realizado el $(date)" >> /var/log/mantenimiento_boot.log

sudo chmod +x /home/daja/comandos.sh

crontab -e

@reboot /home/daja/comandos.sh




sudo nano /etc/at.deny
 juan


echo "Script iniciado tras reboot el: $(date)" >> /home/daja/test_ejecucion.log