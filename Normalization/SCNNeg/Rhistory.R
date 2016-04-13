# Below is your R command history : 
InitDataObjects("pktable", "stat", FALSE)
Read.TextData("SCN_Neg.csv", "colu", "disc");
SanityCheckData();
RemoveMissingPercent(percent=0.5)
ImputeVar(method="knn")
IsSmallSmplSize();
SaveTransformedData()
