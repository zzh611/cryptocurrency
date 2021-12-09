rm(list=ls())

args = (commandArgs(trailingOnly=TRUE))
if(length(args) == 1){
  process = as.numeric(args[1])
} else {
  cat('usage: Rscript hw4.R <template spectrum> <data directory>\n', file=stderr())
  stop()
}

library(forecast)
library(TSA)
library(arrow)
library(zoo)

name<-paste(args[1],'.parquet', sep='')
#每24个小时取一次数据（太密效果巨差)
dat<-read_parquet(name, as_tibble = TRUE)
dat<-na.omit(dat)
x <- dat$open
sep <- seq(from=1, to=length(x), by=1440)
x <- x[sep]
x<-ts(x)

#auto_fit_model
est.white.noise <- function(x){
  p_value = c()
  for (i in 1:2)
  {
    tmp <- Box.test(x, type='Ljung-Box', lag=6*i)
    p_value = append(p_value,tmp[[3]]) 
  }
  if(min(p_value) <= 0.05)
  {
    return(1)
  }
  else 
  {
    return(0)
  }
}

est.model <- function(x)
{
  non.white = est.white.noise(x)
  if(non.white==1)
  {
    auto.model <- auto.arima(x,max.p = 5, max.q = 5,ic = 'aic')
    delta <- auto.model$model$Delta
    phi_length = length(auto.model$model$phi)
    phi = phi_length
    if(phi_length>0)
    {
      for(i in 1:phi_length)
      {
        if(abs(auto.model$model$phi[(phi_length-i+1)])>0)
        {
          break
        }
        else
        {
          phi=phi-1
        }
      }
    }
    theta_length = length(auto.model$model$theta)
    theta = theta_length
    if(theta>0)
    {
      for(i in 1:theta_length)
      {
        if(abs(auto.model$model$theta[(theta_length-i+1)])>0)
        {
          break
        }
        else
        {
          theta=theta-1
        }
      }
    }
    return(arima(x,order = c(phi,delta,theta)))
  }
  else{
    return(0)
  }
}
x.fit = est.model(x) #如果est.model return的是0，说明是白噪声，没有拟合的意义。
fore <- forecast::forecast(x.fit,h = 10)
diff<-fore$mean[10]-fore$mean[1]
stri<-strsplit(args[1],'-')
if(diff>0) write.csv(diff,paste(stri[[1]][2],'_',args[1],'.csv',sep=''))
if(diff<0) write.csv(diff,paste(stri[[1]][1],'_',args[1],'.csv',sep=''))

