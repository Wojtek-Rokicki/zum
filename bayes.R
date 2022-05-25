#library(e1071)
#https://rdrr.io/cran/naivebayes/man/gaussian_naive_bayes.html
#load dependencies
library(naivebayes)
library(dplyr)
library(caret)

source(file="load_datasets.r")

#---------------------------------------------
# BAYES 
#---------------------------------------------

#train model
gnb <- gaussian_naive_bayes(x = data.matrix(x_train), y = y_train)
summary(gnb)


#test on training data
pr_train = predict(gnb, newdata = data.matrix(x_train), type = "class")
table(y_train, pr_train)

#test on testing data
pr_test = predict(gnb, newdata = data.matrix(x_test), type = "class")
table(y_test, pr_test)
















