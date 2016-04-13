# Below is your R command history : 
InitDataObjects("pktable", "stat", FALSE)
Read.TextData("Liver_Neg.csv", "colu", "disc");
SanityCheckData();
RemoveMissingPercent(percent=0.5)
ImputeVar(method="knn")
IsSmallSmplSize();
SaveTransformedData()
