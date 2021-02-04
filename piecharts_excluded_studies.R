###Written by Angelina Volkova on 06/01/2020
###This script makes pie charts to show how the studies were excluded
###based on different criteria

setwd("/Users/av1936/Desktop/Google_Drive/Autoimmunity")
total_studies <- read.table("total_studies_reviewed.txt", sep="\t", header=T)
disease_colors <- c("steelblue3","red", "magenta3","forestgreen","orangered3","gold3",
                    "turquoise4","royalblue3","pink3", "purple3", "brown","springgreen3","cyan2", 
                    "orange2","yellow3", "black", 'olivedrab4',"coral2","hotpink4",
                    "deepskyblue2",  "green3", "grey60")
diseases <- c("Additional Healthy","Antiphospholipid Syndrome","Ankylosing Spondylitis",
              "Behçet's Disease","Celiac Disease","Graves' disease","Inflammatory Bowel Disease",
              "Juvenile Idiopathic Arthritis","Multiple Sclerosis","Myasthenia Gravis",
              "Pouchitis","Psoriatic Arthritis","Primary Sclerosing Cholangitis",
              "Psoriasis","Rheumatoid Arthritis", "Reactive Arthritis","Sjogren's Syndrome",
              "Systemic Lupus Erythematosus","Spondyloarthritis","Systemic Sclerosis","Type I Diabetes",
              "Excluded Studies")

###Plot legend
plot(NULL ,xaxt='n',yaxt='n',bty='n',ylab='',xlab='', xlim=0:1, ylim=0:1)
legend("right", diseases, cex = 1,border=disease_colors,bty = "n",fill = disease_colors)

###Plot all studies
all_studies <-c(53,12,12,8,7,6,5,4,4,4,2,2,2,2,1,1,1,1,1,1)
all_numeric_labels <- c(53,12,12,8,7,6,5,4,"","",2,"","","",1,"","","","","")
all_labels <-  c("Inflammatory Bowel Disease","Multiple Sclerosis","Rheumatoid Arthritis",
                 "Type I Diabetes","Systemic Lupus Erythematosus","Juvenile Idiopathic Arthritis",
                 "Primary Sclerosing Cholangitis",
                 "Ankylosing Spondylitis","Behçet's Disease","Psoriasis",
                 "Celiac Disease","Graves' disease","Miasthenia Gravis","Sjogren's Syndrome",
                 "Antiphospholipid Syndrome","Pouchitis","Psoriatic Arthritis","Reactive Arthritis",
                 "Spondyloarthritis",
                 "Systemic Sclerosis")
all_colors <- c("turquoise4","pink3","yellow3","green3","coral2","royalblue3","cyan2", 
                 "magenta3","forestgreen","orange2",
                 "orangered3","gold3","purple3","olivedrab4",
                 "red","hotpink4","brown","springgreen3","black","hotpink4","deepskyblue2")
pie(all_studies, labels = all_numeric_labels, main = "",col = all_colors,radius=0.5,cex=1.5)


###Plot studies with available data
avail_studies <-c(70,23,8,7,4,3,3,2,2,1,1,1,1,1,1,1)
avail_numeric_labels <- c(70,23,8,7,4,3,3,"",2,"","",1,"","","","")
avail_labels <-  c("Excluded Studies","Inflammatory Bowel Disease","Multiple Sclerosis","Rheumatoid Arthritis",
                   "Type I Diabetes",
                 "Systemic Lupus Erythematosus","Juvenile Idiopathic Arthritis",
                 "Ankylosing Spondylitis","Behçet's Disease","Psoriasis",
                 "Celiac Disease","Miasthenia Gravis",
                 "Antiphospholipid Syndrome","Primary Sclerosing Cholangitis",
                 "Psoriatic Arthritis","Reactive Arthritis")
avail_colors <- c("grey50","turquoise4","pink3","yellow3","green3","coral2","royalblue3",
                "magenta3","forestgreen","orange2",
                "orangered3","purple3",
                "red","cyan2", "springgreen3","black")
pie(avail_studies, labels = avail_numeric_labels, main = "",
    col = avail_colors,radius=0.5,cex=1.5)


###Excluded studies with the same data
same_studies <-c(73,23,7,7,3,3,3,2,2,1,1,1,1,1,1)
same_numeric_labels <- c(73,23,7,"",3,"","",2,"","","","",1,"","")
same_labels <-  c("Excluded Studies","Inflammatory Bowel Disease","Multiple Sclerosis","Rheumatoid Arthritis",
                   "Systemic Lupus Erythematosus","Type I Diabetes","Juvenile Idiopathic Arthritis",
                   "Ankylosing Spondylitis","Behçet's Disease","Psoriasis",
                   "Celiac Disease","Miasthenia Gravis",
                   "Antiphospholipid Syndrome","Primary Sclerosing Cholangitis",
                   "Reactive Arthritis")
same_colors <- c("grey50","turquoise4","pink3","yellow3","coral2","green3","royalblue3",
                  "magenta3","forestgreen","orange2",
                  "orangered3","purple3",
                  "red","cyan2","black")
pie(same_studies, labels = same_numeric_labels, main = "Exluded studies with the same data",
    col = same_colors,radius=0.5,cex=1.5)

###Excluded studies with no FASTQ files

fastq_studies <-c(75,22,7,7,3,3,2,2,2,1,1,1,1,1,1)
fastq_numeric_labels <- c(75,22,7,"",3,"","",2,"","","",1,"","","")
fastq_labels <-  c("Excluded Studies","Inflammatory Bowel Disease","Multiple Sclerosis","Rheumatoid Arthritis",
                  "Systemic Lupus Erythematosus","Juvenile Idiopathic Arthritis","Type I Diabetes",
                  "Ankylosing Spondylitis","Behçet's Disease","Psoriasis",
                  "Celiac Disease","Miasthenia Gravis",
                  "Antiphospholipid Syndrome","Primary Sclerosing Cholangitis",
                  "Reactive Arthritis")
fastq_colors <- c("grey50","turquoise4","pink3","yellow3","coral2","royalblue3","green3",
                 "magenta3","forestgreen","orange2",
                 "orangered3","purple3",
                 "red","cyan2","black")
pie(fastq_studies, labels = fastq_numeric_labels, main = "Exluded studies without FASTQ files",
    col = fastq_colors,radius=0.5,cex=1.5)

###Excluded Studies with Confusing Metadata
meta_studies <-c(82,16,7,6,3,3,2,2,2,1,1,1,1,1,1)
meta_numeric_labels <- c(82,16,7,6,3,"","",2,"","","",1,"","","")
meta_labels <-  c("Excluded Studies","Inflammatory Bowel Disease","Multiple Sclerosis","Rheumatoid Arthritis",
                   "Systemic Lupus Erythematosus","Juvenile Idiopathic Arthritis","Type I Diabetes",
                   "Ankylosing Spondylitis","Behçet's Disease","Psoriasis",
                   "Celiac Disease","Miasthenia Gravis",
                   "Antiphospholipid Syndrome","Primary Sclerosing Cholangitis",
                   "Reactive Arthritis")
meta_colors <- c("grey50","turquoise4","pink3","yellow3","coral2","royalblue3","green3",
                  "magenta3","forestgreen","orange2",
                  "orangered3","purple3",
                  "red","cyan2","black")
pie(meta_studies, labels = meta_numeric_labels, main = "Exluded studies with incomplete metadata",
    col = meta_colors,radius=0.5,cex=1.5)

###Excluded studies with low sequencing depth
depth_studies <-c(84,14,7,6,3,3,2,2,2,1,1,1,1,1,1)
depth_numeric_labels <- c(84,14,7,6,3,"","",2,"","","",1,"","","")
depth_labels <-  c("Excluded Studies","Inflammatory Bowel Disease","Multiple Sclerosis","Rheumatoid Arthritis",
                  "Systemic Lupus Erythematosus","Juvenile Idiopathic Arthritis","Type I Diabetes",
                  "Ankylosing Spondylitis","Behçet's Disease","Psoriasis",
                  "Celiac Disease","Miasthenia Gravis",
                  "Antiphospholipid Syndrome","Primary Sclerosing Cholangitis",
                  "Reactive Arthritis")
depth_colors <- c("grey50","turquoise4","pink3","yellow3","coral2","royalblue3","green3",
                 "magenta3","forestgreen","orange2",
                 "orangered3","purple3",
                 "red","cyan2","black")
pie(depth_studies, labels = depth_numeric_labels, main = "Exluded studies with low sequencing depth",
    col = depth_colors,radius=0.5,cex=1.5)

###Excluded studies with bad quality data
depth_studies <-c(87,14,7,5,3,3,2,2,2,1,1,1,1)
depth_numeric_labels <- c(87,14,7,5,3,"","",2,"","","",1,"")
depth_labels <-  c("Excluded Studies","Inflammatory Bowel Disease","Multiple Sclerosis","Rheumatoid Arthritis",
                   "Systemic Lupus Erythematosus","Juvenile Idiopathic Arthritis","Type I Diabetes",
                   "Ankylosing Spondylitis","Behçet's Disease","Miasthenia Gravis",
                   "Antiphospholipid Syndrome","Primary Sclerosing Cholangitis",
                   "Reactive Arthritis")
depth_colors <- c("grey50","turquoise4","pink3","yellow3","coral2","royalblue3","green3",
                  "magenta3","forestgreen","purple3",
                  "red","cyan2","black")
pie(depth_studies, labels = depth_numeric_labels, main = "Exluded studies with bad quality data",
    col = depth_colors,radius=0.5,cex=1.5)

###Added healthy controls from 3 studies
healthy_studies <-c(87,14,7,5,3,3,2,2,2,1,1,1,1,3)
healthy_numeric_labels <- c(87,14,7,5,3,"","",2,"","","",1,"",3)
healthy_labels <-  c("Excluded Studies","Inflammatory Bowel Disease","Multiple Sclerosis","Rheumatoid Arthritis",
                   "Systemic Lupus Erythematosus","Juvenile Idiopathic Arthritis","Type I Diabetes",
                   "Ankylosing Spondylitis","Behçet's Disease","Miasthenia Gravis",
                   "Antiphospholipid Syndrome","Primary Sclerosing Cholangitis",
                   "Reactive Arthritis","Additional Healthy")
healthy_colors <- c("grey50","turquoise4","pink3","yellow3","coral2","royalblue3","green3",
                  "magenta3","forestgreen","purple3",
                  "red","cyan2","black","steelblue3")
pie(healthy_studies, labels = healthy_numeric_labels, main = "Added healthy controls from 3 studies",
    col = healthy_colors,radius=0.5,cex=1.5)

###Result
result_studies <-c(14,7,5,3,3,2,2,2,1,1,1,1,3)
result_numeric_labels <- c(14,7,5,3,"","",2,"","","",1,"",3)
result_labels <-  c("Inflammatory Bowel Disease","Multiple Sclerosis","Rheumatoid Arthritis",
                     "Systemic Lupus Erythematosus","Juvenile Idiopathic Arthritis","Type I Diabetes",
                     "Ankylosing Spondylitis","Behçet's Disease","Miasthenia Gravis",
                     "Antiphospholipid Syndrome","Primary Sclerosing Cholangitis",
                     "Reactive Arthritis","Additional Healthy")
result_colors <- c("turquoise4","pink3","yellow3","coral2","royalblue3","green3",
                    "magenta3","forestgreen","purple3",
                    "red","cyan2","black","steelblue3")
pie(result_studies, labels = result_numeric_labels, main = "Included studies",
    col = result_colors,radius=0.5,cex=1.5)

