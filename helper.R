#Helper

url<-"https://dev.api.thomsonreuters.com/eikon/v1/timeseries?X-TR-API-APP-ID=r5LjbEgTGh3ZBYumNIhN8qvut7r9p2oW"
jsquery <- 
  '{
"rics": ["IBM.N"],
"interval": "Daily",
"startdate": "2015-10-03T00:00:00Z",
"enddate": "2015-12-07T23:59:59Z",
"fields":  
["TIMESTAMP","OPEN","HIGH","LOW","CLOSE","VOLUME"]
}'

writedf = function(ticker, n){
  newquery=gsub('"IBM.N"', ticker, jsquery)
  post = POST(url=url, body=newquery, encode='json')
  content=content(post,'text')
  content=substring(content,1)
  content = jsonlite::fromJSON(content)
  df = data.frame(matrix(unlist(content)))
  l = length(df[,1])
  df = df[-(l-13*n+1):-l,]
  df = df[(-1*(n-1)):(-1*n)]
  l2 = length(df)
  ldf=l2/(n*6)
  dfl = list()
  l3=l2/n
  for(j in 1:n){
    dfl[[j]]=data.frame(df[(1+l3*(j-1)):(ldf+l3*(j-1))],df[(ldf+1+l3*(j-1)):(2*ldf+l3*(j-1))],df[(2*ldf+1+l3*(j-1)):(3*ldf+l3*(j-1))],df[(3*ldf+1+l3*(j-1)):(4*ldf+l3*(j-1))],df[(4*ldf+1+l3*(j-1)):(5*ldf+l3*(j-1))],df[(5*ldf+1+l3*(j-1)):(6*ldf+l3*(j-1))])
    names(dfl[[j]]) = c('TIMESTAMP','OPEN','HIGH','LOW','CLOSE','VOLUME')
    wdf = length(dfl[[j]][1,])
    for(i in 2:wdf){
      dfl[[j]][,i] = as.numeric(as.character(dfl[[j]][,i]))
    }
  }
  VolMatrix = matrix(nrow = ldf-19, ncol = n)
  for(i in 1:n){
    for(j in 1:(ldf-19)){
      VolMatrix[j,i]=sd(dfl[[i]][j:(j+19),5])
    }
    VolMatrix = data.frame(VolMatrix)
  }
  for(i in 1:n){
    dfl[[i]]=dfl[[i]][20:ldf,]
    dfl[[i]] = data.frame(dfl[[i]],VolMatrix[,i])
    
  }
  for(i in 1:n){
    names(dfl[[i]]) = c('TIMESTAMP','OPEN','HIGH','LOW','CLOSE','VOLUME','VOLATILITY')
  }
  return(dfl)
}

getnumber<-function(text){
  if (text=='"AAPL.O","IBM.N"') {
    num<-2
  } else if (text=='"IBM.N"') {
    num<-1
  }
  return(num)
}

getlim<-function(datalist,n){
  list<-list()
  for (i in 1:n){
    mins<-sapply(datalist[[i]][,2:7],min)
    maxs<-sapply(datalist[[i]][,2:7],max)
    df<-data.frame(mins,maxs)
    list[[length(list)+1]]<-df
  }
  mindf<-data.frame(list[[1]][,1])
  maxdf<-data.frame(list[[1]][,2])
  for (i in 2:n){
    mindf<-data.frame(mindf,list[[i]][,1])
    maxdf<-data.frame(maxdf,list[[i]][,2])
  }
  minvec<-c()
  maxvec<-c()
  for (j in 1:6){
    minvec[j]<-min(mindf[j,])
    maxvec[j]<-max(maxdf[j,])
  }
  df<-data.frame(minvec,maxvec)
  row.names(df)<-c('OPEN','HIGH','LOW','CLOSE','VOLUME','VOLATILITY')
  return(df)
}
