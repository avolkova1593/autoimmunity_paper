###Written by Angelina Volkova on 05/18/2020
###This script makes lollipop and logfc plots
###of feature ranked features

library(ggplot2)
library(RColorBrewer)

setwd("/Users/av1936/Desktop/Google_Drive/Autoimmunity/revision/ml_ready/") ###Change directory of needed

make_lollipop_plots <- function(model_type,data_type,adults){
  feature_importance <- read.table(paste0("ml_results/all_feature_importance_",model_type,"_",data_type,"_6_",adults,".txt"),
                                 sep="\t",header=T)
  abundance <- read.table(paste0(model_type,"_",data_type,"_",level,"_",adults,".txt"),sep="\t",header=T)
  abundance <- abundance[,names(abundance)%in%c("Status", as.character(feature_importance$bacteria))]
  ###Calculate the log fold change
  if (model_type %in% c("auto","IBD","MS","RA")){
    conditions <- c(model_type,"Healthy")
    }else{
      conditions <- levels(abundance$Status)
      }
  condition1 <- abundance[abundance$Status%in%c(conditions[1]),]
  condition2 <- abundance[abundance$Status%in%c(conditions[2]),]
  logfc_df <- data.frame(bacteria=character(),log_fold_change=integer(),stringsAsFactors=FALSE)
  for (i in 1:length(as.character(feature_importance$bacteria))){
    bacteria_condition1 <- condition1[,i]
    mean_bacteria_condition1 <- mean(bacteria_condition1)
    bacteria_condition2 <- condition2[,i]
    mean_bacteria_condition2 <- mean(bacteria_condition2)
    logfc_bacteria <- log10(mean_bacteria_condition1/mean_bacteria_condition2)
    logfc_df[i,] <- c(as.character(feature_importance$bacteria)[i], logfc_bacteria)
    }
  logfc_df$direction <- NA
  logfc_df[logfc_df$log_fold_change>0,]$direction <- "Positive"
  logfc_df[logfc_df$log_fold_change<0,]$direction <- "Negative"
  logfc_df$log_fold_change <- as.numeric(logfc_df$log_fold_change)
  write.table(logfc,paste0("ml_results/logfc_",model_type,"_",data_type,"_6_",adults,".txt"),col.names = T,
              row.names = F, quote=F, sep="\t")
  ###Make and save logfc barplot
  pdf(file=paste0("lollipop_plots/logfc_",model_type,"_",data_type,"_6_",adults,".pdf"),width=8.5,height=8,paper='special')
  print(ggplot(logfc_df, aes(x=bacteria, y=log_fold_change)) +
          geom_bar(aes(fill=direction),stat='identity') +
          scale_fill_manual(values=c("blue4","red4"))+
          theme_bw() +
          coord_flip() +
          labs(title="", y="LogFoldChange", x="Genus")+
          theme_bw()+  
          theme(axis.text=element_text(size=8,colour="black"), 
                axis.title=element_text(size=8,colour="black"),
                text = element_text(size=12,colour="black"),
                legend.position = "none"))
  dev.off()
  ###Make data frames for the lollipop plots
  for (i in c(3,6,9,12)){
    feature_importance[,i] <- as.character(feature_importance[,i])
    feature_importance[,i][feature_importance[,i]%in%c("1","2","3","4","5")] <- "Top 5"
    feature_importance[,i][feature_importance[,i]%in%c("6","7","8","9","10")] <- "Top 10"
    feature_importance[,i][feature_importance[,i]%in%c(as.character(11:20))] <- "Top 20"
    feature_importance[,i][feature_importance[,i]%in%c(as.character(21:30))] <- "Top 30"
    feature_importance[,i][feature_importance[,i]%in%c(as.character(31:length(feature_importance$bacteria)))] <- "Less than 30"
    feature_importance[,i] <- factor(feature_importance[,i],levels=c("Top 5","Top 10","Top 20", "Top 30", "Less than 30"))
    }
  ##Change the width and height of the figures if needed
  my_colors <- c(brewer.pal(n = 4, name = "Dark2"),"grey60")
  for (i in c(3,6,9,12)){
    df_lollipop <- feature_importance[,c(1,i,13)]
    df_lollipop$bacteria <- factor(as.character(df_lollipop$bacteria), levels=c(as.character(df_lollipop$bacteria)))
    pdf(file=paste0("lollipop_plots/model_",as.character(i),"_",model_type,"_",data_type,"_6_",adults,".pdf"),
        width=8.5,height=8,paper='special')
    print(ggplot(df_lollipop, aes(x=bacteria, y=mean_ranking)) +
        geom_segment( aes(x=bacteria, xend=bacteria, y=0, yend=mean_ranking), color="black") +
        geom_point( aes(color=df_lollipop[,2]), size=2.5) +
        scale_color_manual(values=my_colors)+
        theme_bw() +
        coord_flip() +
        labs(title="", y="", x="Genus")+
        theme_bw()+  
        theme(axis.text=element_text(size=12,colour="black"), 
              axis.title=element_text(size=12,colour="black"),
              text = element_text(size=12,colour="black"),
              legend.title=element_blank()))
    dev.off()
  }
}

make_lollipop_plots("auto","16s","All")
make_lollipop_plots("auto","16s","Adults")
make_lollipop_plots("IBD","16s","All")
make_lollipop_plots("IBD","16s","Adults")
make_lollipop_plots("MS","16s","Adults")
make_lollipop_plots("RA","16s","Adults")

make_lollipop_plots("IBD_vs_MS","16s","Adults")
make_lollipop_plots("IBD_vs_RA","16s","Adults")
make_lollipop_plots("MS_vs_RA","16s","Adults")

make_lollipop_plots("auto","meta","All")
make_lollipop_plots("auto","meta","Adults")
make_lollipop_plots("IBD","meta","All")
make_lollipop_plots("IBD","meta","Adults")


