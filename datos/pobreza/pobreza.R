# https://bidat.gob.cl/directorio/Pobreza%20comunal/estimaciones-de-pobreza-comunal-2022

library(readxl)
library(dplyr)
library(janitor)

# cargar
pobreza <- read_xlsx("datos/pobreza/estimaciones_indice_pobreza_multidimensional_comunas_2022.xlsx")

# limpiar
pobreza <- pobreza |> 
  row_to_names(2) |> 
  clean_names() |> 
  filter(!is.na(nombre_comuna))

# convertir variables
pobreza <- pobreza |> 
  mutate(across(c(numero_de_personas_segun_proyecciones_de_poblacion,
                  numero_de_personas_en_situacion_de_pobreza_multidimensional,
                  porcentaje_de_personas_en_situacion_de_pobreza_multidimensional_2022,
                  limite_inferior, 
                  limite_superior),
                as.numeric))

# recodificar
pobreza <- pobreza |> 
  rename(comuna = nombre_comuna,
         personas_proy = numero_de_personas_segun_proyecciones_de_poblacion,
         personas = numero_de_personas_en_situacion_de_pobreza_multidimensional,
         porcentaje = porcentaje_de_personas_en_situacion_de_pobreza_multidimensional_2022,
         casen = presencia_de_la_comuna_en_la_muestra_casen,
         tipo_estimacion = tipo_de_estimacion_sae)

# guardar
write.csv2(pobreza, 
           "datos/pobreza/estimaciones_pobreza.csv", row.names = FALSE)
