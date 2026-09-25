# Downloads the supplementary files of the two systematic maps.
# Run from the repository root:
#   Rscript scripts/01_baixar_dados.R

options(HTTPUserAgent = "Mozilla/5.0 (research data download)", timeout = 300)

maps <- list(
  casallanovo2026_mata_atlantica = "https://link.springer.com/article/10.1186/s13750-026-00390-z",
  adams2021_luz_artificial       = "https://link.springer.com/article/10.1186/s13750-021-00246-8"
)

# Known links (fallback in case reading the article page fails)
base_casa <- "https://media.springernature.com/original/springer-static/esm/art%3A10.1186%2Fs13750-026-00390-z/MediaObjects/13750_2026_390_MOESM"
base_adams <- "https://media.springernature.com/original/springer-static/esm/art%3A10.1186%2Fs13750-021-00246-8/MediaObjects/13750_2021_246_MOESM"
fallback <- list(
  casallanovo2026_mata_atlantica = paste0(base_casa,
    c("1_ESM.pdf", "2_ESM.docx", "3_ESM.xlsx", "4_ESM.xlsx",
      "5_ESM.xlsx", "6_ESM.docx", "7_ESM.xlsx")),
  # The Adams article page blocks automated reading (anti-bot challenge).
  # Additional file 14 was not found on the CDN under any common extension.
  adams2021_luz_artificial = paste0(base_adams,
    c("1_ESM.pdf", "2_ESM.docx", "3_ESM.zip", "4_ESM.xlsx",
      "5_ESM.xlsx", "6_ESM.csv", "7_ESM.xlsx", "8_ESM.docx",
      "9_ESM.xlsx", "10_ESM.xlsx", "11_ESM.xlsx", "12_ESM.docx",
      "13_ESM.accdb", "15_ESM.xlsx", "16_ESM.docx"))
)

find_links <- function(url) {
  html <- tryCatch(paste(readLines(url, warn = FALSE), collapse = "\n"),
                   error = function(e) "")
  links <- regmatches(html, gregexpr(
    "https?://[^\"' <>]*MOESM[0-9]+_ESM\\.[A-Za-z0-9]+", html))[[1]]
  unique(gsub("&amp;", "&", links))
}

# Log column names (mapa, arquivo, url, baixado, data) are kept as in the
# existing data/raw/registro_downloads.csv: map, file, url, downloaded, date.
download_log <- data.frame()

for (name in names(maps)) {
  folder <- file.path("data", "raw", name)
  dir.create(folder, recursive = TRUE, showWarnings = FALSE)

  links <- find_links(maps[[name]])
  if (length(links) == 0) links <- fallback[[name]]
  if (length(links) == 0) {
    message("No links found for ", name,
            ". Download by hand from: ", maps[[name]])
    next
  }

  # One link per file (the page sometimes repeats them)
  links <- links[!duplicated(basename(links))]

  for (link in links) {
    dest <- file.path(folder, basename(link))
    ok <- tryCatch({
      download.file(link, dest, mode = "wb", quiet = TRUE)
      TRUE
    }, error = function(e) FALSE)
    message(if (ok) "OK      " else "FAILED  ", dest)
    download_log <- rbind(download_log, data.frame(
      mapa = name, arquivo = basename(link), url = link,
      baixado = ok, data = as.character(Sys.Date())))
  }
}

write.csv(download_log, file.path("data", "raw", "registro_downloads.csv"),
          row.names = FALSE)
message("Done. See data/raw/registro_downloads.csv")
