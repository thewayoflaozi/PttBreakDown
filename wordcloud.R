

#Rwordseg and tmcn need to be download from forg (zip for windows!)
library(tm)
library(tmcn)
library(Rwordseg)
## Version: 0.2-1
##NOT RUN
# if(FALSE){
# 警告訊息：
# package ‘Rwordseg’ was built under R version 3.0.2 
# }
setwd('path自己改')
d.corpus <- Corpus(DirSource("pttstupid"), list(language = NA))

d.corpus <- tm_map(d.corpus, removePunctuation)
d.corpus <- tm_map(d.corpus, removeNumbers)
d.corpus <- tm_map(d.corpus, function(word) {
  gsub("[A-Za-z0-9]", "", word)
})
#?gsub
# 進行中文斷詞
# 首先，由於ptt有自己獨特的詞彙，例如發文不附沒圖、沒圖沒真相…等等，因此我們另外安裝 ptt 常用詞彙來協助斷詞。ptt常用詞彙
# words <- readLines("http://wubi.sogou.com/dict/download_txt.php?id=9182")
# words <- toTrad(words)
# insertWords(words)
#背後是JAVAANSJ斷辭
d.corpus <- tm_map(d.corpus[1:100], segmentCN, nature = TRUE)
d.corpus <- tm_map(d.corpus, function(sentence) {
  noun <- lapply(sentence, function(w) {
    w[names(w) == "n"]
  })
  unlist(noun)
})
d.corpus <- Corpus(VectorSource(d.corpus))

#停用辭處理
myStopWords <- c(stopwordsCN(), "編輯", "時間", "標題", "發信", "實業", "作者")
d.corpus <- tm_map(d.corpus, removeWords, myStopWords)

#看有哪些停用辭
head(myStopWords, 20)

tdm <- TermDocumentMatrix(d.corpus, control = list(wordLengths = c(2, Inf)))

#TF
#inspect(tdm[1:10, 1:2])
#http://stackoverflow.com/questions/15031338/subscript-out-of-bounds-general-definition-and-solution
library(wordcloud)
1
m1 <- as.matrix(tdm)
v <- sort(rowSums(m1), decreasing = TRUE)
d <- data.frame(word = names(v), freq = v)
wordcloud(d$word, d$freq, min.freq = 10, random.order = F, ordered.colors = F, 
          colors = rainbow(length(row.names(m1))))

