#!/usr/bin/env Rscript

# Meeyoung Park, 04/13/2016
# Command: Rscript <filename> <outdir>
# Input: "_Final.csv"
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
#df = read.csv('../Final_Analysis_050516_Incorrect/Final_Liver/Liver_WT_BL6.csv', header = TRUE, sep = ",")

# Get Group FC
# Separate lipid class
lipid.name <- t(as.data.frame(strsplit(as.character(df$Sample), " ")));
colnames(lipid.name) <- c("Class", "Carbon")
lipid.name.class <- data.frame('Class'=lipid.name[,1])
LipidData <- data.frame('Class'=lipid.name.class, df[, 2:length(df)])

# Grouping by class
NumCtl <- args[2]
NumCase <- args[3]
new_df <- as.matrix(LipidData[,2:length(df)])
data.ctrl <- new_df[, 1: NumCtl]
data.case <- new_df[, (NumCtl+1) : (NumCtl+NumCase)]

# Mean of each row (mean of replicates)
RowM.ctrl <- rowMeans(data.ctrl, na.rm = FALSE, dims = 1)
RowM.case <- rowMeans(data.case, na.rm = FALSE, dims = 1)
mean.df <- data.frame("Ctrl_Mean" = RowM.ctrl, "Case_Mean"= RowM.case)

# All
final.df <- data.frame('Class'=LipidData$Class, mean.df)
df.melted <- melt(final.df, id.vars="Class")
df.grouped <- ddply(df.melted, "Class", summarise,
                      N    = length(value),
                      SUM  = sum(value),
                      Mean = mean(value),
                      SD   = sd(value),
                      SE   = SD / sqrt(N)
);
# Control
ctrl.df <- data.frame('Class'=LipidData$Class, RowM.ctrl)
ctrl.melted <- melt(ctrl.df, id.vars="Class")
ctrl.grouped <- ddply(ctrl.melted, "Class", summarise,
                    N    = length(value),
                    SUM  = sum(value),
                    Mean = mean(value),
                    SD   = sd(value),
                    SE   = SD / sqrt(N)
);

# Case
case.df <- data.frame('Class'=LipidData$Class, RowM.case)
case.melted <- melt(case.df, id.vars="Class")
case.grouped <- ddply(case.melted, "Class", summarise,
                      N    = length(value),
                      SUM  = sum(value),
                      Mean = mean(value),
                      SD   = sd(value),
                      SE   = SD / sqrt(N)
);

raw.FC <- case.grouped$Mean/ctrl.grouped$Mean
log.FC <- log2(raw.FC)
Grouped.Info <- data.frame('Class'=ctrl.grouped$Class,'N'=ctrl.grouped$N, 'Ctrl.Sum'=ctrl.grouped$SUM, 'Ctrl.Mean'=ctrl.grouped$Mean,'Ctrl.SD'=ctrl.grouped$SD, 'Ctrl.SE'=ctrl.grouped$SE,
                            'Case.Sum'=case.grouped$SUM, 'Case.Mean'=case.grouped$Mean, 'Case.SD'=case.grouped$SD, 'Case.SE'=case.grouped$SE,'FC' = raw.FC, 'logFC'=log.FC)

#raw.means.sem <- transform(raw.grouped, lower=mean-se, upper=mean+se)

 # geom_errorbar(aes(ymax=upper, ymin=lower),position=position_dodge(0.5), width=.3, data= log.means.sem.data)

# Output file name
name_temp <-  strsplit(args[1], "/")
tmp <- strsplit(name_temp[[1]][length(name_temp[[1]])], "\\.") #Check the position of file name
tissue_name <- strsplit(tmp[[1]][1], "\\_")
filename1 <- paste(tissue_name[[1]][1],tissue_name[[1]][2],tissue_name[[1]][3], sep="_")
write.csv(Grouped.Info, paste(filename1,'_groupedInfo.csv',sep = ""), row.names=FALSE)

