#!/usr/bin/env Rscript

# Meeyoung Park, 04/13/2016
# Command: Rscript <filename> <outdir>
# Input: "_.csv"
# Process: Grouping by strains
# Output: "groupedFC.csv"

#install.packages('plyr')
#install.packages('ggplot2')
#install.packages('gridExtra')
#install.packages('reshape2')
library(plyr)
library(ggplot2)
library(gridExtra)
library(reshape2)
# Grouping by strains
args = commandArgs(TRUE)
print(args[1])

df = read.csv(args[1], header = TRUE, sep = ",")
#df = read.csv('../Final_Analysis_050516/Final_SCN/SCN_WT_BL6.csv', header = TRUE, sep = ",")

# Get Group FC
# Separate lipid class
lipid.name <- t(as.data.frame(strsplit(as.character(df$Sample), " ")));
colnames(lipid.name) <- c("Class", "Carbon")
lipid.name.class <- data.frame('Class'=lipid.name[,1])
LipidData <- data.frame('Class'=lipid.name.class, df[, 2:9])

# Grouping by class
NumCtl <- 4
NumCase <- 4
new_df <- as.matrix(log2(LipidData[,2:9]))
data.ctrl <- new_df[, 1: NumCtl]
data.case <- new_df[, (NumCtl+1) : (NumCtl+NumCase)]

# Control
ctrl.df <- data.frame('Class'=LipidData$Class, data.ctrl)
ctrl.melted <- melt(ctrl.df, id.vars="Class")
ctrl.grouped <- ddply(ctrl.melted, "Class", summarise,
                      N    = length(value)/NumCtl,
                      mean = mean(value),
                      sd   = sd(value),
                      se   = sd / sqrt(N)
);

# Case
case.df <- data.frame('Class'=LipidData$Class, data.case)
case.melted <- melt(case.df, id.vars="Class")
case.grouped <- ddply(case.melted, "Class", summarise,
                      N    = length(value)/NumCase,
                      mean = mean(value),
                      sd   = sd(value),
                      se   = sd / sqrt(N)
);

# FC
raw.FC <- (2^case.grouped$mean)/(2^ctrl.grouped$mean)
log.FC <- log2(raw.FC)
Grouped.logFC <- data.frame('Class'=ctrl.grouped$Class,'Number'=ctrl.grouped$N, 'Ctrl.mean'=ctrl.grouped$mean,'Ctrl.SD'=ctrl.grouped$sd, 'Ctrl.SE'=ctrl.grouped$se,
                            'Case.mean'=case.grouped$mean, 'Case.SD'=case.grouped$sd, 'Case.SE'=case.grouped$se,'FC' = raw.FC, 'logFC'=log.FC)

# Output file name
name_temp <-  strsplit(args[1], "/")
tmp <- strsplit(name_temp[[1]][length(name_temp[[1]])], "\\.") #Check the position of file name
tissue_name <- strsplit(tmp[[1]][1], "\\_")
filename1 <- paste(tissue_name[[1]][1],tissue_name[[1]][2],tissue_name[[1]][3], sep="_")
write.csv(Grouped.logFC, paste(args[2],filename1,'_groupedFC.csv',sep = ""), row.names=FALSE)



