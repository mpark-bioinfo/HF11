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
#library(plyr)
#library(ggplot2)
#library(gridExtra)
#library(reshape2)

# Grouping by strains
args = commandArgs(TRUE)
print(args[1])
# Output file name
name_temp <-  strsplit(args[1], "/")
tmp <- strsplit(name_temp[[1]][length(name_temp[[1]])], "\\.") #Check the position of file name
tissue_name <- strsplit(tmp[[1]][1], "\\_")
filename1 <- paste(tissue_name[[1]][1],tissue_name[[1]][2],tissue_name[[1]][3], sep="_")
Grouped.Info = read.csv(args[1], header = TRUE, sep = ",")
Grouped.Info = read.csv('../FinalResults_051716/Plot/SCN_WT_BKS_groupedInfo.csv', header = TRUE, sep = ",")

# CE check (Manually?  Need to modify for automatic process)
check <- ((Grouped.Info$Class == "CE") == FALSE)
if (check[1])
{
  newrow <- data.frame("CE", 0,0,0,0,0,0,0,0,0,0,0)
  colnames(newrow) <- colnames(Grouped.Info)
  newGroup.df = rbind(newrow, Grouped.Info)
  
} else
{
  newGroup.df = Grouped.Info
}

tiff(paste(filename1,'_N.tiff',sep = ""))
# Number of lipids
ggplot(newGroup.df, aes(x = Class, y = N, fill=factor(Class))) +
  geom_bar(aes(fill=Class),   # fill depends on cond2
           stat="identity",
           colour="black",    # Black outline for all
           show.legend = FALSE) + 
  xlab("Lipid Class") + ylab("Number of Lipids") +
  scale_x_discrete("Class") +
  theme_bw() + scale_y_continuous(limits = c(0, 70)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1));
dev.off()

# Identify the max and min values
if (max(newGroup.df$Ctrl.Sum) >= max(newGroup.df$Case.Sum))
{
  max.sum <- max(newGroup.df$Ctrl.Sum)
  
} else
{
  max.sum <- max(newGroup.df$Case.Sum)
}

if (min(newGroup.df$Ctrl.Sum) <= min(newGroup.df$Case.Sum))
{
  min.sum <- min(newGroup.df$Ctrl.Sum)
  
} else
{
  min.sum <- min(newGroup.df$Case.Sum)
}

tiff(paste(filename1,'_CtrlSUM.tiff',sep = ""))
ggplot(newGroup.df, aes(x = Class, y = Ctrl.Sum, fill=factor(Class))) +
  geom_bar(aes(fill=Class),   # fill depends on cond2
           stat="identity",
           colour="black",    # Black outline for all
           show.legend = FALSE) + 
  xlab("Lipid Class") + ylab("Total amount of Lipids") +
  scale_x_discrete("Class") +
  theme_bw() + scale_y_continuous(limits = c(0, max.sum)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1));

dev.off()

tiff(paste(filename1,'_CaseSUM.tiff',sep = ""))
ggplot(newGroup.df, aes(x = Class, y = Case.Sum, fill=factor(Class))) +
  geom_bar(aes(fill=Class),   # fill depends on cond2
           stat="identity",
           colour="black",    # Black outline for all
           show.legend = FALSE) + 
  xlab("Lipid Class") + ylab("Total amount of Lipids") +
  scale_x_discrete("Class") +
  theme_bw() + scale_y_continuous(limits = c(0, max.sum)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1));

dev.off()

# Relative Sum Heatmap
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
