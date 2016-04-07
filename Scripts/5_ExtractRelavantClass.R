#!/usr/bin/env Rscript

# Meeyoung Park, 04/07/2016
# Command: Rscript <pos_filename> <pos_filename>
# Input: "_noOdd.txt"
# Process: Check if there are non-relavant lipid class from each polar
#         and combine pos & neg lipids in a file
# Output: Remaining all relevant lipid class: "*_final.txt"

args = commandArgs(TRUE)
print(args[1])
# Read data file
name_temp <-  strsplit(args[1], "_")
tissue_name <- name_temp[[1]][1]
out_filename <- paste(tissue_name,"_final.txt", sep="")

positiveLipid <- data.frame()
negativeLipid <- data.frame()
positiveLipid = read.delim(args[1], header = TRUE, sep = "\t")
negativeLipid = read.delim(args[2], header = TRUE, sep = "\t")

# Positive class:  
posClass <- c('CE','DG','lysoPC','lysoPE','MG','PC','PE','plasmenylPC','plasmenylPE','SM','TG')
negClass <- c('CerP', 'CL', 'PA', 'PG', 'PI','PS')

pos_ordered <- positiveLipid[order(positiveLipid$Class),] 
neg_ordered <- negativeLipid[order(negativeLipid$Class),] 

new_pos_match <- vector('integer') 
for(i in posClass){ 
  strClass <- paste("\\b",i,"\\b", sep="")
  row_pos_match <- grep(strClass, pos_ordered$Class)
  #print(row_match)
  new_pos_match <- append(new_pos_match,row_pos_match)
}

new_neg_match <- vector('integer') 
for(j in negClass){ 
  strClass <- paste("\\b",j,"\\b", sep="")
  row_neg_match <- grep(strClass, neg_ordered$Class)
  #print(row_match)
  new_neg_match <- append(new_neg_match,row_neg_match)
}

# Only selected classes
pos_Data <- pos_ordered[new_pos_match,]
neg_Data <- neg_ordered[new_neg_match,]
all_lipid_data <- rbind(pos_Data,neg_Data)

write.table(all_lipid_data, out_filename, append = FALSE, quote = FALSE, row.names=FALSE, sep="\t")
