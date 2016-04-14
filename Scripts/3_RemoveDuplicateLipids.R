#!/usr/bin/env Rscript

# Meeyoung Park, 04/07/2016
# Command: Rscript <filename> <Outdir>
# Input: _Lipid.csv (First column should be "Lipid" species: class + carbon chain info (TG 41:2))
# Process: Check if there are redundant lipids in the file
# Output: Removing all redundant lipids: "*_nonRedundant.txt"

args = commandArgs(TRUE)
print(args[1])
# Read data file
#LipidData <- read.csv("../Normalization/SCNPos_Lipid.csv", header = TRUE, sep = ",")
LipidData <- read.csv(args[1], header = TRUE, sep = ",")

# Calculate CV
LipidName <- LipidData$Lipid
AdductName <- LipidData$Adduct
IntensityData <- LipidData[,3:50]
qc_sample <- LipidData[, 51:length(LipidData)]

# Calculate CV using qc samples
sd_test <- data.frame(apply(qc_sample,1, sd))
colnames(sd_test) <- 'SD'
mean_test <- data.frame(rowMeans(qc_sample))
colnames(mean_test) <- 'Mean'
RSD <- data.frame('CV' = as.numeric(sd_test$SD)/as.numeric(mean_test$Mean) * 100)

# Sort by CV
LipidDataCV <- data.frame(LipidData,RSD)
sorted_LipidData <- LipidDataCV[order(LipidDataCV$CV),] 
# Check duplicate lipids
dupl_set <- duplicated(sorted_LipidData$Lipid)
# Remove redundant lipids
nonRedundant_idx <- which(dupl_set == FALSE)
new_LipidData <- sorted_LipidData[nonRedundant_idx,]

# Output file name
name_temp <-  strsplit(args[1], "/");
tmp <- strsplit(name_temp[[1]][length(name_temp[[1]])], "\\.") ;#Check the position of file name
tissue_name <- strsplit(tmp[[1]][1], "\\_");
new_out <- paste(args[2], tissue_name[[1]][1],"_nonRedundant.csv", sep="");

write.csv(new_LipidData, new_out, row.names=FALSE)
