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

df = read.csv(args[1], header = TRUE, sep = ",")
#df = read.csv('../FinalResults_051716/SCN_Final.csv', header = TRUE, sep = ",")
#df = read.csv('../FinalResults_051716/Liver_Final.csv', header = TRUE, sep = ",")
#df = read.csv('../FinalResults_051716/Plasma_Final.csv', header = TRUE, sep = ",")
LipidInfo <- (Lipid = paste(df$Class, " ", df$Carbon, "_", df$Double_bond, sep=""))

# Grouping by class
new.df <- as.matrix(df[,5:length(df)])
rownames(new.df) <- LipidInfo

# BKS WT
Ctrl_BKS <- new.df[, c('Ctrl_BKS_2202', 'Ctrl_BKS_2203', 'Ctrl_BKS_2206', 'Ctrl_BKS_2211')]
Ctrl_BL6 <- new.df[, c('Ctrl_BL6_2249', 'Ctrl_BL6_2250', 'Ctrl_BL6_2251', 'Ctrl_BL6_2252')]
Ctrl_BTBR <- new.df[, c('Ctrl_BTBR_2292', 'Ctrl_BTBR_2293', 'Ctrl_BTBR_2297', 'Ctrl_BTBR_2298')]

Ctrl_BKS_db <- new.df[, c('Ctrl_BKS_db._2225', 'Ctrl_BKS_db._2226', 'Ctrl_BKS_db._2227','Ctrl_BKS_db._2231')]
Ctrl_BL6_db <- new.df[, c('Ctrl_BL6_db._2273','Ctrl_BL6_db._2274', 'Ctrl_BL6_db._2275', 'Ctrl_BL6_db._2279')]
Ctrl_BTBR_ob <- new.df[, c('Ctrl_BTBR_ob._2316', 'Ctrl_BTBR_ob._2317', 'Ctrl_BTBR_ob._2318', 'Ctrl_BTBR_ob._2320')]

HF_BKS <- new.df[, c('HF_BKS_2214', 'HF_BKS_2216', 'HF_BKS_2217', 'HF_BKS_2218')]
HF_BL6 <- new.df[, c('HF_BL6_2260', 'HF_BL6_2261', 'HF_BL6_2262', 'HF_BL6_2266')]
HF_BTBR <- new.df[, c('HF_BTBR_2306', 'HF_BTBR_2307', 'HF_BTBR_2308', 'HF_BTBR_2309')] 

HF_BKS_db <- new.df[, c('HF_BKS_db._2239', 'HF_BKS_db._2241', 'HF_BKS_db._2242', 'HF_BKS_db._2243')]
HF_BL6_db <- new.df[, c('HF_BL6_db._2286', 'HF_BL6_db._2287', 'HF_BL6_db._2288', 'HF_BL6_db._2289')]
HF_BTBR_ob <- new.df[, c('HF_BTBR_ob._2329', 'HF_BTBR_ob._2331', 'HF_BTBR_ob._2333', 'HF_BTBR_ob._2334')]

ordered.df <- cbind(Ctrl_BKS,Ctrl_BL6,Ctrl_BTBR,Ctrl_BKS_db,Ctrl_BL6_db,Ctrl_BTBR_ob,HF_BKS,HF_BL6,HF_BTBR,HF_BKS_db,HF_BL6_db,HF_BTBR_ob)
# All heatmap
#all.df <- data.frame('Class'= df$Class, new.df)
#all.scaled<- data.frame('Class'= df$Class, scale(log2(new.df), center = TRUE, scale = TRUE))
#x <- scale(log2(new.df), center = TRUE, scale = TRUE)
new.df <- log2(ordered.df)
my_palette <- colorRampPalette(c("white", "blue","red"))(n = 299)
tiff(paste(args[2], filename1,'_heatmap_all.tiff',sep = ""),
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
