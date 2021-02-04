###Written by Angelina Volkova on 06/02/2020
###This script makes a heatmap of AUCs and F1 scores

library(ComplexHeatmap)
library(circlize)
file_aucs <- read.table("/Users/av1936/Desktop/Desktop/Autoimmunity/revision/ml_results_revision/auc_heatmaps/aucs.txt",
                        sep="\t", header=T)
file_f1 <- read.table("/Users/av1936/Desktop/Desktop/Autoimmunity/revision/ml_results_revision/auc_heatmaps/f1_macro.txt",
                   sep="\t", header=T)

row.names(file_aucs) <- as.character(file_aucs$Data)
row.names(file_f1) <- as.character(file_f1$Data)

Heatmap(file_aucs, cluster_columns = F, cluster_rows=F,column_title = "",
        row_title = "",
        col = colorRamp2(c(0.65,1), c("white","red3")),
        heatmap_legend_param = list(title = ""),
        row_names_gp = gpar(fontsize = 10),
        cell_fun = function(j, i, x, y, width, height, fill) {
          grid.text(sprintf("%.3f", file[i, j]), x, y, gp = gpar(fontsize = 10))
        })

Heatmap(file_f1, cluster_columns = F, cluster_rows=F,column_title = "",
        row_title = "",
        col = colorRamp2(c(0.5,0.75), c("white","orange")),
        heatmap_legend_param = list(title = ""),
        row_names_gp = gpar(fontsize = 10),
        cell_fun = function(j, i, x, y, width, height, fill) {
          grid.text(sprintf("%.3f", file[i, j]), x, y, gp = gpar(fontsize = 10))
        })


