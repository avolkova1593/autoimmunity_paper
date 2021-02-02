###Written by Angelina Volkova on 05/15/2020
###Script preparing a table with metadata and microbial abundance  
###for machine learning for disease vs disease models

set.seed(12345)
setwd("/Users/av1936/Desktop/Google_Drive/Autoimmunity/revision/ml_ready") ###Change the directory

###Choices for a level: "6","7"
###Choices for a model type: "IBD_vs_MS", "IBD_vs_RA", "MS_vs_RA

prepare_data_disease_vs_disease <- function(level,model_type){
  file <- paste0("ml_ready_all_16s_",level,".txt")
  all_samples <- read.table(file, as.is =T,header=T, sep="\t")
  all_samples <- all_samples[all_samples$AgeGroup%in%c("Adults"),]
  all_samples[is.na(all_samples)] <- 0
  ###Choosing the disease type
  if (model_type=="IBD_vs_MS") {
    disease1 <- all_samples[all_samples$AutoimmuneDisease%in%c("IBD"),]
    disease1$Status <- "IBD"
    disease2 <- all_samples[all_samples$AutoimmuneDisease%in%c("MS"),]
    disease2$Status <- "MS"
  } else if (model_type=="IBD_vs_RA") {
    disease1 <- all_samples[all_samples$AutoimmuneDisease%in%c("IBD"),]
    disease1$Status <- "IBD"
    disease2 <- all_samples[all_samples$AutoimmuneDisease%in%c("RA"),]
    disease2$Status <- "RA"
  } else {
    disease1 <- all_samples[all_samples$AutoimmuneDisease%in%c("MS"),]
    disease1$Status <- "MS"
    disease2 <- all_samples[all_samples$AutoimmuneDisease%in%c("RA"),]
    disease2$Status <- "RA"
  }
  ###Select the same number of samples from each condition
  if (nrow(disease1) > nrow(disease2)){
    all_samples <-  rbind(disease2, disease1[sample(nrow(disease1),nrow(disease2)),])
  } else {all_samples <-  rbind(disease1, disease2[sample(nrow(disease2),nrow(disease1)),])
  }
  ###Remove metadata columns not used for machine learning  
  status <- all_samples$Status
  taxa_f <- all_samples[,-c(1:29)]
  taxa_status_f <- taxa_f[,colSums(taxa_f != 0)>0]
  taxa_status_f <- as.data.frame(taxa_status_f)
  taxa_status_f$Status <- c(as.character(status))
  write.table(as.data.frame(taxa_status_f), file=paste0(model_type,"_16s_",level,"_Adults.txt"),
              sep="\t", col.names = T,row.names = F, quote = F)
  #return(taxa_status_f)
}

###Prepare data for machine learning
prepare_data_disease_vs_disease("6", "IBD_vs_MS")
prepare_data_disease_vs_disease("6", "IBD_vs_RA")
prepare_data_disease_vs_disease("6", "MS_vs_RA")

prepare_data_disease_vs_disease("7", "IBD_vs_MS")
prepare_data_disease_vs_disease("7", "IBD_vs_RA")
prepare_data_disease_vs_disease("7", "MS_vs_RA")
