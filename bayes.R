#library(e1071)
#https://rdrr.io/cran/naivebayes/man/gaussian_naive_bayes.html
#load dependencies
library(naivebayes)
library(caret)
library (ROCR)

source(file="load_datasets.r")
source(file="metrics.r")

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
pr_test_prob = predict(gnb, newdata = data.matrix(x_test), type = "prob")

cm = as.matrix(table(y_test, pr_test))
calculateMetrics(cm)


#ROC 
pr_prob_tmp <- as.data.frame(pr_test_prob) 
pr_prob = pr_prob_tmp$spam

pr_labels = as.character(y_test)
#pr_labels_num = as.numeric(sapply(pr_labels, function(x) if(x == "ham") return(0) else return(1) ))



pred <- prediction(pr_prob, y_test)

perf <- performance(pred, "tpr", "fpr")

plot(perf, colorize=TRUE,lwd= 5)
 












