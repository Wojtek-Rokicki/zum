library(dplyr)
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

x_train = training[1:300]
y_train = training$class

x_test = testing[1:300]
y_test = testing$class