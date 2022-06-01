library(randomForest)

source(file="metrics.r")

model_forest <- function(x_train, y_train, ntree_arg, mtry_arg) {
  print(sprintf("ntree_arg: %s", ntree_arg))
  
  model_rf <- randomForest(
    x_train,
    factor(y_train), 
    importance=TRUE, 
    proximity=TRUE,
    ntree=ntree_arg,
    mtry=mtry_arg
  ) 

  return(model_rf)
}


#mtry_arg - def. sqrt(p)
test_forest <- function(dataset, mtry_arg, iters_arg = 2, ntree_arg = 50){
  
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
    
    rfm = model_forest(x_train, y_train, ntree_arg, mtry_arg)
    
    pr_class = predict(rfm, newdata=x_test, type="response")
    pr_prob = predict(rfm, newdata=x_test, type="prob")
    
    pr_prob_tmp <- as.data.frame(pr_prob) 
    pr_prob_spam = pr_prob_tmp$spam
    
    pr_class_all <- c(pr_class_all, pr_class)
    pr_prob_all <- c(pr_prob_all, pr_prob_spam)
    y_test_all <- c(y_test_all, y_test)
    
  }
  
  
  print(table(y_test_all, pr_class_all))
  #metrics
  cm = as.matrix(table(y_test_all, pr_class_all))
  calculateMetrics(cm)
  
  #ROC
  getROC(pr_prob_all, y_test_all)
}

test_forest(data_embbedings, mtry_arg=sqrt(300), iters_arg = 5, ntree_arg=200)
test_forest(data_ngrams, mtry_arg=sqrt(15454) , iters_arg = 5)


#---------------------------------------------
# Random Forest 
#---------------------------------------------

#  mtry   -> liczba drzew
#  ntree  -> liczba losowanych atrybut?w branych pod uwag? przy podziale w w??le
#             default sqrt(p) p - liczba atrybut?w

#tress_num = list(50, 100, 200, 500)


#pr_probs = model_forest(x_train,y_train, ntree=50)








