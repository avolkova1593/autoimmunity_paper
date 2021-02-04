###Written by Angelina Volkova on 05/18/2020
###This script makes 3 Venn diagrams for IBD, MS and RA
###Calculates how many features overlap in models that contain one of the above diseases

library(VennDiagram)
setwd("/Users/av1936/Desktop/Google_Drive/Autoimmunity/revision/ml_ready/ml_results/") ###Change directory of needed
write.table(logfc,paste0("ml_results/logfc_",model_type,"_",data_type,"_6_",adults,".txt"),col.names = T,
            row.names = F, quote=F, sep="\t")

venn_ibd <- read.table("logfc_IBD_16s_6_Adults.txt", sep="\t", header=T)
venn_ms <- read.table("logfc_MS_16s_6_Adults.txt", sep="\t", header=T)
venn_ra <- read.table("logfc_RA_16s_6_Adults.txt", sep="\t", header=T)
venn_ibd_ms <- read.table("logfc_IBD_vs_MS_16s_6_Adults.txt", sep="\t", header=T)
venn_ms_ibd <- read.table("logfc_MS_vs_IBD_16s_6_Adults.txt", sep="\t", header=T) #Version of IBD_vs_MS with logfc and direction reversed
venn_ibd_ra <- read.table("logfc_IBD_vs_RA_16s_6_Adults.txt", sep="\t", header=T)
venn_ra_ibd <- read.table("logfc_RA_vs_IBD_16s_6_Adults.txt", sep="\t", header=T) #Version of IBD_vs_RA with logfc and direction reversed
venn_ms_ra <- read.table("logfc_MS_vs_RA_16s_6_Adults.txt", sep="\t", header=T)
venn_ra_ms <- read.table("logfc_RA_vs_MS_16s_6_Adults.txt", sep="\t", header=T) #Version of MS_vs_RA with logfc and direction reversed

venn_ibd <- venn_ibd[c(1:30),]
venn_ms <- venn_ms[c(1:30),]
venn_ra <- venn_ra[c(1:30),]
venn_ibd_ms <- venn_ibd_ms[c(1:30),]
venn_ms_ibd <- venn_ms_ibd[c(1:30),]
venn_ibd_ra <- venn_ibd_ra[c(1:30),]
venn_ra_ibd <- venn_ra_ibd[c(1:30),]
venn_ms_ra <- venn_ms_ra[c(1:30),]
venn_ra_ms <- venn_ra_ms[c(1:30),]

positive_3_ibd <- intersect(intersect(as.character(venn_ibd$bacteria[venn_ibd$direction%in%c("Positive")]),
                                      as.character(venn_ibd_ms$bacteria[venn_ibd_ms$direction%in%c("Positive")])),
                            as.character(venn_ibd_ra$bacteria[venn_ibd_ra$direction%in%c("Positive")]))
positive_12_ibd <- intersect(as.character(venn_ibd$bacteria[venn_ibd$direction%in%c("Positive")]),
                                       as.character(venn_ibd_ms$bacteria[venn_ibd_ms$direction%in%c("Positive")]))
positive_23_ibd <- intersect(as.character(venn_ibd_ra$bacteria[venn_ibd_ra$direction%in%c("Positive")]),
                             as.character(venn_ibd_ms$bacteria[venn_ibd_ms$direction%in%c("Positive")]))
positive_13_ibd <- intersect(as.character(venn_ibd$bacteria[venn_ibd$direction%in%c("Positive")]),
                             as.character(venn_ibd_ra$bacteria[venn_ibd_ra$direction%in%c("Positive")]))


negative_3_ibd <- intersect(intersect(as.character(venn_ibd$bacteria[venn_ibd$direction%in%c("Negative")]),
                                      as.character(venn_ibd_ms$bacteria[venn_ibd_ms$direction%in%c("Negative")])),
                            as.character(venn_ibd_ra$bacteria[venn_ibd_ra$direction%in%c("Negative")]))
negative_12_ibd <- intersect(as.character(venn_ibd$bacteria[venn_ibd$direction%in%c("Negative")]),
                             as.character(venn_ibd_ms$bacteria[venn_ibd_ms$direction%in%c("Negative")]))
negative_23_ibd <- intersect(as.character(venn_ibd_ra$bacteria[venn_ibd_ra$direction%in%c("Negative")]),
                             as.character(venn_ibd_ms$bacteria[venn_ibd_ms$direction%in%c("Negative")]))
negative_13_ibd <- intersect(as.character(venn_ibd$bacteria[venn_ibd$direction%in%c("Negative")]),
                             as.character(venn_ibd_ra$bacteria[venn_ibd_ra$direction%in%c("Negative")]))



positive_3_ms <- intersect(intersect(as.character(venn_ms$bacteria[venn_ms$direction%in%c("Positive")]),
                                      as.character(venn_ms_ibd$bacteria[venn_ms_ibd$direction%in%c("Positive")])),
                            as.character(venn_ms_ra$bacteria[venn_ms_ra$direction%in%c("Positive")]))
positive_12_ms <- intersect(as.character(venn_ms$bacteria[venn_ms$direction%in%c("Positive")]),
                                     as.character(venn_ms_ibd$bacteria[venn_ms_ibd$direction%in%c("Positive")]))
positive_23_ms <- intersect(as.character(venn_ms_ra$bacteria[venn_ms_ra$direction%in%c("Positive")]),
                            as.character(venn_ms_ibd$bacteria[venn_ms_ibd$direction%in%c("Positive")]))
positive_13_ms <- intersect(as.character(venn_ms$bacteria[venn_ms$direction%in%c("Positive")]),
                            as.character(venn_ms_ra$bacteria[venn_ms_ra$direction%in%c("Positive")]))



negative_3_ms <- intersect(intersect(as.character(venn_ms$bacteria[venn_ms$direction%in%c("Negative")]),
                                      as.character(venn_ms_ibd$bacteria[venn_ms_ibd$direction%in%c("Negative")])),
                            as.character(venn_ms_ra$bacteria[venn_ms_ra$direction%in%c("Negative")]))
negative_12_ms <- intersect(as.character(venn_ms$bacteria[venn_ms$direction%in%c("Negative")]),
                            as.character(venn_ibd_ms$bacteria[venn_ibd_ms$direction%in%c("Negative")]))
negative_23_ms <- intersect(as.character(venn_ms_ra$bacteria[venn_ms_ra$direction%in%c("Negative")]),
                            as.character(venn_ms_ibd$bacteria[venn_ms_ibd$direction%in%c("Negative")]))
negative_13_ms <- intersect(as.character(venn_ms_ra$bacteria[venn_ms_ra$direction%in%c("Negative")]),
                            as.character(venn_ms$bacteria[venn_ms$direction%in%c("Negative")]))


positive_3_ra <- intersect(intersect(as.character(venn_ra$bacteria[venn_ra$direction%in%c("Positive")]),
                                     as.character(venn_ra_ibd$bacteria[venn_ra_ibd$direction%in%c("Positive")])),
                           as.character(venn_ra_ms$bacteria[venn_ra_ms$direction%in%c("Positive")]))
positive_12_ra <- intersect(as.character(venn_ra$bacteria[venn_ra$direction%in%c("Positive")]),
                                     as.character(venn_ra_ibd$bacteria[venn_ra_ibd$direction%in%c("Positive")]))
positive_23_ra <- intersect(as.character(venn_ra_ms$bacteria[venn_ra_ms$direction%in%c("Positive")]),
                            as.character(venn_ra_ibd$bacteria[venn_ra_ibd$direction%in%c("Positive")]))
positive_13_ra <- intersect(as.character(venn_ra$bacteria[venn_ra$direction%in%c("Positive")]),
                            as.character(venn_ra_ms$bacteria[venn_ra_ms$direction%in%c("Positive")]))


negative_3_ra <- intersect(intersect(as.character(venn_ra$bacteria[venn_ra$direction%in%c("Negative")]),
                                     as.character(venn_ra_ibd$bacteria[venn_ra_ibd$direction%in%c("Negative")])),
                           as.character(venn_ra_ms$bacteria[venn_ra_ms$direction%in%c("Negative")]))
negative_12_ra <- intersect(as.character(venn_ra$bacteria[venn_ra$direction%in%c("Negative")]),
                            as.character(venn_ra_ibd$bacteria[venn_ra_ibd$direction%in%c("Negative")]))
negative_23_ra <- intersect(as.character(venn_ra_ms$bacteria[venn_ra_ms$direction%in%c("Negative")]),
                            as.character(venn_ra_ibd$bacteria[venn_ra_ibd$direction%in%c("Negative")]))
negative_13_ra <- intersect(as.character(venn_ra$bacteria[venn_ra$direction%in%c("Negative")]),
                            as.character(venn_ra_ms$bacteria[venn_ra_ms$direction%in%c("Negative")]))
###Save all bacteria present in venn diagrams
all_bugs <- unique(c(negative_12_ibd, negative_23_ibd, negative_13_ibd, negative_3_ibd,
                   positive_12_ibd, positive_23_ibd, positive_13_ibd, positive_3_ibd,
                   negative_12_ms, negative_23_ms, negative_13_ms, negative_3_ms,
                   positive_12_ms, positive_23_ms, positive_13_ms, positive_3_ms,
                   negative_12_ra, negative_23_ra, negative_13_ra, negative_3_ra,
                   positive_12_ra, positive_23_ra, positive_13_ra, positive_3_ra))
write.table(as.data.frame(all_bugs), file="/Users/av1936/Desktop/all_venn_bugs.txt", sep="\t",
            col.names = F, row.names=F, quote=F)
###make venn diagrams
ibd_12 <- length(positive_12_ibd)+length(negative_12_ibd) 
ibd_23 <- length(positive_23_ibd)+length(negative_23_ibd)
ibd_13 <- length(positive_13_ibd)+length(negative_13_ibd)
ibd_all <- length(positive_3_ibd)+length(negative_3_ibd)

ms_12 <- length(positive_12_ms)+length(negative_12_ms)
ms_23 <- length(positive_23_ms)+length(negative_23_ms)
ms_13 <- length(positive_13_ms)+length(negative_13_ms)
ms_all <- length(positive_3_ms)+length(negative_3_ms)

ra_12 <- length(positive_12_ra)+length(negative_12_ra)
ra_23 <- length(positive_23_ra)+length(negative_23_ra)
ra_13 <- length(positive_13_ra)+length(negative_13_ra)
ra_all <- length(positive_3_ra)+length(negative_3_ra)

dev.off()
##IBD 
grid.newpage()
draw.triple.venn(area1 = 30 , area2 = 30, area3 = 30  , n12 = ibd_12, n23 =ibd_23  , n13 =ibd_13 , 
                  n123 =ibd_all , category = c("", "", ""), lty = "blank", 
                  fill = c("green3","deeppink3", "blue3" ),cex=2)
dev.off()

##MS 
grid.newpage()
draw.triple.venn(area1 = 30 , area2 = 30, area3 = 30  , n12 = ms_12, n23 =ms_23  , n13 = ms_13, 
                 n123 = ms_all , category = c("", "", ""), lty = "blank", 
                 fill = c("green3","deeppink3", "blue3" ),cex=2)
dev.off()

##RA
grid.newpage()
draw.triple.venn(area1 = 30 , area2 = 30, area3 = 30  , n12 = ra_12, n23 = ra_23  , n13 = ra_13 , 
                 n123 = ra_all , category = c("", "", ""), lty = "blank", 
                 fill = c("green3","deeppink3", "blue3" ),cex=2)


