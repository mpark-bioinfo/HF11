install.packages('ggplot2')
library(ggplot2)
library(reshape2)
library(corrplot)
library(Hmisc)

args = commandArgs(TRUE)
print(args[1])


#LipidData = read.csv('../Normalization/Final_Plasma/Plasma_WT_BL6.csv', header = TRUE,row.names=1)
LipidData = read.csv(args[1], header = TRUE,row.names=1)
transposed <- t(LipidData)

# Compute correlation table
cor_cov_dat <- rcorr(as.matrix(transposed), type="pearson")
cormat <- as.matrix(data.frame(cor_cov_dat$r))
pmat <- as.matrix(data.frame(cor_cov_dat$P))

# Output file name
name_temp <-  strsplit(args[1], "/")
tmp <- strsplit(name_temp[[1]][length(name_temp[[1]])], "\\.") #Check the position of file name
tissue_name <- strsplit(tmp[[1]][1], "\\_")
filename1 <- paste(args[2], tissue_name[[1]][1],tissue_name[[1]][2],tissue_name[[1]][3],'corr', sep="_")

write.csv(data.frame(cor_cov_dat$r), paste(filename1,'_r.csv',sep = ""), row.names=FALSE)
write.csv(data.frame(cor_cov_dat$p), paste(filename1,'_p.csv',sep = ""), row.names=FALSE)

tiff(paste(filename1,'.tiff',sep = ""))
corrplot(cormat, method="color", tl.col = "white")
dev.off()
