# 1
find /var/log -type f -printf "%s %p\n" | sort -nr | head -n 10 | sed 's/^[0-9]\+ //' | tr '\n' ';' | sed 's/;$//' > archivos_grandes.txt
find /var/log -type f -printf "%s %f\n" | sort -nr | head -n 10 | sed 's/^[0-9]\+ //' | tr '\n' ';' | sed 's/;$//' > archivos_grandes.txt
# ls -ls /var/log | tr -s ' ' | sort -rk 6 -n | cut -d' ' -f6 | head -n 10

# 2
ip a | grep -oP '(\d{1,3}[.]){3}\d{1,3}/\d{1,3}' > ~/ip.txt
ip a | grep -oP '(\d{1,3}[.]){3}\d{1,3}' | grep -v "127.0.0.1" | grep -v ".*[.].*[.].*[.]255" > ~/ip.txt
ip a | grep "inet " | grep -v "127.0.0.1" | sed 's/^ *inet //' | cut -d' ' -f1 | cut -d'/' -f1 | head -n 1 > ip.txt

#3
cat /etc/passwd | grep -P ":[1-9][0-9]{3,}:\d{3,}:" | grep -v ":65534:" | cut -d: -f1 | tee /dev/tty | wc -l
# cat /etc/passwd | grep -E ":[1-9][0-9]{3,}:" | cut -d: -f1 | tee /dev/tty | wc -l

#4
mkdir TEMPORAL
cp -R /etc TEMPORAL
mkdir TEMPORAL && cp -r /etc TEMPORAL/

#5
# tar -cfrut empaquetado.tar TEMPORAL
ln -s empaquetado.tar enlace_debil
tar -cvf empaquetado.tar TEMPORAL/etc
tar -cf empaquetado.tar TEMPORAL/etc
ln -s empaquetado.tar enlace_blando


#6
bzip2 -k empaquetado.tar

#7
tar -tjf empaquetado.tar.bz2 | wc -l

#8
find . -type f -mtime 0 -printf "%f\t\t%s\t\t%Tc\n"

#9
rm -Rf TEMPORAL