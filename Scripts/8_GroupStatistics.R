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
#df = read.csv('../Normalization/Final_SCN/SCN_WT_BL6.csv', header = TRUE, sep = ",")

# Get Group FC
# Separate lipid class
lipid.name <- t(as.data.frame(strsplit(as.character(df$Sample), " ")));
colnames(lipid.name) <- c("Class", "Carbon")
lipid.name.class <- data.frame('Class'=lipid.name[,1])
LipidData <- data.frame('Class'=lipid.name.class, df[, 2:9])

# Grouping by class
NumCtl <- 4
NumCase <- 4
new_df <- as.matrix(LipidData[,2:9])
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

raw.FC <- case.grouped$mean/ctrl.grouped$mean
log.FC <- log2(raw.FC)
Grouped.logFC <- data.frame('Class'=ctrl.grouped$Class,'N'=ctrl.grouped$N, 'Ctrl.mean'=ctrl.grouped$mean,'Ctrl.SD'=ctrl.grouped$sd, 'Ctrl.SE'=ctrl.grouped$se,
                            'Case.mean'=case.grouped$mean, 'Case.SD'=case.grouped$sd, 'Case.SE'=case.grouped$se,'FC' = raw.FC, 'logFC'=log.FC)

#raw.means.sem <- transform(raw.grouped, lower=mean-se, upper=mean+se)

 # geom_errorbar(aes(ymax=upper, ymin=lower),position=position_dodge(0.5), width=.3, data= log.means.sem.data)

# Output file name
name_temp <-  strsplit(args[1], "/")
tmp <- strsplit(name_temp[[1]][length(name_temp[[1]])], "\\.") #Check the position of file name
tissue_name <- strsplit(tmp[[1]][1], "\\_")
filename1 <- paste(tissue_name[[1]][1],tissue_name[[1]][2],tissue_name[[1]][3], sep="_")
write.csv(Grouped.logFC, paste(filename1,'_groupedFC.csv',sep = ""), row.names=FALSE)

tiff(paste(filename1,'_N.tiff',sep = ""))
# Number of lipids
ggplot(Grouped.logFC, aes(x = Class, y = N, fill=factor(Class))) +
  geom_bar(stat = "identity", show.legend = FALSE) + 
  xlab("Lipid Class") + ylab("Number of Lipids") +
  scale_x_discrete("Class") +
  theme_bw() + scale_y_continuous(limits = c(0, 70)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1));
dev.off()

tiff(paste(filename1,'_FC.tiff',sep = ""))
ggplot(Grouped.logFC, aes(x = Class, y = logFC, fill=factor(Class))) +
  geom_bar(stat = "identity", show.legend = FALSE) + 
  xlab("Lipid Class") + ylab("log2 Fold-change") +
  scale_x_discrete("Class") +
  theme_bw() + scale_y_continuous(limits = c(-1.5, 1.5)) +
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
