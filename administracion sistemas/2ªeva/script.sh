#!/bin/bash 
###Contenido del fichero### 
echo "Hola mundo" 
chmod o+x ejemplo.sh 
./ejemplo.sh 
/home/usuario/ejemplo.sh 
sh ejemplo.sh 
bash ejemplo.sh 

texto="Hola mundo" 
numero=27 
resultado=`ls -l` 
echo $texto 
# Hola Mundo 
echo $numero 
# 27 
((numero=numero+3)) 
echo $numero 
# 30 
suma=$((numero+20)) 
echo $suma 
# 50 
let "suma=numero+20" 
echo $suma 
# 50 

lista=(Juan Luis Raquel) 
echo ${lista[*]} 
# Juan Luis Raquel 
echo ${lista[@]} 
# Juan Luis Raquel 
echo ${#lista[*]} 
# 3 
echo ${lista[1]} 
# Luis 
lista[1]="Antonio" 
echo ${lista[*]} 
# Juan Antonio Raquel 
lista[3]="María" 
echo ${lista[*]} 
# Juan Antonio Raquel María 

palabra="Bienvenido" 
echo ${#palabra} 
# 10 
echo ${palabra:4:1} 
# V 
echo ${palabra:2:4} 
# enve 
echo ${palabra:1:-1} 
# ienvenid 
num1=22 
num2=33 
suma=$((num1+num2)) 
echo $suma 
# 55 

echo Introduzca el primer número 
read num1 
echo Introduzca el segundo número 
read num2 
suma=$((num1+num2)) 
echo $suma 
read -p "Dime un texto:" variable 
echo $variable 
read -sp "Dime la contraseña:" password 
echo Tu contraseña es $password 
read -p "Dime tres cosas" un dos tres 
echo $un 
echo $dos 
echo $tres 

echo el parámetro 0 es: $0 
echo En el primer parámetro pone $1, en el segundo $2, en el tercero $3 y en el> 
echo En total hay $# parámetros 
echo Los parámetros son $* 
lista=($@) 
echo También los puedo sacar con la @ y son $lista 
echo El tercer valor es ${lista[2]} 
echo El resultado del echo anterior es $? 
echo El último comando ha sido: $_ 
echo El ID de proceso del script es $$ 

printenv 

bash -n script.sh 
bash -x script.sh 



#!/bin/bash

### --- Sección 1: Ejecución y Permisos ---

echo "Hola mundo"
# -> Hola mundo

# 'chmod' cambia los permisos. 'o+x' otorga permiso de ejecución (x) a 'o' (otros/others).
# Esto es necesario para ejecutar el script directamente.
chmod o+x ejemplo.sh
# -> (Sin salida visual, pero cambia los atributos del archivo)

# Ejecuta el script invocando la ruta relativa (requiere permisos +x).
./ejemplo.sh 
# -> (Ejecuta el contenido del script)

# Ejecuta el script usando la ruta absoluta (requiere permisos +x).
/home/usuario/ejemplo.sh
# -> (Ejecuta el contenido del script)

# Ejecuta el script invocando el intérprete 'sh' (Bourne Shell).
# Nota: No requiere permiso +x en el archivo, ya que se pasa como argumento.
sh ejemplo.sh
# -> (Ejecuta el script, posiblemente con compatibilidad POSIX estricta)

# Ejecuta el script invocando explícitamente 'bash'.
# Recomendado para asegurar que todas las funcionalidades modernas funcionen.
bash ejemplo.sh
# -> (Ejecuta el script con todas las funciones de Bash)

### --- Sección 2: Variables y Aritmética Básica ---

# Asignación de variables de texto (sin espacios alrededor del '=').
texto="Hola mundo"

# Asignación de enteros. Bash no tipa fuertemente, pero reconoce números.
numero=27

# Asignación del resultado de un comando a una variable usando backticks ``.
# Nota: Es preferible usar la sintaxis moderna $(ls -l).
resultado=`ls -l`

# Imprimir el valor de una variable usando '$'.
echo $texto
# -> Hola mundo

echo $numero
# -> 27

# Doble paréntesis ((...)) permite aritmética avanzada estilo C.
# Aquí se incrementa el valor de 'numero' en 3.
((numero=numero+3))
echo $numero
# -> 30

# Expansión aritmética $((...)) para asignar el resultado a una nueva variable.
suma=$((numero+20))
echo $suma
# -> 50

# 'let' es un comando interno (built-in) para evaluar expresiones aritméticas.
# Es una alternativa más antigua a ((...)).
let "suma=numero+20"
echo $suma
# -> 50

### --- Sección 3: Arrays (Arreglos) ---

# Declaración de un array indexado con elementos separados por espacios.
lista=(Juan Luis Raquel)

# ${lista[*]} expande todos los elementos del array como una sola cadena.
echo ${lista[*]}
# -> Juan Luis Raquel

# ${lista[@]} expande todos los elementos, pero trata cada uno como una palabra separada (mejor para bucles).
echo ${lista[@]}
# -> Juan Luis Raquel

# ${#lista[*]} o ${#lista[@]} devuelve la longitud (cantidad de elementos) del array.
echo ${#lista[*]}
# -> 3

# Acceso a un elemento específico por su índice (base 0).
echo ${lista[1]}
# -> Luis

# Modificación de un elemento existente en el índice 1.
lista[1]="Antonio"
echo ${lista[*]}
# -> Juan Antonio Raquel

# Añadir un elemento nuevo en un índice específico (índice disperso).
lista[3]="María"
echo ${lista[*]}
# -> Juan Antonio Raquel María

### --- Sección 4: Manipulación de Cadenas (Slicing) ---

palabra="Bienvenido"

# ${#variable} devuelve la longitud de la cadena de texto.
echo ${#palabra}
# -> 10

# Extracción de subcadena: ${variable:inicio:longitud}.
# Empieza en el carácter 4 (índice 0) y toma 1 carácter ('v' es el 5º, índice 4).
echo ${palabra:4:1}
# -> v

# Empieza en el índice 2 y toma 4 caracteres.
echo ${palabra:2:4}
# -> enve

# Índices negativos cuentan desde el final.
# Desde el índice 1 hasta el penúltimo (-1).
echo ${palabra:1:-1}
# -> ienvenid

### --- Sección 5: Entrada del Usuario (Interactividad) ---

# Variables para ejemplo de suma interactiva.
num1=22
num2=33
suma=$((num1+num2))
echo $suma
# -> 55

# 'read' básico: detiene el script y espera input del usuario.
echo Introduzca el primer número
read num1
# -> (Espera entrada, ej: 10)

echo Introduzca el segundo número
read num2
# -> (Espera entrada, ej: 5)

suma=$((num1+num2))
echo $suma
# -> 15 (si los inputs fueron 10 y 5)

# 'read -p': Permite mostrar un mensaje (prompt) en la misma línea antes de leer.
read -p "Dime un texto:" variable
echo $variable
# -> (Muestra "Dime un texto:", espera input e imprime lo escrito)

# 'read -sp': Combina silent (-s) y prompt (-p). Útil para contraseñas (no muestra caracteres al escribir).
read -sp "Dime la contraseña:" password
echo Tu contraseña es $password
# -> (Pide contraseña ocultándola y luego la muestra - cuidado con hacer echo de passwords real)

# Lectura múltiple: asigna palabras separadas por espacio a variables secuenciales.
read -p "Dime tres cosas" un dos tres
echo $un
echo $dos
echo $tres
# -> (Si escribes "Sol Mar Tierra", asigna: un=Sol, dos=Mar, tres=Tierra)

### --- Sección 6: Variables Especiales y Argumentos ---
# Nota: Estos valores dependen de cómo se llame al script (ej: ./script.sh arg1 arg2)

# $0: Contiene el nombre del script o comando ejecutado.
echo el parámetro 0 es: $0
# -> ./script.sh

# $1, $2, $3...: Son los argumentos posicionales pasados al script.
echo "En el primer parámetro pone $1, en el segundo $2, en el tercero $3"
# -> (Depende de los argumentos. Si no hay, estará vacío)

# $#: Número total de argumentos pasados.
echo En total hay $# parámetros
# -> 0 (si no se pasaron argumentos)

# $*: Todos los argumentos como una sola cadena.
echo Los parámetros son $*
# -> arg1 arg2 arg3

# $@: Todos los argumentos como cadenas separadas (ideal para arrays o iterar).
lista=($@)
echo También los puedo sacar con la @ y son $lista
# -> arg1

# Acceso al array creado desde los argumentos.
echo El tercer valor es ${lista[2]}
# -> (Muestra el tercer argumento si existe)

# $?: Estado de salida del último comando ejecutado (0 = éxito, 1-255 = error).
echo El resultado del echo anterior es $?
# -> 0

# $_: Último argumento del último comando ejecutado.
echo El último comando ha sido: $_
# -> 0 (porque el último argumento del comando anterior fue $?)

# $$: PID (Process ID) del script actual.
echo El ID de proceso del script es $$
# -> (Un número, ej: 12345)

### --- Sección 7: Variables de Entorno y Depuración ---

# Muestra todas las variables de entorno del sistema (USER, HOME, PATH, etc.).
printenv
# -> (Lista larga de variables)

# Comprobación de sintaxis: lee el script sin ejecutarlo (-n = noexec).
# Útil para buscar errores de sintaxis antes de correrlo.
bash -n script.sh
# -> (Sin salida si la sintaxis es correcta)

# Modo depuración (trace): imprime cada comando y sus argumentos tal como se ejecutan (-x = xtrace).
# Muestra la expansión de variables paso a paso.
bash -x script.sh
# -> (Output detallado con signos '+' indicando cada paso ejecutado)