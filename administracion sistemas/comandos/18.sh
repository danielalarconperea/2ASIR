more /etc/shadow /etc/shadow
# Permission denied 
ls -l /etc/shadow 
# -rw-r-----. 1 root root 5195 Oct 21 19:57 /etc/shadow 
ls -l /usr/bin/passwd 
# -rwsr-xr-x 1 root root 31768 Jan 28 2010 /usr/bin/passwd 
chmod u+s file 
chmod 4775 file 
chmod u-s file 
chmod 0775 file 


ls -l /usr/bin/wall 
# -rwxr-sr-x 1 root tty 30800 May 16 2018 /usr/bin/wall 
ls -l /dev/tty? 
# crw--w----. 1 root tty 4, 0 Mar 29 2013 /dev/tty0 
# crw--w----. 1 root tty 4, 1 Oct 21 19:57 /dev/tty1

ls -ld /tmp/data
# drwxrwsrwx. 2 root demo 4096 Oct 30 23:20 /tmp/data
# drwxrwsrwx. 2 root demo 4096 Oct 30 23:20 /tmp/data
# drwxrwSr-x. 2 root root 5036 Oct 30 23:22 /tmp/data2
id
# uid=500(sysadmin) gid=500(sysadmin)
# groups=500(sysadmin),10001(research),10002(development) 
# context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
touch /tmp/data/file.txt
ls -ld /tmp/data/file.txt
# -rw-rw-r--. 1 bob demo 0 Oct 30 23:21 /tmp/data/file.txt
# -rw-r-----. 1 bob payroll 100 Oct 30 23:21 /home/team/file.txt
# -rw-r-----. 1 bob team 100 Oct 30 23:21 /home/team/file.txt

chmod g+s <file|directory>
chmod 2775 <file|directory>
chmod g-s <file|directory>
chmod 0775 <file|directory>

ls -ld /tmp
# drwxrwxrwt 1 root root 4096 Mar 14 2016 /tmp
chmod o+t <directory>
chmod 1775 <file|directory>
chmod o-t <directory>
chmod 0775 <directory>

# /usr/share/doc/superbigsoftwarepackage/data/2013/october/tenth/valuable-information.txt

ls -i /tmp/file.txt
# 215220874 /tmp/file.txt
echo data > file.original
ls -li file.*
# 278772 -rw-rw-r--. 1 sysadmin sysadmin 5 Oct 25 15:42 file.original
ln target link_name
ln file.original file.hard.1
ls -li file.*
# 278772 -rw-rw-r--. 2 sysadmin sysadmin 5 Oct 25 15:53 file.hard.1
# 278772 -rw-rw-r--. 2 sysadmin sysadmin 5 Oct 25 15:53 file.original

ls -l /etc/grub.conf
# lrwxrwxrwx. 1 root root 22 Feb 15 2011 /etc/grub.conf -> ../boot/grub/grub.conf
ln -s target link_name
ln -s /etc/passwd mypasswd
ls -l mypasswd
# lrwxrwxrwx. 1 sysadmin sysadmin 11 Oct 31 13:17 mypasswd -> /etc/passwd


ls -l mytest.txt
# lrwxrwxrwx. 1 sysadmin sysadmin 8 Oct 31 13:29 mytest.txt -> test.txt
more test.txt
# hi there
more mytest.txt
# hi there
rm test.txt
more mytest.txt
# mytest.txt: No such file or directory
ls -l mytest.txt
# lrwxrwxrwx. 1 sysadmin sysadmin 8 Oct 31 13:29 mytest.txt -> test.txt
ls -i file.original
# 278772 file.original
find / -inum 278772 2> /dev/null
# /home/sysadmin/file.hard.1
# /home/sysadmin/file.original
ls -l mypasswd
lrwxrwxrwx. 1 sysadmin sysadmin 11 Oct 31 13:17 mypasswd -> /etc/passwd
ln /boot/vmlinuz-2.6.32-358.6.1.el6.i686 Linux.Kernel
# ln: creating hard link `Linux.Kernel' => `/boot/vmlinuz-2.6.32-358.6.1.el6.i686': Invalid cross-device link
ln -s /boot/vmlinuz-2.6.32-358.6.1.el6.i686 Linux.Kernel
ls -l Linux.Kernel
# lrwxrwxrwx. 1 sysadmin sysadmin 11 Oct 31 13:17 Linux.Kernel -> /boot/vmlinuz-2.6.32-358.6.1.el6.i686
ln /bin binary
# ln: `/bin': hard link not allowed for directory
ln -s /bin binary
ls -l binary
# lrwxrwxrwx. 1 sysadmin sysadmin 11 Oct 31 13:17 binary -> /bin