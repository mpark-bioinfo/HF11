#!/usr/bin/env Rscript

# Meeyoung Park, 04/11/2016
# Command: Rscript <filename> <sample weight> <outdir>
# Input: "exposure_phenotype.cvs"
# Process: Quantile normalization
# Output: "_normalized.cvs"
#source("https://bioconductor.org/biocLite.R")
#biocLite("preprocessCore")
#install.packages("aod")
#install.packages("Rcpp")
library(reshape2)
library(plyr)
library(ggplot2)
library(gridExtra)
library(aod)
library(Rcpp)
ers_df = read.csv('./Raw_Input/exposure_phenotype.csv', header = TRUE, sep = ",")
#attach(ers_df)
#ers_df$Case <- factor(ers_df$Case)
# Statistical Analysis
aov.disease <- aov(ERS ~ Case, data=ers_df)
summary(aov.disease)
model.tables(aov.disease, "means")

# Grouping by class
case.grouped <- ddply(ers_df, "Case", summarise,
                     N    = length(ERS),
                     mean = mean(ERS),
                     sd   = sd(ERS),
                     se   = sd / sqrt(N)
)

tiff('ALSvsCT.tiff')
#pd <- position_dodge(0.1)
ggplot(case.grouped, aes(x = Case, y = mean,fill=factor(Case)))+ 
  geom_bar(position=position_dodge(), stat="identity", colour="black", size=.3) + geom_errorbar(aes(ymin=mean-se, ymax=mean+se), width=.1)+
  xlab("Group") + ylab("Mean") + ggtitle("Exposure Score") +
  scale_fill_hue(name="Group", # Legend label, use darker colors
                 breaks=c("ALS", "CTRL"),
                 labels=c("ALS (N=54)", "Control (N=15)")) +
  scale_y_continuous(breaks=-2:2) + theme_bw()
dev.off()

# Grouping by degree
degree.grouped <- ddply(ers_df, "Degree", summarise,
                     N    = length(ERS),
                     mean = mean(ERS),
                     sd   = sd(ERS),
                     se   = sd / sqrt(N)
)

tiff('ers_degree.tiff')
#pd <- position_dodge(0.1)
ggplot(degree.grouped, aes(x = Degree, y = mean,fill=factor(Degree)))+ 
  geom_bar(position=position_dodge(), stat="identity",
           colour="black", # Use black outlines,
           size=.3) +      # Thinner lines
  geom_errorbar(aes(ymin=mean-se, ymax=mean+se), width=.1)+
  xlab("Group") + ylab("Mean") +
  ggtitle("Exposure Score") +
  scale_fill_hue(name="Group", # Legend label, use darker colors
                 breaks=c("CT", "High", "Low", "Middle"),
                 labels=c("Control (N=15)", "High (N=15)", "Low (N=15)","Middle (N=24)")) +
  scale_y_continuous(breaks=-5:10*2) + theme_bw()
dev.off()

# Statistical Analysis
aov.degree <- aov(ERS ~ Degree, data=ers_df)
summary(aov.degree)
model.tables(aov.degree, "means")

# Student t-test
ers.high.idx <- which((ers_df$Degree == "High")==TRUE)
ers.low.idx <- which((ers_df$Degree == "Low")==TRUE)
ers.middle.idx <- which((ers_df$Degree == "Middle")==TRUE)
ers.ctrl.idx <- which((ers_df$Degree == "CT")==TRUE)
ers.high <- data.frame(ers_df[ers.high.idx,])
ers.middle <- data.frame(ers_df[ers.middle.idx,])
ers.low <- data.frame(ers_df[ers.low.idx,])
ers.ctrl <- data.frame(ers_df[ers.ctrl.idx,])
high.group <- rbind(ers.high, ers.ctrl)
low.group <- rbind(ers.low, ers.ctrl)
middle.group <- rbind(ers.middle, ers.ctrl)

tiff('ttest_degree.tiff')
high.ttest <- t.test(ERS ~ Degree, high.group, var.equal=TRUE)
low.ttest <- t.test(ERS ~ Degree, low.group, var.equal=TRUE)
middle.ttest <- t.test(ERS ~ Degree, middle.group, var.equal=TRUE)
degree_pvalue <- data.frame(Pvalue = c(-log10(high.ttest$p.value), -log10(low.ttest$p.value), -log10(middle.ttest$p.value)))
degree_pvalue <- cbind(Degree = c("High", "Low", "Middle"), degree_pvalue)
ggplot(degree_pvalue, aes(x = Degree, y = Pvalue,fill=factor(Degree)))+ geom_bar(stat="identity",colour="black", size=.3) 
dev.off()

# Linear regression
#reg1 <- lm(high.group$ERS ~ high.group$Degree)
#par(cex=.8)
#plot(high.group$ERS, high.group$Degree)
#abline(reg1)

# Using ddply 
#mydf <- ddply(ers_df, "ERS", mutate, prob = mean(Case))
#ggplot( probs, aes(x=position, y=prob)) +
#  geom_point() +
#  stat_smooth( data=mydf, aes(x = position, y = response),  method="glm", family="binomial", se=F)