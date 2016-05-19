#!/usr/bin/env Rscript

# Meeyoung Park, 04/13/2016
# Command: Rscript <filename> <outdir>
# Input: "_.csv"
# Process: Grouping by strains
# Output: "Strain.csv"

#install.packages('ggplot2')
#install.packages('corrplot')
#install.packages('Hmisc')
#install.packages('gridExtra')

library(plyr)
library(ggplot2)
library(gridExtra)

# Grouping by strains
args = commandArgs(TRUE)
print(args[1])
print(args[2])
print(args[3])
#NewLipidData = read.csv(args[1], header = TRUE, sep = ",")
LipidData = read.csv('../Normalization/Final_SCN/SCN_db_BKS.csv', header = TRUE, sep = ",")
#Liver_LipidData = read.csv('../Normalization/Final_Liver/Liver_WT_BTBR.csv', header = TRUE, sep = ",")
#Plasma_LipidData = read.csv('../Normalization/Final_Plasma/Plasma_WT_BTBR.csv', header = TRUE, sep = ",")
LipidData = read.csv(args[1], header = TRUE, sep = ",")
#Liver_LipidData = read.csv(args[2], header = TRUE, sep = ",")
#Plasma_LipidData = read.csv(args[3], header = TRUE, sep = ",")

# Get FC
NumCtl <- 4
NumHF <- 4
df <- as.matrix(LipidData[,2:9])
data.ctrl <- df[, 1: NumCtl]
data.case <- df[, (NumCtl+1) : (NumCtl+NumHF)]

mean.ctrl <- rowMeans(data.ctrl)
mean.hf <- rowMeans(data.case)
data.fC <- mean.hf/mean.ctrl
log.fc <- log2(data.fC)
log.df <- data.frame(lipid = LipidData$Sample, logFC = log.fc)

#SCN_BKS_WT <- data.frame(SCN_Ctrl_BKS,SCN_HF_BKS)
#boxplot(log2(SCN_BKS_WT),las = 2,col = c('deepskyblue','lightskyblue','skyblue','skyblue4','orangered','red','indianred1','darkred')) 
#ggplot(dfs, aes(x=values)) + geom_density(aes(group=ind, colour=ind, fill=ind), alpha=0.3)


# Separate lipid class
lipid.name <- t(as.data.frame(strsplit(as.character(log.df$lipid), " ")));
colnames(lipid.name) <- c("Class", "Carbon")
lipid.name.class <- data.frame('Class'=lipid.name[,1])
LipidClass <- data.frame('Class'=lipid.name.class , 'logFC'=log.df$logFC)

# Grouping by class
LipidClass_grouped <- ddply(LipidClass, "Class", summarise,
               N    = length(logFC),
               mean = mean(logFC),
               sd   = sd(logFC),
               se   = sd / sqrt(N)
);

# Output file name
name_temp <-  strsplit(args[1], "/")
tmp <- strsplit(name_temp[[1]][length(name_temp[[1]])], "\\.") #Check the position of file name
tissue_name <- strsplit(tmp[[1]][1], "\\_")
filename1 <- paste(tissue_name[[1]][1],tissue_name[[1]][2],tissue_name[[1]][3],'lipid_class', sep="_")
write.csv(log.df, paste(filename1,'_FC.csv',sep = ""), row.names=FALSE)
write.csv(LipidClass_grouped, paste(filename1,'_grouped.csv',sep = ""), row.names=FALSE)

tiff(paste(filename1,'.tiff',sep = ""))
ggplot(LipidClass_grouped, aes(x = Class, y = mean,fill=factor(Class))) +
    geom_bar(stat = "identity",show.legend = FALSE) + 
    xlab("Class") + ylab("Log2 Fold-change") +
    scale_x_discrete("Class") +
    scale_y_continuous(limits = c(-1, 1)) + theme_bw() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
dev.off()

# Output file name
#name_temp <-  strsplit(args[1], "/")
#tmp <- strsplit(name_temp[[1]][length(name_temp[[1]])], "\\.") #Check the position of file name
#tissue_name <- strsplit(tmp[[1]][1], "\\_")
#write.csv(BL6_db, new_out, row.names=FALSE)
