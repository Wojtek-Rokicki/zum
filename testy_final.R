
source(file="bayes.R")
source(file="svn.R")
source(file="RandomForest.R")




class = data_ngrams_15$class


#ograniczanie reprezentacji - usuwanie najczęstszych i najrzadszych unigramów
#atrybuty w wektorach posortowane od najczestszego unigramu
data_15_max  = cbind(data_ngrams_15[1:4053], class) 
data_49_max  = cbind(data_ngrams_15[1:1984], class) 
data_122_max = cbind(data_ngrams_15[1:1000], class) 
data_251_max = cbind(data_ngrams_15[1:502], class) 

data_15_251  = cbind(data_ngrams_15[499:4053], class)
data_15_122  = cbind(data_ngrams_15[993:4053], class)
data_49_251  = cbind(data_ngrams_15[499:2010], class)


ITERS_CNT = 15


test_bayes(data_15_max,  iters_arg = ITERS_CNT, plot_sufix = 'bayes_data_15_max')
test_bayes(data_49_max,  iters_arg = ITERS_CNT, plot_sufix = 'bayes_data_49_max')
test_bayes(data_122_max, iters_arg = ITERS_CNT, plot_sufix = 'bayes_data_122_max')
test_bayes(data_251_max, iters_arg = ITERS_CNT, plot_sufix = 'bayes_data_251_max')

test_bayes(data_15_251,  iters_arg = ITERS_CNT, plot_sufix = 'bayes_data_15_251')
test_bayes(data_15_122,  iters_arg = ITERS_CNT, plot_sufix = 'bayes_data_15_122')
test_bayes(data_49_251,  iters_arg = ITERS_CNT, plot_sufix = 'bayes_data_49_251')

test_bayes(data_embbedings,  iters_arg = ITERS_CNT, plot_sufix = 'bayes_embb')


kernels = list("linear", "radial", "sigmoid")
costs = list(0.01, 0.1, 1, 10) # (all)
#degrees = list(2, 3, 5) # max 6  (polynominal) #mozna pominac
gammas = list(0.01, 0.1, 1) # (radial, sigmoid)


#cost param
for(k in kernels){
  for(c in cost){
    test_svm(data_15_max,  iters_arg = ITERS_CNT, kernel_arg = k, cost_arg= c, plot_sufix = 'svm_data_15_max')
    test_svm(data_49_max,  iters_arg = ITERS_CNT, kernel_arg = k, cost_arg= c, plot_sufix = 'svm_data_49_max')
    test_svm(data_122_max, iters_arg = ITERS_CNT, kernel_arg = k, cost_arg= c, plot_sufix = 'svm_data_122_max')
    test_svm(data_251_max, iters_arg = ITERS_CNT, kernel_arg = k, cost_arg= c, plot_sufix = 'svm_data_251_max')
    test_svm(data_15_251,  iters_arg = ITERS_CNT, kernel_arg = k, cost_arg= c, plot_sufix = 'svm_data_15_251')
    test_svm(data_15_122,  iters_arg = ITERS_CNT, kernel_arg = k, cost_arg= c, plot_sufix = 'svm_data_15_122')
    test_svm(data_49_251,  iters_arg = ITERS_CNT, kernel_arg = k, cost_arg= c, plot_sufix = 'svm_data_49_251')
    
    test_svm(data_embbedings,  iters_arg = ITERS_CNT, kernel_arg = k, cost_arg= c, plot_sufix = 'svm_embb')
  }
}

for(k in list("radial", "sigmoid")){
  #for(g in gammas){
  for(g in list(10)){
    test_svm(data_15_max,  iters_arg = ITERS_CNT, kernel_arg = k, gamma_arg= g, plot_sufix =paste('svm_data_15_max',  k, "g", g , sep = ""))
    test_svm(data_49_max,  iters_arg = ITERS_CNT, kernel_arg = k, gamma_arg= g, plot_sufix =paste('svm_data_49_max',  k, "g", g , sep = ""))
    test_svm(data_122_max, iters_arg = ITERS_CNT, kernel_arg = k, gamma_arg= g, plot_sufix =paste('svm_data_122_max',  k, "g", g , sep = ""))
    test_svm(data_251_max, iters_arg = ITERS_CNT, kernel_arg = k, gamma_arg= g, plot_sufix =paste('svm_data_251_max',  k, "g", g , sep = ""))
    test_svm(data_15_251,  iters_arg = ITERS_CNT, kernel_arg = k, gamma_arg= g, plot_sufix =paste('svm_data_15_251',  k, "g", g , sep = ""))
    test_svm(data_15_122,  iters_arg = ITERS_CNT, kernel_arg = k, gamma_arg= g, plot_sufix =paste('svm_data_15_122',  k, "g", g , sep = ""))
    test_svm(data_49_251,  iters_arg = ITERS_CNT, kernel_arg = k, gamma_arg= g, plot_sufix =paste('svm_data_49_251',  k, "g", g , sep = ""))
    
    test_svm(data_embbedings,  iters_arg = ITERS_CNT, kernel_arg = k, gamma_arg= g, plot_sufix = paste('svm_embb_',  k, "g", g , sep = ""))
  }
}

ntrees = list(50, 200, 500)

f1 <- function(x){return(sqrt(length(x))/2)}
f2 <- function(x){return(sqrt(length(x)))}
f3 <- function(x){return(sqrt(length(x))*sqrt(length(x))/2)}

nattributes_factors = list(f1, f2, f3)

for(nt in ntrees){
  for(f in nattributes_factors){
    test_forest(data_15_max,  mtry_arg = f(length(data_15_max)-1),   iters_arg = ITERS_CNT, ntree_arg = nt, plot_sufix = paste('forest_data_15_max' , "_", nt, "nt_", f(length(data_15_max)-1), "natr_", sep=""))
    test_forest(data_49_max,  mtry_arg = f(length(data_49_max)-1),   iters_arg = ITERS_CNT, ntree_arg = nt, plot_sufix = paste('forest_data_49_max' , "_", nt, "nt_", f(length(data_49_max)-1), "natr_", sep=""))
    test_forest(data_122_max, mtry_arg = f(length(data_122_max)-1), iters_arg = ITERS_CNT, ntree_arg = nt,  plot_sufix = paste('forest_data_122_max', "_", nt, "nt_", f(length(data_122_max)-1), "natr_", sep=""))
    test_forest(data_251_max, mtry_arg = f(length(data_251_max)-1), iters_arg = ITERS_CNT, ntree_arg = nt,  plot_sufix = paste('forest_data_251_max', "_", nt, "nt_", f(length(data_251_max)-1), "natr_", sep=""))
    test_forest(data_15_251,  mtry_arg = f(length(data_15_251)-1),   iters_arg = ITERS_CNT, ntree_arg = nt, plot_sufix = paste('forest_data_15_251' , "_", nt, "nt_", f(length(data_15_251)-1), "natr_", sep=""))
    test_forest(data_15_122,  mtry_arg = f(length(data_15_122)-1),   iters_arg = ITERS_CNT, ntree_arg = nt, plot_sufix = paste('forest_data_15_122' , "_", nt, "nt_", f(length(data_15_122)-1), "natr_", sep=""))
    test_forest(data_49_251,  mtry_arg = f(length(data_49_251)-1),   iters_arg = ITERS_CNT, ntree_arg = nt, plot_sufix = paste('forest_data_49_251' , "_", nt, "nt_", f(length(data_49_251)-1), "natr_", sep=""))
    
    test_forest(data_embbedings, mtry_arg = f(length(data_49_251)-1),   iters_arg = ITERS_CNT, ntree_arg = nt, plot_sufix = 'forest_embb')
  }
}








ntrees = list(50)

f1 <- function(x){return(sqrt(length(x)-1)/2)}
f2 <- function(x){return(sqrt(length(x)-1))}
f3 <- function(x){return(sqrt(length(x)-1)*sqrt(length(x))/2)}

nattributes_factors = list(f1, f2, f3)

ITERS_CNT = 10

for(nt in ntrees){
  for(f in nattributes_factors){
    #test_forest(data_15_max,  mtry_arg = f(length(data_15_max)-1),   iters_arg = ITERS_CNT, ntree_arg = nt, plot_sufix = paste('forest_data_15_max' , "_", nt, "nt_", f(length(data_15_max)-1), "natr_", sep=""))
    #test_forest(data_49_max,  mtry_arg = f(data_49_max),   iters_arg = ITERS_CNT, ntree_arg = nt, plot_sufix = paste('forest_data_49_max' , "_", nt, "nt_", f(data_49_max), "natr_", sep=""))
    test_forest(data_122_max, mtry_arg = f(data_122_max), iters_arg = ITERS_CNT, ntree_arg = nt,  plot_sufix = paste('forest_data_122_max', "_", nt, "nt_", f(data_122_max), "natr_", sep=""))
    #test_forest(data_251_max, mtry_arg = f(data_251_max), iters_arg = ITERS_CNT, ntree_arg = nt,  plot_sufix = paste('forest_data_251_max', "_", nt, "nt_", f(data_251_max), "natr_", sep=""))
    #test_forest(data_15_251,  mtry_arg = f(length(data_15_251)-1),   iters_arg = ITERS_CNT, ntree_arg = nt, plot_sufix = paste('forest_data_15_251' , "_", nt, "nt_", f(length(data_15_251)-1), "natr_", sep=""))
    #test_forest(data_15_122,  mtry_arg = f(length(data_15_122)-1),   iters_arg = ITERS_CNT, ntree_arg = nt, plot_sufix = paste('forest_data_15_122' , "_", nt, "nt_", f(length(data_15_122)-1), "natr_", sep=""))
    #test_forest(data_49_251,  mtry_arg = f(data_49_251),   iters_arg = ITERS_CNT, ntree_arg = nt, plot_sufix = paste('forest_data_49_251' , "_", nt, "nt_", f(data_49_251), "natr_", sep=""))
    
    #test_forest(data_embbedings, mtry_arg = f(data_embbedings),   iters_arg = ITERS_CNT, ntree_arg = nt, plot_sufix = paste('forest_embb' , "_", nt, "nt_", f(data_embbedings), "natr_", sep=""))
  }
}



test_forest(data_49_max,  mtry_arg = f2(data_49_max),   iters_arg = 1, ntree_arg = 100, plot_sufix = paste('forest_data_49_max' , "_", nt, "nt_", f(data_49_max), "natr_", sep=""))
test_forest(data_49_max,  mtry_arg = f2(data_49_max),   iters_arg = 1, ntree_arg = 100, plot_sufix = paste('forest_data_49_max' , "_", nt, "nt_", f(data_49_max), "natr_", sep=""), parr = TRUE)




