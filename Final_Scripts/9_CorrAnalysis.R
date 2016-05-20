#install.packages('ggplot2')
#install.packages('corrplot')
#install.packages('Hmisc')
#install.packages('IDPmisc')
#install.packages('functional')
#install.packages('pheatmap')
#install.packages('IDPmisc')
#setwd("~/Documents/Lipidomics_Analysis/HF11/Scripts")
library(functional)
library(pheatmap)
library(ggplot2)
library(reshape2)
library(corrplot)
library(Hmisc)
library(IDPmisc)

args = commandArgs(TRUE)
print(args[1])

#LipidData = read.csv('../FinalResults_051716/Final_Plasma/Plasma_db_BTBR.csv', header = TRUE,row.names=1)
LipidData = read.csv(args[1], header = TRUE, row.names=1)
ind <- apply(LipidData, 1, var) == 0
new_LipidData <- LipidData[!ind,]
transposed <- t(new_LipidData)

log2.df <- log2(transposed)
scaled.df <- scale(log2.df, center = TRUE, scale = TRUE)

cor_cov_dat <- rcorr(as.matrix(scaled.df), type="spearman")
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
write.csv(corr_data, "corr1.csv", row.names=TRUE, na="NA")
write.csv(p_data, outname2, row.names=TRUE, na="NA")

tiff(outname3)
corrplot(cormat, method="color", tl.col = "white", order ="hclust", hclust.method = "ward.D2", addrect=3)
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



