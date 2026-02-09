library(ellmer)
# ollamar::pull("llama3.2:3b") # descargar modelo
chat <- chat_ollama(model = "llama3.2:3b") # elegir modelo

library(mall)
llm_use(chat) # configurar modelo

library(dplyr)
noticias <- tibble(
  cuerpo = c(
    "El equipo de fútbol ganó el partido con un gol en el último minuto.",
    "La economía del país está en recesión y se esperan más despidos.",
    "El nuevo restaurante en la ciudad tiene una excelente comida y servicio.",
    "El clima ha sido muy impredecible últimamente, con lluvias constantes.",
    "La película que vi anoche fue aburrida y mal actuada.",
    "El concierto de la banda fue increíble, todos disfrutaron mucho.",
    "El tráfico en la ciudad es terrible durante las horas pico.",
    "La nueva política del gobierno ha sido bien recibida por la mayoría de la población.",
    "El libro que leí fue fascinante y me mantuvo enganchado hasta el final.",
    "La situación política actual es preocupante y genera incertidumbre."
  )
)

sentimiento <- noticias |> 
  slice_sample(n = 10) |> 
  # extraer sentimiento
  llm_sentiment(cuerpo, pred_name = "sentimiento",
                options = c("positivo", "neutro", "negativo"))

sentimiento
