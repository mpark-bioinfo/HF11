rm(list=ls())
#########################################################################################
##-----EMBO Practical Course on Metabolomics Bioinformatics for Life Scientists 2016
## ----Ranking and Filtering mZRT metabolic Features to MS/MS Identification Experiments
##-----Maria Vinaixa maria.vinaixa@manchester.ac.uk
#########################################################################################

####Set R Session, Download Data and Explore XCMS results####

#Prepare your R session
library(xcms)
library(ggplot2)
library(reshape)
#library(downloader)
library(gridExtra)
#Load data from dropbox
load("Z:/2016/EMBO Practical Course on Metabolomics Bioinformatics for Life Scientists 2016/FilesVinaixa/LC-MSpracticum/xset3.RData")
#Explore xset3
xset3
#Determine the number of samples per group
table(sampclass(xset3)) 

####Sample Representativeness in each mZRT feature####


#Calculate the 80% of samples in each experimental group
round(table(xset3@phenoData)*0.8,0)
#Obtain the mZRT table
T <- data.frame(xset3@groups)
#Restrict to features found in at least 80% of samples in a group
t <- which(T$CTR>=11 | T$DISEASE>=10 | T$TREATMENT>=10)
Feature.table <- T[t,]
rownames(Feature.table) <- groupnames(xset3)[t]
head(Feature.table)
#Calculate percentage
percentage <- (dim(Feature.table)[1]/dim(T)[1])*100 
percentage

####Intensity####


#Get intensities from xcmsSet object from those features meeting 80% rule
X1 <- groupval(xset3, value="maxo")[t,]
#Get names of mZRT features
rownames(X1) <- groupnames(xset3)[t]
#Define experimental groups
class <- as.factor(xset3@phenoData$class)

#Compute the mean intensities for each group
meanintensities<-t(apply(X1, 1, function(x) tapply(x, class, mean)))
rownames(meanintensities) <- groupnames(xset3)[t]

#Stablish intensity threshold value
thresholdvalue <- 5000
#Getting number of features with mean intensity above certain 
#threshold counts in at least one of the groups except QC group
t <- meanintensities[,which(colnames(meanintensities)!="QC")]
idx_i <- rownames(meanintensities[apply(t, 1, function(x) any(x>thresholdvalue)==TRUE),])
#Getting the percentage out of the total mZRT features meeting the 80% rule
percentage <- (length(idx_i)/dim(meanintensities)[1])*100 
percentage

## Plot Intensity distributions /density plots

# For the first plot we need to sort mean intensities in each group 
M2 <- apply(meanintensities,2,sort,decreasing=TRUE)
require(reshape)
M2plot <- melt(M2)
names(M2plot) <- c("Features","group","Intensity")
require(ggplot2)
#Plot intensities
iplot1 <- ggplot(data=M2plot,aes(x=Features, y=Intensity, colour=group))+ 
  geom_line()+
  geom_hline(yintercept = thresholdvalue, linetype = 2)+
  scale_y_log10()+
  labs(y = "Intensity", x = "# mZRT Features", title= "Intensity")


iplot2 <- ggplot(data=M2plot, aes(x=Intensity, fill=group)) + 
  geom_density(alpha=0.3)+
  scale_x_log10()+
  labs(x="log10(Intensity)",title = "Intensity Distribution")

require(gridExtra)
grid.arrange(iplot1,iplot2,nrow=2)

####Handling analytical variation through Quality Control Samples (QCs)####

## Compute and plot PCA for QCs check and to explore main trends in the data

## 1-. Create a dataframe containing intensity data
  D <- data.frame(X1)
## 2-. Restrict this dataframe to intensities above the fixed threshold value
  D1 <- D[idx_i,]
## 3-. Row-wise normalzation prior to PCA: Normalize across samples each mZRT variable to max=1
  D1norm <- data.frame(t(apply(D1,2,norm<-function(x) (x/max(x)))))
## 4-. Compute PCA
  pca <- prcomp(D1norm)
## 5-. Print variance summary for the fourth first PCs
  summary(pca)$importance[, 1:4]
## 6-. Get scores values
  scores <- data.frame(pca$x[,c("PC1","PC2")])
  scores$class <- class
## 7-. Labelling samples
  lab <- as.numeric(gsub("\\D","",colnames(D1)))
  #7-. Plot scores
scores.plot <- ggplot(data=scores,aes(x=PC1, y=PC2, colour=class))+
  geom_point(alpha = I(0.7), size=10)+
  geom_text(data=scores, mapping=aes(x=PC1, y=PC2, label=lab),size=4, vjust=3, hjust=3)+
  geom_hline(yintercept = 0)+
  geom_vline(xintercept = 0)

scores.plot

## Compute and CV across samples and QCs

#1-. Define (CV) function
co.var <- function(x) ( 100*sd(x)/mean(x) )
#2-. Define  QC and Sample samples classes
cl1 <- rep(c("Sample","QC"), times=c(38,8))
#3-. Compute CV for QC and Samples
CV<-t(apply(D, 1, function(x) tapply(x, cl1, co.var)));
head(CV)
#4-. Determine the percenteage of features where CV(Samples)>CV(QC)
idx_qc <- rownames(CV)[CV[,"Sample"]>CV[,"QC"]]
percentage <- length(idx_qc)/dim(X1)[1]*100
percentage

#Combine both intensity and QC criteria
Ib <- intersect(idx_i,idx_qc)
#Create a new dataset without QC samples and with those mZRT features
#that meet both criteria
D1 <- data.frame(t(D))
D2 <- subset(D1,class!="QC", select=Ib)
#Calculate the number of retained mZRT features
percentage <- dim(D2)[2]/dim(D)[1]*100 
percentage

####Statistical Analysis####

dim(D2)
#Get rid out of QCs in factor defining experimental groups
gr <- as.factor(xset3@phenoData$class[xset3@phenoData$class!="QC"])
#Perform an anova comparison of groups (CTR, DISEASE & TREATMENT)
pm <- matrix(ncol=3,nrow=dim(D2)[2])
for(i in 1:ncol(D2)){ 
  aov.out <- aov(D2[,i] ~ gr)
  multcomp <- TukeyHSD(aov.out)
  pm[i,]  <- as.matrix(multcomp$gr[,"p adj"])
}
rownames(pm) <- colnames(D2)
colnames(pm) <- rownames(multcomp$gr)
#Adjust for multiple testing using false discovery rate
p.val.adj.DISEASE.CTR <- p.adjust(pm[,"DISEASE-CTR"],"fdr");
p.val.adj.TREATMENT.DISEASE <- p.adjust(pm[,"TREATMENT-DISEASE"],"fdr");

#Create the fold change function
fc.test<-function(D2,classvector){
  means<-apply(D2, 2, function(x) tapply(x, classvector, mean))
  means <- t(means)
  case <- means[,"case"];control <- means[,"control"]
  logFC <- log2(case/control)
  FC <- case/control;
  FC2 <- -control/case
  FC[FC<1] <- FC2[FC<1]
  fc.res <- data.frame(cbind(FC, logFC))
  return(fc.res)
}

#Calculate FC for "DISEASE-CTR" groups 
#Define control/case groups
gr2 <- as.character(gr)
gr2[gr2=="CTR"] <- "control"
gr2[gr2=="DISEASE"] <- "case" 
#Calculate FC using fc.test function
fc.res <- fc.test(D2,gr2)
R1 <- data.frame(fc.res,p.val.adj.DISEASE.CTR)
I.DISEASE.CTR <- colnames(D2)[abs(fc.res$FC) > 2 & 
                                p.val.adj.DISEASE.CTR < 0.05]
R1$threshold <- as.factor(abs(R1$FC) > 2 & R1$p.val.adj.DISEASE.CTR< 0.05) 
table(R1$threshold)

#Calculate FC for "DISEASE-TREATMENT" groups 
#Define control/case groups
gr3 <- as.character(gr); 
gr3[gr=="DISEASE"] <- "control" 
gr3[gr=="TREATMENT"] <- "case"; 
fc.res2 <- fc.test(D2,gr3)
R2 <- data.frame(fc.res2,p.val.adj.TREATMENT.DISEASE)
I.DISEASE.TREATMENT <- colnames(D2)[abs(fc.res2$FC) > 2 & 
                                      p.val.adj.TREATMENT.DISEASE< 0.05]

R2$threshold <- as.factor(abs(R2$FC) > 2 & R2$p.val.adj.TREATMENT.DISEASE<0.05) 
table(R2$threshold)

#Draw Volcano plots for both comparisons
p1 <- ggplot(data=R1, aes(x=R1$logFC, y=-log10(R1$p.val.adj.DISEASE.CTR),
                          colour=threshold))+
  geom_point(alpha=0.4, size=1.75) +
  theme(legend.position="none") +
  xlim(-10, 10)+
  geom_hline(yintercept = -log10(0.05))+
  geom_vline(xintercept = log2(2))+
  geom_vline(xintercept = -log2(2))+
  labs(x = "log2(FC)", y = "-log10(p.adj)", title = "DISEASE vs CTR")
p2 <- ggplot(data=R2, aes(x=R2$logFC, y=-log10(R2$p.val.adj.TREATMENT.DISEASE), 
                          colour=threshold))+
  geom_point(alpha=0.4, size=1.75) +
  theme(legend.position="none") +
  xlim(-10, 10)+
  geom_hline(yintercept = -log10(0.05))+
  geom_vline(xintercept = log2(2))+
  geom_vline(xintercept = -log2(2))+
  labs(x = "log2(FC)", y = "-log10(p.adj)", title = "DISEASE vs TREATMENT")
require(gridExtra)
grid.arrange(p1, p2, ncol=2)

####Collapse Relevant Information to subsequent MS/MS ex- periments####

#Combine FC values as a criteria to sort features 
idx.s <- union(I.DISEASE.TREATMENT,I.DISEASE.CTR)
FC.combi <- abs(fc.res$FC*fc.res2$FC)
Rf <- data.frame(R1,R2,FC.combi)
Rf.s <- Rf[idx.s,]
Rf.s.ord <- Rf.s[order(Rf.s$FC.combi, decreasing = TRUE), ]
sig.ord <- rownames(Rf.s.ord)

#Retrieving mZRT information
F <- Feature.table[sig.ord,]

#Getting mean group intensities for significative
#features
intord <- meanintensities[sig.ord,]

#Collapse all information
RESULTS <- data.frame(Rf.s.ord,intord,F)
head(RESULTS,2)
dim(RESULTS)

#Write it in a .csv file
write.csv(file="resultstoMSMS.csv", x=RESULTS)


