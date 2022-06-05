#install.packages ('e1071', dependencies = TRUE)
library(e1071)

source(file="metrics.r")

#---------------------------------------------
# SVM 
#---------------------------------------------

model_svm_class <- function(x_train, y_train, kernel_arg, degree_arg=3, gamma_arg=1, cost_arg=1) {
  #print(sprintf("kernel_arg: %s ;degree_arg: %s ;gamma_arg: %s ;cost_arg: %s", kernel_arg, degree_arg, gamma_arg, cost_arg))
  
  svm_model <- svm(
    x_train, factor(y_train), 
    type="C-classification", 
    kernel=kernel_arg,
    degree = degree_arg,
    gamma = gamma_arg,
    cost=cost_arg
  )
  return(svm_model)
}
  #pr_svm = predict(svm_model, x_test)
  #t = table(y_test, pr_svm)
  #print(t)
  #print("-------------")
  
model_svm_prob <- function(x_train, y_train, kernel_arg, degree_arg=3, gamma_arg=1, cost_arg=1) {    
  svm_model_probs <- svm(
    x_train, factor(y_train), 
    type="C-classification", 
    kernel=kernel_arg,
    degree = degree_arg,
    gamma = gamma_arg,
    cost=cost_arg,
    probability = TRUE
  )
  
  #pr_svm_probs = predict(svm_model_probs, x_test, probability=TRUE)
  
  return(svm_model_probs)
}




test_svm <- function(dataset, iters_arg = 2, kernel_arg, degree_arg=3, gamma_arg=1, cost_arg=1, plot_sufix = ""){
  
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
    
    svm_class = model_svm_class(x_train, y_train, kernel_arg="linear", degree_arg, gamma_arg, cost_arg)
    svm_prob = model_svm_prob(x_train, y_train, kernel_arg="linear", degree_arg, gamma_arg, cost_arg)
    
    pr_class = predict(svm_class, x_test)
    pr_prob = predict(svm_prob, x_test, probability=TRUE)
    
    pr_prob_tmp = attr(pr_prob, "probabilities")
    pr_prob_tmp2 <- as.data.frame(pr_prob_tmp) 
    pr_prob_spam = pr_prob_tmp2$spam
    
    pr_class_all <- c(pr_class_all, pr_class)
    pr_prob_all <- c(pr_prob_all, pr_prob_spam)
    y_test_all <- c(y_test_all, y_test)
    
  }
  
  
  #print(table(y_test_all, pr_class_all))
  #metrics
  cm = as.matrix(table(y_test_all, pr_class_all))
  r_m = calculateMetrics(cm)
  
  #ROC
  auc = getROC(pr_prob_all, y_test_all, file_sufix = plot_sufix)
  
  out_str = paste(r_m, auc, sep =";")
  fileConn<-file(paste("metrics/metrics_", plot_sufix , ".csv"))
  writeLines(c(out_str), fileConn)
  close(fileConn)
  print("----------")
}



#test_svm(data_embbedings, iters_arg = 1)
#test_svm(data_ngrams, iters_arg = 2)





#-------------------------------
#----------------------------

#pr_tmp_ret = model_svn(x_train,y_train, kernel_arg="linear")
##ROC
#pr_tmp = attr(pr_tmp_ret, "probabilities")
#pr_prob_tmp <- as.data.frame(pr_tmp) 
#pr_prob_spam = pr_prob_tmp$spam
#getROC(pr_prob_spam, y_test)
#
#
##https://medium.com/@myselfaman12345/c-and-gamma-in-svm-e6cee48626be
#kernels = list("linear", "polynomial", "radial", "sigmoid")
#costs = list(0.001, 0.01, 0.1, 1, 10, 100) # (all)
#degrees = list(2, 3, 4, 5, 6) # max 6  (polynominal) #mozna pominac
#gammas = list(0.001, 0.01, 0.1, 1, 10, 100) # (radial)
##------------------
##------linear------
#
#for (val in costs){
#  model_svm(x_train,y_train, kernel_arg="linear", cost_arg=val)
#}
#
#
##------------------
##---polynomial-----
#for (val in degrees){
#  model_svm(x_train,y_train, kernel_arg="polynomial", degree_arg=val)
#}
#
#
##------------------
##------radial------
#for (val in gammas){
#  model_svm(x_train,y_train, kernel_arg="radial", gamma_arg=val)
#}
#
#
##------------------
##------sigmoid-----
#for (val in gammas){
#  model_svm(x_train,y_train, kernel_arg="sigmoid", gamma_arg=val)
#}




#degrees <- c(1,2,3)
#for (val in degrees){
#  assign(paste0("variable_", val), "k")
#}
