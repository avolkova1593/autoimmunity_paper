###Written by ANgelina Volkova on 05/10/2020
###This script makes horizontal bars and bars of the number of healthy 
###and disease samples in each of the metagenomics studies studies
library(ggplot2)
library(ComplexHeatmap)
set.seed(234)
setwd("/Users/av1936/Desktop/Google_Drive/Autoimmunity/tables")
info <- read.table("meta_info.txt", header=T, sep="\t")

h1 <- Heatmap(rev(info$Disease_in_question), name = "Disease in question", show_row_names = FALSE, 
              width = unit(3, "mm"), show_heatmap_legend = TRUE,
              col=c("steelblue3","brown", "forestgreen","turquoise4",
               "pink3","yellow3", "deepskyblue2"),
              heatmap_legend_param=list(labels_gp = gpar(fontsize = 9), ncol=2))
h2 <- Heatmap(rev(info$Sequencing_Technology), name = "Platform", show_row_names = FALSE, 
             width=unit(3,"mm"),show_heatmap_legend = TRUE,
              col=c("royalblue2"),
              heatmap_legend_param=list(labels_gp = gpar(fontsize = 9), ncol=1))
h3 <- Heatmap(rev(info$AgeGroup), name = "Age Group", show_row_names = FALSE, width = unit(3, "mm"), 
              col=c("coral3","gold3","cyan4"),show_heatmap_legend = TRUE,
              heatmap_legend_param=list(labels_gp = gpar(fontsize = 9), ncol=1))
h4 <- Heatmap(rev(info$Location), name = "Location", show_row_names = FALSE, width = unit(3, "mm"), 
              col=c("turquoise4", "red2", "green1",
                    "gold3", "olivedrab"),show_heatmap_legend = TRUE,
              heatmap_legend_param=list(labels_gp = gpar(fontsize = 9), ncol=2))
draw(h4+h3+h2+h1)#, heatmap_legend_side = "left")

###Make the disease and healthy number of samples bar plots
ggplot(info, aes(x=Study, y=NumberSamples, fill=Status)) +
  geom_bar(stat = "identity", position = "dodge") + 
  scale_fill_manual(values=c("red3","steelblue3"))+
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
  labs(title="", y="Samples", x="") + ylim(0,325)+
  theme_bw()+ theme(legend.position="none")+
  theme( axis.text=element_text(size=12),
        axis.text.x=element_text(colour="black", angle = 90, hjust = 1),
        axis.title=element_text(size=12, color="black"),axis.text.y=element_text(colour="black"),
        text = element_text(size=12,color="black"),plot.title = element_text(hjust = 0.5),
        legend.title=element_blank())

