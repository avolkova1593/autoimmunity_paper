###Written by Angelina Volkova on 05/20/2020
###Thist script performs spearman correlation between iHMP metagenomics
### and metaproteomics data for bacteria found to be predictive of disease

library(psych)
library(Hmisc)
library(reshape2)
setwd("/Users/av1936/Desktop/Google_Drive/Autoimmunity/")

metabolomics <- read.csv("results_old/results_both_05_22_19/metabolomics_hmp/netrias_hmp_metabolomics.csv")
metagenomics <- read.csv("results_old/results_both_05_22_19/metabolomics_hmp/netrias_hmp_metagenomics.csv")
all_bugs <- read.table("revision/tables/all_venn_bugs.txt", sep="\t",header=T)
###Exclude Dorea and Sutterella due to being predictive of individual 16s studies
all_bugs <- all_bugs[!all_bugs$all_venn_bugs%in%c("Dorea","Sutterella"),]
metagenomics$Bugs <- c(sub("_.*", "", metagenomics$Bugs))
metagenomics <- as.data.frame(metagenomics)
metagenomics_genus <- aggregate(. ~ Bugs,metagenomics, sum, na.action=na.pass)
###Fix the names
names(metagenomics_genus) <- c(sub("_metagenomics_UC","", names(metagenomics_genus)))
names(metagenomics_genus) <- c(sub("_metagenomics_CD","", names(metagenomics_genus)))
names(metagenomics_genus) <- c(sub("_metagenomics_nonIBD","", names(metagenomics_genus)))
names(metabolomics) <-  c(sub("_metabolomics_UC","", names(metabolomics)))
names(metabolomics) <-  c(sub("_metabolomics_CD","", names(metabolomics)))
names(metabolomics) <-  c(sub("_metabolomics_nonIBD","", names(metabolomics)))
mtb_samples <- c(names(metabolomics)[-1])
metagenomics_filtered <- metagenomics_genus[,names(metagenomics_genus)%in%c(mtb_samples)]
metabolomics_filtered <- metabolomics[,names(metabolomics)%in%c(names(metagenomics_filtered))]
row.names(metagenomics_filtered) <- metagenomics_genus$Bugs
row.names(metabolomics_filtered) <- metabolomics$Metabolites
metagenomics_filtered <- metagenomics_filtered[row.names(metagenomics_filtered)%in%c(as.character(all_bugs)),]
metagenomics_filtered <- as.data.frame(t(metagenomics_filtered[rowSums(is.na(metagenomics_filtered)) != ncol(metagenomics_filtered), ]))
metabolomics_filtered <- as.data.frame(t(metabolomics_filtered))
metagenomics_filtered <- metagenomics_filtered[ order(row.names(metagenomics_filtered)), ]
metabolomics_filtered <- metabolomics_filtered[ order(row.names(metabolomics_filtered)), ]

all_correlations <- corr.test(metagenomics_filtered,metabolomics_filtered, use = "pairwise",method="spearman",adjust="BH", 
          alpha=.05,ci=TRUE,minlength=5)
correlation <- all_correlations$r
p_value <- all_correlations$p
p_value[p_value=="NaN"] <- NA
p_value[p_value>0.05] <- NA
p_value <- as.data.frame(p_value)
sig_correlation <- correlation
sig_correlation[is.na(p_value)] <- NA
sig_correlation <- as.data.frame(sig_correlation)
sig_correlation <- sig_correlation[rowSums(is.na(sig_correlation)) != ncol(sig_correlation), ]
sig_correlation <- sig_correlation[, colSums(is.na(sig_correlation)) != nrow(sig_correlation)]
p_value <- p_value[rowSums(is.na(p_value)) != ncol(p_value), ]
p_value <- p_value[, colSums(is.na(p_value)) != nrow(p_value)]
###Save the results
write.table(sig_correlation,file="revision/tables/significant_correlations_w_metabolites.txt",
            sep="\t",row.names = T,col.names = T, quote=F)

write.table(p_value,file="revision/tables/significant_correlations_w_metabolites_p_values.txt",
            sep="\t",row.names = T,col.names = T, quote=F)