
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
gammas = list(0.01, 0.1, 1, 10) # (radial, sigmoid)


#cost param
for(k in kernels){
  for(c in costs){
    test_svm(data_15_max,  iters_arg = ITERS_CNT, kernel_arg = k, cost_arg= c, plot_sufix = paste('svm_data_15_max_', k, "_c_", c ))
    test_svm(data_49_max,  iters_arg = ITERS_CNT, kernel_arg = k, cost_arg= c, plot_sufix = paste('svm_data_49_max_', k, "_c_", c ))
    test_svm(data_122_max, iters_arg = ITERS_CNT, kernel_arg = k, cost_arg= c, plot_sufix = paste('svm_data_122_max_', k, "_c_", c))
    test_svm(data_251_max, iters_arg = ITERS_CNT, kernel_arg = k, cost_arg= c, plot_sufix = paste('svm_data_251_max_', k, "_c_", c))
    test_svm(data_15_251,  iters_arg = ITERS_CNT, kernel_arg = k, cost_arg= c, plot_sufix = paste('svm_data_15_251_', k, "_c_", c ))
    test_svm(data_15_122,  iters_arg = ITERS_CNT, kernel_arg = k, cost_arg= c, plot_sufix = paste('svm_data_15_122_', k, "_c_", c ))
    test_svm(data_49_251,  iters_arg = ITERS_CNT, kernel_arg = k, cost_arg= c, plot_sufix = paste('svm_data_49_251_', k, "_c_", c ))
    
    test_svm(data_embbedings,  iters_arg = ITERS_CNT, kernel_arg = k, cost_arg= c, plot_sufix = paste('svm_embb_', k, "_c_", c ))
  }
}

for(k in list("radial", "sigmoid")){
  for(g in gammas){
    test_svm(data_15_max,  iters_arg = ITERS_CNT, kernel_arg = k, gamma_arg= g, plot_sufix = paste('svm_data_15_max_',  k, "_g_", g ))
    test_svm(data_49_max,  iters_arg = ITERS_CNT, kernel_arg = k, gamma_arg= g, plot_sufix = paste('svm_data_49_max_',  k, "_g_", g ))
    test_svm(data_122_max, iters_arg = ITERS_CNT, kernel_arg = k, gamma_arg= g, plot_sufix = paste('svm_data_122_max_', k, "_g_", g))
    test_svm(data_251_max, iters_arg = ITERS_CNT, kernel_arg = k, gamma_arg= g, plot_sufix = paste('svm_data_251_max_', k, "_g_", g))
    test_svm(data_15_251,  iters_arg = ITERS_CNT, kernel_arg = k, gamma_arg= g, plot_sufix = paste('svm_data_15_251_',  k, "_g_", g ))
    test_svm(data_15_122,  iters_arg = ITERS_CNT, kernel_arg = k, gamma_arg= g, plot_sufix = paste('svm_data_15_122_',  k, "_g_", g ))
    test_svm(data_49_251,  iters_arg = ITERS_CNT, kernel_arg = k, gamma_arg= g, plot_sufix = paste('svm_data_49_251_',  k, "_g_", g ))
    
    test_svm(data_embbedings,  iters_arg = ITERS_CNT, kernel_arg = k, gamma_arg= g, plot_sufix = paste('svm_embb_', k, "_g_", g ))
  }
}




