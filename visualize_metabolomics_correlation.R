###Written by Angelina Volkova on 05/20/2020
###This script plots a heatmap and metabolites correlated
###with individual bacteria colored by p values

library(reshape2)
library(ggplot2)
library(ComplexHeatmap)
library(viridis)
setwd("/Users/av1936/Desktop/Google_Drive/Autoimmunity")
file <- read.table("revision/tables/significant_correlations_w_metabolites.txt",header=T,sep="\t")
p_values <- read.table("revision/tables/significant_correlations_w_metabolites_p_values.txt", header=T,sep="\t")
###Remove bacteria that were found < 10% of the samples
file <- file[!file$Bugs%in%c("Butyricicoccus","Eggerthella", "Lactococcus","Odoribacter"),]
p_values <- p_values[!p_values$Bugs%in%c("Butyricicoccus","Eggerthella", "Lactococcus","Odoribacter"),]
###Fix the names
names(file) <- c(gsub('.*_', '', names(file)))
names(p_values) <- c(gsub('.*_', '', names(file)))
###Remove NAs
p_values <- p_values[,!names(file)%in%c("NA")]
file <- file[,!names(file)%in%c("NA")]
file <- file[,colSums(is.na(file))<nrow(file)]
p_values <- p_values[,colSums(is.na(p_values))<nrow(p_values)]
###Convert to metabolite names
metabolomics <- read.csv("results_old/results_both_05_22_19/metabolomics_hmp/HMP2_metabolomics.csv")
metabolomics <- metabolomics[grepl("^(HMDB)",metabolomics$HMDB...Representative.ID.),]
metabolomics$HMDB...Representative.ID. <- c(gsub('\\*', '.',metabolomics$HMDB...Representative.ID.))
metabolomics <- metabolomics[!is.na(metabolomics$Metabolite),]
###Get all metabolites names
all_metabolites <- character()
for (i in c(names(file)[-1])){
  metabolite <- paste(as.character(metabolomics[metabolomics$HMDB...Representative.ID.%in%c(i),]$Metabolite),
                      collapse = "/")
  all_metabolites <- c(all_metabolites, metabolite)
}
names(file) <- c("Bugs", all_metabolites)
names(p_values) <- c("Bugs", all_metabolites)
file <- file[,!names(file)==""]
p_values <- p_values[,!names(p_values)==""]
row.names(file) <- file$Bugs
###Make a heatmap
ht <-Heatmap(file[,-1],na_col="white",cluster_rows = F,cluster_columns = F,
        name="Spearman \nCorrelation",
        column_names_gp = gpar(fontsize = 10))#, show_column_names = F)
draw(ht, padding = unit(c(100, 2, 2, 2), "mm"))

##Make barplots for individiual bacteria
file_melted <- melt(file, genus=c("Bugs"))
file_melted <- file_melted[!is.na(file_melted$value),]
p_values_melted <- melt(p_values,genus=c("Bugs"))
p_values_melted <- p_values_melted[!is.na(p_values_melted$value),]
file_melted$p_value <- p_values_melted$value
bacteria <- levels(file_melted$Bugs)
bacteria
###Function to plot individual bacteria
plot_bacteria <- function(bug)  {
  one_genus <- file_melted[file_melted$Bugs%in%c(bug),]
  one_genus <- one_genus[order(one_genus$value),]
  one_genus$variable <- factor(one_genus$variable, levels=one_genus$variable)
  ggplot(one_genus, aes(x=variable,y=value,fill=p_value))+
  geom_bar(stat="identity")+
  scale_fill_gradientn(colors = rev(viridis(20)) ,limits = c(0,0.05))+
  coord_flip() +
  ylim(-1,1)+
  labs(title=paste0(bug), y="", x="")+
  theme_bw()+
  theme(axis.text=element_text(size=10,colour="black"),
        axis.title=element_text(size=10,colour="black"),
        text = element_text(size=12,colour="black"),
        #axis.text.x=element_text(angle=90,hjust=1,vjust=0.5),
        legend.title=element_blank())
}

plot_bacteria("Faecalibacterium")
plot_bacteria("Roseburia")
plot_bacteria("Akkermansia")
plot_bacteria("Bilophila")
plot_bacteria("Anaerotruncus")
plot_bacteria("Holdemania")

