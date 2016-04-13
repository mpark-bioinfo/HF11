# Comaprison between Lipid classes
# Bar chart for each class between tissues
# Extract only CV <= 50% 
#LiverLipidData = read.delim('Liver_Final.txt', header = TRUE, sep = "\t")

cutoff0 <- 30
cutoff1 <- 40
cutoff2 <- 50

CV_idx_30 <- which((SCN$CV <= cutoff0) == TRUE)
CV_idx_40 <- which((SCN$CV <= cutoff1) == TRUE)
CV_idx_50 <- which((SCN$CV <= cutoff2) == TRUE)
NewSCNLipidData30 <- SCN[CV_idx_30,]
NewSCNLipidData40 <- SCN[CV_idx_40,]
NewSCNLipidData50 <- SCN[CV_idx_50,]
dim(NewSCNLipidData30)
dim(NewSCNLipidData40)
dim(NewSCNLipidData50)

CV_idx_30 <- which((Liver$CV <= cutoff0) == TRUE)
CV_idx_40 <- which((Liver$CV <= cutoff1) == TRUE)
CV_idx_50 <- which((Liver$CV <= cutoff2) == TRUE)
NewLipidData30 <- Liver[CV_idx_30,]
NewLipidData40 <- Liver[CV_idx_40,]
NewLipidData50 <- Liver[CV_idx_50,]
dim(NewLipidData30)
dim(NewLipidData40)
dim(NewLipidData50)

PlasmaLipidData = read.delim('Plasma_Final.txt', header = TRUE, sep = "\t")
CV_idx_30 <- which((Plasma$CV <= cutoff0) == TRUE)
CV_idx_40 <- which((Plasma$CV <= cutoff1) == TRUE)
CV_idx_50 <- which((Plasma$CV <= cutoff2) == TRUE)
PlasmaNewLipidData30 <- Plasma[CV_idx_30,]
PlasmaNewLipidData40 <- Plasma[CV_idx_40,]
PlasmaNewLipidData50 <- Plasma[CV_idx_50,]
dim(PlasmaNewLipidData30)
dim(PlasmaNewLipidData40)
dim(PlasmaNewLipidData50)
Lipid_Info <- data.frame(NewLipidData40$Class)
colnames(Lipid_Info) <- "Lipid"