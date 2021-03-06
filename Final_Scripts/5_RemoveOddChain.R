
#!/usr/bin/env Rscript

# Meeyoung Park, 04/07/2016
# Command: Rscript <filename>
# Input: _combined.csv
# First three columnd should be "lipid class, carbon chain, double bond" info (TG 41 2)
# Process: Remove odd carbon chain
# Output: Only even Carbon lipids: "*_Final.csv"

args = commandArgs(TRUE)
print(args[1])

# Read data file
LipidData = read.csv(args[1], header = TRUE, sep = ",")
#LipidData = read.csv("../FinalResults_051716/Plasma_combined.csv", header = TRUE, sep = ",")

even_chain_idx <- which((LipidData$Carbon %%2) == 0)
new_LipidData <- LipidData[even_chain_idx,]
print(length(new_LipidData$Class))
#dim(new_LipidData)

# Write output
name_temp <-  strsplit(args[1], "/")
tmp <- strsplit(name_temp[[1]][length(name_temp[[1]])], "\\.") #Check the position of file name
filename <- strsplit(tmp[[1]][1], "\\_")
new_out <- paste(args[2],filename[[1]][1],"_Final.csv", sep="")
write.csv(new_LipidData, new_out, row.names=FALSE)
