top
free
mount 
umount

ls /proc
su -
cat /proc/sys/net/ipv4/icmp_echo_ignore_all
ping -c1 localhost
sudo echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all
ping -c1 localhost

pstree
ps
ps --forest
ps aux | head
ps -ef | head
ps -ef | grep firefox
ps -u root

top
cat /proc/loadavg

free
free -s 10
free -m
free -g

top 
kill

journalctl 
file /var/log/wtmp
lastb

dmesg | grep -i usb

dpkg -L packagename
rpm -ql packagename



ps 
ps x 
ps xr 
ps -ef 
ps --forest x 
pstree 
ps -u daniel
ps u U daniel
echo Me voy a dormir; sleep 20; echo Buenos días 
echo Me voy a dormir& sleep 20& echo Buenos días& 
jobs 
fg %1
kill %3
sleep 5 & 
sleep 500 
bg 1 
fg 1 
top 
uptime 
free 
gnome-system-monitor 
ksysguard