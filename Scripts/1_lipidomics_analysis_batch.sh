Rscript 0_CV_Cutoff.R ../Normalization/SCNPos/SCNPos_imputed.csv ../Final_Analysis_050516/
Rscript 0_CV_Cutoff.R ../Normalization/SCNNeg/SCNNeg_imputed.csv ../Final_Analysis_050516/
Rscript 0_CV_Cutoff.R ../Normalization/LiverPos/LiverPos_imputed.csv ../Final_Analysis_050516/
Rscript 0_CV_Cutoff.R ../Normalization/LiverNeg/LiverNeg_imputed.csv ../Final_Analysis_050516/
Rscript 0_CV_Cutoff.R ../Normalization/PlasmaPos/PlasmaPos_imputed.csv ../Final_Analysis_050516/
Rscript 0_CV_Cutoff.R ../Normalization/PlasmaNeg/PlasmaNeg_imputed.csv ../Final_Analysis_050516/

Rscript 1_Normalize_RawData.R ../Final_Analysis_050516/SCNPos_CV30.csv ../Normalization/SCN_SampleInfo.csv ../Final_Analysis_050516/
Rscript 1_Normalize_RawData.R ../Final_Analysis_050516/SCNNeg_CV30.csv ../Normalization/SCN_SampleInfo.csv ../Final_Analysis_050516/
Rscript 1_Normalize_RawData.R ../Final_Analysis_050516/LiverPos_CV30.csv ../Normalization/Liver_SampleInfo.csv ../Final_Analysis_050516/
Rscript 1_Normalize_RawData.R ../Final_Analysis_050516/LiverNeg_CV30.csv ../Normalization/Liver_SampleInfo.csv ../Final_Analysis_050516/
Rscript 1_Normalize_RawData.R ../Final_Analysis_050516/PlasmaPos_CV30.csv ../Normalization/Plasma_SampleInfo.csv ../Final_Analysis_050516/
Rscript 1_Normalize_RawData.R ../Final_Analysis_050516/PlasmaNeg_CV30.csv ../Normalization/Plasma_SampleInfo.csv ../Final_Analysis_050516/

Rscript 2_SeparateLipidName.R ../Final_Analysis_050516/SCNPos_normalized.csv ../Final_Analysis_050516/
Rscript 2_SeparateLipidName.R ../Final_Analysis_050516/SCNNeg_normalized.csv ../Final_Analysis_050516/
Rscript 2_SeparateLipidName.R ../Final_Analysis_050516/LiverPos_normalized.csv ../Final_Analysis_050516/
Rscript 2_SeparateLipidName.R ../Final_Analysis_050516/LiverNeg_normalized.csv ../Final_Analysis_050516/
Rscript 2_SeparateLipidName.R ../Final_Analysis_050516/PlasmaPos_normalized.csv ../Final_Analysis_050516/
Rscript 2_SeparateLipidName.R ../Final_Analysis_050516/PlasmaNeg_normalized.csv ../Final_Analysis_050516/

Rscript 3_RemoveDuplicateLipids.R ../Final_Analysis_050516/SCNPos_Lipid.csv ../Final_Analysis_050516/
Rscript 3_RemoveDuplicateLipids.R ../Final_Analysis_050516/SCNNeg_Lipid.csv ../Final_Analysis_050516/
Rscript 3_RemoveDuplicateLipids.R ../Final_Analysis_050516/LiverPos_Lipid.csv ../Final_Analysis_050516/
Rscript 3_RemoveDuplicateLipids.R ../Final_Analysis_050516/LiverNeg_Lipid.csv ../Final_Analysis_050516/
Rscript 3_RemoveDuplicateLipids.R ../Final_Analysis_050516/PlasmaPos_Lipid.csv ../Final_Analysis_050516/
Rscript 3_RemoveDuplicateLipids.R ../Final_Analysis_050516/PlasmaNeg_Lipid.csv ../Final_Analysis_050516/

Rscript 4_ExtractRelavantClass.R ../Final_Analysis_050516/SCNPos_nonRedundant.csv ../Final_Analysis_050516/SCNNeg_nonRedundant.csv ../Final_Analysis_050516/SCN
Rscript 4_ExtractRelavantClass.R ../Final_Analysis_050516/LiverPos_nonRedundant.csv ../Final_Analysis_050516/LiverNeg_nonRedundant.csv ../Final_Analysis_050516/Liver
Rscript 4_ExtractRelavantClass.R ../Final_Analysis_050516/PlasmaPos_nonRedundant.csv ../Final_Analysis_050516/PlasmaNeg_nonRedundant.csv ../Final_Analysis_050516/Plasma

Rscript 5_RemoveOddChain.R ../Final_Analysis_050516/SCN_combined.csv ../Final_Analysis_050516/
Rscript 5_RemoveOddChain.R ../Final_Analysis_050516/Liver_combined.csv ../Final_Analysis_050516/
Rscript 5_RemoveOddChain.R ../Final_Analysis_050516/Plasma_combined.csv ../Final_Analysis_050516/

Rscript 6_Grouping_by_Strains.R ../Final_Analysis_050516/SCN_Final.csv ../Final_Analysis_050516/Final_SCN/
Rscript 6_Grouping_by_Strains.R ../Final_Analysis_050516/Liver_Final.csv ../Final_Analysis_050516/Final_Liver/
Rscript 6_Grouping_by_Strains.R ../Final_Analysis_050516/Plasma_Final.csv ../Final_Analysis_050516/Final_Plasma/
