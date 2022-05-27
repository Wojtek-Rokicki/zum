#install.packages ('e1071', dependencies = TRUE)
library(e1071)
source(file="load_datasets.r")

#---------------------------------------------
# SVN 
#---------------------------------------------

model_svn <- function(x_train, y_train, kernel_arg, degree_arg=3, gamma_arg=1, cost_arg=1) {
  print(sprintf("kernel_arg: %s ;degree_arg: %s ;gamma_arg: %s ;cost_arg: %s", kernel_arg, degree_arg, gamma_arg, cost_arg))
  
  svm_model <- svm(
    x_train, factor(y_train), 
    type="C-classification", 
    kernel=kernel_arg,
    degree = degree_arg,
    gamma = gamma_arg,
    cost=cost_arg
  )
  pr_svm = predict(svm_model, x_test)
  t = table(y_test, pr_svm)
  print(t)
  print("-------------")
}

#https://medium.com/@myselfaman12345/c-and-gamma-in-svm-e6cee48626be
kernels = list("linear", "polynomial", "radial", "sigmoid")
costs = list(0.001, 0.01, 0.1, 1, 10, 100) # (all)
degrees = list(2, 3, 4, 5, 6) # max 6  (polynominal) #mo¿na pomin¹æ
gammas = list(0.001, 0.01, 0.1, 1, 10, 100) # (radial)
#------------------
#------linear------

for (val in costs){
  model_svn(x_train,y_train, kernel_arg="linear", cost_arg=val)
}


#------------------
#---polynomial-----
for (val in degrees){
  model_svn(x_train,y_train, kernel_arg="polynomial", degree_arg=val)
}


#------------------
#------radial------
for (val in gammas){
  model_svn(x_train,y_train, kernel_arg="radial", gamma_arg=val)
}


#------------------
#------sigmoid-----
for (val in gammas){
  model_svn(x_train,y_train, kernel_arg="sigmoid", gamma_arg=val)
}




#degrees <- c(1,2,3)
#for (val in degrees){
#  assign(paste0("variable_", val), "k")
#}
