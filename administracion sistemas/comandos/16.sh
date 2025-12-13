grep root /etc/group
getent group root

groupadd -g 1005 research
grep research /etc/group
groupadd development
grep development /etc/group

groupadd -r sales
getent group sales
ls -l index.html
groupmod -n clerks sales
ls -l index.html
groupmod -g 10003 clerks
ls -l index.html
find / -nogroup 

groupdel clerks

useradd -D 
useradd -D -f 30
useradd -D 

grep -Ev '^#|^$' /etc/login.defs

useradd jane
useradd -u 1000 jane
useradd -g users jane
useradd -G sales,research jane
useradd jane
grep '/home/jane' /etc/passwd
useradd -m jane
ls -ld /home/jane  

useradd -mb /test jane
ls -ld /test/Jane

useradd -md /test/jane jane
ls -ld /test/jane

useradd -mk /home/sysadmin jane
ls /home/jane

useradd -s /bin/bash jane

useradd -u 1009 -g users -G sales,research -m -c 'Jane Doe' jane 
grep jane /etc/passwd
grep jane /etc/shadow
grep jane /etc/group
grep jane /etc/gshadow

ls /var/spool/mail

ls /home

passwd Jane

chage -M 60 jane

grep jane /etc/shadow | cut -d: -f1,5

usermod -aG development jane

userdel jane
userdel -r jane