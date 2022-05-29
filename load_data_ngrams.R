library(caret)
library(dplyr)
#-----------unigrams
spam_uni <- read.csv("spam_freq_vec_uni.csv", header=FALSE, encoding = "UTF-8")
names(spam_uni)[length(names(spam_uni))]<-"class" 

e_ham_uni <- read.csv("easy_ham_freq_vec_uni.csv", header=FALSE, encoding = "UTF-8")
names(e_ham_uni)[length(names(e_ham_uni))]<-"class" 

h_ham_uni <- read.csv("hard_ham_freq_vec_uni.csv", header=FALSE, encoding = "UTF-8")
names(h_ham_uni)[length(names(h_ham_uni))]<-"class" 


#join data
df_n = rbind(spam_uni,e_ham_uni,h_ham_uni)

df_n %>%group_by(class) %>%summarise(n = n()) %>%mutate(Freq = n/sum(n))


#split into test and train
intrain_n <- createDataPartition(y = df_n$class, p= 0.7, list = FALSE)
training_n <- df_n[intrain_n,]
testing_n <- df_n[-intrain_n,]

#show stats of datasets

training_n %>%group_by(class) %>%summarise(n = n()) %>%mutate(Freq = n/sum(n))
testing_n %>%group_by(class) %>%summarise(n = n()) %>%mutate(Freq = n/sum(n))

x_train = training_n[1:34920]
y_train = training_n$class

x_test = testing_n[1:34920]
y_test = testing_n$class
