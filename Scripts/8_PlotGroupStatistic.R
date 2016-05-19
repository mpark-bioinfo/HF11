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

# Combine???
#df1.melted <- melt(df1, id.vars="Class")
#df2.melted <- melt(df2, id.vars="Class")
#df3.melted <- melt(df3, id.vars="Class")

# Output file name
name_temp <-  strsplit(args[1], "/")
tmp <- strsplit(name_temp[[1]][length(name_temp[[1]])], "\\.") #Check the position of file name
tissue_name <- strsplit(tmp[[1]][1], "\\_")
filename1 <- paste(tissue_name[[1]][1],tissue_name[[1]][2],tissue_name[[1]][3], sep="_")

tiff(paste(args[2], filename1,'_base_mean.tiff',sep = ""))
ggplot(df, aes(x = Class, y = Ctrl.mean,fill=factor(Class)))+ 
  geom_bar(position=position_dodge(), stat="identity",
           colour="black", # Use black outlines,
           size=.3) +      # Thinner lines
  geom_errorbar(aes(ymin=Ctrl.mean-Ctrl.SE, ymax=Ctrl.mean+Ctrl.SE), width=.1)+
  xlab("Class") + ylab("log2(Mean)") +
  theme_bw() + scale_y_continuous(limits = c(0, 50)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1));
dev.off()

tiff(paste(args[2], filename1,'_case_mean.tiff',sep = ""))
ggplot(df, aes(x = Class, y = Case.mean,fill=factor(Class)))+ 
  geom_bar(position=position_dodge(), stat="identity",
           colour="black", # Use black outlines,
           size=.3) +      # Thinner lines
  geom_errorbar(aes(ymin=Case.mean-Case.SE, ymax=Case.mean+Case.SE), width=.1)+
  xlab("Class") + ylab("log2(Mean)") +
  theme_bw() + scale_y_continuous(limits = c(0, 50)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1));
dev.off()

tiff(paste(args[2], filename1,'_FC.tiff',sep = ""))
ggplot(df, aes(x = Class, y = logFC, fill=factor(Class))) +
  geom_bar(aes(fill=Class),   # fill depends on cond2
           stat="identity",
           colour="black",    # Black outline for all
           show.legend = FALSE) + 
  xlab("Lipid Class") + ylab("log2 Fold-change") +
  scale_x_discrete("Class") +
  theme_bw() + scale_y_continuous(limits = c(-1, 1.5)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1));

dev.off()

tiff(paste(args[2], filename1,'_N.tiff',sep = ""))
# Number of lipids
ggplot(df, aes(x = Class, y = Number, fill=factor(Class))) +
  geom_bar(aes(fill=Class),   # fill depends on cond2
           stat="identity",
           colour="black",    # Black outline for all
           show.legend = FALSE) + 
  xlab("Lipid Class") + ylab("Number of Lipids") +
  scale_x_discrete("Class") +
  theme_bw() + scale_y_continuous(limits = c(0, 80)) +
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
