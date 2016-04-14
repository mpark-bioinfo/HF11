#!/usr/bin/env Rscript

# Meeyoung Park, 04/11/2016
# Command: Rscript <filename> <sample weight> <outdir>
# Input: "_CV30.cvs"
# Process: Quantile normalization with tissue normalization
# Output: "_normalized.cvs"
#source("https://bioconductor.org/biocLite.R")
#biocLite("preprocessCore")
library("preprocessCore")

args = commandArgs(TRUE)
print(args[1])

#LipidData = read.csv('../Normalization/SCNPos_CV30.csv', header = TRUE, sep = ",")
LipidData = read.csv(args[1], header = TRUE, sep = ",")
sampleIntensity <- LipidData[,2:49]
qcIntensityData <- LipidData[50:length(LipidData)]

#sampleInfo <- read.csv('SCN_SampleInfo.csv', header = TRUE, sep = ",")
sampleInfo = read.csv(args[2], header = TRUE, sep = ",")
temp <- as.matrix(sampleInfo$Weight)
sampleWeight <- rep(1,length(LipidData[,1])) %*% t.default(temp)

# Normalization by tissue weight 
# Define normalize function
norm.weight <- sampleIntensity/sampleWeight

# Quantile normalization for all data including qc samples
newIntensityData <- data.frame(norm.weight, qcIntensityData)
norm.quantile <- normalize.quantiles(as.matrix(newIntensityData), copy=FALSE)

# Create col names
num_of_qc <- length(50:length(LipidData))
QC_label <- rep("QC", times= num_of_qc)
colnames(norm.quantile) <- c('Ctrl_BKS_2202', 'Ctrl_BKS_2203', 'Ctrl_BKS_2206', 'Ctrl_BKS_2211',
  'HF_BKS_2214', 'HF_BKS_2216', 'HF_BKS_2217', 'HF_BKS_2218',
  'Ctrl_BKS_db._2225', 'Ctrl_BKS_db._2226', 'Ctrl_BKS_db._2227','Ctrl_BKS_db._2231',
  'HF_BKS_db._2239', 'HF_BKS_db._2241', 'HF_BKS_db._2242', 'HF_BKS_db._2243',
  'Ctrl_BL6_2249', 'Ctrl_BL6_2250', 'Ctrl_BL6_2251', 'Ctrl_BL6_2252',
  'HF_BL6_2260', 'HF_BL6_2261', 'HF_BL6_2262', 'HF_BL6_2266',
  'Ctrl_BL6_db._2273','Ctrl_BL6_db._2274', 'Ctrl_BL6_db._2275', 'Ctrl_BL6_db._2279',
  'HF_BL6_db._2286', 'HF_BL6_db._2287', 'HF_BL6_db._2288', 'HF_BL6_db._2289',
  'Ctrl_BTBR_2292', 'Ctrl_BTBR_2293', 'Ctrl_BTBR_2297', 'Ctrl_BTBR_2298',
  'HF_BTBR_2306', 'HF_BTBR_2307', 'HF_BTBR_2308', 'HF_BTBR_2309',
  'Ctrl_BTBR_ob._2316', 'Ctrl_BTBR_ob._2317', 'Ctrl_BTBR_ob._2318', 'Ctrl_BTBR_ob._2320',
  'HF_BTBR_ob._2329', 'HF_BTBR_ob._2331', 'HF_BTBR_ob._2333', 'HF_BTBR_ob._2334', QC_label);

FinalLipidData <- data.frame('Sample'= LipidData$Sample, norm.quantile)

# Output file name
name_temp <-  strsplit(args[1], "/");
tmp <- strsplit(name_temp[[1]][length(name_temp[[1]])], "\\.") ;#Check the position of file name
tissue_name <- strsplit(tmp[[1]][1], "\\_");
new_out <- paste(args[3], tissue_name[[1]][1],"_normalized.csv", sep="");
write.csv(FinalLipidData, new_out, row.names=FALSE)
