#!/usr/bin/env Rscript

# Meeyoung Park, 04/13/2016
# Command: Rscript <filename> <outdir>
# Input: "_.csv"
# Process: Grouping by strains
# Output: "Strain.csv"
<<<<<<< HEAD
#install.packages('gridExtra')
=======

>>>>>>> 81fbef7f5b3a78443f86ca876b472e856525db08
library(plyr)
library(ggplot2)
library(gridExtra)

# Grouping by strains
args = commandArgs(TRUE)
print(args[1])
#NewLipidData = read.csv(args[1], header = TRUE, sep = ",")
#SCN_LipidData = read.csv('../Normalization/Final_SCN/SCN_WT_BTBR.csv', header = TRUE, sep = ",")
#Liver_LipidData = read.csv('../Normalization/Final_Liver/Liver_WT_BTBR.csv', header = TRUE, sep = ",")
#Plasma_LipidData = read.csv('../Normalization/Final_Plasma/Plasma_WT_BTBR.csv', header = TRUE, sep = ",")
SCN_LipidData = read.csv(args[1], header = TRUE, sep = ",")
Liver_LipidData = read.csv(args[2], header = TRUE, sep = ",")
Plasma_LipidData = read.csv(args[3], header = TRUE, sep = ",")

# Get FC

SCN_Ctrl <- SCN_LipidData[, 2:5]
SCN_HF <- SCN_LipidData[, 6:9]
Liver_Ctrl <- Liver_LipidData[, 2:5]
Liver_HF <- Liver_LipidData[, 6:9]
Plasma_Ctrl <- Plasma_LipidData[,  2:5]
Plasma_HF <- Plasma_LipidData[, 6:9]

#SCN_Ctrl_BKS <- SCN_LipidData[, c('Ctrl_BKS_2202', 'Ctrl_BKS_2203', 'Ctrl_BKS_2206', 'Ctrl_BKS_2211')]
#SCN_HF_BKS <- SCN_LipidData[, c('HF_BKS_2214', 'HF_BKS_2216', 'HF_BKS_2217', 'HF_BKS_2218')]
#Liver_Ctrl_BKS <- Liver_LipidData[, c('Ctrl_BKS_2202', 'Ctrl_BKS_2203', 'Ctrl_BKS_2206', 'Ctrl_BKS_2211')]
#Liver_HF_BKS <- Liver_LipidData[, c('HF_BKS_2214', 'HF_BKS_2216', 'HF_BKS_2217', 'HF_BKS_2218')]
#Plasma_Ctrl_BKS <- Plasma_LipidData[, c('Ctrl_BKS_2202', 'Ctrl_BKS_2203', 'Ctrl_BKS_2206', 'Ctrl_BKS_2211')]
#Plasma_HF_BKS <- Plasma_LipidData[, c('HF_BKS_2214', 'HF_BKS_2216', 'HF_BKS_2217', 'HF_BKS_2218')]

#SCN_BKS_WT <- data.frame(SCN_Ctrl_BKS,SCN_HF_BKS)
#boxplot(log2(SCN_BKS_WT),las = 2,col = c('deepskyblue','lightskyblue','skyblue','skyblue4','orangered','red','indianred1','darkred')) 
#ggplot(dfs, aes(x=values)) + geom_density(aes(group=ind, colour=ind, fill=ind), alpha=0.3)

mean.ctrl.SCN <- rowMeans(SCN_Ctrl)
mean.hf.SCN <- rowMeans(SCN_HF)
SCN_FC <- mean.hf.SCN/mean.ctrl.SCN
log_SCN_FC <- data.frame(log2(SCN_FC))

mean.ctrl.Liver <- rowMeans(Liver_Ctrl)
mean.hf.Liver <- rowMeans(Liver_HF)
Liver_FC <- mean.hf.Liver/mean.ctrl.Liver
log_Liver_FC <- data.frame(log2(Liver_FC))

mean.ctrl.Plasma <- rowMeans(Plasma_Ctrl)
mean.hf.Plasma <- rowMeans(Plasma_HF)
Plasma_FC <- mean.hf.Plasma/mean.ctrl.Plasma
log_Plasma_FC <- data.frame(log2(Plasma_FC))

# Separate lipid class
NewLipid_SCN <- data.frame(LipidInfo=SCN_LipidData$Sample)
Lipids_SCN <- t(as.data.frame(strsplit(as.character(NewLipid_SCN$LipidInfo), " ")));
colnames(Lipids_SCN) <- c("Class", "Carbon")
lipid_SCN.class <- data.frame('Class'=Lipids_SCN[,1])
separatedData_SCN <- data.frame('Class'=lipid_SCN.class , 'logFC'=log_SCN_FC$log2.SCN_FC.)

NewLipid_Liver <- data.frame(LipidInfo=Liver_LipidData$Sample)
Lipids_Liver <- t(as.data.frame(strsplit(as.character(NewLipid_Liver$LipidInfo), " ")));
colnames(Lipids_Liver) <- c("Class", "Carbon")
lipid_Liver.class <- data.frame('Class'=Lipids_Liver[,1])
separatedData_Liver <- data.frame('Class'=lipid_Liver.class , 'logFC'=log_Liver_FC$log2.Liver_FC.)

NewLipid_Plasma <- data.frame(LipidInfo=Plasma_LipidData$Sample)
Lipids_Plasma <- t(as.data.frame(strsplit(as.character(NewLipid_Plasma$LipidInfo), " ")));
colnames(Lipids_Plasma) <- c("Class", "Carbon")
lipid_Plasma.class <- data.frame('Class'=Lipids_Plasma[,1])
separatedData_Plasma <- data.frame('Class'=lipid_Plasma.class , 'logFC'=log_Plasma_FC$log2.Plasma_FC.)


# Grouping by class
SCN_grouped <- ddply(separatedData_SCN, "Class", summarise,
               N    = length(logFC),
               mean = mean(logFC),
               sd   = sd(logFC),
               se   = sd / sqrt(N)
);

# Grouping by class
Liver_grouped <- ddply(separatedData_Liver, "Class", summarise,
                     N    = length(logFC),
                     mean = mean(logFC),
                     sd   = sd(logFC),
                     se   = sd / sqrt(N)
);

Plasma_grouped <- ddply(separatedData_Plasma, "Class", summarise,
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
write.csv(SCN_grouped, paste(filename1,'.csv',sep = ""), row.names=FALSE)
tiff(paste(filename1,'.tiff',sep = ""))
ggplot(SCN_grouped, aes(x = Class, y = mean,fill=factor(Class))) +
    geom_bar(stat = "identity",show.legend = FALSE) + 
    xlab("Class") + ylab("Log2 Fold-change") +
    scale_x_discrete("Class") +
    scale_y_continuous(limits = c(-1, 1)) + theme_bw() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
dev.off()

name_temp <-  strsplit(args[2], "/")
tmp <- strsplit(name_temp[[1]][length(name_temp[[1]])], "\\.") #Check the position of file name
tissue_name <- strsplit(tmp[[1]][1], "\\_")
filename1 <- paste(tissue_name[[1]][1],tissue_name[[1]][2],tissue_name[[1]][3],'lipid_class', sep="_")
write.csv(Liver_grouped, paste(filename2,'.csv',sep = ""), row.names=FALSE)
tiff(paste(filename2,'.tiff',sep = ""))
ggplot(Liver_grouped, aes(x = Class, y = mean,fill=factor(Class))) +
  geom_bar(stat = "identity",show.legend = FALSE) + 
  xlab("Class") + ylab("Log2 Fold-change") +
  scale_x_discrete("Class") +
  scale_y_continuous(limits = c(-1, 1)) + theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
dev.off()

name_temp <-  strsplit(args[3], "/")
tmp <- strsplit(name_temp[[1]][length(name_temp[[1]])], "\\.") #Check the position of file name
tissue_name <- strsplit(tmp[[1]][1], "\\_")
filename1 <- paste(tissue_name[[1]][1],tissue_name[[1]][2],tissue_name[[1]][3],'lipid_class', sep="_")
write.csv(Plasma_grouped, paste(filename3,'.csv',sep = ""), row.names=FALSE)
tiff(paste(filename3,'.tiff',sep = ""))
ggplot(Plasma_grouped, aes(x = Class, y = mean,fill=factor(Class))) +
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
