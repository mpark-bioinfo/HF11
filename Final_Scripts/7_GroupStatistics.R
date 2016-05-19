#!/usr/bin/env Rscript

# Meeyoung Park, 04/13/2016
# Command: Rscript <filename> <outdir>
<<<<<<< HEAD
# Input: "_.csv"
=======
# Input: "_Final.csv"
>>>>>>> 6a9203dfe1d39e001ea338d2c1ec3d898b42a103
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
<<<<<<< HEAD
#df = read.csv('../Final_Analysis_050516/Final_SCN/SCN_WT_BL6.csv', header = TRUE, sep = ",")
=======
#df = read.csv('../Final_Analysis_050516_Incorrect/Final_Liver/Liver_WT_BL6.csv', header = TRUE, sep = ",")
>>>>>>> 6a9203dfe1d39e001ea338d2c1ec3d898b42a103

# Get Group FC
# Separate lipid class
lipid.name <- t(as.data.frame(strsplit(as.character(df$Sample), " ")));
colnames(lipid.name) <- c("Class", "Carbon")
lipid.name.class <- data.frame('Class'=lipid.name[,1])
<<<<<<< HEAD
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
=======
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
>>>>>>> 6a9203dfe1d39e001ea338d2c1ec3d898b42a103

# Output file name
name_temp <-  strsplit(args[1], "/")
tmp <- strsplit(name_temp[[1]][length(name_temp[[1]])], "\\.") #Check the position of file name
tissue_name <- strsplit(tmp[[1]][1], "\\_")
filename1 <- paste(tissue_name[[1]][1],tissue_name[[1]][2],tissue_name[[1]][3], sep="_")
<<<<<<< HEAD
write.csv(Grouped.logFC, paste(args[2],filename1,'_groupedFC.csv',sep = ""), row.names=FALSE)


=======
write.csv(Grouped.Info, paste(filename1,'_groupedInfo.csv',sep = ""), row.names=FALSE)
>>>>>>> 6a9203dfe1d39e001ea338d2c1ec3d898b42a103

