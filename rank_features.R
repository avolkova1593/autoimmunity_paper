###Written by Angelina Volkova on 05/17/2020
###This script ranks the features by mean importance from all four models

setwd("/Users/av1936/Desktop/Google_Drive/Autoimmunity/revision/ml_ready/ml_results/")

rank_features <- function(model_type,data_type,level,adults){
  rf <- read.table(paste0("rf_importance_",model_type,"_",data_type,"_",level,"_",adults,".txt"),sep="\t",header=T)
  svm <- read.table(paste0("svm_importance_",model_type,"_",data_type,"_",level,"_",adults,".txt"),sep="\t",header=T)
  xgboost <- read.table(paste0("xgboost_importance_",model_type,"_",data_type,"_",level,"_",adults,".txt"),sep="\t",header=T)
  ridge <- read.table(paste0("ridge_importance_",model_type,"_",data_type,"_",level,"_",adults,".txt"),sep="\t",header=T)
  ###Get mean values for svm
  bacteria <- c()
  weights <- c()
  for (i in unique(svm$var)) {
    bacterium <- svm[svm$var%in%c(as.character(i)),]
    sum_weights <- mean(bacterium$Overall)
    bacteria <-c(bacteria,unique(as.character(bacterium$var)))
    weights <- c(weights,sum_weights)
  }
  ###Random forest importance
  ranking <- c(1:length(rf$taxa))
  rf_importance <- as.data.frame(rf$taxa)
  rf_importance$weights <- rf[,1]
  names(rf_importance) <- c("bacteria","weights")
  rf_importance <- rf_importance[order(-rf_importance$weights),]
  rf_importance$ranking <- ranking
  rf_importance$bacteria <- as.character(rf_importance$bacteria)
  rf_importance <- rf_importance[order(rf_importance$bacteria),]
  ###SVM importance
  svm_importance <- as.data.frame(bacteria)
  svm_importance$weights <- weights
  svm_importance <- svm_importance[order(-svm_importance$weights),]
  svm_importance$ranking <- ranking
  svm_importance$bacteria <- as.character(svm_importance$bacteria)
  svm_importance <- svm_importance[order(svm_importance$bacteria),]
  ###Get ridge importance
  ridge_importance <- as.data.frame(ridge$taxa)
  ridge_importance$weights <- ridge$Overall
  names(ridge_importance) <- c("bacteria","weights")
  ridge_importance <- ridge_importance[order(-ridge_importance$weights),]
  ridge_importance$ranking <- ranking
  ridge_importance$bacteria <- as.character(ridge_importance$bacteria)
  ridge_importance <- ridge_importance[order(ridge_importance$bacteria),]
  ###Get xgboost importance
  xgboost_importance <- as.data.frame(xgboost$Taxa)
  xgboost_importance$weights <- xgboost$Overall
  names(xgboost_importance) <- c("bacteria","weights")
  xgboost_importance <- xgboost_importance[order(-xgboost_importance$weights),]
  xgboost_importance$ranking <- ranking
  xgboost_importance[xgboost_importance$weights==0,]$ranking <- nrow(xgboost_importance)
  xgboost_importance$bacteria <- as.character(xgboost_importance$bacteria)
  xgboost_importance <- xgboost_importance[order(xgboost_importance$bacteria),]
  ###Combine importance values from all four algorithms
  all_importance <- cbind(svm_importance,rf_importance,xgboost_importance,ridge_importance)
  names(all_importance) <- c("bacteria","svm_weights","svm_ranking",
                           "bacteria","rf_weights","rf_ranking",
                           "bacteria","xgboost_weights","xgboost_ranking",
                           "bacteria","ridge_weights","ridge_ranking")
  ###Calculate mean importance
  mean_ranking <- c()
  for (i in 1:nrow(all_importance)){
    mean_value <- (all_importance$svm_ranking[i]+all_importance$rf_ranking[i]+
                     all_importance$xgboost_ranking[i]+all_importance$ridge_ranking[i])/4
    mean_ranking <- c(mean_ranking,mean_value)
    }
  all_importance$mean_ranking <- mean_ranking
  all_importance <- all_importance[order(all_importance$mean_ranking),]
  write.table(all_importance,file=paste0("all_feature_importance_",model_type,"_",data_type,"_",level,"_",adults,".txt"),
            sep="\t",col.names = T,row.names = F,quote = F)
}

rank_features("auto","16s","6","All")
rank_features("auto","16s","6","Adults")
rank_features("IBD","16s","6","All")
rank_features("IBD","16s","6","Adults")
rank_features("MS","16s","6","Adults")
rank_features("RA","16s","6","Adults")

rank_features("auto","16s","7","All")
rank_features("auto","16s","7","Adults")
rank_features("IBD","16s","7","All")
rank_features("IBD","16s","7","Adults")
rank_features("MS","16s","7","Adults")
rank_features("RA","16s","7","Adults")

rank_features("IBD_vs_MS","16s","6","Adults")
rank_features("IBD_vs_RA","16s","6","Adults")
rank_features("MS_vs_RA","16s","6","Adults")

rank_features("IBD_vs_MS","16s","7","Adults")
rank_features("IBD_vs_RA","16s","7","Adults")
rank_features("MS_vs_RA","16s","7","Adults")

rank_features("auto","meta","6","All")
rank_features("auto","meta","6","Adults")
rank_features("IBD","meta","6","All")
rank_features("IBD","meta","6","Adults")

rank_features("auto","meta","7","All")
rank_features("auto","meta","7","Adults")
rank_features("IBD","meta","7","All")
rank_features("IBD","meta","7","Adults")

