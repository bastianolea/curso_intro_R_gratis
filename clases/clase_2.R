# Clase 2
# Introducción al análisis de datos con R para 
# personas de las ciencias sociales y humanidades
# Bastián Olea Herrera - https://bastianolea.rbind.io

# diapositivas: https://bastianolea.github.io/curso_intro_R_gratis/


# cargar datos ----

# cargar datos desde csv
# usando la función nativa de R
datos <- read.csv2("estimaciones_pobreza.csv")
# esta función carga los datos en un formato básico y antiguo
# es preferible cargarlo con el paquete {readr}

# instalar el paquete (sólo es necesario hacerlo una vez por computador)
# install.packages("readr")
library("readr") # cargar el paquete (es como "abrirlo")
datos <- read_csv2("estimaciones_pobreza.csv")
# cargar en formato tibble, que es más conveniente

datos


# dplyr ----
# dplyr es un paquete para manipulación de datos en R
# es parte del "tidyverse", un conjunto de paquetes para análisis de datos

# instalar el paquete
# install.packages("dplyr")
library("dplyr") # cargar el paquete

## explorar datos ----

head(datos) # ver las primeras filas
tail(datos) # ver las últimas filas
glimpse(datos) # ver estructura de los datos

# seleccionar columnas
select(datos, 
       comuna, personas)

# ver nombres de columnas
names(datos)

select(datos, 
       comuna, personas_proy)

# seleccionar columnas por su posición
datos |> 
  select(2, 3, 5)

# seleccionar columnas de la 1 a la 5
datos |> 
  select(1:5)

# extraer filas específicas
slice(datos, 1) # sólo la primera fila

slice(datos, 9) # sólo la novena fila

slice(datos, 
      c(1, 2, 3)) # usando un vector

# seleccionar y luego ver últimas observaciones
datos |> 
  select(comuna, personas) |> # usando un conector
  tail()

# seleccionar, ordenar y ver primeras observaciones
datos |> 
  select(comuna, personas) |> 
  arrange(personas) |> 
  head()

# seleccionar, ordenar de mayor a menor y ver primeras observaciones
datos |> 
  select(comuna, porcentaje) |>
  arrange(desc(porcentaje)) |> 
  head()

# también se epuede hacer todo seguido, pero en varias líneas queda más ordenado
datos |> select(comuna, porcentaje) |> arrange(desc(porcentaje)) |> head()

# seleccionar, ordenar y ver todas las observaciones
datos |> 
  select(comuna, personas) |> 
  arrange(personas) |> 
  print(n = Inf)


## filtrar datos ----
# https://bastianolea.rbind.io/blog/r_introduccion/dplyr_intro/#filtrar-datos

# filtrar filas según condiciones
datos |> 
  filter(personas_proy > 400000)
# quedan solamente las observaciones que cumplen la condición

# filtrar filas con pocentaje mayor al 10%
datos |> 
  filter(porcentaje < 0.1) |> 
  arrange(porcentaje)

# dos filtros consecutivos
datos |> 
  filter(personas_proy > 10000) |> 
  filter(porcentaje < 0.1) |> 
  arrange(porcentaje)

# forma alternativa de hacer dos filtros consecutivos
datos |> 
  filter(personas_proy > 10000,
         porcentaje < 0.1) |> 
  arrange(porcentaje)

# filtrar variables categóricas o de texto
datos |> 
  filter(region == "Maule")

# ver las observaciones distintas de una columna
datos |> 
  distinct(region)

# contar observaciones por categoría
datos |> 
  count(region) |> 
  arrange(n)
# entrega la cantidad de filas donde se repite un mismo valor,
# es decir, se cuenta la cantidad de veces que aparece cada valor único

datos |> 
  count(comuna)

datos |> 
  count(region)

# filtrar por porcentaje y luego contar por región y ordenar
datos |> 
  filter(porcentaje > 0.3) |> 
  count(region) |> 
  arrange(desc(n))



## crear variables ----
# https://bastianolea.rbind.io/blog/r_introduccion/dplyr_mutate/

# crear una nueva variable con mutate
datos |> 
  select(2:5) |> 
  mutate(prueba = 1)
# la columna "prueba" se llena con 1

# crear una nueva variable aplicando a una operación 
# matemática a una columna existente
datos |> 
  select(2:6) |> 
  mutate(p = porcentaje * 100) |> 
  mutate(personas_proy_mil = personas_proy / 1000)

# renombrar columnas y luego crear dos columnas más
datos |> 
  select(2:5) |> 
  rename(poblacion = personas_proy,
         personas_pobreza = personas) |> 
  mutate(porcentaje = personas_pobreza / poblacion) |> 
  mutate(porcentaje = porcentaje * 100)


datos %>% 
  # select(1:5) %>% 
  mutate(p = porcentaje * 100) %>%
  mutate(personas_proy_mil = personas_proy / 1000)

datos |> 
  head(n = 10)


### if else ----
# repaso de comparaciones
edad = 32
edad > 30

# si la comparación se cumple, se entrega el primer valor, 
# de lo contrario se entrega el segundo
ifelse(edad > 30,
       yes = "mayor a 30",
       no = "menor a 30")

ifelse(edad > 30, "mayor a 30", "menor a 30")


datos |> 
  select(region, comuna, porcentaje) |> 
  mutate(nivel = ifelse(porcentaje > 0.2, "alto", "bajo")) 

# guardar un dataframe nuevo
conteo_pobreza <- datos |> 
  select(region, comuna, porcentaje) |> 
  mutate(nivel = ifelse(porcentaje > 0.2, "alto", "bajo")) |> 
  count(nivel)

conteo_pobreza

# crear un nuevo dataframe a partir de una modificación de otro dataframe
datos_filtrados <- datos |> 
  filter(porcentaje > 0.3)

datos_filtrados


# calcular el promedio de todos los datos de la columna porcentaje
promedio <- datos |> 
  pull(porcentaje) |> # extraer la columna porcentaje como un vector
  mean() # calcular el promedio del vector

promedio

### case when ----
# crear una nueva variable con tres categorías según el valor del porcentaje
datos |>
  select(region, comuna, porcentaje) |>
  mutate(nivel = case_when(
    porcentaje > promedio ~ "alta",
    porcentaje > 0.17 ~ "media",
    porcentaje <= 0.17 ~ "baja")
  )

# calcular la mediana de la columna porcentaje
mediana <- datos |> 
  pull(porcentaje) |> 
  median()

# crear una nueva variable con tres categorías según el valor del porcentaje y la mediana
datos |>
  select(region, comuna, porcentaje) |>
  mutate(nivel = case_when(
    porcentaje > mediana*1.2 ~ "alta",
    porcentaje > mediana ~ "media",
    porcentaje <= mediana ~ "baja")
  )


## resúmenes de datos ----
# https://bastianolea.rbind.io/blog/r_introduccion/dplyr_summarize/

# calcular el promedio de la columna porcentaje
datos |> 
  summarise(mean(porcentaje))

# calcular el promedio de la columna porcentaje y 
# guardarlo en una nueva columna llamada "promedio"
datos |> 
  summarise(promedio = mean(porcentaje))

# calcular el promedio, la mediana, el mínimo y el máximo de la columna porcentaje
datos |> 
  summarise(promedio = mean(porcentaje),
            mediana = median(porcentaje),
            minimo = min(porcentaje),
            maximo = max(porcentaje))

# calcular el promedio, la mediana, el mínimo, el máximo y el percentil 25 de la columna personas_proy
datos |>
  rename(variable = personas_proy) |> 
  summarise(promedio = mean(variable),
            mediana = median(variable),
            minimo = min(variable),
            maximo = max(variable),
            percentil_25 = quantile(variable, .25))

### resumen agrupado ----
# calcular el promedio de la columna porcentaje por región
datos |> 
  group_by(region) |> 
  summarise(promedio = mean(porcentaje))


