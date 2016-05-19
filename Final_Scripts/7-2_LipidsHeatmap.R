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
library(gplots)
library(RColorBrewer)
# Grouping by strains
args = commandArgs(TRUE)
print(args[1])

# Output file name
name_temp <-  strsplit(args[1], "/")
tmp <- strsplit(name_temp[[1]][length(name_temp[[1]])], "\\.") #Check the position of file name
tissue_name <- strsplit(tmp[[1]][1], "\\_")
filename1 <- paste(tissue_name[[1]][1],tissue_name[[1]][2],tissue_name[[1]][3], sep="_")

setwd("C:/Users/Meeyoung/Dropbox/HF11_LipidomicsStudy/HF11/Final_Scripts")

#df = read.csv(args[1], header = TRUE, sep = ",", row.names = 1)
#df = read.csv('../FinalResults_051716/SCN_Final.csv', header = TRUE, sep = ",")
#df = read.csv('../FinalResults_051716/Liver_Final.csv', header = TRUE, sep = ",")
df = read.csv('../FinalResults_051716/Plasma_Final.csv', header = TRUE, sep = ",")
LipidInfo <- (Lipid = paste(df$Class, " ", df$Carbon, "_", df$Double_bond, sep=""))

# Grouping by class
new.df <- as.matrix(df[,5:length(df)])
rownames(new.df) <- LipidInfo
# All heatmap
#all.df <- data.frame('Class'= df$Class, new.df)
#all.scaled<- data.frame('Class'= df$Class, scale(log2(new.df), center = TRUE, scale = TRUE))
#x <- scale(log2(new.df), center = TRUE, scale = TRUE)
new.df <- log2(new.df)
my_palette <- colorRampPalette(c("white", "blue","red"))(n = 299)
tiff(paste('../FinalResults_051716/Plasma_Final','_heatmap_all.tiff',sep = ""),
      width = 5*300,        # 5 x 300 pixels
      height = 5*300,
      res = 300,            # 300 pixels per inch
      pointsize = 8)        # smaller font size)

heatmap.2(new.df,
          main = "All groups", # heat map title
          notecol="black",      # change font color of cell labels to black
          density.info="none",  # turns off density plot inside color legend
          trace="none",         # turns off trace lines inside the heat map
          margins =c(12,9),     # widens margins around plot
          col=my_palette,       # use on color palette defined earlier
          dendrogram="row",     # only draw a row dendrogram
          Colv="NA")            # turn off column clustering


dev.off()
