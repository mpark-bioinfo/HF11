Rscript 0_CV_Cutoff.R ../Normalization/SCNPos/SCNPos_imputed.csv ../Normalization/
Rscript 0_CV_Cutoff.R ../Normalization/SCNNeg/SCNNeg_imputed.csv ../Normalization/
Rscript 0_CV_Cutoff.R ../Normalization/LiverPos/LiverPos_imputed.csv ../Normalization/
Rscript 0_CV_Cutoff.R ../Normalization/LiverNeg/LiverNeg_imputed.csv ../Normalization/
Rscript 0_CV_Cutoff.R ../Normalization/PlasmaPos/PlasmaPos_imputed.csv ../Normalization/
Rscript 0_CV_Cutoff.R ../Normalization/PlasmaNeg/PlasmaNeg_imputed.csv ../Normalization/

Rscript 1_Normalize_RawData.R ../Normalization/SCNPos_CV30.csv ../Normalization/SCN_SampleInfo.csv ../Normalization/
Rscript 1_Normalize_RawData.R ../Normalization/SCNNeg_CV30.csv ../Normalization/SCN_SampleInfo.csv ../Normalization/
Rscript 1_Normalize_RawData.R ../Normalization/LiverPos_CV30.csv ../Normalization/Liver_SampleInfo.csv ../Normalization/
Rscript 1_Normalize_RawData.R ../Normalization/LiverNeg_CV30.csv ../Normalization/Liver_SampleInfo.csv ../Normalization/
Rscript 1_Normalize_RawData.R ../Normalization/PlasmaPos_CV30.csv ../Normalization/Plasma_SampleInfo.csv ../Normalization/
Rscript 1_Normalize_RawData.R ../Normalization/PlasmaNeg_CV30.csv ../Normalization/Plasma_SampleInfo.csv ../Normalization/

Rscript 2_SeparateLipidName.R ../Normalization/SCNPos_normalized.csv ../Normalization/
Rscript 2_SeparateLipidName.R ../Normalization/SCNNeg_normalized.csv ../Normalization/
Rscript 2_SeparateLipidName.R ../Normalization/LiverPos_normalized.csv ../Normalization/
Rscript 2_SeparateLipidName.R ../Normalization/LiverNeg_normalized.csv ../Normalization/
Rscript 2_SeparateLipidName.R ../Normalization/PlasmaPos_normalized.csv ../Normalization/
Rscript 2_SeparateLipidName.R ../Normalization/PlasmaNeg_normalized.csv ../Normalization/

Rscript 3_RemoveDuplicateLipids.R ../Normalization/SCNPos_Lipid.csv ../Normalization/
Rscript 3_RemoveDuplicateLipids.R ../Normalization/SCNNeg_Lipid.csv ../Normalization/
Rscript 3_RemoveDuplicateLipids.R ../Normalization/LiverPos_Lipid.csv ../Normalization/
Rscript 3_RemoveDuplicateLipids.R ../Normalization/LiverNeg_Lipid.csv ../Normalization/
Rscript 3_RemoveDuplicateLipids.R ../Normalization/PlasmaPos_Lipid.csv ../Normalization/
Rscript 3_RemoveDuplicateLipids.R ../Normalization/PlasmaNeg_Lipid.csv ../Normalization/

Rscript 4_ExtractRelavantClass.R ../Normalization/SCNPos_nonRedundant.csv ../Normalization/SCNNeg_nonRedundant.csv ../Normalization/SCN
Rscript 4_ExtractRelavantClass.R ../Normalization/LiverPos_nonRedundant.csv ../Normalization/LiverNeg_nonRedundant.csv ../Normalization/Liver
Rscript 4_ExtractRelavantClass.R ../Normalization/PlasmaPos_nonRedundant.csv ../Normalization/PlasmaNeg_nonRedundant.csv ../Normalization/Plasma

Rscript 5_RemoveOddChain.R ../Normalization/SCN_combined.csv ../Normalization/
Rscript 5_RemoveOddChain.R ../Normalization/Liver_combined.csv ../Normalization/
Rscript 5_RemoveOddChain.R ../Normalization/Plasma_combined.csv ../Normalization/
