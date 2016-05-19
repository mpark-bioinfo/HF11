#!/usr/bin/env Rscript

# Meeyoung Park, 04/13/2016
# Command: Rscript <filename> <outdir>
# Input: "_Final.csv"
# Process: Grouping by tissues
# Output: "grouped.csv"

#install.packages('plyr')
#install.packages('ggplot2')
#install.packages('gridExtra')
#install.packages('reshape2')
#install.packages('scales')
library(plyr)
library(ggplot2)
library(gridExtra)
library(reshape2)
library(scales)
# Grouping by strains
args = commandArgs(TRUE)
print(args[1])

# Output file name
name_temp <-  strsplit(args[1], "/")
tmp <- strsplit(name_temp[[1]][length(name_temp[[1]])], "\\.") #Check the position of file name
tissue_name <- strsplit(tmp[[1]][1], "\\_")
filename1 <- paste(tissue_name[[1]][1],tissue_name[[1]][2],tissue_name[[1]][3], sep="_")

df = read.csv(args[1], header = TRUE, sep = ",")
#df = read.csv('../FinalResults_051716/Plasma_Final.csv', header = TRUE, sep = ",")
# Grouping by class
new.df <- as.matrix(df[,5:length(df)])
# All heatmap
all.df <- data.frame('Class'= df$Class, log2(new.df))
all.melted <- melt(all.df, id.vars="Class")
all.scaled <- ddply(all.melted, .(variable), transform, Scaled_Concentration = rescale(value))


tiff(paste(args[2],filename1,'_heatmap_all.tiff',sep = ""))
ggplot(all.scaled, aes(variable, Class)) + geom_tile(aes(fill = Scaled_Concentration),colour = "white") +
  scale_fill_gradient(low = "white",high = "steelblue")+
  theme_minimal()+ # minimal theme
  theme(axis.text.x = element_text(angle = 45, vjust = 1, 
                                   size = 8, hjust = 1))#+ coord_fixed();
dev.off()
