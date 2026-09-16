## Lê o CSV e acrescenta o nome do mês como fator.
ler_dados <- function(arquivo) {
  dados <- read.csv(arquivo)
  dados$Mes <- factor(dados$Month, levels = 5:9,
                      labels = c("Maio", "Junho", "Julho", "Agosto",
                                 "Setembro"))
  dados
}

## Média mensal de ozônio e de velocidade do vento.
medias_mensais <- function(dados) {
  medias <- aggregate(cbind(Ozone, Wind) ~ Mes, data = dados, FUN = mean,
                      na.action = na.pass, na.rm = TRUE)
  medias[, -1] <- round(medias[, -1], 1)
  medias
}

## Regressão do ozônio sobre a velocidade do vento.
ajustar_modelo <- function(dados) {
  lm(Ozone ~ Wind, data = dados)
}

## Desenha a dispersão com a reta ajustada e devolve o caminho do PNG.
salvar_figura <- function(dados, modelo, arquivo = "saidas/dispersao.png") {
  dir.create(dirname(arquivo), showWarnings = FALSE, recursive = TRUE)
  png(arquivo, width = 1400, height = 900, res = 180)
  on.exit(dev.off())
  plot(Ozone ~ Wind, data = dados, pch = 20, col = "steelblue",
       xlab = "Velocidade do vento (mph)", ylab = "Ozônio (ppb)")
  abline(modelo, col = "tomato", lwd = 2)
  arquivo
}

## Exporta as médias mensais como CSV e devolve o caminho do arquivo.
exportar_medias <- function(medias, arquivo = "saidas/medias-mensais.csv") {
  dir.create(dirname(arquivo), showWarnings = FALSE, recursive = TRUE)
  write.csv(medias, arquivo, row.names = FALSE)
  arquivo
}