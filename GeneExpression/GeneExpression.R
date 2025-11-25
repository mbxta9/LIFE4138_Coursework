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
library(DT) #For interactive tables
library(knitr) #For table viewing
library(ggrepel)
library(RColorBrewer) #For colouring on graphs
library(plotly) #For interactive graphs
library(ggpubr) #For MA plots


# Loading the datasets
a_vs_b <- read_tsv("Datasets/set_2/A_vs_B.deseq2.results.tsv")
a_vs_d <- read_tsv("Datasets/set_2/A_vs_D.deseq2.results.tsv")


# Generating summary statistics

## Number of significantly upregulated genes
find_sig_upreg <- function(dataset) {
    #Function to take a dataframe of Deseq2 results and return a new dataframe
    #Calculates upregulated genes based on the threshold of log2fold change >= 1
    #and adjusted p value < 0.05
    changed <- subset(dataset, log2FoldChange >= 1 & padj < 0.05)
    return(changed)
}
## Number of significantly downregulated genes
find_sig_downreg <- function(dataset) {
    #Function to take a dataframe of Deseq2 results and return a new dataframe
    #Calculates downregulated genes based on the threshold of log2fold change <= -1
    #and adjusted p value < 0.05
    changed <- subset(dataset, log2FoldChange <= -1 & padj < 0.05)
    return(changed)
}

a_vs_b$padj[is.na(a_vs_b$padj)] <- 1 #Replaces all NAs in P adjusted value with 1 to show no significance
a_vs_d$padj[is.na(a_vs_b$padj)] <- 1 #Replaces all NAs in P adjusted value with 1 to show no significance

a_vs_b$log2FoldChange[is.na(a_vs_b$log2FoldChange)] <- 0 #Replaces all NAs in Log2FoldChange with 1 to show no significance
a_vs_d$log2FoldChange[is.na(a_vs_b$log2FoldChange)] <- 0 #Replaces all NAs in P Log2FoldChange with 1 to show no significance

#Using previous function to create dataframes of significant genes
sig_a_b_up <- find_sig_upreg(a_vs_b)
sig_a_b_down <- find_sig_downreg(a_vs_b)
sig_a_d_up <- find_sig_upreg(a_vs_d)
sig_a_d_down <- find_sig_downreg(a_vs_d)


#Dataframe to create a table of number of up and down regulated genes
up_down <- data.frame(Dataset_Name=c('A vs B','A vs D'),
    Upregulated_genes=c(nrow(sig_a_b_up), nrow(sig_a_d_up)), #Num of upregulated
    Downregulated_genes = c(nrow(sig_a_b_down), nrow(sig_a_d_down))) #Num of downregulated
kable(up_down) #Shows table

#Table of summary stats
generate_summary <- function(dataset,column) {
    summary <- c( #Creates vector of values
        min(dataset[[column]],na.rm = TRUE), #Min value
        max(dataset[[column]],na.rm = TRUE), #Max value
        mean(dataset[[column]],na.rm = TRUE), #Mean
        median(dataset[[column]],na.rm = TRUE), #Median
        quantile(dataset[[column]],0.25, na.rm = TRUE), #First Quartile
        quantile(dataset[[column]],0.75, na.rm = TRUE) #Third Quartile
    )
    return(summary) #Returns vector of stats
}

#A vs B table
stat_names = c('Min','Max','Mean','Median','Lower Quartile', 'Upper Quartile') #Creates vector of stat names for table
p_value <- generate_summary(a_vs_b,'pvalue') #Generates the summary stats on the p value column
log2fold <- generate_summary(a_vs_b,'log2FoldChange') #Generates the summary stats on the log2fold change column
output_a_b <- data.frame(stat_names,p_value,log2fold) #Creates a dataframe for outputting
kable(output_a_b, col.names=c("Statistic","P Value","Log2FoldChange"),caption = "Table 1: Summary statistics on the A vs B Dataset") #Shows Table

#A vs D table
p_value <- generate_summary(a_vs_d,'pvalue') #Generates stats for P value
log2fold <- generate_summary(a_vs_d,'log2FoldChange') #Generates stats for log2foldchange
output_a_d <- data.frame(stat_names,p_value,log2fold) #Creates dataframe for outputting
kable(output_a_d, col.names=c("Statistic","P Value","Log2FoldChange"),caption = "Table 1: Summary statistics on the A vs D Dataset") #Shows table

#Volcano plot
#Creating a new column for colouring in A vs B
a_vs_b$diffexpressed <- "NO" #Creates new column and assigns NO to all values
a_vs_b$diffexpressed[a_vs_b$log2FoldChange >= 1 & a_vs_b$padj < 0.05] <- "UP" #Calculates if sig. up reg. then assigns up
a_vs_b$diffexpressed[a_vs_b$log2FoldChange <= 1 & a_vs_b$padj < 0.05] <- "DOWN" #Calculates if sig. down reg. then assigns down

#Creating the volcano plot
a_vs_b_volcano <- ggplot(data = a_vs_b, aes(x = log2FoldChange, y = -log10(padj), color = diffexpressed, text = gene_id)) + #colours by diffexpressed and adds text to each point for plotly
    geom_point() +
    scale_color_manual(values = c("blue", "grey", "red"), labels = c('Downregulated', 'Not Significant', 'Upregulated')) + #Creates colour scheme based on labels
    coord_cartesian(ylim = c(0, 20), xlim = c(-5, 5)) + #Crops the graph
    labs( #Adds labels
        x = "Log 2 Fold Change",
        y = "-log10(P Adjusted Value)",
        title = "Volcano plot of A vs B",
        color = "Significance"
    ) +
    theme_light() +
    theme(plot.title = element_text(hjust = 0.5)) #Centres title
ggplotly(a_vs_b_volcano)

#Creating a new column for colouring in A vs D
a_vs_d$diffexpressed <- "NO" #Creates new column and assigns NO to all values
a_vs_d$diffexpressed[a_vs_d$log2FoldChange >= 1 & a_vs_d$padj < 0.05] <- "UP" #Calculates if sig. up reg. then assigns up
a_vs_d$diffexpressed[a_vs_d$log2FoldChange <= 1 & a_vs_d$padj < 0.05] <- "DOWN" #Calculates if sig. down reg. then assigns down

#Creating the volcano plot
a_vs_d_volcano <- ggplot(data = a_vs_d, aes(x = log2FoldChange, y = -log10(padj), color = diffexpressed, text = gene_id)) + #colours by diffexpressed and adds text to each point for plotly
    geom_point() +
    scale_color_manual(values = c("blue", "grey", "red"), labels = c('Downregulated', 'Not Significant', 'Upregulated')) + #Creates colour scheme based on labels
    coord_cartesian(ylim = c(0, 20), xlim = c(-10, 10)) + #Crops the graph
    labs(
        x = "Log 2 Fold Change",
        y = "-log10(P Adjusted Value)",
        title = "Volcano plot of A vs D",
        color = "Significance"
    ) +
    theme_light() +
    theme(plot.title = element_text(hjust = 0.5)) #Centres title
ggplotly(a_vs_d_volcano)


#MA PLOT
#A vs B
a_vs_b_MA <- ggmaplot(data = a_vs_b #Creates an MA plot
    )+
coord_cartesian(ylim = c(-10, 10)) + #Crops graph
labs( #Adds labels
    x = "Log2 Mean Expression",
    y = "Log 2 Fold Change",
    title = "MA plot of A vs B",
    color = "Significance"
) +
theme_light() +
theme(plot.title = element_text(hjust = 0.5)) #Centres title
ggplotly(a_vs_b_MA)

#A vs D
a_vs_d_MA <- ggmaplot(data = a_vs_d #Creates an MA plot
    )+
coord_cartesian(ylim = c(-10, 10)) + #Crops graph
labs( #Adding labels
    x = "Log2 Mean Expression",
    y = "Log 2 Fold Change",
    title = "MA plot of A vs D",
    color = "Significance"
) +
theme_light() +
theme(plot.title = element_text(hjust = 0.5)) #Centres title
ggplotly(a_vs_d_MA)


#Histogram of A vs B
a_vs_b_histogram <- ggplot(aes(x = pvalue), data = a_vs_b) +  #Creates histogram
    geom_histogram(
        binwidth = 0.1,
        colour = "black",
        fill = "blue",
        na.rm = TRUE #Removing any NAs to prevent errors
    ) +
    xlim(0, 1) + #Cropping along x axis
    ylim(0,1000) + #Cropping along y axis
    labs(
        x = "P value",
        y = "Frequency",
        title = "Histogram of P value in A vs B"  
    ) + 
    theme_light() + 
    theme(plot.title = element_text(hjust = 0.5)) #Centres title
ggplotly(a_vs_b_histogram)

#Histogram of A vs D
a_vs_d_histogram <- ggplot(aes(x = pvalue), data = a_vs_d) + #Creates histogram
    geom_histogram(
        binwidth = 0.1,
        colour = "black",
        fill = "blue",
        na.rm = TRUE #Removing any NAs to prevent errors
    ) +
    xlim(0, 1) + #Cropping along x axis
    ylim(0,1000) + #Cropping along y axis
    labs(
        x = "P value",
        y = "Frequency",
        title = "Histogram of P value in A vs D"  
    ) + 
    theme_light() + 
    theme(plot.title = element_text(hjust = 0.5)) #Centres title
ggplotly(a_vs_d_histogram)

#Heatmap
heat_ab <- a_vs_b %>%
    arrange(padj) %>%
    slice_head(n = 20) %>% #Arrange by adjusted p value and take only top 20
    select(gene_id,baseMean) %>%
    mutate(Name = "A_vs_B") #Add column called Name to kno which dataset its from

heat_ad <- a_vs_d %>%
    arrange(padj) %>%
    slice_head(n = 20) %>% #Arrange by adjusted p value and take only top 20
    select(gene_id,baseMean) %>%
    mutate(Name = "A_vs_D") #Add column called Name to kno which dataset its from

heatmap_data <- bind_rows(heat_ab, heat_ad) #Combine the two top 20 datasets
heatmap_data <- heatmap_data %>%
    complete(gene_id,Name, fill = list(baseMean = 0)) %>% #Fill blanks with 0 values
    mutate(log_expression = log10(baseMean + 1)) #Create new column with log adjusted values


heatmap_plot <- ggplot(heatmap_data, aes( #Creates the plot
    x = Name, #Comparison of datasets
    y = gene_id, #Gene list on y axis
    fill = log_expression #Colours heatmap based on expression
)) +
geom_tile() +
scale_fill_gradient(low="white", high="blue", name = "Log10(baseMean)") + #Chooses colours for map
labs(
    title = "Heatmap of expression of top 20 differentially expressed genes for A vs B and A vs D",
    x = "Dataset Comparison",
    y = "Gene ID"
)+
theme_minimal() +
theme(
    panel.grid = element_blank(), #Removes gridlines
    plot.title = element_text(hjust = 0.5, size = 11) #Centres title and makes it fit
)

ggplotly(heatmap_plot)

#Creating saved full list of A vs B
sig_a_b <- bind_rows(
    sig_a_b_up %>% mutate(Regulation = "Upregulated"), #Adds regulation label
    sig_a_b_down %>% mutate(Regulation = "Downregulated") #Adds regulation label
) %>%
    select(gene_id, log2FoldChange, pvalue, padj, Regulation) #Gets only columns needed for output


dir.create(file.path("Outputs"), showWarnings = FALSE) #Creates folder to keep files tidy

write_csv(sig_a_b, "Outputs/Sig_A_vs_B.csv") #Saves full list to file.

#Significance Table A vs B
sig_a_b <- bind_rows( #Creates dataframe of combined top 25
    sig_a_b_up %>%
        arrange(padj) %>% #Sort by lowest padj
        slice_head(n = 25) %>% #Take top 25
        mutate(Regulation = "Upregulated"), #Add new column to show regulation

    sig_a_b_down %>%
        arrange(padj) %>% #Sort by lowest padj
        slice_head(n = 25) %>% #Take top 25
        mutate(Regulation = "Downregulated") #Add new column to show regulation
) %>%
    select(gene_id, log2FoldChange, pvalue, padj, Regulation) #Gets all columns needed for output

datatable(sig_a_b, rownames = FALSE, caption = "Table 3: Top 25 upregulated and top 25 downregulated genes in A vs B") #Shows output nicely

#Creating saved full list of A vs D
sig_a_d <- bind_rows(
    sig_a_d_up %>% mutate(Regulation = "Upregulated"), #Adds regulation label
    sig_a_d_down %>% mutate(Regulation = "Downregulated") #Adds regulation label
) %>%
    select(gene_id, log2FoldChange, pvalue, padj, Regulation) #Gets only columns needed for output

dir.create(file.path("Outputs"), showWarnings = FALSE) #Creates folder to keep files tidy

write_csv(sig_a_d, "Outputs/Sig_A_vs_D.csv") #Saves full list to file

#Significance Table A vs D
sig_a_d <- bind_rows( #Creates dataframe of combined top 25
    sig_a_d_up %>%
        arrange(padj) %>% #Sort by lowest padj
        slice_head(n = 25) %>% #Take top 25
        mutate(Regulation = "Upregulated"), #Add new column to show regulation

    sig_a_d_down %>%
        arrange(padj) %>% #Sort by lowest padj
        slice_head(n = 25) %>% #Take top 25
        mutate(Regulation = "Downregulated") #Add new column to show regulation
) %>%
    select(gene_id, log2FoldChange, pvalue, padj, Regulation) #Gets all columns needed for output

datatable(sig_a_d, rownames = FALSE, caption = "Table 4: Top 25 upregulated and top 25 downregulated genes in A vs D") #Shows output nicely
