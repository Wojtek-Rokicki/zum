#library (ROCR)
#
#get 
#y1 <- factor(c("spam","spam","spam","ham"))
#y2 <- factor(c("spam","spam","spam","spam"))
#y1 <- factor(y1, levels = c("ham", "spam"))
#y2 <- factor(y2, levels = c("ham", "spam"))
#y1_u <- unclass(y1)
#y2_u <- unclass(y2)
#y1_n <- as.numeric(y1_u)
#y2_n <- as.numeric(y2_u)
#
#pred <- prediction(y1_n, y2_n)
#data(ROCR.simple)

#---------metrics
#cm -> confusion matrix 
calculateMetrics <-function(cm){
  n = sum(cm) # number of instances
  nc = nrow(cm) # number of classes
  diag = diag(cm) # number of correctly classified instances per class 
  rowsums = apply(cm, 1, sum) # number of instances per class
  colsums = apply(cm, 2, sum) # number of predictions per class
  p = rowsums / n # distribution of instances over the actual classes
  q = colsums / n # distribution of instances over the predicted classes
  
  accuracy = round((sum(diag) / n ), digits =2)
  precision = round((diag / colsums ), digits =2)
  recall = round((diag / rowsums), digits =2)
  print("accuracy: ")
  print(accuracy)
  print("precision :")
  print(precision)
  print("recall: ")
  print(recall)
}
