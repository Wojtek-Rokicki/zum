library(randomForest)
source(file="load_datasets.r")
source(file="metrics.r")

model_forest <- function(x_train, y_train, ntree_arg) {
  print(sprintf("ntree_arg: %s", ntree_arg))
  
  model_rf <- randomForest(
    x_train,
    factor(y_train), 
    importance=TRUE, 
    proximity=TRUE,
    ntree=ntree_arg
  ) 
  pr_forest = predict(model_rf, newdata=x_test, type="response")
  pr_forest_probs = predict(model_rf, newdata=x_test, type="prob")
  t = table(y_test, pr_forest)
  print(t)
  print("-------------")
  
  return(pr_forest_probs)
}


#---------------------------------------------
# Random Forest 
#---------------------------------------------

#  mtry   -> liczba drzew
#  ntree  -> liczba losowanych atrybut?w branych pod uwag? przy podziale w w??le
#             default sqrt(p) p - liczba atrybut?w

tress_num = list(50, 100, 200, 500)


pr_probs = model_forest(x_train,y_train, ntree=50)


#ROC 
pr_prob_tmp <- as.data.frame(pr_probs) 
pr_prob_spam = pr_prob_tmp$spam
getROC(pr_prob_spam, y_test)


#for (val in tress_num){
#  model_forest(x_train,y_train, ntree=val)
#}






