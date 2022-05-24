#library(e1071)
#https://rdrr.io/cran/naivebayes/man/gaussian_naive_bayes.html
library(naivebayes)
library(dplyr)
library(caret)
library(Matrix)
#load datasets
spam_embbedings_300 <- read.csv("spam_embbedings_300.csv", header=FALSE, encoding = "UTF-8")
names(spam_embbedings_300)[length(names(spam_embbedings_300))]<-"class" 

e_ham_embbedings_300 <- read.csv("easy_ham_embbedings_300.csv", header=FALSE, encoding = "UTF-8")
names(e_ham_embbedings_300)[length(names(e_ham_embbedings_300))]<-"class" 

h_ham_embbedings_300 <- read.csv("hard_ham_embbedings_300.csv", header=FALSE, encoding = "UTF-8")
names(h_ham_embbedings_300)[length(names(h_ham_embbedings_300))]<-"class" 


#join data
df = rbind(spam_embbedings_300,e_ham_embbedings_300,h_ham_embbedings_300)

df %>%group_by(class) %>%summarise(n = n()) %>%mutate(Freq = n/sum(n))


#split into test and train
intrain <- createDataPartition(y = df$class, p= 0.7, list = FALSE)
training <- df[intrain,]
testing <- df[-intrain,]

#show stats of datasets

training %>%group_by(class) %>%summarise(n = n()) %>%mutate(Freq = n/sum(n))
testing %>%group_by(class) %>%summarise(n = n()) %>%mutate(Freq = n/sum(n))


#train model
x_train = training[1:300]
y_train = training$class


gnb <- gaussian_naive_bayes(x = data.matrix(x_train), y = y_train)
summary(gnb)


#test model
pr = predict(gnb, newdata = data.matrix(x_train), type = "class")


table(y_train, pr)










