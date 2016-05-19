#!/usr/bin/env Rscript

# Meeyoung Park, 04/07/2016
# Command: Rscript <pos_filename> <neg_filename>
# Input: "_nonRedundant.csv"
# Process: Check if there are non-relavant lipid class from each polar
#         and combine pos & neg lipids in a file
# Output: Remaining all relevant lipid class: "*_combined.csv"

args = commandArgs(TRUE)
print(args[1])

# Read data file
positiveLipid <- data.frame()
negativeLipid <- data.frame()
positiveLipid = read.csv(args[1], header = TRUE, sep = ",")
negativeLipid = read.csv(args[2], header = TRUE, sep = ",")

posLipidInfo <- data.frame(t(as.data.frame(strsplit(as.character(positiveLipid$Lipid), " "))))
colnames(posLipidInfo) <- c("Lipid_Class", "Carbon_Chain")
posCarbonInfo <- t(as.data.frame(strsplit(as.character(posLipidInfo$Carbon_Chain), ":")));
colnames(posCarbonInfo) <- c("Carbon", "Double_bond")
pos_separatedData <- data.frame('Class'=posLipidInfo$Lipid_Class, posCarbonInfo, positiveLipid[,2:length(positiveLipid)])

negLipidInfo <- data.frame(t(as.data.frame(strsplit(as.character(negativeLipid$Lipid), " "))))
colnames(negLipidInfo) <- c("Lipid_Class", "Carbon_Chain")
negCarbonInfo <- t(as.data.frame(strsplit(as.character(negLipidInfo$Carbon_Chain), ":")));
colnames(negCarbonInfo) <- c("Carbon", "Double_bond")
neg_separatedData <- data.frame('Class'=negLipidInfo$Lipid_Class, negCarbonInfo, negativeLipid[,2:length(negativeLipid)])

# Positive class:  
posClass <- c('CE','DG','lysoPC','lysoPE','MG','PC','PE','plasmenylPC','plasmenylPE','SM','TG')
negClass <- c('CerP', 'CL', 'PA', 'PG', 'PI','PS')

pos_ordered <- pos_separatedData[order(pos_separatedData$Class),] 
neg_ordered <- neg_separatedData[order(neg_separatedData$Class),] 

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
pos_Data <- pos_ordered[new_pos_match,1:52]
neg_Data <- neg_ordered[new_neg_match,1:52]
all_lipid_data <- rbind(pos_Data,neg_Data)

# Output file
new_out <- paste(args[3],"_combined.csv", sep="");
write.csv(all_lipid_data, new_out, row.names=FALSE)
