install.packages("rJava")
install.packages('minerva')
install.packages('quantmod')

library(ggplot2)
library(reshape2)
library(corrplot)
library(Hmisc)
library(minerva)
library(quantmod)

source("MINE.r")
df = read.csv('../Normalization/Final_SCN/SCN_db_BKS.csv', header = TRUE, sep = ",")
lipid.df <- t(df[,2:9])

# Standard scaling
log2.lipid.df <- log2(lipid.df)
log2.scaled.df <- t(scale(log2.lipid.df, center = TRUE, scale = TRUE))
new_df <- data.frame('Sample'=df$Sample,log2.scaled.df)
mine.results <- MINE(new_df,"all.pairs")

#install.packages('ggplot2')
#install.packages('corrplot')
#install.packages('Hmisc')

#setwd("~/Documents/Lipidomics_Analysis/HF11/Scripts")

#args = commandArgs(TRUE)
#print(args[1])

LipidData = read.csv('../Normalization/Final_Plasma/Plasma_WT_BL6.csv', header = TRUE,row.names=1)
#LipidData = read.csv(args[1], header = TRUE,row.names=1)
transposed <- t(LipidData)

# Compute correlation table
mine(x,y)

