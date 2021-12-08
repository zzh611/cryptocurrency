library(tensorflow)
library(keras) # for deep learning
library(reticulate)
library(FITSio)
library(arrow)
use_condaenv('r-reticulate')

setwd("D:/courseware/wisconsin/stat 605/final_group_work/")
path <-paste(getwd(),'data',sep ='/')
fileNames <- dir(path)
filePath <- sapply(fileNames, function(x){paste(path,x,sep = '/')})
dat_list <- lapply(filePath, function(x){
  read_parquet(x)})
path_output <- paste(getwd(),'rnn',sep ='/')
plot_output <- paste(getwd(),'plot',sep ='/')
names  <- lapply(fileNames,function(x){gsub(".parquet$","",x)})
residual <- c()
for( j in 1:length(names)){ 
  dat <- dat_list[[j]]
  dat <- dat[(dat$open_time <= "2021-11-01 23:00:00")&(dat$open_time >= "2020-01-01 23:00:00"),]
  dat <- na.omit(dat)
  data <- dat$open
  data_test <- data[round(length(data)*0.8):length(data)]
  data_train <- data[1:(round(length(data)*0.8)-1)]
  maxlen <- 7
  exch_matrix<- matrix(0, nrow = length(data_train)-maxlen-1, ncol = maxlen+1) 
  for(i in 1:(length(data_train)-maxlen-1)){
    exch_matrix[i,] <- data_train[i:(i+maxlen)]
  }
  x_train <- exch_matrix[, -ncol(exch_matrix)]
  y_train <- exch_matrix[, ncol(exch_matrix)]
  x_train <- array_reshape(x_train, dim = c((length(data_train)-maxlen-1), maxlen, 1))
  model <- keras_model_sequential()
  model %>% layer_dense(input_shape = dim(x_train)[-1], units=maxlen)
  model %>% layer_simple_rnn(units= 10)%>%layer_dense(units = 1)
  summary(model)
  model %>% compile(
    loss = "mse",
    optimizer= "adam",
    metric = "mae" 
  )
  history <- model %>% 
    fit(x_train, y_train, epochs = 5, batch_size = 32, validation_split=0.1)
  save_model_name = paste0(path_output,"/",names[[j]],'_rnn_model.h5')
  save_model_hdf5(model, save_model_name)
  rnn_model <- load_model_hdf5(save_model_name)
  maxlen <- 7
  exch_matrix2<- matrix(0, nrow = length(data)-maxlen-1, ncol = maxlen+1) 
  for(i in 1:(length(data)-maxlen-1)){
    exch_matrix2[i,] <- data[i:(i+maxlen)]
  }
  x_train2 <- exch_matrix2[, -ncol(exch_matrix2)]
  y_train2 <- exch_matrix2[, ncol(exch_matrix2)]
  pred <- rnn_model %>% predict(x_train2)
  df_eval_rnn <- tibble::tibble(y_rnn=y_train2[round(length(y_train2)*0.8):length(y_train2)],
                                yhat_rnn=as.vector(pred)[round(length(y_train2)*0.8):length(y_train2)])
  residual <- append(residual,sum(abs(df_eval_rnn$yhat_rnn - df_eval_rnn$y_rnn))/nrow(df_eval_rnn))
  file_path = paste0(plot_output,"/",names[[j]],".jpg")
  png(file=file_path)
  plot(ts(data[1:(round(length(data)*0.8)-1)],start = 1,end=round(length(data)*0.8)-1),ylab ="ratio", main = paste0(names[[j]]," Pair"),ylim=c(min(min(pred),min(data)),max(max(pred),max(data))))
  lines(ts(data[round(length(data)*0.8):length(data)],start=round(length(data)*0.8),end=length(data)),col="blue")
  lines(ts(as.vector(pred)),col="red")
  legend("topleft",legend=c("train data","test data","pred value"),col=c("black","blue","red"),lwd=1) 
  dev.off()
}

