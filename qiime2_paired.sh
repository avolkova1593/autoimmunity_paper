###Written by Angelina Volkova on 05/05/2020
###This script processes paired-read Illumina fastq files 
###paths to which are provided in a manifest file 
###${1} is a directory containing individual study data
###${2} is a rarefaction depth
###${3} is a taxonomic level (6 for genus, 7 for species)
#!/bin/bash
output="output_directory"

qiime tools import \
--type 'SampleData[PairedEndSequencesWithQuality]' \
--input-path $output/${1}/${1}_manifest.csv \
--output-path $output/${1}/${1}_demux.qza \
--input-format PairedEndFastqManifestPhred33

qiime demux summarize \
--i-data $output/${1}/${1}_demux.qza \
--o-visualization $output/${1}/${1}_demux.qzv

qiime dada2 denoise-paired \
--i-demultiplexed-seqs $outputDir/${1}/${1}_demux.qza \
--p-trunc-len-f 0 \
--p-trunc-len-r 0 \
--p-trim-left-f 20 \
--p-trim-left-r 20 \
--o-table $outputDir/${1}/${1}_table.qza \
--o-representative-sequences $outputDir/${1}/${1}_rep_seqs.qza \
--o-denoising-stats $outputDir/${1}/${1}_denoising_stats.qza

qiime feature-table summarize \
--i-table $output/${1}/${1}_table.qza \
--o-visualization $output/${1}/${1}_table.qzv \

qiime feature-table tabulate-seqs \
--i-data $output/${1}/${1}_rep_seqs.qza \
--o-visualization $output/${1}/${1}_rep_seqs.qzv

qiime feature-classifier classify-sklearn \
--i-classifier $output/whole_classifier.qza \
--i-reads $output/${1}/${1}_rep_seqs.qza \
--o-classification $output/${1}/${1}_taxonomy.qza

qiime feature-table rarefy \
--i-table $output/${1}/${1}_table.qza \
--p-sampling-depth ${2} \
--o-rarefied-table $output/${1}/${1}_table_rare_${2}.qza

qiime taxa collapse \
--i-table $output/${1}/${1}_table_rare_${2}.qza \
--i-taxonomy $output/${1}/${1}_taxonomy.qza \
--p-level ${3} \
--o-collapsed-table $output/${1}/${1}_table_rare_${2}_${3}.qza

qiime feature-table summarize \
--i-table $output/${1}/${1}_table_rare_${2}_${3}.qza \
--o-visualization $output/${1}/${1}_table_rare_${2}_${3}.qzv

