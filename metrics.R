library (ROCR)
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
  
  print(cm)
  TP = cm[2,2] #TP
  TN = cm[1,1] #TN
  FP = cm[1,2] #FP
  FN = cm[2,1] #FN
  accuracy = round((sum(diag) / n ), digits =2)
  precision = round((diag / colsums ), digits =2)
  recall = round((diag / rowsums), digits =2)
  
  p_ham = unname(precision)[1]
  p_spam = unname(precision)[2]
  
  r_ham = unname(recall)[1]
  r_spam = unname(recall)[2]
  
  print("accuracy: ")
  print(accuracy)
  print("precision :")
  print(precision)
  print("recall: ")
  print(recall)
  
  m_ret =paste(TP,TN,FP,FN,p_spam, p_ham,r_spam, r_ham, accuracy, sep = ";")
  return(m_ret)
}

#ROC
getROC <-function(pr_probs, labels, file_sufix = ""){
  #pr_prob_tmp <- as.data.frame(probs) 
  #pr_prob = pr_prob_tmp$spam
  
  #pr_labels = as.character(y_test)
  #pr_labels_num = as.numeric(sapply(pr_labels, function(x) if(x == "ham") return(0) else return(1) ))
  
  pred <- prediction(pr_probs, labels)
  perf <- performance(pred, "tpr", "fpr")
  
  # 1. Open jpeg file
  jpeg(paste("plots/roc_plot_", file_sufix, '.jpg', sep = ""), width = 850, height = 850)
  # 3. Close the file
  plot(perf,lwd= 4)
  dev.off()
  
  auc <- performance(pred, measure = "auc")
  auc <- auc@y.values[[1]]
  auc <- round(auc, digits = 3)
  print("AUC:")
  print(auc)
  
  return(auc)
}








