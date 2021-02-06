This repository contains scripts for processing data for Volkova & Ruggles paper:  
"Metagenomic Analysis ofAutoimmune DiseaseIdentifiesRobust Autoimmunity and 2 Disease Specific Microbial Signatures".  

Brief description of each of the scripts:    

__barplots_genus_16s_for_fig2.R__ makes bar plots for each of the 16S studies on genus level.   
__barplots_genus_meta_for_fig2.R__ makes bar plots for each of the metagenomics studies on genus level.    
__barplots_info_16S_for_fig2.R__ makes horizontal bars and bars of the number of healthy and disease samples in each of the 16S studies.   
__barplots_info_meta_for_fig2.R__ makes horizontal bars and bars of the number of healthy and disease samples in each of the metagenomics studies.   
__compute_f1.R__ computes F1 macro score.   
__correlate_w_metabolomics.R__ performs spearman correlation between iHMP metagenomics and metaproteomics data for bacteria found to be predictive of disease.     
__make_lollipop_plots.R__ makes lollipop and logfc plots of ranked features.    
__make_venn_diagrams.R__ makes 3 Venn diagrams for IBD, MS and RA and calculates how many features overlap in models that contain one of the above diseases.   
__merge_mapping_w_abundance.R__ merges mapping file with the abundance tables and converts absolute abundance to relative abundance.   
__metagenomics_paired.sh__ processes paired read metagenomics data with the accession numbers being supplied as a txt file.    
__metagenomics_single.sh__ processes single read metagenomics data with the accession numbers being supplied as a txt file.    
__ml_functions.R__ contains machine learning functions for running random forest, xgboost, svm with rfe and ridge regression.    
__ml_performance_heatmap.R__ makes a heatmap of AUCs and F1 scores.    
__pcoa_16s.R__ creates PCOA plots from 16S relative abundance tables.   
__pcoa_meta.R__ creates PCoA plots from metagenomics relative abundance tables.    
__piecharts_excluded_studies.R__ makes pie charts to show how the studies were excluded based on different criteria.    
__prepare_for_ml_disease_vs_disease.R__ prepares a table with metadata and microbial abundance for machine learning for disease vs disease models.    
__prepare_for_ml_disease_vs_healthy.R__ prepares a table with metadata and microbial abundance for machine learning.    
__qiime2_454.sh__ processes 454 fastq files paths to which are provided in a manifest file.    
__qiime2_paired.sh__ processes paired-read Illumina fastq files paths to which are provided in a manifest file.     
__qiime2_single.sh__ processes single-read Illumina and Ion Torrent fastq files paths to which are provided in a manifest file.    
__qiime2_train_taxonomy.sh__ trains a taxonomy classifier on whole 16s rRNA sequences from GreenGenes 13_8 database.    
__rank_features.R__ ranks the features by mean importance from all four models.    
__run_ml_disease_vs_disease.R__ runs ml on prepared tables from prepare_for_ml_disease_vs_disease.R.    
__run_ml_disease_vs_healthy.R__ run ml on prepared tables from prepare_for_ml_disease_vs_healthy.R.    
__visualize_metabolomics_correlation.R__ plots a heatmap and metabolites correlated with individual bacteria colored by p values.  
