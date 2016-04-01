#Shiny Server

source("helper.R")

shinyServer(function(input,output,session){
  library(httr)
  library(jsonlite)
# num<-reactive({getnumber(input$ticker)})
  colorvector<-c("chocolate4","cornflowerblue","cyan1","brown","bisque3","darkmagenta","forestgreen","gold","darksalmon","darkseagreen2")
  list<-reactive({writedf(input$ticker,10)})
  minmax<-reactive({getlim(list(),10)})
  output$plot1<-renderPlot({
    plot(list()[[1]][(length(list()[[1]][,1])-20+input$ts),c(input$xcol,input$ycol)],xlim=unlist(minmax()[input$xcol,]),ylim=unlist(minmax()[input$ycol,]),col=colorvector[1],pch=19,cex=3)
    for (i in 2:10) {
      points(list()[[i]][(length(list()[[1]][,1])-20+input$ts),c(input$xcol,input$ycol)],col=colorvector[i],pch=19,cex=3)
    }
  })
})