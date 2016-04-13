# Below is your R command history : 
InitDataObjects("pktable", "stat", FALSE)
Read.TextData("Plasma_Neg.csv", "colu", "disc");
SanityCheckData();
RemoveMissingPercent(percent=0.5)
ImputeVar(method="knn")
IsSmallSmplSize();
SaveTransformedData()
