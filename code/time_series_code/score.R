setwd('/Users/tuoyuaner/Desktop')
library(tidyverse)
choice<-read.table('choices.txt',sep = ',')
combine<-read.table('combine.txt',sep = ',')
jobs<-read.table("1000jobs.txt")
names<-data.frame(matrix(nrow=0,ncol=2))
for (i in 1:1000){
  names[i,]<-strsplit(jobs[i,],'-')[[1]]
}

new_name<-c(names[,1],names[,2])%>%as.data.frame()
names(new_name)<-'name'
new_name<-new_name%>%group_by(name)%>%summarise(n=n())


combine<-combine[,-1]%>%as.data.frame()
combine[combine=='x']<-NA
combine<-na.omit(combine)
dat<-cbind(combine,choice)
names(dat)<-c('diff','choice')
dat$diff<-dat$diff%>%as.numeric()

a<-dat%>%group_by(choice)%>%summarise(count=n())%>%
  filter(count!=1)%>%
  left_join(new_name,by=c('choice'='name'))%>%
  mutate(score=count/n)%>%arrange(-score)




write.csv(a,'score.csv')
