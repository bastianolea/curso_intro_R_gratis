library(dplyr)
library(janitor)
library(readxl)

genero <- read_xlsx("datos/censo/P5_Genero.xlsx",
                    sheet = 2)

genero |> 
  row_to_names(3)

library(tidyr)

genero_long <- genero |> 
  row_to_names(3) |> 
  pivot_longer(cols = 4:last_col(),
               names_to = "genero",
               values_to = "poblacion") |> 
  rename(total = 3)
  

genero_porcentaje <- genero_long |> 
  mutate(poblacion = as.numeric(poblacion),
         total = as.numeric(total)) |>
  clean_names() |>
  # group_by(region) |>
  # mutate(prueba = sum(poblacion)) |> 
  mutate(porcentaje = poblacion / total)

genero_porcentaje |> 
  filter(genero == "Transmasculino")
