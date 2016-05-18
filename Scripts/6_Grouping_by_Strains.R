#!/usr/bin/env Rscript

# Meeyoung Park, 04/13/2016
# Command: Rscript <filename> <outdir>
# Input: "_Final.csv"
# Process: Grouping by strains
# Output: "Strain.csv"

# Grouping by strains
args = commandArgs(TRUE)
print(args[1])

NewLipidData = read.csv(args[1], header = TRUE, sep = ",")
#LipidData = read.csv('../Normalization/SCN_Final.csv', header = TRUE, sep = ",")
# Output file name
name_temp <-  strsplit(args[1], "/")
tmp <- strsplit(name_temp[[1]][length(name_temp[[1]])], "\\.") #Check the position of file name
tissue_name <- strsplit(tmp[[1]][1], "\\_")

Lipid_Info <- data.frame(paste(NewLipidData$Class, paste(NewLipidData$Carbon, "_", NewLipidData$Double_bond, sep="")))
colnames(Lipid_Info) <- "Sample"

# BKS WT
Ctrl_BKS <- NewLipidData[, c('Ctrl_BKS_2202', 'Ctrl_BKS_2203', 'Ctrl_BKS_2206', 'Ctrl_BKS_2211')]
HF_BKS <- NewLipidData[, c('HF_BKS_2214', 'HF_BKS_2216', 'HF_BKS_2217', 'HF_BKS_2218')]
BKS_WT <- data.frame(Lipid_Info, Ctrl_BKS, HF_BKS)
new_out <- paste(args[2],tissue_name[[1]][1],"_WT_BKS.csv", sep="")
write.csv(BKS_WT, new_out, row.names=FALSE)

# BKS_db/+
Ctrl_BKS_db <- NewLipidData[, c('Ctrl_BKS_db._2225', 'Ctrl_BKS_db._2226', 'Ctrl_BKS_db._2227','Ctrl_BKS_db._2231')]
HF_BKS_db <- NewLipidData[, c('HF_BKS_db._2239', 'HF_BKS_db._2241', 'HF_BKS_db._2242', 'HF_BKS_db._2243')]
BKS_db <- data.frame(Lipid_Info, Ctrl_BKS_db, HF_BKS_db)
new_out <- paste(args[2],tissue_name[[1]][1],"_db_BKS.csv", sep="")
write.csv(BKS_db, new_out, row.names=FALSE)

# BL6 WT
Ctrl_BL6 <- NewLipidData[, c('Ctrl_BL6_2249', 'Ctrl_BL6_2250', 'Ctrl_BL6_2251', 'Ctrl_BL6_2252')]
HF_BL6 <- NewLipidData[, c('HF_BL6_2260', 'HF_BL6_2261', 'HF_BL6_2262', 'HF_BL6_2266')]
BL6_WT <- data.frame(Lipid_Info, Ctrl_BL6, HF_BL6)
new_out <- paste(args[2],tissue_name[[1]][1],"_WT_BL6.csv", sep="")
write.csv(BL6_WT, new_out, row.names=FALSE)

# BL6 db/+
Ctrl_BL6_db <- NewLipidData[, c('Ctrl_BL6_db._2273','Ctrl_BL6_db._2274', 'Ctrl_BL6_db._2275', 'Ctrl_BL6_db._2279')]
HF_BL6_db <- NewLipidData[, c('HF_BL6_db._2286', 'HF_BL6_db._2287', 'HF_BL6_db._2288', 'HF_BL6_db._2289')]
BL6_db <- data.frame(Lipid_Info, Ctrl_BL6_db, HF_BL6_db)
new_out <- paste(args[2],tissue_name[[1]][1],"_db_BL6.csv", sep="")
write.csv(BL6_db, new_out, row.names=FALSE)

# BTBR WT
Ctrl_BTBR <- NewLipidData[, c('Ctrl_BTBR_2292', 'Ctrl_BTBR_2293', 'Ctrl_BTBR_2297', 'Ctrl_BTBR_2298')]
HF_BTBR <- NewLipidData[, c('HF_BTBR_2306', 'HF_BTBR_2307', 'HF_BTBR_2308', 'HF_BTBR_2309')] 
BTBR_WT <- data.frame(Lipid_Info, Ctrl_BTBR, HF_BTBR)
new_out <- paste(args[2],tissue_name[[1]][1],"_WT_BTBR.csv", sep="")
write.csv(BTBR_WT, new_out, row.names=FALSE)

# BTBR db/+
Ctrl_BTBR_ob <- NewLipidData[, c('Ctrl_BTBR_ob._2316', 'Ctrl_BTBR_ob._2317', 'Ctrl_BTBR_ob._2318', 'Ctrl_BTBR_ob._2320')]
HF_BTBR_ob <- NewLipidData[, c('HF_BTBR_ob._2329', 'HF_BTBR_ob._2331', 'HF_BTBR_ob._2333', 'HF_BTBR_ob._2334')]
BTBR_db <- data.frame(Lipid_Info, Ctrl_BTBR_ob, HF_BTBR_ob)
new_out <- paste(args[2],tissue_name[[1]][1],"_db_BTBR.csv", sep="")
write.csv(BTBR_db, new_out, row.names=FALSE)
