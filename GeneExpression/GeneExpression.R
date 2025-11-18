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

#Table of summary stats
stat_names = c('Min','Max','Mean','Median','Lower Quartile', 'Upper Quartile')
p_value <- c(
    min(a_vs_b[["pvalue"]],na.rm = TRUE),
    max(a_vs_b[["pvalue"]],na.rm = TRUE),
    mean(a_vs_b[["pvalue"]],na.rm = TRUE),
    median(a_vs_b[["pvalue"]],na.rm = TRUE),
    quantile(a_vs_b[["pvalue"]],0.25, na.rm = TRUE),
    quantile(a_vs_b[["pvalue"]],0.75, na.rm = TRUE)
    )
log2fold <- c(
    min(a_vs_b[["log2FoldChange"]],na.rm = TRUE),
    max(a_vs_b[["log2FoldChange"]],na.rm = TRUE),
    mean(a_vs_b[["log2FoldChange"]],na.rm = TRUE),
    median(a_vs_b[["log2FoldChange"]],na.rm = TRUE),
    quantile(a_vs_b[["log2FoldChange"]],0.25, na.rm = TRUE),
    quantile(a_vs_b[["log2FoldChange"]],0.75, na.rm = TRUE)
    )
output_a_b <- data.frame(stat_names, p_value, log2fold)
kable(output_a_b)