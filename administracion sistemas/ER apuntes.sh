### Componentes Clave

- **Caracteres Literales:** Cualquier carácter normal como 'a', 'X', '5', etc., se busca a sí mismo. 'hola' busca exactamente "hola".

- **Metacaracteres:** Son los caracteres con poderes especiales. Los más importantes son:

    - **Anclas:**
        - '^':  **Principio** de una línea o texto. '^hola' busca "hola" al inicio.
        - '$': **Final** de una línea o texto. 'mundo$' busca "mundo" al final.

    - **Cuantificadores:** Indican cuántas veces se repite lo anterior.
        - '*': **Cero o más** veces. 'ab*c' coincide con "ac", "abc", "abbbc".
        - '+': **Una o más** veces. 'ab+c' coincide con "abc", "abbc", pero no con "ac".
        - '?': **Cero o una** vez. 'colou?r' coincide con "color" y "colour".
        - '{n}': Exactamente **n** veces. '\d{3}' busca 3 dígitos seguidos.
        - '{n,m}': Entre **n y m** veces. '\d{2,4}' busca de 2 a 4 dígitos.

    - **Agrupación y Rangos:**
        - '( )': **Agrupa** partes del patrón. '(la)+' busca "la", "lala", "lalala". También se usa para capturar texto.
        - '[ ]': Define un **conjunto de caracteres** permitidos. '[abc]' coincide con 'a', 'b', o 'c'. '[a-z]' coincide con cualquier letra minúscula.
        - '[^ ]': **Niega** un conjunto. '[^0-9]' coincide con cualquier cosa que no sea un dígito.
        - '|': Actúa como un **"O" lógico**. 'gato|perro' coincide con "gato" o "perro".

    - **El Comodín:**
        - '.': Coincide con **cualquier carácter** (excepto el salto de línea, normalmente).

- **Clases de Caracteres (Atajos):**
    - '\d': Cualquier **dígito** ('[0-9]').
    - '\w': Cualquier **carácter de palabra** (letra, número o guion bajo) ('[a-zA-Z0-9_]').
    - '\s': Cualquier **espacio en blanco** (espacio, tabulador, nueva línea).
    - '\D', '\W', '\S': Las mayúsculas son lo **contrario** de las minúsculas (no dígito, no palabra, no espacio).

---

### ¿Para qué se usan?

1.  **Validación de Datos:**
    - **Correos electrónicos:** '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    - **Números de teléfono:** '^\+?\d{1,3}?[- .]?\(?\d{3}\)?[- .]?\d{3}[- .]?\d{4}$' (Este es un ejemplo, varía mucho por país).
    - **Contraseñas seguras:** '(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}' (Al menos 8 caracteres, con mayúscula, minúscula y número).

2.  **Búsqueda y Reemplazo de Texto:**
    - **Buscar:** Encontrar todas las líneas que contienen "ERROR" en un archivo de log. ('grep 'ERROR' archivo.log')
    - **Reemplazar:** Cambiar todas las fechas en formato 'DD/MM/AAAA' a 'AAAA-MM-DD'.
    - **Extraer:** Sacar todos los enlaces '<a>' de una página HTML.

3.  **Análisis de Texto (Parsing):**
    - Descomponer datos de un archivo CSV o un log para procesarlos.
    - Extraer información específica de grandes bloques de texto.

4.  **Manipulación de Cadenas de Texto:**
    - Dividir una cadena de texto por un patrón complejo.
    - Limpiar texto eliminando caracteres no deseados o espacios extra.
    - Reformatear texto.

---

### Consejos Prácticos

- **Escapa los metacaracteres:** Si quieres buscar un carácter especial como '.' o '*' literalmente, debes "escaparlo" con una barra invertida '\' ('\.' , '\*').
- **Usa herramientas online:** Sitios como [regex101.com](https://regex101.com) o [regexr.com](https://regexr.com) son fantásticos para construir y probar tus expresiones regulares de forma interactiva.
- **Sé específico pero flexible:** Una buena regex es lo suficientemente específica para no capturar cosas que no quieres, pero lo suficientemente flexible para capturar todas las variaciones que sí necesitas.
