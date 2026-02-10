library(stringr)
library(dplyr)

library(readr) # cargar el paquete (es como "abrirlo")
datos <- read_csv2("estimaciones_pobreza.csv")
# cargar en formato tibble, que es más conveniente



datos

texto <- "todxs pueden aprender a programar 💕" 

str_detect(texto, "todos")
str_detect(texto, "gato")
str_detect(texto, "prog")

datos |> 
  distinct(region)

datos |> 
  filter(str_detect(comuna, "Alto")) |> 
  select(comuna)

datos |> 
  filter(str_detect(comuna, "alto"))

datos |> 
  mutate(comuna = str_to_upper(comuna)) |> 
  filter(str_detect(comuna, "ALTO"))

datos |> 
  mutate(comuna = str_to_lower(comuna))

datos |> 
  mutate(comuna = str_remove_all(comuna, "a"))

datos |> 
  mutate(comuna = str_replace_all(comuna, "a", "🌸")) |> 
  mutate(comuna = str_replace_all(comuna, "A", "🌸"))

datos |> 
  mutate(comuna = str_replace_all(comuna, "a|A", "🌸")) # regex



# descarga el archivo
download.file("https://raw.githubusercontent.com/bastianolea/prensa_chile/refs/heads/main/prensa_datos_muestra.csv",
              "prensa.csv")

# carga directo
prensa <- readr::read_csv2("https://raw.githubusercontent.com/bastianolea/prensa_chile/refs/heads/main/prensa_datos_muestra.csv")

# cargar el archivo
prensa <- readr::read_csv2("prensa.csv")

library(readr)
prensa <- read_csv2("prensa.csv")


prensa

prensa |> 
  glimpse()

prensa |> 
  select(titulo) |> 
  slice(60:70)

prensa |> 
  select(titulo) |> 
  slice_sample(n = 10)

prensa |> 
  count(fuente)

prensa |> 
  filter(fuente == "Cooperativa")

prensa |> 
  filter(str_detect(titulo, "asesin"))

prensa |> 
  filter(str_detect(titulo, "desigual"))

prensa |> 
  filter(str_detect(titulo, "desigual")) |> 
  nrow()

prensa |> 
  group_by(fuente) |> 
  summarize(conteo = sum(str_detect(titulo, "desigual|inequ|igualda"))) |> 
  arrange(-conteo)

prensa |> 
  group_by(fuente) |> 
  summarize(conteo = sum(str_detect(cuerpo, "desigual|inequ|igualda"))) |> 
  arrange(-conteo)

prensa |> 
  select(cuerpo) |> 
  slice(3) |> 
  pull()


prensa_ambiente <- prensa |> 
  filter(str_detect(cuerpo, "medioambiente|ambiente|ecolo|recicla"))

prensa_ambiente

# install.packages("tidytext")
library(tidytext)
# install.packages("stopwords")

prensa_palabras <- prensa |> 
  slice_sample(n = 1000) |> 
  unnest_tokens(input = cuerpo, output = palabra) |> # tokenizar
  filter(!palabra %in% stopwords::stopwords("spanish")) # eliminar palabras vacías

palabras_conteo <- prensa_palabras |> 
  count(palabra) |> 
  arrange(-n)

palabras_conteo |> 
  filter(palabra == "gatos")

palabras_conteo

# install.packages("wordcloud2")
library(wordcloud2)

palabras_conteo |>
  filter(n > 100) |> 
  wordcloud2::wordcloud2( # personalización
    rotateRatio = 0.1, # rotación máxima
    gridSize = 8, # espaciado entre cada palabra
    size = 0.5, # tamaño del texto en general
    minSize = 11) # tamaño mínimo de las letras


prensa

library(ellmer)
chat <- chat_ollama(model = "llama3.2:3b") 

chat$chat("hola")

library(mall)
llm_use(chat)

sentimiento <- prensa |> 
  slice_sample(n = 10) |> 
  llm_sentiment(cuerpo, 
                pred_name = "sentimiento",
                options = c("positivo", "neutro", "negativo"))

sentimiento |> 
  select(titulo, sentimiento) |> 
  count(sentimiento)

sentimiento |> 
  select(titulo, sentimiento) |> 
  filter(sentimiento == "positivo")

clasificaciones <- sentimiento |> 
  llm_classify(titulo, 
               labels = c("policial", "economía", "deportes", "política"))

clasificaciones

# install.packages("readxl")
library(readxl)

clasif <- read_excel("ClasificacionComunasPNDR_Censo2024.xlsx")

clasif

datos

datos |> 
  select(1:6) |> 
  left_join(clasif,
            by = join_by(codigo == CUT)
  )


clasif_2 <- clasif |>
  rename(codigo = CUT,
         clasificacion = CLASIFICACION) |> 
  select(codigo, clasificacion)

clasif_2


datos_2 <- datos |> 
  select(1:6) |> 
  left_join(clasif_2)


datos_2 |> 
  group_by(clasificacion) |> 
  summarise(personas = sum(personas))

datos_2 |> 
  group_by(clasificacion) |> 
  summarise(personas = sum(personas),
            personas_proy = sum(personas_proy)) |> 
  mutate(porcentaje = (personas / personas_proy) * 100 ) |> 
  mutate(porcentaje = paste0(round(porcentaje, 1), "%"))


# install.packages("tidyr")
library(tidyr)

library(readxl)

genero <- read_xlsx("P5_Genero.xlsx", sheet = 2)

# install.packages("janitor")
library(janitor)

genero |> 
  janitor::row_to_names(3)


genero <- read_xlsx("P5_Genero.xlsx", sheet = 2, skip = 3)

genero_2 <- genero |> 
  filter(!is.na(Región))

genero_2 |> 
  glimpse()

genero_2 |> 
  pivot_longer(cols = Masculino:`No binario`)


genero_3 <- genero_2 |> 
  pivot_longer(cols = 3:10,
               names_to = "genero", values_to = "cantidad")

genero_region <- genero_3 |> 
  filter(genero != "Población de 18 años o más",
         Región != "País") |> 
  group_by(Región) |> 
  mutate(total = sum(cantidad)) |> 
  mutate(porcentaje = cantidad / total)

genero_region |> 
  filter(genero == "Transmasculino") |> 
  mutate(porcentaje = porcentaje * 100) |> 
  arrange(-porcentaje)


genero_3 |> 
  filter(genero != "Población de 18 años o más",
         Región == "País") |> 
  group_by(Región) |> 
  mutate(total = sum(cantidad)) |> 
  mutate(porcentaje = cantidad / total)
