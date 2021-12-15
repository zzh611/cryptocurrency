rm(list=ls())
args = commandArgs(trailingOnly=TRUE)
if(length(args) == 1){
  process = as.numeric(args[1])
} else {
  cat('usage: Rscript stable.R <file name>\n', file=stderr())
  stop()
}
library(arrow)
data <- read_parquet(paste0(args[1],".parquet"), as_tibble = TRUE)
data1 <- data[which(data$open_time >= '2020-01-01 23:00:00 CST'),]
data1 <- data1[which(data1$open_time <= '2021-01-01 23:00:00 CST'),]
data1$stand <- data1$open/mean(data1$open)
variance <- var(data1$stand)
df <- data.frame("variance" = variance, "file" = args[1])
write.csv(df, paste("csv/",args[1],".csv", sep = ""), row.names = FALSE)

