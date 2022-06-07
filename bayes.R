#library(e1071)
#https://rdrr.io/cran/naivebayes/man/gaussian_naive_bayes.html
#load dependencies
library(naivebayes)
library(caret)


#source(file="load_datasets.r")
source(file="metrics.r")
source(file="utils.r")

#---------------------------------------------
# BAYES 
#---------------------------------------------

model_bayes <- function(x_train_arg, y_train_arg, laplace_arg = 0){
  gnb <- gaussian_naive_bayes(
    x = data.matrix(x_train_arg),
    y = y_train_arg,
    laplace=laplace_arg
  )
  return(gnb)
}


test_bayes <- function(dataset, iters_arg = 2, laplace_arg = 0, plot_sufix = ""){
  
  pr_prob_all = c()
  pr_class_all = c()
  y_test_all = c()
  
  iters = seq(1, iters_arg, by=1)
  for(i in iters){
    print(i)
    #genrate new split
    d_sets = splitTrainTest(dataset)
    x_train = d_sets[[1]]
    x_test = d_sets[[2]]
    y_train = d_sets[[3]]
    y_test = d_sets[[4]]
    
    gnb = model_bayes(x_train, y_train)
    pr_class = predict(gnb, newdata = data.matrix(x_test), type = "class")
    pr_prob = predict(gnb, newdata = data.matrix(x_test), type = "prob")

    pr_prob_tmp <- as.data.frame(pr_prob) 
    pr_prob_spam = pr_prob_tmp$spam
      
    pr_class_all <- c(pr_class_all, pr_class)
    pr_prob_all <- c(pr_prob_all, pr_prob_spam)
    y_test_all <- c(y_test_all, y_test)
    
  }
  
  print(plot_sufix)
  #print(table(y_test_all, pr_class_all))
  #metrics
  cm = as.matrix(table(y_test_all, pr_class_all))
  r_m = calculateMetrics(cm)
  
  #ROC
  auc = getROC(pr_prob_all, y_test_all, file_sufix = plot_sufix)
  
  out_str = paste(r_m, auc, sep =";")
  fileConn<-file(paste("metrics/metrics_", plot_sufix , ".csv", sep=""))
  writeLines(c(out_str), fileConn)
  close(fileConn)
  print("----------")
}

#test_bayes(data_embbedings, iters_arg = 1,plot_sufix="test")
#test_bayes(data_ngrams, iters_arg = 15)


##train model
#gnb <- gaussian_naive_bayes(x = data.matrix(x_train), y = y_train, laplace=2)
##summary(gnb)
#
#
##test on training data
#pr_train = predict(gnb, newdata = data.matrix(x_train), type = "class")
#table(y_train, pr_train)
#
##test on testing data
#pr_test = predict(gnb, newdata = data.matrix(x_test), type = "class")
#pr_test_prob = predict(gnb, newdata = data.matrix(x_test), type = "prob")
#
#cm = as.matrix(table(y_test, pr_test))
#calculateMetrics(cm)
#
#
##ROC 
#pr_prob_tmp <- as.data.frame(pr_test_prob) 
#pr_prob_spam = pr_prob_tmp$spam
#getROC(pr_prob_spam, y_test)
#



















