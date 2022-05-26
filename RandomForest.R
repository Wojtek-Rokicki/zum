library(randomForest)
source(file="load_datasets.r")


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
  t = table(y_test, pr_forest)
  print(t)
  print("-------------")
}

#---------------------------------------------
# Random Forest 
#---------------------------------------------

#  mtry   -> liczba drzwi
#  ntree  -> liczba losowanych atrybutów branych pod uwagê przy podziale w wêŸle
#             default sqrt(p) p - liczba atrybutów

tress_num = list(50, 100, 200, 500)


for (val in tress_num){
  model_forest(x_train,y_train, ntree=val)
}



#model_rf <- randomForest(
#  x_train,
#  factor(y_train), 
#  importance=TRUE, 
#  proximity=TRUE
#) 
#pr_forest = predict(model_rf, newdata=x_test, type="response")
#
#table(y_test, pr_forest)



