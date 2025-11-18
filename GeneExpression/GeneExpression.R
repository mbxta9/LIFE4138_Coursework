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
#install.packages("tidyverse")
#install.packages("DT")
#install.packages("knitr")
library(tidyverse)
library(DT)
library(knitr)
library(ggrepel)
library(RColorBrewer)
library(plotly)


# Loading the datasets
a_vs_b <- read_tsv("Datasets/set_2/A_vs_B.deseq2.results.tsv")
a_vs_d <- read_tsv("Datasets/set_2/A_vs_D.deseq2.results.tsv")


# Generating summary statistics

## Number of significantly upregulated genes
find_sig_upreg <- function(dataset) {
    changed <- subset(dataset, log2FoldChange >= 0.5 & padj < 0.05)
    return(changed)
}
## Number of significantly downregulated genes
find_sig_downreg <- function(dataset) {
    changed <- subset(dataset, log2FoldChange <= -0.5 & padj < 0.05)
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
generate_summary <- function(dataset,column) {
    summary <- c(
        min(dataset[[column]],na.rm = TRUE),
        max(dataset[[column]],na.rm = TRUE),
        mean(dataset[[column]],na.rm = TRUE),
        median(dataset[[column]],na.rm = TRUE),
        quantile(dataset[[column]],0.25, na.rm = TRUE),
        quantile(dataset[[column]],0.75, na.rm = TRUE)
    )
    return(summary)
}

#A vs B table
stat_names = c('Min','Max','Mean','Median','Lower Quartile', 'Upper Quartile')
p_value <- generate_summary(a_vs_b,'pvalue')
log2fold <- generate_summary(a_vs_b,'log2FoldChange')
output_a_b <- data.frame(stat_names,p_value,log2fold)
kable(output_a_b, col.names=c("Statistic","P Value","Log2FoldChange"),caption = "Table 1: Summary statistics on the A vs B Dataset")

#A vs D table
p_value <- generate_summary(a_vs_d,'pvalue')
log2fold <- generate_summary(a_vs_d,'log2FoldChange')
output_a_d <- data.frame(stat_names,p_value,log2fold)
kable(output_a_d, col.names=c("Statistic","P Value","Log2FoldChange"),caption = "Table 1: Summary statistics on the A vs D Dataset")

#Volcano plot
#Creating a new column for colouring
a_vs_b$diffexpressed <- "NO"
a_vs_b$diffexpressed[a_vs_b$log2FoldChange >= 0.5 & a_vs_b$pvalue < 0.05] <- "UP"
a_vs_b$diffexpressed[a_vs_b$log2FoldChange <= -0.5 & a_vs_b$pvalue < 0.05] <- "DOWN"

#Creating the volcano plot
a_vs_b_volcano <- ggplot(data = a_vs_b, aes(x = log2FoldChange, y = -log10(pvalue), color = diffexpressed, text = gene_id)) +
    geom_point() +
    scale_color_manual(values = c("red", "grey", "blue"), labels = c('Downregulated', 'Not Significant', 'Upregulated')) +
    coord_cartesian(ylim = c(0, 20), xlim = c(-5, 5)) +
    labs(
        x = "Log 2 Fold Change",
        y = "-log10(pvalue)",
        title = "Volcano plot of A vs B",
        color = "Significance"
    ) +
    theme_light() +
    theme(plot.title = element_text(hjust = 0.5))
ggplotly(a_vs_b_volcano)

#Creating a new column for colouring
a_vs_d$diffexpressed <- "NO"
a_vs_d$diffexpressed[a_vs_d$log2FoldChange >= 0.5 & a_vs_d$pvalue < 0.05] <- "UP"
a_vs_d$diffexpressed[a_vs_d$log2FoldChange <= -0.5 & a_vs_d$pvalue < 0.05] <- "DOWN"

#Creating the volcano plot
a_vs_d_volcano <- ggplot(data = a_vs_d, aes(x = log2FoldChange, y = -log10(pvalue), color = diffexpressed, text = gene_id)) +
    geom_point() +
    scale_color_manual(values = c("red", "grey", "blue"), labels = c('Downregulated', 'Not Significant', 'Upregulated')) +
    coord_cartesian(ylim = c(0, 20), xlim = c(-10, 10)) +
    labs(
        x = "Log 2 Fold Change",
        y = "-log10(pvalue)",
        title = "Volcano plot of A vs D",
        color = "Significance"
    ) +
    theme_light() +
    theme(plot.title = element_text(hjust = 0.5))
ggplotly(a_vs_d_volcano)
