# Clase 1
# Introducción al análisis de datos con R para 
# personas de las ciencias sociales y humanidades
# Bastián Olea Herrera - https://bastianolea.rbind.io

# diapositivas: https://bastianolea.github.io/curso_intro_R_gratis/


# operaciones matemáticas ----

# sumar dos números
1+1

# sumar muchos números en una sola línea
4+4+5+5+5+5+5+5+5+5 

# multiplicar números grandes
89889*65546

# podemos comentar líneas de código para que no se ejecuten
# 34343-65656+3232*4343


## trabajar con texto ----

# en R, el texto se escribe entre comillas
"gato"

# no se pueden sumar textos como si fueran números
# "gato" + "perro" # esto genera un error


# asignación de variables ----
# guardar un valor en una variable usando <-

# guardar el año actual en una variable
año <- 2026

# ver el contenido de la variable
año

# guardar un texto en una variable
nombre <- "basti"


# reasignar valores ----

# podemos cambiar el valor de una variable existente
año <- 1993


## operaciones con variables ----

# crear dos variables con números
edad <- 32
año <- 2026

# restar variables (el orden importa)
edad - año
año - edad

# el símbolo = también funciona para asignar, pero se recomienda usar <-
perros = 6

# también se puede asignar de derecha a izquierda (poco común)
4 -> panes


# comparaciones ----
# las comparaciones entregan TRUE (verdadero) o FALSE (falso)

# comparar si un número es mayor que otro
edad > 55

# comparar si dos valores son iguales (con ==, no con =)
edad == 38

# comparar con variables
habitantes <- 350000
habitantes > 200000

# comparar si dos valores son diferentes (!=)
año != 2025


# vectores ----
# un vector es una secuencia de valores del mismo tipo

# crear un vector de números con c()
pob <- c(350, 400, 1010, 23, 490)

# las operaciones matemáticas se aplican a todos los elementos del vector
pob * 1000

# las comparaciones también se aplican a cada elemento
pob > 100

# crear un vector de edades
edades <- c(30, 40, 45, 32, 35, 27, 34, 54, 65, 24, 43)

# evaluar si las edades cumplen una comparación
edades > 35

# crear un vector de texto
animales <- c("perro", "gato", "gallina")

# comparar cada elemento del vector con un valor
animales == "gato"


# funciones para resumir datos ----

# calcular el promedio de un vector
mean(edades)

# obtener el valor máximo
max(edades)

# obtener el valor mínimo
min(edades)

# ordenar los valores de menor a mayor
sort(edades)

# sumar todos los valores del vector
sum(edades)