

splitTrainTest <- function(df_arg){
  #split into test and train
  intrain <- createDataPartition(y = df_arg$class, p= 0.7, list = FALSE)
  training <- df_arg[intrain,]
  testing <- df_arg[-intrain,]
  
  #show stats of datasets
  
  #training %>%group_by(class) %>%summarise(n = n()) %>%mutate(Freq = n/sum(n))
  #testing %>%group_by(class) %>%summarise(n = n()) %>%mutate(Freq = n/sum(n))
  
  x_train = training[1:(length(training)-1)]
  y_train = training$class
  
  x_test = testing[1:(length(testing)-1)]
  y_test = testing$class
  
  #x_all = df_arg[1:(length(df_arg)-1)]
  #y_all = df_arg$class
  
  ret_list = list(x_train, x_test, y_train, y_test)
  return(ret_list)
}


#d_sets = splitTrainTest(data_embbedings)
#x_train = d_sets[[1]]
#x_test = d_sets[[2]]
#y_train = d_sets[[3]]
#y_test = d_sets[[4]]
#