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

LipidData = read.csv('../FinalResults_051716/Final_Plasma/Plasma_db_BTBR.csv', header = TRUE, row.names=1)

Grouped.Info = read.csv('../FinalResults_051716/Plot/Liver_WT_BL6_groupedInfo.csv', header = TRUE, sep = ",")

# Identify the max and min values
if (max(Grouped.Info$Ctrl.Sum) >= max(Grouped.Info$Case.Sum))
{
  max.sum <- log2(max(Grouped.Info$Ctrl.Sum))
  
} else
{
  max.sum <- log2(max(Grouped.Info$Case.Sum))
}

if (min(Grouped.Info$Ctrl.Sum) <= min(Grouped.Info$Case.Sum))
{
  min.sum <- log2(min(Grouped.Info$Ctrl.Sum))
  
} else
{
  min.sum <- log2(min(Grouped.Info$Case.Sum))
}

tiff(paste(filename1,'_CtrlSUM.tiff',sep = ""))
ggplot(Grouped.Info, aes(x = Class, y = log2(Ctrl.Sum), fill=factor(Class))) +
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
ggplot(Grouped.Info, aes(x = Class, y = log2(Case.Sum), fill=factor(Class))) +
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
sum.df <- data.frame("Class" = Grouped.Info$Class, "CtrlSum" = log2(Grouped.Info$Ctrl.Sum), "CaseSum" = log2(Grouped.Info$Case.Sum))
if (max(sum.df$CtrlSum) >= max(sum.df$CaseSum))
{
  max.sum <- max(sum.df$CtrlSum)
  
} else
{
  max.sum <- max(sum.df$CaseSum)
}


FC.df <- data.frame("Class" = Grouped.Info$Class, "FC" = (Grouped.Info$logFC))
log2sum <- log2((sum.df[,2:length(sum.df)]))
rownames(log2sum) <- sum.df$Class
log2sum[] <- sapply(log2sum, function(x) as.numeric(sub(",", "\\.", x)))
log2sum1 <- as.matrix(log2sum)
my_palette <- colorRampPalette(c("white", "blue","red"))(n = 299)
heatmap.2(log2sum1,
          main = "All groups", # heat map title
          notecol="black",      # change font color of cell labels to black
          density.info="none",  # turns off density plot inside color legend
          trace="none",         # turns off trace lines inside the heat map
          margins =c(12,9),     # widens margins around plot
          col=my_palette,       # use on color palette defined earlier
          dendrogram="row",     # only draw a row dendrogram
          Colv="NA")            # turn off column clustering



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
