###Written by Angelina Volkova om 06/01/2020
###This script computes F1 macro score
library(caret)
library(ROCR)
setwd("/Users/av1936/Desktop/Google_Drive/Autoimmunity/revision/ml_results_revision/ml_results")

compute_f1 <- function(algorithm,model_type, data_type,level,adults){
    model <- readRDS(paste0(algorithm,"_model_",model_type,"_",data_type,"_",level,"_",adults,".rds"))
    test_set <- read.table(paste0("test_set_",model_type,"_",data_type,"_",level,"_",adults,".txt"), 
                            header=T, sep="\t")
    pred <- predict(model, test_set)
    prediction <- prediction(pred[,3],test_set$Status)
    f <- performance(prediction, "f")
    macro_f <- mean(as.numeric(unlist(f@y.values[1]))[-1])
    write.table(as.data.frame(macro_f), 
          file=paste0("f1_scores_",algorithm,"_model_",model_type,"_",data_type,"_",level,"_",adults,".txt"),
            sep="\t", col.names = F, row.names = F, quote = F)
    }

for (i in c("rf", "xgboost", "svm","ridge")){
  algorithm <- i
  compute_f1(algorithm, "auto", "16s","6","All")
  compute_f1(algorithm, "auto", "16s","6","Adults")
  compute_f1(algorithm, "IBD", "16s","6","All")
  compute_f1(algorithm, "IBD", "16s","6","Adults")
  compute_f1(algorithm, "MS", "16s","6","Adults")
  compute_f1(algorithm, "RA", "16s","6","Adults")
  
  compute_f1(algorithm, "auto", "16s","7","All")
  compute_f1(algorithm, "auto", "16s","7","Adults")
  compute_f1(algorithm, "IBD", "16s","7","All")
  compute_f1(algorithm, "IBD", "16s","7","Adults")
  compute_f1(algorithm, "MS", "16s","7","Adults")
  compute_f1(algorithm, "RA", "16s","7","Adults")
  
  compute_f1(algorithm, "auto", "meta","6","All")
  compute_f1(algorithm, "auto", "meta","6","Adults")
  compute_f1(algorithm, "IBD", "meta","6","All")
  compute_f1(algorithm, "IBD", "meta","6","Adults")
  
  compute_f1(algorithm, "auto", "meta","7","All")
  compute_f1(algorithm, "auto", "meta","7","Adults")
  compute_f1(algorithm, "IBD", "meta","7","All")
  compute_f1(algorithm, "IBD", "meta","7","Adults")
}