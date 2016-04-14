#!/usr/bin/env Rscript

# Meeyoung Park, 04/07/2016
# Command: Rscript <filename> <outdir>
# Input: "_imputed.csv"
# Process: Extract >= CV cutoff
# Output: "_CV.csv"
#library(dply)

args = commandArgs(TRUE)
print(args[1])

# Define CV function
cutoff <- 30

# Read input file
lipid_data = read.csv(args[1], header = TRUE, sep = ",")
#lipid_data = read.csv("../Normalization/SCNPos/SCNPos_imputed.csv", header = TRUE, sep = ",")

# Exclude internal standards
is_lipid_idx <- grep("IS", lipid_data$Sample)
LipidData <- lipid_data[-is_lipid_idx, ] 

# Calculate CV
TestPool <- LipidData[, 50:length(LipidData)]
sd_test <- data.frame(apply(TestPool,1, sd))
colnames(sd_test) <- 'SD'
mean_test <- data.frame(rowMeans(TestPool))
colnames(mean_test) <- 'Mean'
RSD <- data.frame(as.numeric(sd_test$SD)/as.numeric(mean_test$Mean) * 100)
colnames(RSD) <- 'CV';
count.10 <- as.numeric(table(RSD$CV <= 10)["TRUE"])
count.20 <- as.numeric(table(RSD$CV <= 20)["TRUE"])
count.30 <- as.numeric(table(RSD$CV <= 30)["TRUE"])
print(dim(RSD)[1])
print(count.10)
print(count.20)
print(count.30)

percentage10 <- count.10/dim(RSD)[1]*100
percentage20 <- count.20/dim(RSD)[1]*100
percentage30 <- count.30/dim(RSD)[1]*100
print(percentage10)
print(percentage20)
print(percentage30)
CV30_idx <- which((as.numeric(RSD$CV) <= cutoff) == TRUE);

FinalLipidData <- LipidData[CV30_idx,];
print(dim(FinalLipidData));
# Output file name
name_temp <-  strsplit(args[1], "/");
tmp <- strsplit(name_temp[[1]][length(name_temp[[1]])], "\\.") ;#Check the position of file name
tissue_name <- strsplit(tmp[[1]][1], "\\_");
new_out <- paste(args[2], tissue_name[[1]][1],"_CV30.csv", sep="");
write.csv(FinalLipidData, new_out, row.names=FALSE)