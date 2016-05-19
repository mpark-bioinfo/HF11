#!/usr/bin/env Rscript

# Meeyoung Park, 04/13/2016
# Command: Rscript <filename> <outdir>
# Input: "_groupedInfo.csv"
# Process: Grouping by strains
# Output: "_N.tiff"

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
# Output file name
name_temp <-  strsplit(args[1], "/")
tmp <- strsplit(name_temp[[1]][length(name_temp[[1]])], "\\.") #Check the position of file name
tissue_name <- strsplit(tmp[[1]][1], "\\_")
filename1 <- paste(tissue_name[[1]][1],tissue_name[[1]][2],tissue_name[[1]][3], sep="_")

Grouped.Info = read.csv(args[1], header = TRUE, sep = ",")
#Grouped.Info = read.csv('../FinalResults_051716/Plot/Plasma_WT_BKS_groupedInfo.csv', header = TRUE, sep = ",")

# CE check (Manually?  Need to modify for automatic process)
check <- ((Grouped.Info$Class == "CE") == FALSE)
if (check[1])
{
  newrow <- data.frame("CE", 0,0,0,0,0,0,0,0,0,0,0)
  colnames(newrow) <- colnames(Grouped.Info)
 newGroup.df = rbind(newrow, Grouped.Info)
 
}else
{
  newGroup.df = Grouped.Info
}

tiff(paste(args[2], filename1,'SCN_N.tiff',sep = ""))
#tiff('../FinalResults_051716/Plot/SCN_N.tiff',sep = "")

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

