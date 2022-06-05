# Load models
source(file = "bayes.R")
source(file = "svm.R")
source(file = "random_forest.R")

# Load metrics for model evaluation
source(file = "metrics.R")

# Load data
ngrams_freq_vec_representations <- list.files("./ngrams_vec_limited", full.names = TRUE)


test_bayes()
test_svm()
test_forest()
