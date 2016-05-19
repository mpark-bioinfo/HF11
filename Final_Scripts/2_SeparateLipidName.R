#!/usr/bin/env Rscript

# Meeyoung Park, 04/11/2016
# Command: Rscript <filename> <outdir>
# Input: "_normalized.csv"
# Process: Separate lipid species
# Output: "_Lipid.csv"

args = commandArgs(TRUE)
print(args[1])

# Read data file
#LipidData = read.csv("../Final_Analysis_Apr/Quality_Control/SCNPos_normalized.csv", header = TRUE, sep = ",")
LipidData = read.csv(args[1], header = TRUE, sep = ",")
NewLipid <- data.frame(LipidInfo=LipidData$Sample)
Lipids <- t(as.data.frame(strsplit(as.character(NewLipid$LipidInfo), ";")));
colnames(Lipids) <- c("Lipid", "Adduct")
separatedData <- data.frame(Lipids, LipidData[,2:length(LipidData)])

# Output file name
name_temp <-  strsplit(args[1], "/");
tmp <- strsplit(name_temp[[1]][length(name_temp[[1]])], "\\.") ;#Check the position of file name
tissue_name <- strsplit(tmp[[1]][1], "\\_");
new_out <- paste(args[2], tissue_name[[1]][1],"_Lipid.csv", sep="");

write.csv(separatedData, new_out, row.names=FALSE)

