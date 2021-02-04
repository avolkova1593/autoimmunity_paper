#### Written by Angelina Volkova on 05/15/2020
#### This script is for making bar plots for each of the studies
#### both on genus level
library(plyr)
library(reshape)
library(ggplot2)
library(grid)
library(RColorBrewer)
set.seed(5432)
setwd("/Users/av1936/Desktop/Google_Drive/Autoimmunity/revision/ml_ready")
###Read the file
my_file <- read.table("ml_ready_all_meta_6.txt", as.is =T,header=T, sep="\t")
names(my_file) <- gsub(".*f__", "f__\\",names(my_file))
names(my_file) <- gsub("\\.", "_",names(my_file))
names(my_file) <- gsub("__", "_",names(my_file))
studies <- c(unique(my_file$Study))
all_bacteria <- character()
all_studies_list <- list()
taxa_ordered <- list()
###Studies with both disease and healthy samples
for (i in c(2,3,4,5,8,9,11,12,13)){
  current_study <- my_file[my_file$Study%in%c(studies[i]),]
  healthy <- current_study[current_study$Status%in%c("Healthy"),]
  healthy <- healthy[,-c(1:26)]
  healthy_percent <- as.data.frame(colSums(healthy)/sum(colSums(healthy))*100)
  healthy_percent$Bacteria <- row.names(healthy_percent)
  disease <- current_study[current_study$Status%in%c("Disease"),]
  disease <- disease[,-c(1:26)]
  disease_percent <- as.data.frame(colSums(disease)/sum(colSums(disease))*100)
  disease_percent$Bacteria <- row.names(disease_percent)
  taxa <- cbind(healthy_percent, disease_percent)
  taxa <- taxa[,c(1,3,4)]
  names(taxa) <- c("Healthy", "Disease", "Bacteria")
  taxa[taxa$Healthy < 0.5 | taxa$Disease < 0.5,]$Bacteria <- "Less_than_0.5%"
  taxa_less <- taxa[taxa$Bacteria%in%c("Less_than_0.5%"),]
  taxa_more <- taxa[!taxa$Bacteria%in%c("Less_than_0.5%"),]
  taxa_less <- aggregate(. ~ Bacteria, data=taxa_less, FUN=sum)
  taxa_final <- rbind(taxa_more,taxa_less)
  taxa_ordered[[i]] <- taxa_final[order(-taxa_final$Disease),]$Bacteria
  names(taxa_final) <- c(paste0(studies[i],"_Healthy"), paste0(studies[i],"_Disease"), "Bacteria")
  taxa_final <- melt(taxa_final, id=c("Bacteria")) 
  taxa_final$Study <- studies[i]
  all_studies_list[[i]] <- taxa_final
  my_bacteria <- c(unique(taxa$Bacteria))
  all_bacteria <- c(all_bacteria, my_bacteria)
}
###Studies with only disease samples
for (i in c(1,6,7)) {
  current_study <- my_file[my_file$Study%in%c(studies[i]),]
  disease <- current_study[current_study$Status%in%c("Disease"),]
  disease <- disease[,-c(1:26)]
  disease_percent <- as.data.frame(colSums(disease)/sum(colSums(disease))*100)
  disease_percent$Bacteria <- row.names(disease_percent)
  taxa <- disease_percent
  names(taxa) <- c("Disease", "Bacteria")
  taxa[taxa$Disease < 0.5,]$Bacteria <- "Less_than_0.5%"
  taxa_less <- taxa[taxa$Bacteria%in%c("Less_than_0.5%"),]
  taxa_more <- taxa[!taxa$Bacteria%in%c("Less_than_0.5%"),]
  taxa_less <- aggregate(. ~ Bacteria, data=taxa_less, FUN=sum)
  taxa_final <- rbind(taxa_more,taxa_less)
  names(taxa_final) <- c(paste0(studies[i],"_Disease"), "Bacteria")
  taxa_final <- melt(taxa_final, id=c("Bacteria")) 
  taxa_final$Study <- studies[i]
  all_studies_list[[i]] <- taxa_final
  my_bacteria <- c(unique(taxa$Bacteria))
  all_bacteria <- c(all_bacteria, my_bacteria)
}
###Studies with only healthy samples
for (i in c(10)) {
  current_study <- my_file[my_file$Study%in%c(studies[i]),]
  healthy <- current_study[current_study$Status%in%c("Healthy"),]
  healthy <- healthy[,-c(1:26)]
  healthy_percent <- as.data.frame(colSums(healthy)/sum(colSums(healthy))*100)
  healthy_percent$Bacteria <- row.names(healthy_percent)
  taxa <- healthy_percent
  names(taxa) <- c("Disease", "Bacteria")
  taxa[taxa$Disease < 0.5,]$Bacteria <- "Less_than_0.5%"
  taxa_less <- taxa[taxa$Bacteria%in%c("Less_than_0.5%"),]
  taxa_more <- taxa[!taxa$Bacteria%in%c("Less_than_0.5%"),]
  taxa_less <- aggregate(. ~ Bacteria, data=taxa_less, FUN=sum)
  taxa_final <- rbind(taxa_more,taxa_less)
  names(taxa_final) <- c(paste0(studies[i],"_Healthy"), "Bacteria")
  taxa_final <- melt(taxa_final, id=c("Bacteria")) 
  taxa_final$Study <- studies[i]
  all_studies_list[[i]] <- taxa_final
  my_bacteria <- c(unique(taxa$Bacteria))
  all_bacteria <- c(all_bacteria, my_bacteria)
}

####Order taxa in each study in the same way
###and combine tables
#Set colors
qual_col_pals = brewer.pal.info[brewer.pal.info$category == 'qual',]
col_vector = unlist(mapply(brewer.pal, qual_col_pals$maxcolors, rownames(qual_col_pals)))
bacteria <- unique(all_bacteria)[!unique(all_bacteria)%in%c("Less_than_0.5%")]
different_from_16s_bacteria <- setdiff(bacteria, names(studies_colors))
my_colors <- studies_colors[names(studies_colors)%in%bacteria]
my_colors <- c(my_colors,sample(col_vector,22))
names(my_colors)[24:45] <- different_from_16s_bacteria
less_than_color <- "gray60"
names(less_than_color) <- "Less_than_0.5%"
new_colors <- c(my_colors, less_than_color)
bacteria_levels <- c(names(new_colors))

df_taxa <- data.frame(Bacteria=character(),
                      variable=character(), 
                      value=character(),
                      Study=factor(),
                      stringsAsFactors=FALSE)
for (i in 1:length(all_studies_list)){
  #i <- 2
  study <- all_studies_list[[i]]
  bacteria_levels
  study$Bacteria <- factor(as.character(study$Bacteria), levels=bacteria_levels)
  df_taxa <- rbind(df_taxa,study)
}
###plot the taxa bar plots
b <- ggplot(df_taxa, 
       aes(x=variable, y=value, fill=Bacteria)) +
  geom_bar(stat = "identity", position = position_fill(reverse = TRUE)) + 
  scale_fill_manual(values=c(new_colors))+
  scale_x_discrete(limits=c("Hall_Disease","Hall_Healthy","",
                            "HMP2_Disease","HMP2_Healthy","",
                            "Ananthakrishnan_Disease","", "Connors_Disease","",
                            "Lewis_Disease","", "Wen_Disease", "Wen_Healthy","",
                            "Zhou_Disease","Zhou_Healthy","",
                            "Ye_Disease","Ye_Healthy","",
                            "Scher_Disease","Scher_Healthy","",
                            "Cekanaviciute_Disease","Cekanaviciute_Healthy","",
                            "Ventura_Disease","Ventura_Healthy","",
                            "Heinz_Buschart_Disease","Heinz_Buschart_Healthy","",
                            "HMP1_Healthy"))+
  labs(title="", y="Relative Abundance", x="")+
  theme_bw()+  
  theme(legend.position="none")+
  guides(fill=guide_legend(ncol=2)) +
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(), panel.grid.minor.y = element_blank(),
        axis.text=element_text(size=12,colour="black"), axis.text.x = element_text(angle = 90, hjust = 1),
        axis.title=element_text(size=12,colour="black"),
        text = element_text(size=12,colour="black"),
        legend.title=element_blank())
# extract Legend 
g_legend <- function(a.gplot){ 
  tmp <- ggplot_gtable(ggplot_build(a.gplot)) 
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box") 
  legend <- tmp$grobs[[leg]] 
  return(legend)} 
legend <- g_legend(b) 
grid.newpage()
grid.draw(legend) 

