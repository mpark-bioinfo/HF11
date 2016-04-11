# Comaprison between Lipid classes
# Bar chart for each class between tissues
# Extract only CV <= 50% 
LiverLipidData = read.delim('Liver_Final.txt', header = TRUE, sep = "\t")

cutoff0 <- 30
cutoff1 <- 40
cutoff2 <- 50
CV_idx_30 <- which((LiverLipidData$CV <= cutoff0) == TRUE)
CV_idx_40 <- which((LiverLipidData$CV <= cutoff1) == TRUE)
CV_idx_50 <- which((LiverLipidData$CV <= cutoff2) == TRUE)
NewLipidData30 <- LiverLipidData[CV_idx_30,]
NewLipidData40 <- LiverLipidData[CV_idx_40,]
NewLipidData50 <- LiverLipidData[CV_idx_50,]
dim(NewLipidData30)
dim(NewLipidData40)
dim(NewLipidData50)

PlasmaLipidData = read.delim('Plasma_Final.txt', header = TRUE, sep = "\t")
CV_idx_30 <- which((PlasmaLipidData$CV <= cutoff0) == TRUE)
CV_idx_40 <- which((PlasmaLipidData$CV <= cutoff1) == TRUE)
CV_idx_50 <- which((PlasmaLipidData$CV <= cutoff2) == TRUE)
PlasmaNewLipidData30 <- PlasmaLipidData[CV_idx_30,]
PlasmaNewLipidData40 <- PlasmaLipidData[CV_idx_40,]
PlasmaNewLipidData50 <- PlasmaLipidData[CV_idx_50,]
dim(PlasmaNewLipidData30)
dim(PlasmaNewLipidData40)
dim(PlasmaNewLipidData50)
Lipid_Info <- data.frame(NewLipidData40$Class)
colnames(Lipid_Info) <- "Lipid"