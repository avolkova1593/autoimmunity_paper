###Written by Angelina Volkova on 05/05/2020
###This script processes single read metagenomics data
###with the accession numbers being supplied as a txt file
#!/bin/bash
module unload anaconda2/cpu/5.2.0
module load python/cpu/2.7.15
module load fastx-toolkit/0.0.13
module load bowtie2/2.3.4.1
module load metaphlan2/097a52362c79

cd ${1} ###${1} is a directory containing data of an individual study

#assign samples to variables
output = "output_directory"
sample_prefix=$(sed -n "$SLURM_ARRAY_TASK_ID"p accession_numbers.txt)
threads=12
hostDB=$output/databases/Homo_sapiens_Bowtie2_v0.1
database=$output/database/db_v20"
echo ${sample_prefix}

# Run kneaddata
mkdir -p kneaddata
kneaddata \
--input raw_files/${sample_prefix}.fastq.gz \
--output kneaddata/${sample_prefix}_knead \
--reference-db $hostDB \
--threads $threads \
--log kneaddata/${sample_prefix}_kneaddata.log \
--trimmomatic /gpfs/share/apps/trimmomatic/0.36 \
--remove-intermediate-output \
--trimmomatic-options='ILLUMINACLIP:TruSeq3-SE.fa:2:30:10' \
--trimmomatic-options='LEADING:3' \
--trimmomatic-options='TRAILING:3' \
--trimmomatic-options='SLIDINGWINDOW:4:15' \
--trimmomatic-options='MINLEN:36'

metaphlan2.py kneaddata/${sample_prefix}_knead/${sample_prefix}_kneaddata.fastq \
--input_type fastq \
--bowtie2db $database > ${sample_prefix}_kneaddata.fastq
