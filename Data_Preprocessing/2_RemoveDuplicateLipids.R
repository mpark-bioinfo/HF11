#!/usr/bin/env Rscript

# Meeyoung Park, 04/07/2016
# Command: Rscript <filename>
# Input: First column should be "Lipid" species: class + carbon chain info (TG 41:2)
# Process: Check if there are redundant lipids in the file
# Output: Removing all redundant lipids: "*_nonRedundant.txt"

args = commandArgs(TRUE)
print(args[1])
# Read data file
LipidData <- read.delim(args[1], header = TRUE, sep = "\t")
# Sort by CV
sorted_LipidData <- LipidData[order(LipidData$CV),] 
# Check duplicate lipids
dupl_set <- duplicated(sorted_LipidData$Lipid)
# Remove redundant lipids
nonRedundant_idx <- which(dupl_set == FALSE)
new_LipidData <- sorted_LipidData[nonRedundant_idx,]
#name_temp <-  strsplit(args[1], "/")
#tmp <- strsplit(name_temp[[1]][3], "\\.") #Check the position of file name
tmp <- strsplit(args[1], "\\.")
filename <- strsplit(tmp[[1]][1], "\\_")
new_out <- paste(filename[[1]][1],"_nonRedundant.txt", sep="")
write.table(new_LipidData, new_out, append = FALSE, quote = FALSE, row.names=FALSE, sep="\t") 