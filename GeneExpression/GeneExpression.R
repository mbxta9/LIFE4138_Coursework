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
#install.packages("ggrepel")
#install.packages("RColorBrewer")
#install.packages("plotly")
#install.packages("ggpubr")
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
    #Function to generate summary statistics on a dataset and a specific column.
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
summary_table <- function(dataset, name) {
    stat_names = c('Min','Max','Mean','Median','Lower Quartile', 'Upper Quartile') #Creates vector of stat names for table
    p_value <- generate_summary(dataset,'pvalue') #Generates stats for P value
    log2fold <- generate_summary(dataset,'log2FoldChange') #Generates stats for log2foldchange
    output <- data.frame(stat_names,p_value,log2fold) #Creates dataframe for outputting
    return(output)
}

kable(summary_table(a_vs_b), col.names=c("Statistic","P Value","Log2FoldChange"),caption = "Table 1: Summary statistics on the A vs B Dataset") #Shows table
kable(summary_table(a_vs_d), col.names=c("Statistic","P Value","Log2FoldChange"),caption = "Table 2: Summary statistics on the A vs D Dataset") #Shows table

#Volcano plot
#Creating a new column for colouring in A vs B
a_vs_b$diffexpressed <- "NO" #Creates new column and assigns NO to all values
a_vs_b$diffexpressed[a_vs_b$log2FoldChange >= 1 & a_vs_b$padj < 0.05] <- "UP" #Calculates if sig. up reg. then assigns up
a_vs_b$diffexpressed[a_vs_b$log2FoldChange <= -1 & a_vs_b$padj < 0.05] <- "DOWN" #Calculates if sig. down reg. then assigns down

#Creating a new column for colouring in A vs D
a_vs_d$diffexpressed <- "NO" #Creates new column and assigns NO to all values
a_vs_d$diffexpressed[a_vs_d$log2FoldChange >= 1 & a_vs_d$padj < 0.05] <- "UP" #Calculates if sig. up reg. then assigns up
a_vs_d$diffexpressed[a_vs_d$log2FoldChange <= 1 & a_vs_d$padj < 0.05] <- "DOWN" #Calculates if sig. down reg. then assigns down

#Function for volcano plot
create_volcano <- function(dataset, name, x_crop_values, y_crop_values) {
    volcano <- ggplot(data = dataset, aes(
        x = log2FoldChange, 
        y = -log10(padj), 
        color = diffexpressed, 
        text = gene_id)) + #colours by diffexpressed and adds text to each point for plotly
        geom_point() +
        scale_color_manual(values = c("blue", "grey", "red"), labels = c('Downregulated', 'Not Significant', 'Upregulated')) + #Creates colour scheme based on labels
        coord_cartesian(ylim = y_crop_values, xlim = x_crop_values) + #Crops the graph
        labs( #Adds labels
            x = "Log 2 Fold Change",
            y = "-log10(P Adjusted Value)",
            title = paste("Volcano plot of ", name),
            color = "Significance"
        ) +
        theme_light() +
        theme(plot.title = element_text(hjust = 0.5)) #Centres title

}

ggplotly(create_volcano(a_vs_b,"A vs B",c(-5,5),c(0,15)))
ggplotly(create_volcano(a_vs_d,"A vs D",c(-10,10),c(0,20)))

#Function for MA plot
create_ma <- function(dataset, name, y_crop_values) {
    ma_plot <- ggmaplot(data = dataset) + #Creates an MA plot
    coord_cartesian(ylim = y_crop_values) + #Crops graph
    labs( #Adds labels
        x = "Log2 Mean Expression",
        y = "Log 2 Fold Change",
        title = paste("MA plot of ",name),
        color = "Significance"
    ) +
    theme_light() +
    theme(plot.title = element_text(hjust = 0.5)) 
}

#Drawing the MA plots
ggplotly(create_ma(a_vs_b, "A vs B", c(-10,10)))
ggplotly(create_ma(a_vs_d, "A vs D", c(-10,10)))

#Function to make a histogram
create_histogram <- function(dataset, name) {
    histogram_plot <- ggplot(aes(x = pvalue), data = dataset) +  #Creates histogram
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
        title = paste("Histogram of P value in ", name)  
    ) + 
    theme_light() + 
    theme(plot.title = element_text(hjust = 0.5)) #Centres title
}

ggplotly(create_histogram(a_vs_b, "A vs B")) #Calls function to draw graph
ggplotly(create_histogram(a_vs_d, "A vs D")) #Calls function to draw graph

#Heatmap
top_from_A_vs_B <- a_vs_b %>%
    arrange(padj) %>%
    slice_head(n = 20) #Arrange by padj and take top 20

top_from_A_vs_D <- a_vs_d %>%
    arrange(padj) %>%
    slice_head(n = 20) #Arrange by padj and take top 20

top_gene_rows <- bind_rows(top_from_A_vs_B, top_from_A_vs_D) #Create combined list of top genes

top_gene_list <- unique(top_gene_rows$gene_id) #Create list of only unique genes to use as a filter

heat_ab_common <- a_vs_b %>%
    filter(gene_id %in% top_gene_list) %>% #Select only genes from top 20
    select(gene_id,log2FoldChange) %>% #Take gene name and change
    mutate(Name = "A vs B") #Add new column of Name

heat_ad_common <- a_vs_d %>%
    filter(gene_id %in% top_gene_list) %>% #Select only genes from top 20
    select(gene_id,log2FoldChange) %>% #Take gene name and change
    mutate(Name = "A vs D") #Add new column of Name

heatmap_data_common <- bind_rows(heat_ab_common,heat_ad_common) #Combine to create top 40 list with values from both AvsB and AvsD

heatmap_plot_common <- ggplot(heatmap_data_common, aes( #Creates the plot
    x = Name, #Comparison of datasets
    y = gene_id, #Gene list on y axis
    fill = log2FoldChange #Colours heatmap based on expression
)) +
geom_tile() +
scale_fill_viridis_c(option = "D", name = "log2FoldChange") + #Chooses colours for map
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

ggplotly(heatmap_plot_common)

#Function to create file of significant genes
create_sig_file <- function(data,name) {
    dir.create(file.path("Outputs"), showWarnings = FALSE) #Creates folder to keep files tidy

    sig_out <- bind_rows(
    find_sig_upreg(data) %>% mutate(Regulation = "Upregulated"), #Adds regulation label
    find_sig_downreg(data) %>% mutate(Regulation = "Downregulated") #Adds regulation label
) %>%
    select(gene_id, log2FoldChange, pvalue, padj, Regulation) #Gets only columns needed for output

    dir.create(file.path("Outputs"), showWarnings = FALSE) #Creates folder to keep files tidy
    write_csv(sig_out, paste0("Outputs/Sig_",name,".csv")) #Saves full list to file
}

#Creating the files
create_sig_file(a_vs_b,"A_vs_B")
create_sig_file(a_vs_d,"A_vs_D")


#Function to make a significant genes top 25 table
sig_table <- function(dataset) {
    sig_table <- bind_rows( #Creates dataframe of combined top 25
    find_sig_upreg(dataset) %>%
        arrange(padj) %>% #Sort by lowest padj
        slice_head(n = 25) %>% #Take top 25
        mutate(Regulation = "Upregulated"), #Add new column to show regulation

    find_sig_downreg(dataset) %>%
        arrange(padj) %>% #Sort by lowest padj
        slice_head(n = 25) %>% #Take top 25
        mutate(Regulation = "Downregulated") #Add new column to show regulation
) %>%
    select(gene_id, log2FoldChange, pvalue, padj, Regulation) #Gets all columns needed for output
    return(sig_table)
}

#Showing the tables
datatable(sig_table(a_vs_b), rownames = FALSE, caption = "Table 3: Top 25 upregulated and top 25 downregulated genes in A vs B") #Shows output nicely
datatable(sig_table(a_vs_d), rownames = FALSE, caption = "Table 4: Top 25 upregulated and top 25 downregulated genes in A vs D") #Shows output nicely