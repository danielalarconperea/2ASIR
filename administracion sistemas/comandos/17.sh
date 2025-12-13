id
touch /tmp/filetest1
ls -l /tmp/filetest1
ls -la 

groups
id
newgrp research
id

touch /tmp/filetest2
ls -l /tmp/filetest2

id
exit
id

touch sample
ls -l sample
chgrp research sample
ls -l sample 

chgrp development /etc/passwd
chgrp -R development test_dir
stat /tmp/filetest1

chown jane /tmp/filetest1
ls -l /tmp/filetest1

chown jane:users /tmp/filetest2
ls -l /tmp/filetest2

chown .users /tmp/filetest1
ls -l /tmp/filetest1

ls -l /etc/passwd


touch abc.txt
ls -l abc.txt

chmod g+w abc.txt
ls -l abc.txt  

chmod ug+x,o-r abc.txt
ls -l abc.txt

chmod u=rx abc.txt
ls -l abc.txt 

chmod 754 abc.txt
ls -l abc.txt

stat /tmp/filetest1


umask

umask 027
touch sample
ls -l sample

umask 027
mkdir test-dir
ls -ld test-dir