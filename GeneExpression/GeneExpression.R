#!/usr/bin/Rscript

####################################################################
#                                                                  #
#        Title: Gene Expression R Script                           #
#                                                                  #
#        Author: Tahir Ansari                                      #
#        Date: 18 Nov 2025                                         #
#                                                                  #
#        Description: My script for the gene expression            #
#                     practical portion of coursework              #
#                                                                  #
####################################################################


# Installing necessary packages
# install.packages("tidyverse")
#install.packages("DT")
library(tidyverse)
library(DT)
library(knitr)


# Loading the datasets
a_vs_b <- read_tsv("Datasets/set_2/A_vs_B.deseq2.results.tsv")
a_vs_d <- read_tsv("Datasets/set_2/A_vs_D.deseq2.results.tsv")


# Generating summary statistics

## Number of significantly upregulated genes
find_sig_upreg <- function(dataset) {
    changed <- subset(dataset, log2FoldChange >= 1 & padj < 0.05)
    return(changed)
}
## Number of significantly downregulated genes
find_sig_downreg <- function(dataset) {
    changed <- subset(dataset, log2FoldChange <= -1 & padj < 0.05)
    return(changed)
}

sig_a_b_up <- find_sig_upreg(a_vs_b)
sig_a_b_down <- find_sig_downreg(a_vs_b)
sig_a_d_up <- find_sig_upreg(a_vs_d)
sig_a_d_down <- find_sig_downreg(a_vs_d)

up_down <- data.frame(Dataset_Name=c('A vs B','A vs D'),
    Upregulated_genes=c(nrow(sig_a_b_up), nrow(sig_a_d_up)),
    Downregulated_genes = c(nrow(sig_a_b_down), nrow(sig_a_d_down)))
kable(up_down)

summary_variables <- c('mean','median','min','max')
p_value <- c(mean(a_vs_b[["pvalue"],rm.NA = True]),median(a_vs_b[["pvalue"]],rm.NA = True))

mean(a_vs_b[["pvalue"]],rm.NA=TRUE)
print(a_vs_b[["pvalue"]])
output_a_b <- data.frame(summary_variables,p_value)
kable(output_a_b)
