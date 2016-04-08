
# Phenotype data
phenoData <- read.delim("phenoData.dat", header = TRUE, sep = "\t")
BL6 <- c('Ctrl_BL6_2249', 'Ctrl_BL6_2250', 'Ctrl_BL6_2251', 'Ctrl_BL6_2252','HF_BL6_2260','HF_BL6_2261','HF_BL6_2262','HF_BL6_2266')

new_data <- data.frame()
new_data <- cbind(as.character(SCN$Class), SCN$Carbon, SCN$Saturation)
for(i in BL6){ 
  for(j in colnames(SCN))
  {
    strClass <- paste("\\b",i,"\\b", sep="")
    col_match <- grep(strClass, colnames(SCN)[j])
    print(col_match)
    new_data <- cbind(new_data,col_match)
  }
}

dim(new_data)
