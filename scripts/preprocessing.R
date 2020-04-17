# ladowanie bibliotek
library(tm)

# zmiana katalogu roboczego
workDir <- "C:\\Users\\Michal\\Dropbox\\studia\\IV semestr\\Przetwarzanie języka naturalnego - Katarzyna Wójcik\\R projects\\TextMining11N"
setwd(workDir) #ustawienie katalogu domowego

#lokalizacja katalogów funkcjonalnych
inputDir <- ".\\data" # (. kropka oznacza katalog roboczy)
outputDir <- ".\\results"
dir.create(outputDir, showWarnings = FALSE)


#utworzenie korpusu dokumentów
corpusDir <- paste(
  inputDir,
  "Literatura - streszczenia - oryginal",
  sep = "\\"
)
corpus <- VCorpus(
  DirSource(
    corpusDir,
    pattern = "*.txt",
    encoding = "UTF-8"
  ),
  readerControl = list(
    language = "pl_PL"
  )
)

#wstępne przetwarzanie
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, content_transformer(tolower))


stopListFile <- paste(
  inputDir,
  "stopwords_pl.txt",
  sep = "\\"
)
stopList <- readLines(stopListFile, encoding = "UTF-8")
corpus <- tm_map(corpus, removeWords, stopList)
corpus <- tm_map(corpus, stripWhitespace)

writeLines(character())


#usunięcie z tekstów em dash i 3/4
removeChar <- content_transformer(function(text, pattern) gsub(pattern, "", text))
corpus <- tm_map(corpus, removeChar, intToUtf8(8722))
corpus <- tm_map(corpus, removeChar, intToUtf8(190))

#usunięcie rozszerzeń z nazw dokumentów
cutExtensions <- function(document, extension) {
  meta(document, "id") <- gsub(paste("\\.", extension, "$", sep=""),"", meta(document, "id"))
  return(document)
}
corpus <- tm_map(corpus, cutExtensions, "txt")

#usunięcie podziału na akapity z tekstu
pasteParagraphs <- content_transformer(function(text, char) paste(text, collapse = char))
corpus <- tm_map(corpus, pasteParagraphs, " ")


