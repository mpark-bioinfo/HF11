#!/usr/bin/env Rscript

# Meeyoung Park, 04/13/2016
# Command: Rscript <filename> <outdir>
# Input: "_.csv"
# Process: Grouping by strains
# Output: "Strain.csv"
install.packages('gridExtra')
install.packages('reshape2')
library(plyr)
library(ggplot2)
library(gridExtra)
library(reshape2)

# Grouping by strains
args = commandArgs(TRUE)
print(args[1])
#NewLipidData = read.csv(args[1], header = TRUE, sep = ",")
SCN_LipidData = read.csv('../Normalization/Final_SCN/SCN_WT_BKS.csv', header = TRUE, sep = ",")
Liver_LipidData = read.csv('../Normalization/Final_Liver/Liver_WT_BKS.csv', header = TRUE, sep = ",")
Plasma_LipidData = read.csv('../Normalization/Final_Plasma/Plasma_WT_BKS.csv', header = TRUE, sep = ",")
#SCN_LipidData = read.csv(args[1], header = TRUE, sep = ",")
#Liver_LipidData = read.csv(args[2], header = TRUE, sep = ",")
#Plasma_LipidData = read.csv(args[3], header = TRUE, sep = ",")

# Get mean
SCN_Ctrl_BKS <- SCN_LipidData[, c('Ctrl_BKS_2202', 'Ctrl_BKS_2203', 'Ctrl_BKS_2206', 'Ctrl_BKS_2211')]
SCN_HF_BKS <- SCN_LipidData[, c('HF_BKS_2214', 'HF_BKS_2216', 'HF_BKS_2217', 'HF_BKS_2218')]
Liver_Ctrl_BKS <- Liver_LipidData[, c('Ctrl_BKS_2202', 'Ctrl_BKS_2203', 'Ctrl_BKS_2206', 'Ctrl_BKS_2211')]
Liver_HF_BKS <- Liver_LipidData[, c('HF_BKS_2214', 'HF_BKS_2216', 'HF_BKS_2217', 'HF_BKS_2218')]
Plasma_Ctrl_BKS <- Plasma_LipidData[, c('Ctrl_BKS_2202', 'Ctrl_BKS_2203', 'Ctrl_BKS_2206', 'Ctrl_BKS_2211')]
Plasma_HF_BKS <- Plasma_LipidData[, c('HF_BKS_2214', 'HF_BKS_2216', 'HF_BKS_2217', 'HF_BKS_2218')]



SCN_BKS_WT <- data.frame(SCN_Ctrl_BKS,SCN_HF_BKS)
rownames(SCN_BKS_WT) <- SCN_LipidData$Sample
SCN_BKS_WT_t<- t(SCN_BKS_WT)
ggplot(stack(SCN_BKS_WT_t), aes(x = ind, y = values, fill = ind)) + geom_boxplot() + coord_flip() + guides(fill=FALSE)


ggplot(mean.SCN, aes(x = Mean,fill=factor(Intensity))) + geom_boxplot() + coord_flip()












boxplot(log2(SCN_BKS_WT),las = 2,col = c('deepskyblue','lightskyblue','skyblue','skyblue4','orangered','red','indianred1','darkred')) 
# standard normalization
scaled.dat <- scale(SCN_BKS_WT)
boxplot(log2(scaled.dat),las = 2,col = c('deepskyblue','lightskyblue','skyblue','skyblue4','orangered','red','indianred1','darkred')) 

# Density function before scaling
mean.ctrl.SCN <- log2(rowMeans(SCN_Ctrl_BKS))
mean.hf.SCN <- log2(rowMeans(SCN_HF_BKS))
mean.SCN <- data.frame(CT=mean.ctrl.SCN, HF=mean.hf.SCN)

dfs <- stack(mean.SCN)
ggplot(dfs, aes(x=values)) + geom_density(aes(group=ind, colour=ind, fill=ind), alpha=0.3)

# Density function after scaling


#dfs.scaled <- stack(mean.scaled.df)
ggplot(mean.scaled.df, aes(x=values)) + geom_density(aes(colour=ind, fill=ind), alpha=0.3)

ggplot(dfs.scaled, aes(x=values)) + geom_density(alpha=0.3)
