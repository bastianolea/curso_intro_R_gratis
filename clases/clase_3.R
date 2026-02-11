# Clase 3
# Introducción al análisis de datos con R para 
# personas de las ciencias sociales y humanidades
# Bastián Olea Herrera - https://bastianolea.rbind.io

# diapositivas: https://bastianolea.github.io/curso_intro_R_gratis/


# cargar paquetes ----
library(stringr) # para trabajar con texto
library(dplyr) # para manipular datos
library(readr) # para cargar archivos CSV

datos <- read_csv2("estimaciones_pobreza.csv")
# cargar en formato tibble, que es más conveniente


# manipulación de texto ----
# stringr es un paquete para trabajar con cadenas de texto

# crear un texto de ejemplo
texto <- "todxs pueden aprender a programar 💕" 

# detectar si un texto contiene una palabra específica
str_detect(texto, "todos") # devuelve FALSE porque no encuentra coincidencia exacta
str_detect(texto, "gato") # devuelve FALSE
str_detect(texto, "prog") # devuelve TRUE porque "prog" está en "programar"


## explorar datos de texto ----

# ver las regiones únicas en los datos
datos |> 
  distinct(region)

# filtrar comunas que contengan "Alto" en su nombre
datos |> 
  filter(str_detect(comuna, "Alto")) |> 
  select(comuna)

# esto no encuentra nada porque "alto" está con mayúscula inicial
datos |> 
  filter(str_detect(comuna, "alto"))

# convertir todo a mayúsculas antes de buscar
datos |> 
  mutate(comuna = str_to_upper(comuna)) |> 
  filter(str_detect(comuna, "ALTO"))

# convertir todo a minúsculas
datos |> 
  mutate(comuna = str_to_lower(comuna))

# eliminar todas las letras "a" de los nombres de comunas
datos |> 
  mutate(comuna = str_remove_all(comuna, "a"))

# reemplazar letras por emojis (mayúsculas y minúsculas por separado)
datos |> 
  mutate(comuna = str_replace_all(comuna, "a", "🌸")) |> 
  mutate(comuna = str_replace_all(comuna, "A", "🌸"))

# usar regex (expresiones regulares) para reemplazar minúsculas y mayúsculas a la vez
datos |> 
  mutate(comuna = str_replace_all(comuna, "a|A", "🌸")) # el símbolo | significa "o"



# datos de prensa ----

# hay varias opciones para cargar datos desde internet


# opción 1: descargar el archivo desde internet y guardarlo localmente
download.file("https://raw.githubusercontent.com/bastianolea/prensa_chile/refs/heads/main/prensa_datos_muestra.csv",
              "prensa.csv")

prensa <- readr::read_csv2("prensa.csv")

# opción 2: cargar directo desde internet (sin descargar)
prensa <- readr::read_csv2("https://raw.githubusercontent.com/bastianolea/prensa_chile/refs/heads/main/prensa_datos_muestra.csv")

# opción 3: bajar manualmente el archivo y cargar el archivo descargado
prensa <- readr::read_csv2("prensa.csv")


## explorar datos de prensa ----

prensa

# ver la estructura de los datos
prensa |> 
  glimpse()

# ver títulos específicos (filas 60 a 70)
prensa |> 
  select(titulo) |> 
  slice(60:70)

# extraer 10 títulos al azar
prensa |> 
  select(titulo) |> 
  slice_sample(n = 10)

# contar cuántas noticias hay por fuente (medio de prensa)
prensa |> 
  count(fuente)

# filtrar solo noticias de un medio
prensa |> 
  filter(fuente == "Cooperativa")


## buscar palabras en los datos ----

# buscar noticias que contengan "asesinato" en el título
prensa |> 
  filter(str_detect(titulo, "asesin")) # buscamos la palabra parcial para encontrar más resultados

# buscar títulos que contengan "desigual"
prensa |> 
  filter(str_detect(titulo, "desigual"))

# contar cuántas noticias mencionan "desigual"
prensa |> 
  filter(str_detect(titulo, "desigual")) |> 
  nrow() # cuenta la cantidad de filas

# contar por fuente cuántas noticias mencionan palabras relacionadas con desigualdad
prensa |> 
  group_by(fuente) |> 
  summarize(conteo = sum(str_detect(titulo, "desigual|inequ|igualda"))) |> 
  arrange(-conteo) # ordenar de mayor a menor

# hacer la misma búsqueda pero en el cuerpo de las noticias (no solo el título)
prensa |> 
  group_by(fuente) |> 
  summarize(conteo = sum(str_detect(cuerpo, "desigual|inequ|igualda"))) |> 
  arrange(-conteo)

# ver el cuerpo completo de una noticia específica
prensa |> 
  select(cuerpo) |> 
  slice(3) |> 
  pull() # extrae la columna como vector


# crear un dataset filtrado de noticias sobre medioambiente
prensa_ambiente <- prensa |> 
  filter(str_detect(cuerpo, "medioambiente|ambiente|ecolo|recicla"))

prensa_ambiente

# contar noticias de medioambiente por fiente
prensa_ambiente |> 
  count(fuente) |> 
  arrange(-n)


# análisis de texto ----
# tidytext permite hacer análisis de texto avanzado

# install.packages("tidytext")
# install.packages("stopwords")
library(tidytext)

# tokenizar: separar el texto en palabras individuales
prensa_palabras <- prensa |> 
  slice_sample(n = 1000) |> # tomar una muestra de 1000 noticias
  unnest_tokens(input = cuerpo, output = palabra) |> # separar en palabras
  filter(!palabra %in% stopwords::stopwords("spanish")) # eliminar palabras vacías (como "el", "la", "de")

# contar las palabras más frecuentes
palabras_conteo <- prensa_palabras |> 
  count(palabra) |> 
  arrange(-n)

# buscar cuántas veces aparece la palabra "gatos"
palabras_conteo |> 
  filter(palabra == "gatos")

palabras_conteo


## nube de palabras ----

# install.packages("wordcloud2")
library(wordcloud2)

# crear una nube de palabras con las más frecuentes
palabras_conteo |>
  filter(n > 100) |> # solo palabras que aparecen más de 100 veces
  wordcloud2::wordcloud2( 
    rotateRatio = 0.1, # rotación máxima de las palabras
    gridSize = 8, # espaciado entre cada palabra
    size = 0.5, # tamaño del texto en general
    minSize = 11) # tamaño mínimo de las letras


# análisis con inteligencia artificial ----
# usar modelos de lenguaje (LLMs) locales con ollama

prensa

# install.packages("ellmer")
library(ellmer)

# crear un chat con un modelo de IA local
# ollamar::pull("llama3.2:3b") # descargar el modelo localmente (solo la primera vez)
chat <- chat_ollama(model = "llama3.2:3b") 

# probar el chat
chat$chat("hola")

# install.packages("mall")
library(mall)
llm_use(chat) # configurar el modelo a usar

# análisis de sentimiento: 
# clasificar si las noticias son positivas, neutras o negativas
sentimiento <- prensa |> 
  slice_sample(n = 10) |> # tomar 10 noticias al azar
  llm_sentiment(cuerpo, 
                pred_name = "sentimiento",
                options = c("positivo", "neutro", "negativo"))

# contar cuántas noticias son de cada tipo de sentimiento
sentimiento |> 
  select(titulo, sentimiento) |> 
  count(sentimiento)

# ver solo las noticias clasificadas como positivas
sentimiento |> 
  select(titulo, sentimiento) |> 
  filter(sentimiento == "positivo")

# clasificar las noticias por categoría temática
clasificaciones <- sentimiento |> 
  llm_classify(titulo, 
               labels = c("policial", "economía", "deportes", "política"))

clasificaciones


# unir tablas ----
# combinar datos de diferentes fuentes

# install.packages("readxl")
library(readxl)

# cargar archivo Excel con clasificación de comunas
clasif <- read_excel("ClasificacionComunasPNDR_Censo2024.xlsx")

clasif

datos

# unir los datos de pobreza con la clasificación de comunas
datos |> 
  select(1:6) |> 
  left_join(clasif,
            by = join_by(codigo == CUT) # unir por código de comuna
  )

# preparar la tabla de clasificación: renombrar y seleccionar columnas
clasif_2 <- clasif |>
  rename(codigo = CUT,
         clasificacion = CLASIFICACION) |> 
  select(codigo, clasificacion)

clasif_2

# crear un nuevo dataset con los datos unidos
datos_2 <- datos |> 
  select(1:6) |> 
  left_join(clasif_2) # ahora los nombres coinciden automáticamente

# calcular el total de personas en pobreza por tipo de clasificación
datos_2 |> 
  group_by(clasificacion) |> 
  summarise(personas = sum(personas))

# calcular el porcentaje de pobreza por clasificación
datos_2 |> 
  group_by(clasificacion) |> 
  summarise(personas = sum(personas),
            personas_proy = sum(personas_proy)) |> 
  mutate(porcentaje = (personas / personas_proy) * 100 ) |> 
  mutate(porcentaje = paste0(round(porcentaje, 1), "%")) # convertir a texto con %


# transformar datos ----
# cambiar datos de formato ancho a formato largo

# install.packages("tidyr")
library(tidyr)

library(readxl)

# cargar datos de género del censo
genero <- read_xlsx("P5_Genero.xlsx", sheet = 2)

# install.packages("janitor")
library(janitor)

# convertir una fila en nombres de columnas
genero |> 
  janitor::row_to_names(3)

# mejor: saltar las primeras 3 filas al cargar
genero <- read_xlsx("P5_Genero.xlsx", sheet = 2, skip = 3)

# eliminar filas vacías (donde Región es NA)
genero_2 <- genero |> 
  filter(!is.na(Región))

genero_2 |> 
  glimpse()

# transformar columnas a filas (de formato ancho a largo)
genero_2 |> 
  pivot_longer(cols = Masculino:`No binario`)

# especificar mejor la transformación
genero_3 <- genero_2 |> 
  pivot_longer(cols = 3:10, # columnas 3 a 10
               names_to = "genero", values_to = "cantidad")

# calcular porcentajes de cada categoría de género por región
genero_region <- genero_3 |> 
  filter(genero != "Población de 18 años o más",
         Región != "País") |> 
  group_by(Región) |> 
  mutate(total = sum(cantidad)) |> 
  mutate(porcentaje = cantidad / total)

# ver qué regiones tienen mayor porcentaje de personas transmasculinas
genero_region |> 
  filter(genero == "Transmasculino") |> 
  mutate(porcentaje = porcentaje * 100) |> 
  arrange(-porcentaje)

# calcular los porcentajes a nivel país
genero_3 |> 
  filter(genero != "Población de 18 años o más",
         Región == "País") |> 
  group_by(Región) |> 
  mutate(total = sum(cantidad)) |> 
  mutate(porcentaje = cantidad / total)