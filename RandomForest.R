library(randomForest)
source(file="load_datasets.r")



#---------------------------------------------
# Random Forest 
#---------------------------------------------

model_rf <- randomForest(x_train, factor(y_train), importance=TRUE, proximity=TRUE) 
pr_forest = predict(model_rf, newdata=x_test, type="response")

table(y_test, pr_forest)



