# Baixa os arquivos suplementares dos dois mapas sistemáticos.
# Rode a partir da pasta raiz do repositório:
#   Rscript scripts/01_baixar_dados.R

options(HTTPUserAgent = "Mozilla/5.0 (research data download)", timeout = 300)

mapas <- list(
  casallanovo2026_mata_atlantica = "https://link.springer.com/article/10.1186/s13750-026-00390-z",
  adams2021_luz_artificial       = "https://link.springer.com/article/10.1186/s13750-021-00246-8"
)

# Links já conhecidos (plano B, caso a leitura da página falhe)
base_casa <- "https://media.springernature.com/original/springer-static/esm/art%3A10.1186%2Fs13750-026-00390-z/MediaObjects/13750_2026_390_MOESM"
base_adams <- "https://media.springernature.com/original/springer-static/esm/art%3A10.1186%2Fs13750-021-00246-8/MediaObjects/13750_2021_246_MOESM"
reserva <- list(
  casallanovo2026_mata_atlantica = paste0(base_casa,
    c("1_ESM.pdf", "2_ESM.docx", "3_ESM.xlsx", "4_ESM.xlsx",
      "5_ESM.xlsx", "6_ESM.docx", "7_ESM.xlsx")),
  # A página do Adams bloqueia leitura automática (verificação anti-bot).
  # O Additional file 14 não foi achado no CDN com nenhuma extensão comum.
  adams2021_luz_artificial = paste0(base_adams,
    c("1_ESM.pdf", "2_ESM.docx", "3_ESM.zip", "4_ESM.xlsx",
      "5_ESM.xlsx", "6_ESM.csv", "7_ESM.xlsx", "8_ESM.docx",
      "9_ESM.xlsx", "10_ESM.xlsx", "11_ESM.xlsx", "12_ESM.docx",
      "13_ESM.accdb", "15_ESM.xlsx", "16_ESM.docx"))
)

achar_links <- function(url) {
  html <- tryCatch(paste(readLines(url, warn = FALSE), collapse = "\n"),
                   error = function(e) "")
  links <- regmatches(html, gregexpr(
    "https?://[^\"' <>]*MOESM[0-9]+_ESM\\.[A-Za-z0-9]+", html))[[1]]
  unique(gsub("&amp;", "&", links))
}

registro <- data.frame()

for (nome in names(mapas)) {
  pasta <- file.path("data", "raw", nome)
  dir.create(pasta, recursive = TRUE, showWarnings = FALSE)

  links <- achar_links(mapas[[nome]])
  if (length(links) == 0) links <- reserva[[nome]]
  if (length(links) == 0) {
    message("Nenhum link encontrado para ", nome,
            ". Baixe manualmente em: ", mapas[[nome]])
    next
  }

  # Um link por arquivo (a página às vezes repete)
  links <- links[!duplicated(basename(links))]

  for (link in links) {
    destino <- file.path(pasta, basename(link))
    ok <- tryCatch({
      download.file(link, destino, mode = "wb", quiet = TRUE)
      TRUE
    }, error = function(e) FALSE)
    message(if (ok) "OK      " else "FALHOU  ", destino)
    registro <- rbind(registro, data.frame(
      mapa = nome, arquivo = basename(link), url = link,
      baixado = ok, data = as.character(Sys.Date())))
  }
}

write.csv(registro, file.path("data", "raw", "registro_downloads.csv"),
          row.names = FALSE)
message("Pronto. Veja data/raw/registro_downloads.csv")
