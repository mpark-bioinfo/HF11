#install.packages('ggplot2')

#setwd("~/Documents/Lipidomics_Analysis/HF11/Scripts")
library(plyr)
library(ggplot2)
library(reshape2)

args = commandArgs(TRUE)
print(args[1])

df = read.csv(args[1], header = TRUE, sep = ",", row.names = 1)
#WT_BKS = read.csv('../GroupStatistics/WT_BKS_FC.csv', header = TRUE, row.names = 1)

# Output file name
name_temp <-  strsplit(args[1], "/")
tmp <- strsplit(name_temp[[1]][length(name_temp[[1]])], "\\.") #Check the position of file name
filename <- paste(tmp[[1]][1],'.tiff',sep = "")

tiff(filename)
transposed<- t(df)
df.melted <- melt(transposed, id.vars="Class")
new.df <- data.frame("Class"=df.melted$Var2, "Tissue"=df.melted$Var1, "logFC"=df.melted$value)

ggplot(new.df, aes(x=Class, y=logFC, colour=Tissue, fill=Tissue)) + 
  geom_bar(aes(fill=Tissue),   # fill depends on cond2
           stat="identity",
           colour="black",    # Black outline for all
           position=position_dodge()) + xlab("Lipid Class") + ylab("log2 Fold-change") +
  scale_y_continuous(limits = c(-1, 1.5)) + theme_bw() + theme(axis.text.x = element_text(angle = 45, hjust = 1));

dev.off()


