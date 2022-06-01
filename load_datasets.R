library(caret)
library(dplyr)
#library(modelr)

#load datasets
#-------------embbedings
spam_embbedings_300 <- read.csv("embbedings/spam_embbedings_300.csv", header=FALSE, encoding = "UTF-8")
names(spam_embbedings_300)[length(names(spam_embbedings_300))]<-"class" 

e_ham_embbedings_300 <- read.csv("embbedings/easy_ham_embbedings_300.csv", header=FALSE, encoding = "UTF-8")
names(e_ham_embbedings_300)[length(names(e_ham_embbedings_300))]<-"class" 

h_ham_embbedings_300 <- read.csv("embbedings/hard_ham_embbedings_300.csv", header=FALSE, encoding = "UTF-8")
names(h_ham_embbedings_300)[length(names(h_ham_embbedings_300))]<-"class" 


#join data
data_embbedings = rbind(spam_embbedings_300,e_ham_embbedings_300,h_ham_embbedings_300)

data_embbedings %>%group_by(class) %>%summarise(n = n()) %>%mutate(Freq = n/sum(n))

df = data_embbedings
#
#
##split into test and train
intrain <- createDataPartition(y = df$class, p= 0.7, list = FALSE)
training <- df[intrain,]
testing <- df[-intrain,]

#show stats of datasets

training %>%group_by(class) %>%summarise(n = n()) %>%mutate(Freq = n/sum(n))
testing %>%group_by(class) %>%summarise(n = n()) %>%mutate(Freq = n/sum(n))

x_train = training[1:300]
y_train = training$class

x_test = testing[1:300]
y_test = testing$class
#
#x_all = df[1:(length(df)-1)]
#y_all = df$class

#cv_embb  <- crossv_kfold(df, k = 5)
#
#for (cv_data in cv_embb) {
#  print(typeof(cv_data))
#  print(head(cv_data))
#  print("-----")
#}
