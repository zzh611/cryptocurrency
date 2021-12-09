setwd('/Users/tuoyuaner/Desktop')
library(tidyverse)
choice<-read.table('choices.txt',sep = ',')
combine<-read.table('combine.txt',sep = ',')
combine<-combine[,-1]%>%as.data.frame()
combine[combine=='x']<-NA
combine<-na.omit(combine)
dat<-cbind(combine,choice)
names(dat)<-c('diff','choice')
dat$diff<-dat$diff%>%as.numeric()
a<-dat%>%group_by(choice)%>%summarise(avg=mean(diff), count=n())%>%
  mutate(score=abs(avg*count))%>%arrange(-score)

head(a)
