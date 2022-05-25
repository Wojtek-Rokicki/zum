library (ROCR)

pred <- prediction(predictions, y);

# Recall-Precision curve             
RP.perf <- performance(pred, "prec", "rec");

plot (RP.perf);

# ROC curve
ROC.perf <- performance(pred, "tpr", "fpr");
plot (ROC.perf);

# ROC area under the curve
auc.tmp <- performance(pred,"auc");
auc <- as.numeric(auc.tmp@y.values)
