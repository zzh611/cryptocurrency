library(forecast)
library(arrow)
library(zoo)
library(tensorflow)
library(keras) # for deep learning
library(reticulate)
use_condaenv('r-reticulate')

#每24个小时取一次数据（太密效果巨差）
setwd("D:/courseware/wisconsin/stat 605/final_group_work/data")
dat<-read_parquet("ADA-BTC.parquet", as_tibble = TRUE)
dat <- na.omit(dat)
dat <- dat[(dat$open_time <= "2021-11-01 23:00:00")&(dat$open_time >= "2020-01-01 23:00:00"),]
##这里进行了更改
if(nrow(dat)<30000)
{
  stop("data length is not enough")
}

dat <- na.omit(dat)
x <- dat$open[seq(from=1, to=nrow(dat), by=1440)]
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
    delta <- auto.model$model$Delta[1]  ##这里进行了更改
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
if(length(x.fit) > 1)
{
  fore <- forecast::forecast(x.fit,h = 10);fore
  png(file=file_path) #这里设置图片的输出地址
  #par(mfrow=c(1,1))
  plot(fore)
  lines(fore$fitted,col="red",lty = 2)
  legend("topleft",legend=c("train data","test data","pred value"),col=c("black","blue","red"),lty = c(1,2),lwd=1)
  #dev.off()
}
