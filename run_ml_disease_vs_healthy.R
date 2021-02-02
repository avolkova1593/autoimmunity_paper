###Written by Angelina Volkova on 05/17/2020
###Run ml on prepared tables from prepare_for_ml_disease_vs_healthy.R
###Run on command line

set.seed(12345)
setwd("/Users/av1936/Desktop/Google_Drive/Autoimmunity/revision/ml_ready") ###Change the directory
source("/Users/av1936/Desktop/ml_functions.R") ###Change the location of the file

###Supply the following arguments
###Choice for a data type: "16s", "meta"
###Choices for a level: "6","7"
###Choices for a disease type: "auto","IBD", "MS", "RA"
###Choices for Adults: "Adults", "All"

args <- commandArgs(trailingOnly = TRUE)
data_type <- as.character(args[1])
level <- as.character(args[2])
disease_type <- as.character(args[3])
adults <- as.character(args[4])

data <- read.table(paste0(disease_type,"_",data_type,"_",level,"_",adults,".txt"), sep="\t", header=T)
data_split <- split_train_test(data,"yes") 
###Run machine learning
rf_results <- run_random_forest(data_split[[1]],data_split[[2]])
svm_results <- run_svm_rfe(data_split[[1]],data_split[[2]])
ridge_results <- run_ridge(data_split[[1]],data_split[[2]])
xgboost_results <- run_xgboost(data_split[[1]],data_split[[2]])
###Save test set
write.table(data_split[[2]],paste0("ml_results/test_set_",disease_type,"_",data_type,"_",level,"_",adults,".txt"),
            quote=F, col.names=T,row.names = F, sep="\t")

###Save rf results in ml_results directory
write.table(as.data.frame(rf_results[[1]]),paste0("ml_results/rf_auc_",disease_type,"_",data_type,"_",level,"_",adults,".txt"),
            quote=F, col.names=F,row.names = F, sep="\t")
write.table(as.data.frame(rf_results[[2]]),paste0("ml_results/rf_importance_",disease_type,"_",data_type,"_",level,"_",adults,".txt"),
            quote=F, col.names=T,row.names = T, sep="\t")
saveRDS(rf_results[[3]],paste0("ml_results/rf_model_",disease_type,"_",data_type,"_",level,"_",adults,".rds"))

###Save svm results in ml_results directory
write.table(as.data.frame(svm_results[[1]]),paste0("ml_results/svm_auc_",disease_type,"_",data_type,"_",level,"_",adults,".txt"),
            quote=F, col.names=F,row.names = F, sep="\t")
write.table(as.data.frame(svm_results[[2]]),paste0("ml_results/svm_importance_",disease_type,"_",data_type,"_",level,"_",adults,".txt"),
            quote=F, col.names=T,row.names = T, sep="\t")
write.table(as.data.frame(svm_results[[3]]),paste0("ml_results/svm_opt_variables_",disease_type,"_",data_type,"_",level,"_",adults,".txt"),
            quote=F, col.names=T,row.names = T, sep="\t")
saveRDS(svm_results[[4]],paste0("ml_results/svm_model_",disease_type,"_",data_type,"_",level,"_",adults,".rds"))

###Save ridge results in ml_results directory
write.table(as.data.frame(ridge_results[[1]]),paste0("ml_results/ridge_auc_",disease_type,"_",data_type,"_",level,"_",adults,".txt"),
            quote=F, col.names=F,row.names = F, sep="\t")
write.table(as.data.frame(ridge_results[[2]]),paste0("ml_results/ridge_importance_",disease_type,"_",data_type,"_",level,"_",adults,".txt"),
            quote=F, col.names=T,row.names = T, sep="\t")
saveRDS(ridge_results[[3]],paste0("ml_results/ridge_model_",disease_type,"_",data_type,"_",level,"_",adults,".rds"))

###Save xgboost results in ml_results directory
write.table(as.data.frame(xgboost_results[[1]]),paste0("ml_results/xgboost_auc_",disease_type,"_",data_type,"_",level,"_",adults,".txt"),
            quote=F, col.names=F,row.names = F, sep="\t")
write.table(as.data.frame(xgboost_results[[2]]),paste0("ml_results/xgboost_importance_",disease_type,"_",data_type,"_",level,"_",adults,".txt"),
            quote=F, col.names=T,row.names = T, sep="\t")
saveRDS(xgboost_results[[3]],paste0("ml_results/xgboost_model_",disease_type,"_",data_type,"_",level,"_",adults,".rds"))


###Create and run mock models with a random label
data_mock <- data
data_mock$Status <- sample(as.character(data$Status))
data_split_mock <- split_train_test(data_mock,"yes") 
###Run machine learning on mock data
rf_results_mock <- run_random_forest(data_split_mock[[1]],data_split_mock[[2]])
svm_results_mock <- run_svm_rfe(data_split_mock[[1]],data_split_mock[[2]])
ridge_results_mock <- run_ridge(data_split_mock[[1]],data_split_mock[[2]])
xgboost_results_mock <- run_xgboost(data_split_mock[[1]],data_split_mock[[2]])

###Save rf mock results in ml_results directory
write.table(as.data.frame(rf_results_mock[[1]]),paste0("ml_results/mock_rf_auc_",disease_type,"_",data_type,"_",level,"_",adults,".txt"),
            quote=F, col.names=F,row.names = F, sep="\t")
write.table(as.data.frame(rf_results_mock[[2]]),paste0("ml_results/mock_rf_importance_",disease_type,"_",data_type,"_",level,"_",adults,".txt"),
            quote=F, col.names=T,row.names = T, sep="\t")
saveRDS(rf_results_mock[[3]],paste0("ml_results/mock_rf_model_",disease_type,"_",data_type,"_",level,"_",adults,".rds"))

###Save svm mock results in ml_results directory
write.table(as.data.frame(svm_results_mock[[1]]),paste0("ml_results/mock_svm_auc_",disease_type,"_",data_type,"_",level,"_",adults,".txt"),
            quote=F, col.names=F,row.names = F, sep="\t")
write.table(as.data.frame(svm_results_mock[[2]]),paste0("ml_results/mock_svm_importance_",disease_type,"_",data_type,"_",level,"_",adults,".txt"),
            quote=F, col.names=T,row.names = T, sep="\t")
write.table(as.data.frame(svm_results_mock[[3]]),paste0("ml_results/mock_svm_opt_variables_",disease_type,"_",data_type,"_",level,"_",adults,".txt"),
            quote=F, col.names=T,row.names = T, sep="\t")
saveRDS(svm_results_mock[[4]],paste0("ml_results/mock_svm_model_",disease_type,"_",data_type,"_",level,"_",adults,".rds"))

###Save ridge mock results in ml_results directory
write.table(as.data.frame(ridge_results_mock[[1]]),paste0("ml_results/mock_ridge_auc_",disease_type,"_",data_type,"_",level,"_",adults,".txt"),
            quote=F, col.names=F,row.names = F, sep="\t")
write.table(as.data.frame(ridge_results_mock[[2]]),paste0("ml_results/mock_ridge_importance_",disease_type,"_",data_type,"_",level,"_",adults,".txt"),
            quote=F, col.names=T,row.names = T, sep="\t")
saveRDS(ridge_results_mock[[3]],paste0("ml_results/mock_ridge_model_",disease_type,"_",data_type,"_",level,"_",adults,".rds"))

###Save xgboost mock results in ml_results directory
write.table(as.data.frame(xgboost_results_mock[[1]]),paste0("ml_results/mock_xgboost_auc_",disease_type,"_",data_type,"_",level,"_",adults,".txt"),
            quote=F, col.names=F,row.names = F, sep="\t")
write.table(as.data.frame(xgboost_results_mock[[2]]),paste0("ml_results/mock_xgboost_importance_",disease_type,"_",data_type,"_",level,"_",adults,".txt"),
            quote=F, col.names=T,row.names = T, sep="\t")
saveRDS(xgboost_results_mock[[3]],paste0("ml_results/mock_xgboost_model_",disease_type,"_",data_type,"_",level,"_",adults,".rds"))
