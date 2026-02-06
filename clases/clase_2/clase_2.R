

# cargar datos csv
# datos <- read.csv2("estimaciones_pobreza.csv")

# install.packages("readr")
library(readr)
datos <- read_csv2("estimaciones_pobreza.csv")
# cargar en formato tibble

datos <- readr::read_csv2("estimaciones_pobreza.csv")

# instalar un paquete
# install.packages("dplyr")

library("dplyr")


head(datos)
tail(datos)
glimpse(datos)

select(datos, comuna, personas)

datos

names(datos)

select(datos, 
       comuna, personas_proy)


slice(datos, 1)

slice(datos, c(1, 2, 3))

datos |> 
  select(comuna, personas) |> 
  tail()

datos |> 
  select(comuna, personas) |> 
  arrange(personas) |> 
  head()

datos |> 
  select(comuna, porcentaje) |>
  arrange(desc(porcentaje)) |> 
  head()

datos |> select(comuna, porcentaje) |> arrange(desc(porcentaje)) |> head()

datos |> 
  select(comuna, personas) |> 
  arrange(personas) |> 
  print(n = Inf)

datos |> 
  select(comuna, personas) |> 
  arrange(personas)


datos |> 
  filter(personas_proy > 400000)

datos |> 
  filter(porcentaje < 0.1) |> 
  arrange(porcentaje)

datos |> 
  filter(personas_proy > 10000) |> 
  filter(porcentaje < 0.1) |> 
  arrange(porcentaje)


datos |> 
  filter(personas_proy > 10000,
         porcentaje < 0.1) |> 
  arrange(porcentaje)

datos |> 
  filter(personas_proy > 10000 & porcentaje < 0.1) |> 
  arrange(porcentaje)

datos %>%
  arrange(personas_proy) %>%
  select(region, comuna)

datos |> 
  filter(region == "Maule")

datos |> 
  distinct(region)

datos |> 
  count(region) |> 
  arrange(n)

datos |> 
  count(comuna)

datos |> 
  select(region)

datos |> 
  count(region)

datos |> 
  count(tipo_estimacion)

datos |> 
  filter(porcentaje > 0.3) |> 
  count(region) |> 
  arrange(desc(n))

datos |> 
  select(1:5)

datos |> 
  select(2, 3, 5)

datos |> 
  select(personas, comuna)

datos |> 
  select(2:5) |> 
  mutate(prueba = 1)

datos |> 
  select(2:6) |> 
  mutate(p = porcentaje * 100) |> 
  mutate(personas_proy_mil = personas_proy / 1000)

datos |> 
  select(2:5) |> 
  rename(poblacion = personas_proy,
         personas_pobreza = personas) |> 
  mutate(porcentaje = personas_pobreza / poblacion) |> 
  mutate(porcentaje = porcentaje * 100)


datos %>% 
  select(1:5) %>% 
  mutate(prueba = 1)

datos %>% 
  # select(1:5) %>% 
  mutate(p = porcentaje * 100) %>%
  mutate(personas_proy_mil = personas_proy / 1000)

datos |> 
  head(n = 10)

edad = 32


edad > 30

ifelse(edad > 30,
       yes = "mayor a 30",
       no = "menor a 30")

ifelse(edad > 30, "mayor a 30", "menor a 30")


datos |> 
  select(region, comuna, porcentaje) |> 
  mutate(nivel = ifelse(porcentaje > 0.2, "alto", "bajo")) 

conteo_pobreza <- datos |> 
  select(region, comuna, porcentaje) |> 
  mutate(nivel = ifelse(porcentaje > 0.2, "alto", "bajo")) |> 
  count(nivel)

conteo_pobreza

datos_filtrados <- datos |> 
  filter(porcentaje > 0.3)

datos_filtrados

promedio <- datos |> 
  pull(porcentaje) |> 
  mean()

promedio

datos |>
  select(region, comuna, porcentaje) |>
  mutate(nivel = case_when(
    porcentaje > promedio ~ "alta",
    porcentaje > 0.17 ~ "media",
    porcentaje <= 0.17 ~ "baja")
  )

mediana <- datos |> 
  pull(porcentaje) |> 
  median()

datos |> 
  pull(porcentaje) |> 
  sd()

datos |>
  select(region, comuna, porcentaje) |>
  mutate(nivel = case_when(
    porcentaje > mediana*1.2 ~ "alta",
    porcentaje > mediana ~ "media",
    porcentaje <= mediana ~ "baja")
  )

datos

datos |> 
  pull(porcentaje) |> 
  mean()

datos |> 
  summarise(mean(porcentaje))

datos |> 
  summarise(promedio = mean(porcentaje))

datos |> 
  summarise(promedio = mean(porcentaje),
            mediana = median(porcentaje),
            minimo = min(porcentaje),
            maximo = max(porcentaje))

datos |>
  rename(variable = personas_proy) |> 
  summarise(promedio = mean(variable),
            mediana = median(variable),
            minimo = min(variable),
            maximo = max(variable),
            percentil_25 = quantile(variable, .25))


datos |> 
  group_by(region) |> 
  summarise(promedio = mean(porcentaje))


