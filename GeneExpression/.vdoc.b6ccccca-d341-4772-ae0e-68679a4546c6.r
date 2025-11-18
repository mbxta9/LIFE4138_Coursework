#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#| echo: true
library(tidyverse)
a_vs_b <- read_tsv("Datasets/set_2/A_vs_B.deseq2.results.tsv")
a_vs_d <- read_tsv("Datasets/set_2/A_vs_D.deseq2.results.tsv")
#
#
#
#
#
#
#
#| echo: true
#Number of significantly upregulated genes
find_sig_upreg <- function(dataset) {
    changed <- subset(dataset, log2FoldChange >= 1 & padj <= 0.05)
    return(changed)
}
#Number of significantly downregulated genes
find_sig_downreg <- function(dataset) {
    changed <- subset(dataset, log2FoldChange =< -1 & padj <= 0.05)
    return(changed)
}
```
#
#
#
#| echo: true
library(DT)
sig_a_b_up <- find_sig_upreg(a_vs_b)
sig_a_b_down <- find_sig_downreg(a_vs_b)
sig_a_d_up <- find_sig_upreg(a_vs_d)
sig_a_d_down <- find_sig_downreg(a_vs_d)
```
#
#
#| echo: false
up_down <- data.frame(Dataset_Name=c('A vs B','A vs D'),
    Upregulated_genes=c(nrow(sig_a_b_up), nrow(sig_a_d_up)),
    Downregulated_genes = c(nrow(sig_a_b_down), nrow(sig_a_d_down)))
datatable(up_down)
```
#
#
#
