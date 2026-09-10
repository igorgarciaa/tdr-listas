library(ggplot2)

dados <- read.csv("airquality.csv")

dados$Mes <- factor(dados$Month,
  levels = 5:9,
  labels = c("Maio", "Junho", "Julho", "Agosto", "Setembro")
)

grafico <- ggplot(subset(dados, !is.na(Ozone)), aes(x = Mes, y = Ozone)) +
  geom_boxplot(fill = "#9ecbff", colour = "#0b2f6b", outlier.colour = "#7e6ff0") +
  labs(
    x = "Mes",
    y = "Ozonio (ppb)",
    title = "Distribuicao mensal do ozonio, Nova York, 1973"
  ) +
  theme_minimal(base_size = 12)

ggsave("figura.pdf", plot = grafico, width = 6, height = 4)
