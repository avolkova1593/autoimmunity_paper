###Written by Angelina Volkova on 05/05/2020
###This script trains a taxonomy classifier on
###whole 16s rRNA sequences from GreenGenes 13_8 database
#!/bin/bash
output="output_directory"
database_seqs=$output/gg_otu_99.qza
database_tax=$output/ref-taxonomy.qza

qiime feature-classifier fit-classifier-naive-bayes \
--i-reference-reads $database_seqs \
--i-reference-taxonomy $database_tax \
--o-classifier $output/whole_classifier.qza
