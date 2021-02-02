### Written by Angelina Volkova on 05/15/2020
###File containing machine learning functions for 
###running random forest, xgboost, svm with rfe
###and ridge regression

library(caret)
library(ROCR)
library(randomForest)
library(kernlab)
library(e1071)
library(xgboost)

###Function that removes features that have near-zero variance
###and splits the set into training and test sets
###Takes in a numeric data table with a status column
### and "yes"/"no" whether to use near-zero-variance feature removal 

split_train_test <- function(data, use_nzv){ 
  if (use_nzv=="yes") {
    status <- data$Status
    data$Status <- NULL
    zero_var <- nzv(data) 
    data <- data[, -zero_var]
    data$Status <- as.character(status)
    } 
  ml_partition <- createDataPartition(y=data$Status, p=0.9, list=FALSE)
  train_set <- data[ml_partition,]
  test_set <- data[-ml_partition,]
  return(list(train_set,test_set))
}

###Random forest function.Takes in training and test sets
###Returns AUC, feature importance and a trained model

run_random_forest <- function(train_set, test_set){
  control <- trainControl(method="repeatedcv", number=7, repeats=3, verbose = TRUE,allowParallel = TRUE)
  rf_model <- train(Status~.,data=train_set, method="rf", importance=TRUE, trControl = control,ntree = 1000)
  rf_pred <- predict(rf_model, test_set, type="prob")
  rf_prediction <- prediction(rf_pred[,2],test_set$Status)
  rf_perf <- performance(rf_prediction, "tpr", "fpr")
  rf_auc_perf <- performance(rf_prediction, measure="auc")
  rf_auc <- round(as.numeric(rf_auc_perf@y.values), digits = 3)
  rf_importance <- as.data.frame(varImp(rf_model)$importance)
  rf_importance$taxa <- row.names(rf_importance)
  return(list(rf_auc,rf_importance,rf_model))
}

###SVM RFE function. Takes in training and test sets
###Returns AUC, feature importance, optimal variables and a trained model

run_svm_rfe <- function(train_set, test_set){
  train_set$Status<- as.factor(as.character(train_set$Status))
  test_set$Status<- as.factor(as.character(test_set$Status))
  newSVM <- caretFuncs
  fiveStats <- function(...) c(twoClassSummary(...),defaultSummary(...))
  newSVM$summary <- fiveStats
  predVars <- names(train_set)[!(names(train_set) %in% c("Status"))]
  varSeq <- seq(1, length(predVars)-1, by = 2)
  ctrl <- rfeControl(method = "repeatedcv",repeats = 3,number=7,
                   verbose = TRUE,functions = newSVM,allowParallel = TRUE)  
  svm_model <- rfe(x = train_set[, predVars],y = train_set$Status,sizes = varSeq,
                 metric = "ROC",rfeControl = ctrl,method="svmRadial", tuneLength=10,
                 trControl=trainControl(method="cv", classProbs=TRUE))
  svm_pred <- predict(svm_model, test_set)
  svm_prediction <- prediction(svm_pred[,3],test_set$Status)
  svm_perf <- performance(svm_prediction, "tpr", "fpr")
  svm_auc_perf <- performance(svm_prediction, measure="auc")
  svm_auc <- round(as.numeric(svm_auc_perf@y.values), digits = 3)
  return(list(svm_auc, svm_model$variables, svm_model$optVariables, svm_model))
}

###Ridge regression function. Takes in training and test sets
###Returns AUC, feature importance and a trained model
run_ridge <- function(train_set, test_set){
  predVars <- names(train_set)[!(names(train_set) %in% c("Status"))]
  ctrl <- trainControl(method='repeatedcv', number=7, repeats=3,returnResamp='none', allowParallel = TRUE,
                     summaryFunction = twoClassSummary,classProbs = TRUE,  verbose = TRUE)
  ridge_model <- train(x = train_set[, predVars],y = train_set$Status, method='glmnet',  
                     metric = "ROC", trControl=ctrl,
                     tuneGrid = expand.grid(alpha = 0,lambda = seq(0.001,0.1,by = 0.001)))  
  ridge_pred <- predict(ridge_model, test_set, type="prob")
  ridge_importance <- as.data.frame(varImp(ridge_model,scale=F)$importance)
  ridge_importance$taxa <- row.names(ridge_importance)
  row.names(ridge_importance) <- NULL
  ridge_prediction <- prediction(ridge_pred[2],test_set$Status)
  ridge_perf <- performance(ridge_prediction, "tpr", "fpr")
  ridge_auc_perf <- performance(ridge_prediction, measure="auc")
  ridge_auc <- round(as.numeric(ridge_auc_perf@y.values), digits = 3)
  return(list(ridge_auc,ridge_importance,ridge_model))
  }

###XGBoost function. Takes in training and test sets
###Returns AUC, feature importance and a trained model

run_xgboost <- function(train_set, test_set){
  predVars <- names(train_set)[!(names(train_set) %in% c("Status"))]
  train_set$Status<- as.factor(as.character(train_set$Status))
  test_set$Status<- as.factor(as.character(test_set$Status))
  tune_grid <- expand.grid(nrounds = seq(from = 200, to = 1000, by = 50),eta = c(0.01,0.025, 0.05, 0.1),
                         max_depth = c(4,5,6,7,8),gamma = 0,colsample_bytree = 1,min_child_weight = 1,subsample = 1)
  control <- trainControl(method="repeatedcv", number=7, repeats=3, verbose = TRUE, allowParallel = TRUE)
  xgboost_model <- train(Status~.,data=train_set,  method = "xgbTree",importance=TRUE,tuneGrid = tune_grid,
                       trControl = control,verbose=TRUE)
  pred <- predict(xgboost_model, test_set, type="prob")
  xgboost_prediction <- prediction(pred[,2],test_set$Status)
  xgboost_perf <- performance(xgboost_prediction, "tpr", "fpr")
  xgboost_auc_perf <- performance(xgboost_prediction, measure="auc")
  xgboost_auc <- round(as.numeric(xgboost_auc_perf@y.values), digits = 3)
  xgboost_importance <- as.data.frame(varImp(xgboost_model)$importance)
  xgboost_importance$Taxa <- row.names(xgboost_importance)
  return(list(xgboost_auc, xgboost_importance,xgboost_model))
}


