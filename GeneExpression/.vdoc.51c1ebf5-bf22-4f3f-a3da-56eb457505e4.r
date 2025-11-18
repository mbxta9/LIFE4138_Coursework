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
# Number of significantly upregulated genes
find_sig_changed <- function(dataset) {
    changed <- subset(dataset, log2FoldChange > 1 & padj < 0.05 | log2FoldChange < -1 & padj < 0.05)
    return(changed)
}
```
#
#
#
#| echo: true
library(DT)
sig_a_b <- find_sig_changed(a_vs_b)
sig_a_d <- find_sig_changed(a_vs_d)
#
#
#
#
