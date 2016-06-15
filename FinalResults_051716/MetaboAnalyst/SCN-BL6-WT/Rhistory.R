# Below is your R command history : 
InitDataObjects("conc", "stat", FALSE)
Read.TextData("SCN_WT_BL6.csv", "colu", "disc");
SanityCheckData();
ReplaceMin();
IsSmallSmplSize();
Normalization("NULL", "LogNorm", "AutoNorm", "Ctrl-BL6-2249", ratio=FALSE, ratioNum=20)
FC.Anal.unpaired(2.0, 0)
FC.Anal.unpaired(1.5, 1)
Ttests.Anal(F, 0.05, FALSE, TRUE)
Ttests.Anal(T, 0.05, FALSE, TRUE)
PLSR.Anal()
PlotPLS2DScore("pls_score2d_0_", "png", 72, width=NA, 1,2,0.95,1,0)
PlotPLSLoading("pls_loading_0_", "png", 72, width=NA, 1, 2,"scatter", 1);
GetMinGroupSize();
PLSDA.CV("L",4, "Q2")
PlotPLS.Imp("pls_imp_0_", "png", 72, width=NA, "vip", "Comp. 1", 15,FALSE)
PlotHeatMap("heatmap_0_", "png", 72, width=NA, "euclidean", "ward.D","bwm", "overview", T, T, NA, T)
PlotSubHeatMap("heatmap_1_", "png", 72, width=NA, "euclidean", "ward.D","bwm", "tanova", 25, "overview", F, T, T)
SaveTransformedData()
