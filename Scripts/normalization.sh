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
