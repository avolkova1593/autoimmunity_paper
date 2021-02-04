###Written by Angelina Volkova on 05/14/2020
###Script for creating PCoA plots from metagenomics relative abundance tables

library(ggplot2)
library(vegan)
library(dplyr)
library(ape)
library(ggsci)
library(viridis)
set.seed(2345)
setwd("/Users/av1936/Desktop/Google_Drive/Autoimmunity/revision/ml_ready")
my_file <- read.table("ml_ready_all_meta_7.txt", as.is =T,header=T, sep="\t")
###Custom colors palette
colors <- c("#003859","#88fa31","#6300b3","#ecff35","#000797","#8bd000","#0138cd","#00b116","#f723dc","#00dc63",
            "#b300c4","#81ff82","#9363ff","#57a200","#c665ff","#cdbd00","#005edc","#daa400","#310070","#deff84",
            "#001e7e","#8affa6","#f900a7","#00ab6b","#ff70f5","#99a600","#7e0085","#02eacd","#ef0059","#01a77f",
            "#de003f","#3ce4ff","#e47d00","#00409c","#ffd165","#47005d","#f0fbba","#1b0021","#d8ffd5","#af0064",
            "#9bfff8","#940028","#00bada","#ff605a","#005a13","#ff56b8","#606d00","#b484ff","#2f4400","#e291ff",
            "#132f00","#ff86d9","#001d17","#ff5a9c","#007d75","#ff8060","#00488b","#ffa45f","#8f8eff","#a05500",
            "#7ca0ff","#923100","#0081ad","#761d00","#bbdbff","#490010","#fef5cd","#002153","#ffcf85","#001024",
            "#f1f4ff","#2b0009","#ffc7f6","#5b4f00","#c9b0ff","#754f00","#bec7ff","#5b2500","#ffa4e1","#005044",
            "#ff8a78","#005c8c","#ffa798","#2d001e","#ffcbc6","#76004a","#01778e","#ff8bac","#005f62","#660029",
            "#4b3100")
study_colors <- c(sample(colors)[c(50:57,74:79)])
##Remove the samples with all zeros
my_file <- my_file[rowSums(my_file[, -c(1:26)] > 0) != 0, ]
###Compute PCoA
distance_bray <- vegdist(my_file[,-c(1:26)], method = "bray")
my_pcoa <- pcoa(distance_bray)
pcoa_df <- as.data.frame(my_pcoa$vectors[,1])
names(pcoa_df) <- "V1"
pcoa_df$V2 <- my_pcoa$vectors[,2]
###Add metadata to PCoA
pcoa_df$Study <- my_file$Study
pcoa_df$Status <- my_file$Status
pcoa_df$Location <- my_file$Country
pcoa_df$Disease <- my_file$AutoimmuneDisease
pcoa_df$Age <- my_file$Age
pcoa_df$AgeGroup <- my_file$AgeGroup
pcoa_df$Antibiotics <- my_file$Antibiotics
pcoa_df$DNAExtractionkit <- my_file$DNAExtractionKit
### Compute adonis
permanova_study <- adonis(distance_bray ~ Study, data=pcoa_df)$aov.tab$`Pr(>F)`[1]
permanova_status <- adonis(distance_bray ~ Status, data=pcoa_df)$aov.tab$`Pr(>F)`[1]
permanova_location <- adonis(distance_bray ~ Location, data=pcoa_df)$aov.tab$`Pr(>F)`[1]
permanova_disease <- adonis(distance_bray ~ Disease, data=pcoa_df)$aov.tab$`Pr(>F)`[1]
permanova_age <- adonis(distance_bray ~ Age, data=pcoa_df)$aov.tab$`Pr(>F)`[1]
permanova_agegroup <- adonis(distance_bray ~ AgeGroup, data=pcoa_df)$aov.tab$`Pr(>F)`[1]
permanova_antibiotics <- adonis(distance_bray ~ Antibiotics, data=pcoa_df)$aov.tab$`Pr(>F)`[1]
permanova_kit <- adonis(distance_bray ~ DNAExtractionkit, data=pcoa_df)$aov.tab$`Pr(>F)`[1]

###PCoA colored by Study
ggplot(pcoa_df,aes(V1,V2,colour = Study)) + 
  geom_point(size=1)+
  scale_color_manual(values = c(study_colors))+
  labs(title="", x=paste0("PC1 (",round(my_pcoa$values$Relative_eig[1]*100, digits=3),"%)"), 
       y=paste0("PC2 (",round(my_pcoa$values$Relative_eig[2]*100, digits=3),"%)"))+
  guides(colour = guide_legend(override.aes = list(size=6)))+
  theme_bw()+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(), panel.grid.minor.y = element_blank(),
        axis.text=element_text(size=14), axis.text.x=element_text(colour="black"),
        axis.title=element_text(size=14),axis.text.y=element_text(colour="black"),
        text = element_text(size=14),
        legend.title=element_blank())
###PCoA colored by Status
ggplot(pcoa_df,aes(V1,V2,colour = Status)) + 
  geom_point(size=1)+
  scale_colour_manual(values=c("red3", "steelblue3"))+
  labs(title="", x=paste0("PC1 (",round(my_pcoa$values$Relative_eig[1]*100, digits=3),"%)"), 
       y=paste0("PC2 (",round(my_pcoa$values$Relative_eig[2]*100, digits=3),"%)"))+
  guides(colour = guide_legend(override.aes = list(size=6)))+
  theme_bw()+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(), panel.grid.minor.y = element_blank(),
        axis.text=element_text(size=14), axis.text.x=element_text(colour="black"),
        axis.title=element_text(size=14),axis.text.y=element_text(colour="black"),
        text = element_text(size=14),
        legend.title=element_blank())
###PCoA colored by Disease type
ggplot(pcoa_df,aes(V1,V2,colour = Disease)) + 
  geom_point(size=1)+
  scale_colour_manual(values=c("brown","forestgreen","steelblue3",
                               "turquoise4", "pink3", "purple1",
                               "yellow3", "deepskyblue2"))+
  labs(title="", x=paste0("PC1 (",round(my_pcoa$values$Relative_eig[1]*100, digits=3),"%)"), 
       y=paste0("PC2 (",round(my_pcoa$values$Relative_eig[2]*100, digits=3),"%)"))+
  guides(colour = guide_legend(override.aes = list(size=6)))+
  theme_bw()+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(), panel.grid.minor.y = element_blank(),
        axis.text=element_text(size=14), axis.text.x=element_text(colour="black"),
        axis.title=element_text(size=14),axis.text.y=element_text(colour="black"),
        text = element_text(size=14),
        legend.title=element_blank())
###PCoA colored by the country of origin
ggplot(pcoa_df,aes(V1,V2,colour = Location)) + 
  geom_point(size=1)+   scale_color_manual(values = c("turquoise4", "red2", "green1",
                                                       "gold3", "olivedrab"))+
  labs(title="", x=paste0("PC1 (",round(my_pcoa$values$Relative_eig[1]*100, digits=3),"%)"), 
       y=paste0("PC2 (",round(my_pcoa$values$Relative_eig[2]*100, digits=3),"%)"))+
  guides(colour = guide_legend(override.aes = list(size=6)))+
  theme_bw()+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(), panel.grid.minor.y = element_blank(),
        axis.text=element_text(size=14), axis.text.x=element_text(colour="black"),
        axis.title=element_text(size=14),axis.text.y=element_text(colour="black"),
        text = element_text(size=14),
        legend.title=element_blank())
###PCoA colored by Age group
ggplot(pcoa_df,aes(V1,V2,colour = AgeGroup)) + 
  geom_point(size=1)+
  scale_colour_manual(values=c("coral3","cyan4","grey70"),
                      labels=c("Adults", "Children", "NA"))+
  labs(title="", x=paste0("PC1 (",round(my_pcoa$values$Relative_eig[1]*100, digits=3),"%)"), 
       y=paste0("PC2 (",round(my_pcoa$values$Relative_eig[2]*100, digits=3),"%)"))+
  guides(colour = guide_legend(override.aes = list(size=6)))+
  theme_bw()+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(), panel.grid.minor.y = element_blank(),
        axis.text=element_text(size=14), axis.text.x=element_text(colour="black"),
        axis.title=element_text(size=14),axis.text.y=element_text(colour="black"),
        text = element_text(size=14),
        legend.title=element_blank())
###PCoA colored by Age
pcoa_df$Age <- as.numeric(pcoa_df$Age)
ggplot(pcoa_df,aes(V1,V2, color=Age)) + 
  scale_color_gradient(low = "yellow",high = "gold4",
                       na.value = "grey80",guide = "colourbar",aesthetics = "color")+
  geom_point(size=1)+
  labs(title="", x=paste0("PC1 (",round(my_pcoa$values$Relative_eig[1]*100, digits=3),"%)"), 
       y=paste0("PC2 (",round(my_pcoa$values$Relative_eig[2]*100, digits=3),"%)"))+
  theme_bw()+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(), panel.grid.minor.y = element_blank(),
        axis.text=element_text(size=14), axis.text.x=element_text(colour="black"),
        axis.title=element_text(size=14),axis.text.y=element_text(colour="black"),
        text = element_text(size=14),
        legend.title=element_blank())
###PCoA colored by Antibiotics use
ggplot(pcoa_df,aes(V1,V2,colour = Antibiotics)) + 
  geom_point(size=1)+   scale_color_manual(values = c("red",  
                                                      "purple","green",
                                                      "magenta","grey80"))+
  labs(title="", x=paste0("PC1 (",round(my_pcoa$values$Relative_eig[1]*100, digits=3),"%)"), 
       y=paste0("PC2 (",round(my_pcoa$values$Relative_eig[2]*100, digits=3),"%)"))+
  guides(colour = guide_legend(override.aes = list(size=6)))+
  theme_bw()+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(), panel.grid.minor.y = element_blank(),
        axis.text=element_text(size=14), axis.text.x=element_text(colour="black"),
        axis.title=element_text(size=14),axis.text.y=element_text(colour="black"),
        text = element_text(size=14),
        legend.title=element_blank())
###PCoA colored by DNA extraction kit
ggplot(pcoa_df,aes(V1,V2,colour = DNAExtractionkit)) + 
  geom_point(size=1)+   
  scale_color_manual(values = c("steelblue2","magenta3", "deeppink4","gold3",
                                "red3", "grey80"),
                     limits = c("MoBio Power Soil DNA Isolation kit ","Norgen Stool DNA Isolation kit",
                                  "phenol trichloromethane DNA extraction method ",
                                 "QIAamp DNA Stool kit ","QIAGEN AllPrep DNA RNA Mini kit","not_available"))+
  labs(title="", x=paste0("PC1 (",round(my_pcoa$values$Relative_eig[1]*100, digits=3),"%)"), 
       y=paste0("PC2 (",round(my_pcoa$values$Relative_eig[2]*100, digits=3),"%)"))+
  guides(colour = guide_legend(override.aes = list(size=6)))+
  theme_bw()+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(), panel.grid.minor.y = element_blank(),
        axis.text=element_text(size=14), axis.text.x=element_text(colour="black"),
        axis.title=element_text(size=14),axis.text.y=element_text(colour="black"),
        text = element_text(size=14),
        legend.title=element_blank())
