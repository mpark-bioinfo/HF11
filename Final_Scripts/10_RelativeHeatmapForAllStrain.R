#!/usr/bin/env Rscript

# Meeyoung Park, 04/13/2016
# Command: Rscript <filename> <outdir>
# Input: "_Final.csv"
# Process: Grouping by strains
# Get median value for each lipid class 
# Check empty classes (i.e. 'CE', and 'CerP') in SCN after getting the total number of lipids in each class.  
# Output: "MedianValues.csv"

#install.packages('plyr')
#install.packages('ggplot2')
#install.packages('gridExtra')
#install.packages('reshape2')
install.packages('matrixStats')
library(plyr)
library(ggplot2)
library(gridExtra)
library(reshape2)
library(matrixStats)

# Grouping by strains
args = commandArgs(TRUE)
print(args[1])

df = read.csv(args[1], header = TRUE, sep = ",")
#df = read.csv('../FinalResults_051716/Final_SCN/SCN_WT_BL6.csv', header = TRUE, sep = ",")

# Separate lipid class
lipid.name <- t(as.data.frame(strsplit(as.character(df$Lipid), " ")));
colnames(lipid.name) <- c("Class", "Carbon")
lipid.name.class <- data.frame('Class'=lipid.name[,1])
lipid.name.carbon <- data.frame('Carbon'=lipid.name[,2])
LipidData <- data.frame('Class'=lipid.name.class, 'Carbon'=lipid.name.carbon, df[, 2:length(df)])

#
check1 <- ((LipidData$Class == "CE") == TRUE)
check2 <- ((LipidData$Class == "CerP") == TRUE)
if ((check1[1] == FALSE) & (check2[1] == FALSE))
{
  newrow1 <- data.frame("CE", "1_1", 1,1,1,1,1,1,1,1)
  newrow2 <- data.frame("CerP", "1_1", 1,1,1,1,1,1,1,1)
  colnames(newrow1) <- colnames(LipidData)
  colnames(newrow2) <- colnames(LipidData)
  newGroup.df = rbind(newrow1, newrow2, LipidData)
  
} else
{
  newGroup.df = LipidData
}

# Grouping by class
NumCtl <- 4
NumCase <- 4
new.df <- as.matrix(newGroup.df[,3:length(df)])
data.ctrl <- newGroup.df[, 1: NumCtl]
data.case <- newGroup.df[, (NumCtl+1) : (NumCtl+NumCase)]

# Median of each row (mean of replicates)
RowM.ctrl <- rowMedians(data.ctrl, na.rm = FALSE, dims = 1)
RowM.case <- rowMedians(data.case, na.rm = FALSE, dims = 1)
median.df <- data.frame('Class'=newGroup.df$Class, 'Carbon'=newGroup.df$Carbon, "Ctrl_Median" = RowM.ctrl, "Case_Median"= RowM.case)

# Control
ctrl.df <- data.frame('Class'=newGroup.df$Class, RowM.ctrl)
ctrl.melted <- melt(ctrl.df, id.vars="Class")
ctrl.grouped <- ddply(ctrl.melted, "Class", summarise,
                      N    = length(value),
                      SUM  = sum(value),
                      Mean = mean(value),
                      SD   = sd(value),
                      SE   = SD / sqrt(N)
)

tiff(paste(filename1,'_CtrlMedian.tiff',sep = ""))
ggplot(ctrl.grouped, aes(x = Class, y = log2(SUM), fill=factor(Class))) +
  geom_bar(aes(fill=Class),   # fill depends on cond2
           stat="identity",
           colour="black",    # Black outline for all
           show.legend = TRUE) + 
  xlab("Lipid Class") + ylab("Log2(Total amount of Lipids)") +
  scale_x_discrete("Class") +
  theme_bw() + scale_y_continuous(limits = c(0, 30)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1));

dev.off()

# Case
case.df <- data.frame('Class'=newGroup.df$Class, RowM.case)
case.melted <- melt(case.df, id.vars="Class")
case.grouped <- ddply(case.melted, "Class", summarise,
                      N    = length(value),
                      SUM  = sum(value),
                      Mean = mean(value),
                      SD   = sd(value),
                      SE   = SD / sqrt(N)
)


tiff(paste(filename1,'_CaseMedian.tiff',sep = ""))
ggplot(case.grouped, aes(x = Class, y = log2(SUM), fill=factor(Class))) +
  geom_bar(aes(fill=Class),   # fill depends on cond2
           stat="identity",
           colour="black",    # Black outline for all
           show.legend = TRUE) + 
  xlab("Lipid Class") + ylab("Log2(Total amount of Lipids)") +
  scale_x_discrete("Class") +
  theme_bw() + scale_y_continuous(limits = c(0, 30)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1));

dev.off()

raw.ratio <- case.grouped$SUM/ctrl.grouped$SUM
log.ratio <- log2(raw.ratio)
Grouped.Info <- data.frame('Class'=ctrl.grouped$Class,'N'=ctrl.grouped$N, 'Ctrl.Sum'=ctrl.grouped$SUM, 'Ctrl.Mean'=ctrl.grouped$Mean,'Ctrl.SD'=ctrl.grouped$SD, 'Ctrl.SE'=ctrl.grouped$SE,
                           'Case.Sum'=case.grouped$SUM, 'Case.Mean'=case.grouped$Mean, 'Case.SD'=case.grouped$SD, 'Case.SE'=case.grouped$SE,'FC' = raw.ratio, 'log2(FC)'=log.ratio)
write.csv(Grouped.Info, paste(args[2],filename1,'_groupedInfo.csv',sep = ""), row.names=FALSE)


# Relative Median Heatmap
sum.df <- data.frame("Class" = newGroup.df$Class, "CtrlSum" = log2(newGroup.df$Ctrl.Sum), "CaseSum" = log2(newGroup.df$Case.Sum))
if (max(sum.df$CtrlSum) >= max(sum.df$CaseSum))
{
  max.sum <- max(sum.df$CtrlSum)
  
} else
{
  max.sum <- max(sum.df$CaseSum)
}

sum.melted <- melt(sum.df, id.vars="Class")
tiff(paste(filename1,'_CtrlCaseSUM.tiff',sep = ""))
ggplot(sum.melted, aes(x= Class, y=value, colour=variable, fill=factor(variable))) + 
  geom_bar(stat="identity",
           colour="black",    # Black outline for all
           position= "dodge", width=.7) + xlab("Lipid Class") + ylab("log2(Sum)") +
           scale_x_discrete("Class") +
           scale_y_continuous(limits = c(0, max.sum)) + 
  scale_fill_manual(values = c("blue", "red"), .3) +
  theme_bw() + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1));

dev.off()

#ggplot(degree_pvalue, aes(x = Degree, y = Pvalue,fill=factor(Degree)))+ geom_bar(stat="identity",colour="black", size=.3)
#ggplot(means.sem, aes(x = Class, y = mean,fill=factor(Class))) +
#  geom_bar(stat = "identity", show.legend = FALSE) + 
#  xlab("Class") + ylab("Log2 Fold-change") +
#  scale_x_discrete("Class") +
#  scale_y_continuous(limits = c(-1, 1)) + theme_bw() +
#  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
#  geom_errorbar(aes(ymax=upper, ymin=lower),position=position_dodge(0.5), width=.3, data= means.sem)
