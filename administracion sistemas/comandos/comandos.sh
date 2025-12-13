sudo apt install bzip2

tar -cf bin.tar /bin/*

tar -czf bin.gz /bin/*

sudo reboot now

zip -r bin.zip /bin

ls -lh

tar -czfr bin.gz /bin/*

tar -czf bin.gz /bin/

touch uno.txt

ls

touch uno.txt dos.txt tres.txt

zip -u bin.zip *.txt

zip -d bin.zip "bin/p*"

unzip -l bin.zip

unzip -Z -1 bin.zip | grep '^bin/..n'

tar -tf bin.tar | grep '^bin/..n'

mkdir bin_copia

unzip bin.zip -d bin_copia/

split -n 10 -d bin.tar parte_

cat parte_* > bin_unido.tar

md5sum bin.tar bin_unido.tar

ls -l

ls -l binz.gz

ls -l /usr/share/dict/spanish

sudo ls -l /usr/share/dict/spanish

cd /usr/share/dict/spanish

cd /usr/share/dict/

dir

cd ~

ls -l /usr/share/dict/american-english

ln binz.gz compr_duro

ln -s /usr/share/dict/american-english diccionario

ls -l binz.gz compr_duro

ls -l binz.gz compr_duro /usr/share/dict/american-english diccionario

ls -li binz.gz compr_duro /usr/share/dict/american-english diccionario

head -n 5 diccionario > primeras.txt

tail -n 5 diccionario > ultimas.txt

paste -d ';' primeras.txt ultimas.txt

paste -s -d '-' primeras.txt ultimas.txt > unidas_b.txt

cat unidas_b.txt

cat unidas_b.txt | tr 'a-zA-Z' 'f-za-eF-ZA-E'

cat encriptado.txt

cat encriptado.txt | tr 'f-za-eF-ZA-E' 'a-zA-Z'

cat desencriptado.txt

diff unidas_b.txt desencriptado.txt

sudo poweroff now

sudo poweroff

cd Downloads/

cat codigos.txt

ls Downloads/

mv Downloads/codigos.txt ~

ls -l | sort -k 6

ls -l | sort -k 5

ls -l | sort -k 7

ls -l | sort -k 7n

ls -l | sort -k 6M

ls -l | sort -k 6M | nl | tail -n +5

ls -l | sort -k 6M | nl | tail

ls -l | sort -k 6M | nl | tail -n 5

ls -l | tr ' ' ';'

ls -l | tr ' .' ';'

ls -l | tr -s ' ' ';'

ls -l | sed 's/ ./;/g'

ls -l | sed 's/ .*/;/g'

ls -l | sed 's/ */;/g'

ls -l | sed 's/ /;/g'

ls -l | sed 's/ +;/g'

ls -l | sed -E 's/ +/;/g'

ls -l | sed -E 's/ ./;/g'

ls -l | sed -E 's/ */;/g'

ls -l | sed -E 's/ /;/g'

ls -l | sed -E 's/ +/;/g' > archivos.txt

cat archivos.txt

man paste

ls -l | cut -d' ' -f6 | uniq | grep . | paste -s -d ';'

ls -l | uniq | grep . | paste -s -d ';'

ls -l /bin/ | cut -d' ' -f6 | uniq | grep . | paste -s -d ';'

ls -l /bin/ | grep . | paste -s -d ';'

ls -l /bin/ | uniq | grep . | paste -s -d ';'

ls -l /bin/ | tr -s ' ' | cut -d' ' -f6 | uniq | grep . | paste -s -d ';'

ls -l /bin/ | tr -s ' ' | cut -d' ' -f6 | sort | uniq | grep . | paste -s -d ';'

ls -l /bin/ | tr -s ' ' | cut -d' ' -f6 | sort | uniq | paste -s -d ';'

ls -l /bin/ | tr -s ' ' | cut -d' ' -f6 | sort | paste -s -d ';'

ls -l | tr -s ' ' | cut -d' ' -f6 | sort | uniq | paste -s -d ';'

ls -l | tr -s ' ' | cut -d' ' -f6 | sort | uniq | paste -s -d ';' > meses.txt

cat diccionario

ls diccionario

ls -l diccionario

grep '*asir*' diccionario

grep 'asir' diccionario

grep "asir" diccionario

grep '^zi' diccionario

grep '$aso' diccionario

grep 'aso$' diccionario

grep '[eiou]z'

grep '[eiou]z' diccionario

grep '[!a]z' diccionario

grep '![a]z' diccionario

grep -E '[!a]z' diccionario

grep -E '![a]z' diccionario

grep '[!aeiou]z'

grep '[!aeiou]z' diccionario

grep '![aeiou]z' diccionario

grep '[a-u]z' diccionario

grep '[^aeiou]z' diccionario

grep '[aeiou]x[aeiou]' diccionario

grep '[aeiou]{2}' diccionario

grep '[aeiou]{2,}' diccionario

grep '*[aeiou]{2,}*' diccionario

grep -E '[aeiou]{2}' diccionario

grep '^ax$' diccionario

grep '^a*x$' diccionario

grep '^a.*x$' diccionario

grep '^z.*r.*s$' diccionario

grep -E '[aeiou]{3}' diccionario

grep '(tro|bro).*[^aeiou]$' diccionario

grep 'crub+' diccionario

grep '(cru)b+' diccionario

grep 'cru(b)+' diccionario

grep 'cru[b]+' diccionario

grep '^[^aeiou]z' diccionario

grep '^[^AEIOU]z' diccionario

grep '^[^aeiouAEIOU]z' diccionario

grep "cru.*b" diccionario.txt

grep "cru.*b" diccionario

grep "crub*" diccionario

grep "crub+" diccionario

grep -E "crub+" diccionario

grep "\d" codigos.txt

grep -E "\d" codigos.txt

grep -E "\d{8}" codigos.txt

grep -E "^\d{8}$" codigos.txt

grep -E "^ [0-9]{8}$" codigos.txt

grep -E "^[0-9]{8}$" codigos.txt

grep -E '^\d{8}$' codigos.txt

grep -E '^[0-9]{8}$' codigos.txt

cat -A codigos.txt

grep -E "^[0-9]{8}\r?$" codigos.txt

grep -E "^[0-9]{8}\r$" codigos.txt

nano codigos.txt

grep -P "^[0-9]{8}\r?$" codigos.txt

grep -P "^[0-9]{8}$" codigos.txt

sudo apt install dos2unix

dos2unix codigos.txt

cat codigos.txt

grep -E "^\d{4}[A-Z]{3}$" codigos.txt

grep -P "^\d{8}$" codigos.txt

grep -P "^\d{4}[A-Z]{3}$" codigos.txt

grep -P "^\d{4}[A-Z]{3}$" codigos.txt | grep -v "[AEIOU]"

grep -P "^\d{8}[A-Z]$" codigos.txt | grep -v "[AEIOU]"

grep -P "^\d{2}[ ].*$" codigos.txt

grep -P "\d{2}[ ].*$" codigos.txt

grep -P "^ES\d{2}[ ]\d{4}[ ]\d{4}[ ]\d{4}[ ]\d{4}[ ]\d{4}$" codigos.txt

grep -P "^\d{3}[.]\d{3}[.]\d{3}[.]\d{3}$" codigos.txt

grep -P "^\d{3}[\.]\d{3}[\.]\d{3}[\.]\d{3}$" codigos.txt

grep -P "^\d{3}[.]\d{3}[.]\d{3}[.]\d{3}.*$" codigos.txt

grep -P "^.*\d{3}[.]\d{3}[.]\d{3}[.]\d{3}.*$" codigos.txt

grep -P "^\d{1,3}[.]\d{1,3}[.]\d{1,3}[.]\d{1,3}$" codigos.txt

grep -P "^(\d{1,3}[.]){3}\d{1,3}$" codigos.txt

grep -P "^ES\d{2}([ ]\d{4}){4}$" codigos.txt

grep -P "^ES\d{2}([ ]\d{4}){5}$" codigos.txt

ls -l /var/log

ls -l /var/log | sort

man sort

man sed

poweroff

echo -n "Escribe tu nombre: " ; read nombre

read asdf

read

echo -e "Línea 1\nLínea 2\t¡Tabulada!"

echo "Hoooolaaaaa" | tr -s "ol"

echo "Hoooolaaaaa" | tr -s "oa"

sudo echo "Hoooolaaaaa" | tr -s "oa"

history

ls -l /var/log | tr -d ' '

ls -l /var/log | tr -d ' ' | sort -k 6M

ls -l /var/log | tr -d ' +' | sort -k 6M

man ls

ls -ls /var/log | tr -d ' ' | sort -k 6M

ls -ls /var/log | sort -k 6M

ls -ls /var/log | sort -k 5M

ls -ls /var/log | sort -k 2M

ls -ls /var/log | sort -k 1M

ls -ls /var/log | sort -k 1

ls -ls /var/log | sort -k 2

ls -ls /var/log | sort -k 4

ls -ls /var/log | sort -k 5

ls -ls /var/log | sort -k 6

ls -ls /var/log | sort -k 7

ls -ls /var/log | sort -k 8

ls -ls /var/log | sort -k 3

ls -ls /var/log | sort -kn 6

ls -ls /var/log | sort -k 6 -n

ls -ls /var/log | tr -d ' ' ';'

ls -ls /var/log | tr -d ' ' | sort -k 6 -n

ls -ls /var/log | tr -sd ' ' ';' | sort -k 6 -n

ls -ls /var/log | sed -s 's/ */;/g' | sort -k 6 -n

ls -ls /var/log | sed -s 's/ +/;/g' | sort -k 6 -n

ls -ls /var/log | sed -Es 's/ +/;/g' | sort -k 6 -n

ls -ls /var/log | sed -Es 's/ +/;/g' | sort -kr 6 -n

ls -ls /var/log | sed -Es 's/ +/;/g' | sort -r -k 6 -n

man cut

history | grep 'cut'

ls -ls /var/log | sed -Es 's/ +/;/g' | cut -d; -f6 | head -n 10

ls -ls /var/log | tr -s ' ' | cut -d; -f6 | head -n 10

ls -ls /var/log | tr -s ' ' | cut -d' ' -f6 | head -n 10

ls -ls /var/log | tr -s ' ' | head -n 10

ls -ls /var/log | tr -s ' ' | cut -d' ' -f7 | head -n 10

find /var/log -type f -printf "%s %p\n" | sort -nr | head -n 10 | sed 's/^[0-9]\+ //' | tr '\n' ';' | sed 's/;$//' > archivos_grandes.txt

sudo find /var/log -type f -printf "%s %p\n" | sort -nr | head -n 10 | sed 's/^[0-9]\+ //' | tr '\n' ';' | sed 's/;$//' > archivos_grandes.txt

cat archivos_grandes.txt

man find

sudo find /var/log -type f -printf "%s %f\n" | sort -nr | head -n 10 | sed 's/^[0-9]\+ //' | tr '\n' ';' | sed 's/;$//' > archivos_grandes.txt

ip a

ip a | grep -P '([0-9]{1-3}\.){3}[0-9]{1-3}'

ip a | grep -P '(\d{1-3}[.]){3}\d{1-3}'

ip a | grep -P "(\d{1-3}[.]){3}\d{1-3}"

ip a | grep -P ".*"

ip a | grep -P "(\d{1,3}[.]){3}\d{1,3}"

ip a | grep -P "(\d{1,3}[.]){3}\d{1,3}[/]\d{1,3}"

ip a | sed -P "s/(\d{1,3}[.]){3}\d{1,3}\/\d{1,3}//g"

ip a | grep -oP '(\d{1,3}[.]){3}\d{1,3}/\d{1,3}'

ip a | grep -oP '(\d{1,3}[.]){3}\d{1,3}/\d{1,3}' > ~/ip.txt

cat ip.txt

ip a | grep "inet " | grep -v "127.0.0.1" | sed 's/^ *inet //' | cut -d' ' -f1 | cut -d'/' -f1 | head -n 1

ip a | grep "inet "

ip a | grep "inet " | grep -v "127.0.0.1" | sed 's/^ *inet //'

ip a | grep "inet " | grep -v "127.0.0.1" | sed 's/^ *inet //' | cut -d' ' -f1

ip a | grep -oP '(\d{1,3}[.]){3}\d{1,3}' | grep -v "127.0.0.1"

ip a | grep "inet " | grep -oP '(\d{1,3}[.]){3}\d{1,3}' | grep -v "127.0.0.1"

ip a | grep -oP '(\d{1,3}[.]){3}\d{1,3}' | grep -v "127.0.0.1" | grep -v ".*[.].*[.].*[.]255"

users

cat /etc/passwd

cat /etc/passwd | grep -E ":[1-9][0-9]{3,}:" | cut -d: -f1 | tee /dev/tty | wc -l

cat /etc/passwd | grep -E ":[1-9][0-9]{3,}:"

cat /etc/passwd | grep -E ":[1-9][0-9]{3,}:" | cut -d: -f1

cat /etc/passwd | grep -E ":[1-9][0-9]{3,}:" | cut -d: -f1 | tee /dev/tty

cat /dev/tty

cat /etc/passwd | grep -E ":[1-9][0-9]{3,}:\d{3,}:" | cut -d: -f1 | tee /dev/tty | wc -l

cat /etc/passwd | grep -E ":[1-9][0-9]{3,}:\d{3,}:"

cat /etc/passwd | grep -P ":[1-9][0-9]{3,}:\d{3,}:"

cat /etc/passwd | grep -P ":[1-9][0-9]{3,}:\d{3,}:" | grep -v ":65534:"

cat /etc/passwd | grep -P ":[1-9][0-9]{3,}:\d{3,}:" | grep -v ":65534:" | cut -d: -f1 | tee /dev/tty | wc -l

mkdir TEMPORAL

man cp

cp -R /etc TEMPORAL

ls TEMPORAL

ls -r TEMPORAL

ls -R TEMPORAL

man tar

cat empaquetado.tar

tar -cf empaquetado.tar TEMPORAL

tar -cfr empaquetado.tar TEMPORAL

tar -cfru empaquetado.tar TEMPORAL

man ln

ln -s empaquetado.tar enlace_debil

ls -li

bzip2 -k empaquetado.tar

man wc

tar -tjf empaquetado.tar.bz2 | wc -l

tar -tjf empaquetado.tar.bz2

tar -fjt empaquetado.tar.bz2 | wc -l

tar -tfj empaquetado.tar.bz2 | wc -l

echo -e "Nombre\t\tTamaño\tFecha"

find . -type f -mtime 0 -printf "%f\t\t%s\t%Tc\n"

find ~ -type f -mtime 0 -printf "%f\t\t%s\t%Tc\n"

find . -type f -mtime 0 -printf "%f\t\t\t\t%s\t%Tc\n"

find . -type f -mtime 0 -printf "%f\t\t\t\t%s\t%Tc\n\n"

find . -type f -mtime 0 -printf "%f\t\t\t\t%s\t\t\t\t%Tc\n\n"

find . -type f -mtime 0 -printf "%f\t\t%s\t\t%Tc\n\n"

find . -type f -mtime 0 -printf "%f\t\t%s\t\t%tc\n\n"

find . -type f -mtime 0 -printf "%f\t\t%s\t\t%tc\n" | head

find . -type f -mtime 0 -printf "%f\t\t%s\t\t%Tc\n" | head

find . -type f -mtime 0 -printf "%f\t\t%s\t\t%TK\n" | head

find . -type f -mtime 0 -printf "%f\t\t%s\t\t%Tk\n" | head

find . -type f -mtime 0 -printf "%f\t\t%s\t\t%Ta\n" | head

rm -R TEMPORAL

man rm

rm -Rf TEMPORAL




ls -l | sort k 6M 


ls -l | nl | tail -n +5 


ls -l | tr -s 


ls -l | sed -E 's/+/;/g' 


ls -l | sed -E 's/+/;/g' > archivos.txt 


cat archivos.txt 


ls-1tr-s cut -d' -f6 sort uniq pastes-d' '> meses.txt 


ls -l/bin/tr s 


grep 'asir' diccionario 


grep '^zi' diccionario 


grep 'asos' diccionario 


grep '[eiou]z' diccionario 


grep '^[^aeiouAEIOU]z' diccionario 


grep '[aeiou]x[aeiou]' diccionario 


grep -E '[aeiou]{2}' diccionario 


grep '^a.*x$' diccionario 


grep '^z.*r.*s$' diccionario 


grep -E '[aeiou] 3}' diccionario 


grep -E (trolbro).*[^aeiou]\$' diccionario 


grep "cru.*b" diccionario 


grep -E $"[\Theta-9]\{8\}5"$ codigos.txt 


grep -P "^\d 4] [A-Z]{3}\$" codigos.txt | grep -v "[AEIOU]" 


grep -P "^\d{8} [A-Z]\$" codigos.txt | grep -v "[AEIOU]' 


grep -P $"ES\backslash d\{2\}([]\backslash d\{4\})\{5\}S^{\prime\prime}$ codigos.txt 


grep -P $"^{\prime\prime\wedge}(\backslash d\{1,3\}[.])\{3\}\backslash d\{1,3\}S^{\prime\prime}$ codigos.txt