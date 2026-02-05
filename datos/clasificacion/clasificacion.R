# Nueva clasificación de las comunas de Chile según la Política Nacional de Desarrollo Rural, basado en los datos del Censo 2024
# https://bibliotecadigital.odepa.gob.cl/handle/20.500.12650/74476

library(readxl)
library(dplyr)
library(janitor)

clasificacion <- read_xlsx("datos/clasificacion/ClasificacionComunasPNDR_Censo2024.xlsx")

clasificacion <- clasificacion |> 
  clean_names() |> 
  rename(codigo = cut,
         cut_region = cod_reg)

# guardar
readr::write_csv2(clasificacion, "datos/clasificacion/clasificacion.csv")
