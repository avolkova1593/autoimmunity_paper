###Written by ANgelina Volkova on 05/10/2020
###This script makes horizontal bars and bars of the number of healthy 
###and disease samples in each of the 16S studies
library(ggplot2)
library(ComplexHeatmap)
set.seed(234)
setwd("/Users/av1936/Desktop/Google_Drive/Autoimmunity/tables")
info <- read.table("studies_16s_info.txt", header=T, sep="\t")
###Make horizontal bars plots for Figure2 
h1 <- Heatmap(rev(info$Disease_in_question), name = "Disease in question", show_row_names = FALSE, 
              width = unit(3, "mm"), show_heatmap_legend = TRUE,
              col=c("steelblue3","red", "forestgreen","turquoise4",
               "royalblue3","pink3","purple3","cyan2","yellow3",  "magenta4",
               "black","coral2","deepskyblue2"),
              heatmap_legend_param=list(labels_gp = gpar(fontsize = 9), ncol=2))
h2 <- Heatmap(rev(info$Sequencing_Technology), name = "Platform", show_row_names = FALSE, 
             width=unit(3,"mm"),show_heatmap_legend = TRUE,
              col=c("deeppink2", "royalblue2", "green3"),
              heatmap_legend_param=list(labels_gp = gpar(fontsize = 9), ncol=1))
h3 <- Heatmap(rev(info$AgeGroup), name = "Age Group", show_row_names = FALSE, width = unit(3, "mm"), 
              col=c("coral3","gold3","cyan4","grey70"),show_heatmap_legend = TRUE,
              heatmap_legend_param=list(labels_gp = gpar(fontsize = 9), ncol=1))
h4 <- Heatmap(rev(info$Location), name = "Location", show_row_names = FALSE, width = unit(3, "mm"), 
              col=c("turquoise4", "red2",  "brown",
              "purple3","green3","steelblue2",
              "magenta3",
              "plum3","deeppink4",  "rosybrown4",
               "royalblue2", "olivedrab3",
              "navyblue", "maroon",  "gold3"),show_heatmap_legend = TRUE,
              heatmap_legend_param=list(labels_gp = gpar(fontsize = 9), ncol=2))
draw(h4+h3+h2+h1)

###Making the bar plots of healthy and disease number of samples for each study
ggplot(info[c(1:19),], aes(x=Study, y=NumberSamples, fill=Status)) +
  geom_bar(stat = "identity", position = "dodge") + 
  scale_fill_manual(values=c("red3","steelblue3"))+
  scale_x_discrete(limits=c("Bajer_Disease", "Bajer_Healthy", "", 
                            "Braun_Disease", "Braun_Healthy", "",
                            "Dunn_Disease","Dunn_Healthy", "",
                            "Goyal_Disease","Goyal_Healthy","",
                            "Halfvarson_Disease","Halfvarson_Healthy","",
                            "Mar_Disease","Mar_Healthy","",
                            "Pascal_Disease", "Pascal_Healthy", "",
                            "Shaw_Disease", "Shaw_Healthy", "",
                            "Connors_Disease", "", "Jacob_Disease", "", "Sprockett_Disease"))+
  labs(title="", y="Samples", x="") + ylim(0,125)+
  theme_bw()+ theme(legend.position="none")+
  theme( axis.text=element_text(size=12),
        axis.text.x=element_text(colour="black", angle = 90, hjust = 1),
        axis.title=element_text(size=12, color="black"),axis.text.y=element_text(colour="black"),
        text = element_text(size=12,color="black"),plot.title = element_text(hjust = 0.5),
        legend.title=element_blank())

ggplot(info[c(20:37),],aes(x=Study, y=NumberSamples, fill=Status)) +
  geom_bar(stat = "identity", position = "dodge") + 
  scale_fill_manual(values=c("red3","steelblue3"))+
  scale_x_discrete(limits=c( "Cekanaviciute_Disease", "Cekanaviciute_Healthy", "",
                            "Chen_MS_Disease","Chen_MS_Healthy", "",
                            "Choileain_Disease","Choileain_Healthy","",
                            "Jangi_Disease","Jangi_Healthy","",
                            "Kozhieva_Disease", "Kozhieva_Healthy", "","Miyake_Disease","",
                            "Moris_Disease", "Moris_Healthy", "",
                            "Mejia_Leon_Disease", "Mejia_Leon_Healthy", "",
                            "Giloteaux_Healthy", "", "HMP1_Healthy","", "Whisner_Healthy"))+
  labs(title="", y="Samples", x="")+ ylim(0,125)+
  theme_bw()+ theme(legend.position="none")+
  theme(axis.text=element_text(size=12),
    axis.text.x=element_text(colour="black", angle = 90, hjust = 1),
    axis.title=element_text(size=12, color="black"),axis.text.y=element_text(colour="black"),
    text = element_text(size=12,color="black"),plot.title = element_text(hjust = 0.5),
    legend.title=element_blank())

ggplot(info[c(38:65),], aes(x=Study, y=NumberSamples, fill=Status)) +
  geom_bar(stat = "identity", position = "dodge") + 
  scale_fill_manual(values=c("red3","steelblue3"))+
  scale_x_discrete(limits=c( "Chen_RA_Disease", "Chen_RA_Healthy", "",
                             "Scher_Disease","Scher_Healthy", "","Lee_Disease", "",
                             "Sun_Disease","Sun_Healthy","",
                             "Li_Disease_RA","Li_Disease_SLE","Li_Healthy","",
                             "Hevia_Disease", "Hevia_Healthy", "",
                             "Luo_Disease", "Luo_Healthy", "",
                             "Zegarra_Ruiz_Disease", "Zegarra_Ruiz_Healthy", "",
                             "Manasson_Disease", "Manasson_Healthy", "",
                             "Consolandi_Disease", "Consolandi_Healthy","",
                             "Ruff_Disease", "Ruff_Healthy","",
                             "Di_Paola_Disease", "Di_Paola_Healthy","",
                             "Stoll_Disease", "Stoll_Healthy","",
                             "Tejesvi_Disease", "Tejesvi_Healthy",""))+
  labs(title="", y="Samples", x="")+ ylim(0,125)+
  theme(legend.position="none")+ theme_bw()+ 
  theme(legend.position="none")+
  theme(axis.text=element_text(size=12),
    axis.text.x=element_text(colour="black", angle = 90, hjust = 1),
    axis.title=element_text(size=12, color="black"),axis.text.y=element_text(colour="black"),
    text = element_text(size=12,color="black"),plot.title = element_text(hjust = 0.5),
    legend.title=element_blank())

#extract the legend
c <- ggplot(info, aes(x=Study, y=NumberSamples, fill=Status)) +
  geom_bar(stat = "identity", position = "dodge") + 
  scale_fill_manual(values=c("red3","steelblue3"))+
  labs(title="", y="Samples", x="")+
  guides(fill=guide_legend(ncol=1)) +
  theme_bw()+ 
  theme( axis.text=element_text(size=12),
         axis.text.x=element_text(colour="black", angle = 90, hjust = 1),
         axis.title=element_text(size=12, color="black"),axis.text.y=element_text(colour="black"),
         text = element_text(size=12,color="black"),plot.title = element_text(hjust = 0.5),
         legend.title=element_blank())
g_legend <- function(a.gplot){ 
  tmp <- ggplot_gtable(ggplot_build(a.gplot)) 
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box") 
  legend <- tmp$grobs[[leg]] 
  return(legend)} 
legend <- g_legend(c) 
grid.newpage()
grid.draw(legend) 
