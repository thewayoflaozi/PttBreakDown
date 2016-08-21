library(xml2)
library(XML)
library(httr)
library(RCurl)

data <- list()

# Sys.setlocale(category='LC_ALL', locale='C')

for( i in 3090:3099){
  
  tmp <- paste(i, '.html', sep='')
  url <- paste('www.ptt.cc/bbs/StupidClown/index', tmp, sep='')
  html <- htmlParse(GET(url),encoding="UTF8")
  #html <- htmlParse(getURL(url))
  #url.list <- xpathSApply(html, "//div[@class='title']/a[@href]", xmlAttrs)
  url.list <- xpathSApply(html, "//div[@class='title']/a[@href]", xmlAttrs)
  #name <- strsplit(url, '/')[[1]][4]
  #write(doc, gsub('html', 'txt', name))
  data <- rbind(data, paste('www.ptt.cc', url.list, sep=''))
  Sys.sleep(ceiling(runif(1,5,10)))
  }
# mode(data)
# str(data)
# data[1]
# 
# for(i in 1:length(data)){
#   i=1
#   html <- htmlParse(GET(data[i]),encoding="UTF8")
#   html.content <- xpathSApply(html, "//div[@id='main-content']",  xmlValue)
# }
# html.content

getdoc <- function(line){
    url <- toString(line)
    #html <- htmlParse(getURL(url), encoding='UTF-8')
    html <- htmlParse(GET(url),encoding="UTF8")
    html.date<-xpathSApply(html,"//*[@id='main-content']/div[4]/span[2]",xmlValue)
    html.title<-xpathSApply(html,"//*[@id='main-content']/div[3]/span[2]",xmlValue)
    html.content <- xpathSApply(html, "//*[@id='main-content']/text()",  xmlValue)
    html.comment<-xpathSApply(html, "//*[@id='main-content']/div[@class='push']/span[@class='f3 push-content']",  xmlValue)
    #html.comments<-paste(html.comment[1:],sep='')
# TEST<- toString(html.comment)
    html.date.sep<-read.table(textConnection(html.date), header=F, sep=" ")
    result<-paste(html.title,html.content,toString(html.comment))
    result
    filename<-paste(html.date.sep[5],toString(html.date.sep[[2]]),html.date.sep[3],sep='')
    # xml <- xmlTree()
    # xml$addTag("article",close=FALSE)
    # xml$addTag("title", html.date)
    # #xml$closeTag()
    # xml$addTag("content", html.content)
    # #xm
    #l$closeTag()
    # xml$addTag("comment", html.comment)
    # #xml$closeTag()
    # xml$closeTag()
    # #    xml
    write(result,file=filename,append = TRUE)
    Sys.sleep(ceiling(runif(1,6,10)))
}
# Sys.setlocale(category = "LC_ALL", locale = "English_United States.1252")

sapply(data, getdoc)  
