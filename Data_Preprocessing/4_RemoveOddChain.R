
#!/usr/bin/env Rscript

# Meeyoung Park, 04/07/2016
# Command: Rscript <filename>
# Input: _nonRedundant_LipidClass.txt 
# First column should be "Lipid" species: class + carbon chain info (TG 41:2)
# Process: Remove odd carbon chain
# Output: Only even saturation lipids: "*_noOdd.txt"
args = commandArgs(TRUE)
print(args[1])
# Read data file
LipidData <- read.delim(args[1], header = TRUE, sep = "\t")
even_chain_idx <- which((LipidData$Saturation %%2) == 0)
new_LipidData <- LipidData[even_chain_idx,]
#dim(new_LipidData)
#name_temp <-  strsplit(args[1], "/")
tmp <- strsplit(args[1], "\\.")
filename <- strsplit(tmp[[1]][1], "\\_")
new_out <- paste(filename[[1]][1],"_noOdd.txt", sep="")
write.table(new_LipidData, new_out, append = FALSE, quote = FALSE, row.names=FALSE, sep="\t") 
