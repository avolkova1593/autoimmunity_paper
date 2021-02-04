#### Written by Angelina Volkova on 05/15/2020
#### This script is for making bar plots for each of the studies
#### both on genus level
library(plyr)
library(reshape)
library(ggplot2)
library(grid)
set.seed(5432)
setwd("/Users/av1936/Desktop/Google_Drive/Autoimmunity/revision/ml_ready")
###Custom color palette
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
###Read the file
my_file <- read.table("ml_ready_all_16s__6.txt", as.is =T,header=T, sep="\t")
studies <- c(unique(my_file$Study))
all_bacteria <- character()
all_studies_list <- list()
taxa_ordered <- list()
###Studies with both disease and healthy samples
for (i in c(1,3,5,7:13,15,18,20,21,23:34,36)){
  #i <- 1
  current_study <- my_file[my_file$Study%in%c(studies[i]),]
  healthy <- current_study[current_study$Status%in%c("Healthy"),]
  healthy <- healthy[,-c(1:29)]
  healthy_percent <- as.data.frame(colSums(healthy)/sum(colSums(healthy))*100)
  healthy_percent$Bacteria <- row.names(healthy_percent)
  disease <- current_study[current_study$Status%in%c("Disease"),]
  disease <- disease[,-c(1:29)]
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
for (i in c(2,14,17,19,35)) {
  current_study <- my_file[my_file$Study%in%c(studies[i]),]
  disease <- current_study[current_study$Status%in%c("Disease"),]
  disease <- disease[,-c(1:29)]
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
for (i in c(6,16,22)) {
  current_study <- my_file[my_file$Study%in%c(studies[i]),]
  healthy <- current_study[current_study$Status%in%c("Healthy"),]
  healthy <- healthy[,-c(1:29)]
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
###Li et al. has both SLE and RA samples
for (i in c(4)){
  i <- 4
  current_study <- my_file[my_file$Study%in%c(studies[i]),]
  healthy <- current_study[current_study$Status%in%c("Healthy"),]
  healthy <- healthy[,-c(1:29)]
  healthy_percent <- as.data.frame(colSums(healthy)/sum(colSums(healthy))*100)
  healthy_percent$Bacteria <- row.names(healthy_percent)
  
  disease1 <- current_study[current_study$AutoimmuneDisease%in%c("RA"),]
  disease1 <- disease1[,-c(1:29)]
  disease_percent1 <- as.data.frame(colSums(disease1)/sum(colSums(disease1))*100)
  disease_percent1$Bacteria <- row.names(disease_percent1)
  
  disease2 <- current_study[current_study$AutoimmuneDisease%in%c("SLE"),]
  disease2 <- disease2[,-c(1:29)]
  disease_percent2 <- as.data.frame(colSums(disease2)/sum(colSums(disease2))*100)
  disease_percent2$Bacteria <- row.names(disease_percent2)
  
  taxa <- cbind(healthy_percent, disease_percent1, disease_percent2)
  taxa <- taxa[,c(1,3,5,6)]
  names(taxa) <- c("Healthy", "Disease_RA","Disease_SLE","Bacteria")
  taxa[taxa$Healthy < 0.5 | taxa$Disease_RA < 0.5 | taxa$Disease_SLE < 0.5,]$Bacteria <- "Less_than_0.5%"
  taxa_less <- taxa[taxa$Bacteria%in%c("Less_than_0.5%"),]
  taxa_more <- taxa[!taxa$Bacteria%in%c("Less_than_0.5%"),]
  taxa_less <- aggregate(. ~ Bacteria, data=taxa_less, FUN=sum)
  taxa_final <- rbind(taxa_more,taxa_less)
  names(taxa_final) <- c(paste0(studies[i],"_Healthy"), paste0(studies[i],"_Disease_RA"), 
                         paste0(studies[i],"_Disease_SLE"), "Bacteria")
  taxa_final <- melt(taxa_final, id=c("Bacteria")) 
  taxa_final$Study <- studies[i]
  all_studies_list[[i]] <- taxa_final
  my_bacteria <- c(unique(taxa$Bacteria))
  all_bacteria <- c(all_bacteria, my_bacteria)
}
colors <- c(sample(colors))
bacteria <- unique(all_bacteria)[!unique(all_bacteria)%in%c("Less_than_0.5%")]
less_than_color <- "gray60"
names(colors) <- bacteria
names(less_than_color) <- "Less_than_0.5%"
studies_colors <- c(colors[1:80], less_than_color)
taxa_order_1 <- unique(taxa_ordered[[25]])
taxa_order_1 <- taxa_order_1[!taxa_order_1%in%c("Less_than_0.5%")]
taxa_order_rest <- unique(bacteria)
taxa_order_rest <- taxa_order_rest[!taxa_order_rest%in%c("Less_than_0.5%")]
bacteria_levels <- unique(c(taxa_order_1, taxa_order_rest, "Less_than_0.5%"))

df_taxa <- data.frame(Bacteria=character(),
                      variable=character(), 
                      value=character(),
                      Study=factor(),
                      stringsAsFactors=FALSE)
####Order taxa in each study in the same way
###and combine tables
for (i in 1:length(all_studies_list)){
  #i <- 2
  study <- all_studies_list[[i]]
  bacteria_levels
  study$Bacteria <- factor(as.character(study$Bacteria), levels=bacteria_levels)
  df_taxa <- rbind(df_taxa,study)
}

df_taxa_ibd <- df_taxa[df_taxa$Study%in%c("Bajer","Braun","Halfvarson","Goyal","Jacob",
                                          "Connors","Shaw","Mar","Sprockett","Pascal","Dunn"),]
df_taxa_ibd$Bacteria <- factor(as.character(df_taxa_ibd$Bacteria), levels=bacteria_levels)
df_taxa_ra <- df_taxa[df_taxa$Study%in%c("Di_Paola","Li","Zegarra_Ruiz","Chen_RA","Manasson","Lee","Scher",       
                                         "Luo","Sun","Consolandi","Tejesvi","Hevia", "Ruff","Stoll"),]
df_taxa_ra$Bacteria <- factor(as.character(df_taxa_ra$Bacteria), levels=bacteria_levels)
df_taxa_ms <- df_taxa[!df_taxa$Study%in%c("Bajer","Braun","Halfvarson","Goyal","Jacob",
                                           "Connors","Shaw","Mar","Sprockett","Pascal","Dunn",
                                           "Di_Paola","Li","Zegarra_Ruiz","Chen_RA","Manasson","Lee","Scher",       
                                           "Luo","Sun","Consolandi","Tejesvi","Hevia", "Ruff","Stoll"),]
df_taxa_ms$Bacteria <- factor(as.character(df_taxa_ms$Bacteria), levels=bacteria_levels)
studies_colors <- studies_colors[order(factor(names(studies_colors), levels = bacteria_levels))]
###Extract taxa for a legend 
b <- ggplot(df_taxa, 
       aes(x=variable, y=value, fill=Bacteria)) +
  geom_bar(stat = "identity", position = position_fill(reverse = TRUE)) + 
  scale_fill_manual(values=studies_colors)+
  labs(title="", y="Relative Abundance", x="")+
  theme_bw()+  
  guides(fill=guide_legend(ncol=3)) +
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

###make a barplot of ibd studies
ggplot(df_taxa_ibd, aes(x=variable, y=value, fill=Bacteria)) +
   geom_bar(stat = "identity", position = position_fill(reverse = TRUE)) + 
   scale_fill_manual(values=studies_colors)+
   scale_x_discrete(limits=c("Bajer_Disease", "Bajer_Healthy", "", 
                             "Braun_Disease", "Braun_Healthy", "",
                             "Dunn_Disease","Dunn_Healthy", "",
                             "Goyal_Disease","Goyal_Healthy","",
                             "Halfvarson_Disease","Halfvarson_Healthy","",
                             "Mar_Disease","Mar_Healthy","",
                            "Pascal_Disease", "Pascal_Healthy", "",
                            "Shaw_Disease", "Shaw_Healthy", "",
                             "Connors_Disease", "", "Jacob_Disease", "", "Sprockett_Disease"))+
   labs(title="", y="Relative Abundance", x="")+
   theme_bw()+  
   theme(legend.position="none")+
   theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank(),
         panel.grid.major.y = element_blank(), panel.grid.minor.y = element_blank(),
         axis.text=element_text(size=12,colour="black"), axis.text.x = element_text(angle = 90, hjust = 1),
         axis.title=element_text(size=12,colour="black"),
         text = element_text(size=12,colour="black"),
         legend.title=element_blank())

###Make a barplot of ra studies
ggplot(df_taxa_ra, aes(x=variable, y=value, fill=Bacteria)) +
   geom_bar(stat = "identity", position = position_fill(reverse = TRUE)) + 
   scale_fill_manual(values=studies_colors)+
   scale_x_discrete(limits=c("Chen_RA_Disease", "Chen_RA_Healthy", "",
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
   labs(title="", y="Relative Abundance", x="")+
   theme_bw()+  
   theme(legend.position="none")+
   theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank(),
         panel.grid.major.y = element_blank(), panel.grid.minor.y = element_blank(),
         axis.text=element_text(size=12,colour="black"), axis.text.x = element_text(angle = 90, hjust = 1),
         axis.title=element_text(size=12,colour="black"),
         text = element_text(size=12,colour="black"),
         legend.title=element_blank())
 
###Make a barplot of ms and the rest of the studies
 ggplot(df_taxa_ms, aes(x=variable, y=value, fill=Bacteria)) +
   geom_bar(stat = "identity", position = position_fill(reverse = TRUE)) + 
   scale_fill_manual(values=studies_colors)+
   scale_x_discrete(limits=c("Cekanaviciute_Disease", "Cekanaviciute_Healthy", "",
                             "Chen_MS_Disease","Chen_MS_Healthy", "",
                             "Choileain_Disease","Choileain_Healthy","",
                             "Jangi_Disease","Jangi_Healthy","",
                             "Kozhieva_Disease", "Kozhieva_Healthy", "","Miyake_Disease","",
                             "Moris_Disease", "Moris_Healthy", "",
                             "Mejia_Leon_Disease", "Mejia_Leon_Healthy", "",
                             "Giloteaux_Healthy", "", "HMP1_Healthy","", "Whisner_Healthy"))+
   labs(title="", y="Relative Abundance", x="")+
   theme_bw()+  
   theme(legend.position="none")+
   theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank(),
         panel.grid.major.y = element_blank(), panel.grid.minor.y = element_blank(),
         axis.text=element_text(size=12,colour="black"), axis.text.x = element_text(angle = 90, hjust = 1),
         axis.title=element_text(size=12,colour="black"),
         text = element_text(size=12,colour="black"),
         legend.title=element_blank())
 