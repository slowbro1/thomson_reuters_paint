#Shiny UI

params<-c("OPEN","HIGH","LOW","CLOSE","VOLUME","VOLATILITY")
tickers<-c('"AAPL.O","IBM.N"','"MSFT.O","FB.O"')
tickers<-c('"NXPI.O","TXN.O","SWKS.O","SYMC.O","CTSH.O","STX.O","NTES.O","AMAT.O","MU.O","NVDA.O"','"INTU.O","LRCX.O","ADI.O","CTXS.O","XLNX.O","ADSK.O","MXIM.O","CERN.O","LLTC.O","CHKP.O"','"AKAM.O","CA.O","NTAP.O","GOOG.O","GOOGL.O","CMCSA.O","AVGO.O","WBA.O","ENDP.O","MYL.O"')
shinyUI(pageWithSidebar(
  headerPanel("Thomson-Reuters Paint"),
  sidebarPanel(
    selectInput("ticker","Tickers",tickers),
    selectInput("xcol","X Axis",params,selected=params[5]),
    selectInput("ycol","Y Axis",params,selected=params[6]),
    sliderInput("ts","Timesteps (days):",min=0,max=20,value=0)
  ),
  mainPanel(
    plotOutput("plot1"),
    helpText("Thomson-Reuters Paint by Cheng Guo, Sahib Singh, Ruitao Wang and Yibing Xie. This APP is built using R Shiny and the Thomson-Reuters API courtesy of LehighHacks, and we used httr and jsonlite packages.")
  )
))