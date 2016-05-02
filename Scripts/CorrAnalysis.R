#install.packages('ggplot2')
#install.packages('corrplot')
#install.packages('Hmisc')
#install.packages('IDPmisc')
#install.packages('functional')
library(functional)
#setwd("~/Documents/Lipidomics_Analysis/HF11/Scripts")

library(ggplot2)
library(reshape2)
library(corrplot)
library(Hmisc)
require(IDPmisc)
args = commandArgs(TRUE)
print(args[1])

#LipidData = read.csv('../Normalization/Final_Plasma/Plasma_WT_BL6.csv', header = TRUE,row.names=1)
LipidData = read.csv(args[1], header = TRUE, row.names=1)
new_LipidData <- LipidData[!row.names(LipidData)%in% c("PC 36_4","PI 38_4"),]
transposed <- t(new_LipidData)

# Compute correlation table
cor_cov_dat <- rcorr(as.matrix(transposed), type="pearson") 
corr_data <- data.frame(cor_cov_dat$r)
cormat <- as.matrix(data.frame(cor_cov_dat$r))
pmat <- as.matrix(data.frame(cor_cov_dat$P))
p_data <- data.frame(cor_cov_dat$P)


# Output file name
name_temp <-  strsplit(args[1], "/")
tmp <- strsplit(name_temp[[1]][length(name_temp[[1]])], "\\.") #Check the position of file name
tissue_name <- strsplit(tmp[[1]][1], "\\_")
filename1 <- paste(tissue_name[[1]][1],tissue_name[[1]][2],tissue_name[[1]][3],'corr', sep="_")
outname1 <- paste(args[2],filename1,'_r.csv',sep = "")
outname2 <- paste(args[2],filename1,'_p.csv',sep = "")
outname3 <- paste(args[2],filename1,'.tiff',sep = "")
write.csv(corr_data, outname1, row.names=FALSE)
write.csv(p_data, outname2, row.names=FALSE)

tiff(outname3)
corrplot(cormat, method="color", tl.col = "black", order ="hclust", hclust.method = "ward.D2")
dev.off()
# Remove NaN
#noNan <- function(d=data) d[apply(d, 1, function(x) any(!is.nan(x))),]
#new_data1 <- noNan(cormat)

#new_cormat <- cormat[apply(cormat, 1, function(x) any(!is.nan(x))),]

# Ward Hierarchical Clustering
#hclustfunc <- function(x, method = "ward.D2", dmeth = "euclidean") {    
#  hclust(dist(x, method = dmeth), method = method)
#}
#ind <- !(complete.cases(cormat) != is.nan(cormat))
#fit <- hclustfunc(new_cormat)
#plot(fit) # display dendogram
#groups <- cutree(fit, k=5) # cut tree into 5 clusters
# draw dendogram with red borders around the 5 clusters
#rect.hclust(fit, k=5, border="red") 



