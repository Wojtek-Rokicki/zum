library(caret)
library(dplyr)
#-----------unigrams
spam_uni <- read.csv("spam_freq_vec_uni_en.csv", header=FALSE, encoding = "UTF-8")
names(spam_uni)[length(names(spam_uni))]<-"class" 

ham_uni <- read.csv("ham_freq_vec_uni_en.csv", header=FALSE, encoding = "UTF-8")
names(ham_uni)[length(names(ham_uni))]<-"class" 


#join data
df_n = rbind(spam_uni,ham_uni)

df_n %>%group_by(class) %>%summarise(n = n()) %>%mutate(Freq = n/sum(n))


#split into test and train
intrain_n <- createDataPartition(y = df_n$class, p= 0.7, list = FALSE)
training_n <- df_n[intrain_n,]
testing_n <- df_n[-intrain_n,]

#show stats of datasets

training_n %>%group_by(class) %>%summarise(n = n()) %>%mutate(Freq = n/sum(n))
testing_n %>%group_by(class) %>%summarise(n = n()) %>%mutate(Freq = n/sum(n))

x_train = training_n[1:(length(training_n)-1)]
y_train = training_n$class

x_test = testing_n[1:(length(testing_n)-1)]
y_test = testing_n$class
