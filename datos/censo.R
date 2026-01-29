# https://www.ine.gob.cl/estadisticas/sociales/demografia-y-vitales/proyecciones-de-poblacion

library(readxl)
library(dplyr)

datos_original <- read_xlsx("datos/estimaciones-y-proyecciones-de-población-1992-2070_base-2024_base-de-datos.xlsx")

library(janitor)

datos <- datos_original |> 
  clean_names()
  
datos |> 
  distinct(nivel)

datos |> 
  distinct(sexo)

datos |> 
  distinct(fecha)


library(lubridate)

datos_2 <- datos |> 
  mutate(fecha = dmy(fecha)) |> 
  mutate(año = year(fecha))



datos_2 |> 
  filter(año == 2026) |> 
  print(n=Inf)
  summarize(poblacion = sum(poblacion))
  
# cada año tiene dos mediciones
datos_2 |> 
  group_by(año) |> 
  summarize(n_distinct(fecha)) |> 
  print(n=Inf)

pob_año <- datos_2 |> 
  group_by(año) |> 
  summarize(poblacion = sum(poblacion))

pob_año |> 
  filter(año >= 2026)

datos |> 
  filter(fecha == "1/1/2026") |> 
  summarize(poblacion = sum(poblacion))

# gráfico ----
library(ggplot2)

datos_2

datos_2 |> 
  group_by(fecha, sexo) |>
  summarize(poblacion = sum(poblacion)) |>
  ggplot() +
  aes(x=fecha, y=poblacion/1e6,
      color = sexo) +
  geom_line() +
  geom_vline(xintercept = as.Date("2026-01-29")) +
  labs(
    x = "Año",
    y = "Población (millones)",
    title = "Proyección de la población de Chile",
    subtitle = "Fuente: INE - Proyecciones de Población 1992-2070"
  ) +
  theme_minimal()


datos_2 |> 
  filter(edad <= 10) |> 
  filter(año > 2000,
         año < 2030) |> 
  # group_by(fecha, sexo) |>
  # summarize(poblacion = sum(poblacion)) |>
  ggplot() +
  aes(x=fecha, y=poblacion/1e6,
      color = as.factor(edad)) +
  geom_line() +
  geom_vline(xintercept = as.Date("2026-01-29")) +
  labs(
    x = "Año",
    y = "Población (millones)",
    title = "Proyección de la población de Chile",
    subtitle = "Fuente: INE - Proyecciones de Población 1992-2070"
  ) +
  theme_minimal() +
  facet_wrap(~sexo)



migracion <- read_xlsx("datos/estimaciones-y-proyecciones-de-población-1992-2070_base-2024_tabulados.xlsx",
                       sheet = 4)


migracion |> 
  slice(1)

library(tidyr)

migracion |> 
  select(-1) |> 
  row_to_names(1) |> 
  rename(variables = 1) |> 
  filter(variables == "Saldo Migratorio") |> 
  pivot_longer(cols = where(is.numeric),
               names_to = "año", 
               values_to = "migrantes")
  