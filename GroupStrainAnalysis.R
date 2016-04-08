
install.packages("ggplot2")
install.packages("heatmap3")
install.packages("plyr")
install.packages("pca3d")
install.packages("rgl")
install.packages("ellipse")
#Prepare your R session
library(ggplot2)
library(heatmap3)
library(plyr)
library(rgl) 
library(ellipse)
library(pca3d) 
# Phenotype data
phenoData <- read.delim("phenoData.dat", header = TRUE, sep = "\t")

subsetCol <- c('Class','Ctrl_BL6_2249', 'Ctrl_BL6_2250', 'Ctrl_BL6_2251', 'Ctrl_BL6_2252','HF_BL6_2260','HF_BL6_2261','HF_BL6_2262','HF_BL6_2266')

# Cut-off CV <=30%
new_CV30 <- subset(SCN, SCN$CV <= 30)

# Extract only BL6
lipid_data <- new_CV30[, subsetCol]
# Log2 conversion
data_log <- log2(lipid_data[,2:length(lipid_data)])
# Final data with row lipid names
final_data_log <- cbind(lipid_data$Class, as.data.frame(data_log))

# Mean of each group: WT and HF
WT <- as.numeric(final_data_log[, 2:5])
HF <- as.numeric(final_data_log[, 6:9])
meanWT <- rowMeans(WT)
meanHF <- rowMeans(HF)
final_WT <- cbind(lipid_data$Class, as.data.frame(meanWT))
colnames(final_WT) <- c("Class", "MeanValue")
final_HT <- cbind(lipid_data$Class, as.data.frame(meanHF))
colnames(final_HT) <- c("Class", "MeanValue")
# Summarize by group
WTdata <- ddply(final_WT, "Class", function(final_WT) {
    mean.count <- mean(final_WT$MeanValue)
   })
WTdata
ggplot(data= WTdata,aes(x= WTdata$Class, y = WTdata$V1)) + geom_bar(colour="black", fill="#DD8888", width=.8,stat="identity")

#ddply(final_WT, lipid_data$Class, FUN=colSums)
#summarizedWT <- by(final_WT[,2], lipid_data$Class, FUN=colSums)
#dataResults <- as.data.frame(summarizedData)
#heatmap(final_data_log)
