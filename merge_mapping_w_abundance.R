###Written by Angelina Volkova on 05/14/2020
###This script merges mapping file with the abundance tables
###and converts absolute abundance to relative abundance
setwd("/Users/av1936/Desktop/Google_Drive/Autoimmunity/revision")

levels <- c("6","7") ##6 for genus, 7 for species
##Merge 16s mapping file with 16s abundance table
for (level in levels) {
  mapping_file_16s <- read.table("files_with_abundance/all_16s_mapping_file_modified.txt", header=T, sep ="\t")
  abundance_table_16s <-read.table(paste0("files_with_abundance/all_studies_table_rare_5000_",level,".txt"),header=T, sep="\t")
  abundance_table_16s <- as.data.frame(t(abundance_table_16s))
  my_names_16s <- as.character(unlist(abundance_table_16s[1,]))
  names(abundance_table_16s) <- my_names_16s
  abundance_table_16s <- abundance_table_16s[-1,]
  abundance_table_numeric_16s <- apply(abundance_table_16s, 2, as.numeric)
  abundance_table_percent_16s <- as.data.frame(abundance_table_numeric_16s/rowSums(abundance_table_numeric_16s)*100)
  abundance_table_percent_16s$SampleID <- row.names(abundance_table_16s)
  merged_df_16s <- merge(mapping_file_16s,abundance_table_percent_16s, by="SampleID")
  ###Calculate how many samples left in each study after merging
  print(summary(as.factor(mapping_file_16s$Study)))
  print(summary(as.factor(merged_df_16s$Study)))
  write.table(merged_df_16s, file=paste0("ml_ready/ml_ready_all_16s_",level,".txt"),col.names=T, row.names=F, 
             sep ="\t", quote=F)
}

###Merge metagenomics mapping file with metagenomics abundance table
for (level in levels) {
  mapping_file_meta <- read.table("files_with_abundance/all_meta_mapping_file.txt", header=T, sep ="\t")
  abundance_table_meta <-read.table(paste0("files_with_abundance/all_meta_studies_",level,".tsv"),
                             header=T, sep="\t")
  names(abundance_table_meta) <- gsub("_metaphlan_bugs_list","", names(abundance_table_meta))
  names(abundance_table_meta) <- gsub("_trimmed","", names(abundance_table_meta))
  names(abundance_table_meta) <- gsub("combined","Sample", names(abundance_table_meta))
  names(abundance_table_meta) <- gsub("(FE).*", "\\1", names(abundance_table_meta))
  names(abundance_table_meta)[700:711] <- c("Sample_030B_FE","Sample_034B_FE","Sample_035B_FE", "Sample_037B_FE",
                                     "Sample_038B_FE","Sample_042B_FE","Sample_049B_FE","Sample_068B_FE",
                                     "Sample_070B_FE","Sample_080B_FE","Sample_090B_FE","Sample_104B_FE")
  abundance_table_meta <- as.data.frame(t(abundance_table_meta))
  my_names_meta <- as.character(unlist(abundance_table_meta[1,]))
  names(abundance_table_meta) <- my_names_meta
  abundance_table_meta <- abundance_table_meta[-1,]
  abundance_table_meta$SampleID <- row.names(abundance_table_meta)
  merged_df_meta <- merge(mapping_file_meta,abundance_table_meta, by="SampleID")
  ###Calculate how many samples left in each study after merging
  print(summary(as.factor(mapping_file_meta$Study)))
  print(summary(as.factor(merged_df_meta$Study)))
  write.table(merged_df_meta, file=paste0("ml_ready/ml_ready_all_meta_",level,".txt"),
              col.names=T, row.names=F, sep ="\t", quote=F)
}


