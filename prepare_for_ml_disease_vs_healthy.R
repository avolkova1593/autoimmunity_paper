###Written by Angelina Volkova on 05/15/2020
###Script preparing a table with metadata and microbial abundance  
###for machine learning

set.seed(12345)
setwd("/Users/av1936/Desktop/Google_Drive/Autoimmunity/revision/ml_ready") ###Change the directory

###Choices for a data type: "16s", "meta"
###Choices for a level: "6","7"
###Choices for a disease type: "auto","IBD", "MS", "RA"
###Choices for Adults: "Adults", "All"

prepare_data <- function(data_type,level,disease_type,adults){
  file <- paste0("ml_ready_all_",data_type,"_",level,".txt")
  all_samples <- read.table(file, as.is =T,header=T, sep="\t")
  if (adults=="Adults") {
    all_samples <- all_samples[all_samples$AgeGroup%in%c("Adults"),]
    } 
  all_samples[is.na(all_samples)] <- 0
  ###Choosing the disease type
  if (disease_type=="IBD") {
    studies_disease <- all_samples[all_samples$AutoimmuneDisease%in%c("IBD"),]
  } else if (disease_type=="MS") {
    studies_disease <- all_samples[all_samples$AutoimmuneDisease%in%c("MS"),]
  } else if (disease_type=="RA") {
    studies_disease <- all_samples[all_samples$AutoimmuneDisease%in%c("RA"),]
  } else { studies_disease <- all_samples[all_samples$Status%in%c("Disease"),]
  }
  studies_healthy <- all_samples[all_samples$Status%in%c("Healthy"),]
  ###Select the same number of samples from each condition
  if (nrow(studies_disease) > nrow(studies_healthy)){
    all_samples <-  rbind(studies_healthy, studies_disease[sample(nrow(studies_disease), 
                                                              nrow(studies_healthy)),])
  } else {all_samples <-  rbind(studies_disease, studies_healthy[sample(nrow(studies_healthy), 
                                                                         nrow(studies_disease)),])
  }
  ###Remove metadata columns not used for machine learning  
  status <- all_samples$Status
  if (data_type=="16s") {
    taxa_f <- all_samples[,-c(1:29)]
  } else {taxa_f <- all_samples[,-c(1:26)]
  }
  
  taxa_status_f <- taxa_f[,colSums(taxa_f != 0)>0]
  taxa_status_f <- as.data.frame(taxa_status_f)
  taxa_status_f$Status <- c(as.character(status))
  write.table(as.data.frame(taxa_status_f), file=paste0(disease_type,"_",data_type,"_",level,"_",adults,".txt"),
              sep="\t", col.names = T,row.names = F, quote = F)
  #return(taxa_status_f)
}

###Prepare data for machine learning
prepare_data("16s","6","auto","All")
prepare_data("16s","6","auto","Adults")
prepare_data("16s","6","IBD","All")
prepare_data("16s","6","IBD","Adults")
prepare_data("16s","6","MS","Adults")
prepare_data("16s","6","RA","Adults")

prepare_data("16s","7","auto","All")
prepare_data("16s","7","auto","Adults")
prepare_data("16s","7","IBD","All")
prepare_data("16s","7","IBD","Adults")
prepare_data("16s","7","MS","Adults")
prepare_data("16s","7","RA","Adults")

prepare_data("meta","6","auto","All")
prepare_data("meta","6","auto","Adults")
prepare_data("meta","6","IBD","All")
prepare_data("meta","6","IBD","Adults")

prepare_data("meta","7","auto","All")
prepare_data("meta","7","auto","Adults")
prepare_data("meta","7","IBD","All")
prepare_data("meta","7","IBD","Adults")

