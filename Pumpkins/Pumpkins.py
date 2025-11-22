#!/usr/bin/env python3

'''
==================================================================================================================================================

Script: Pumpkins.py
Author: Tahir Ansari
Created: 14-11-2025

Description: A python script to run analysis on the pumpkins dataset available in the github repo: https://github.com/mbxta9/LIFE4138_Coursework

==================================================================================================================================================
'''

#Importing requirements
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np
import os

def import_dataset(path :str)-> pd.DataFrame: 
    '''
    Function to import a csv dataset from its filepath or url
    Checks to see if 
    Arguments:
    path: Takes a string of a url or filepath of a csv file to import.

    Returns:
    dataset - returns a pandas dataframe
    '''
    if path.lower().endswith('.csv') == False: #Error if not .csv file
        print("File is not a csv file")
        quit() #Prevents script running if not valid file
    try:
        dataset = pd.read_csv(path) #Imports the dataset
        print('Dataset imported successfully!')
        return dataset
    except FileNotFoundError: #Error if file doesnt exist
        print("File not found, please enter a valid path")
        quit() #Prevents script running if not valid file
    except pd.errors.EmptyDataError: #Error if file empty
        print("The provided file is empty.")
        quit() #Prevents script running if not valid file
    except pd.errors.ParserError: #Error if not in csv format inside
        print("Please check if this in .csv format") #Prevents script running if not valid file
    except Exception as e: #Any other error
        print(f"Unknown error: {e}")
        quit() #Prevents script running if not valid file
    return None

def check_empty(dataframe: pd.DataFrame):
    '''
    Function to check if any of the columns used are completely empty and stops the program.
    Empty columns will cause errors in the graphs, so stops code running unnecesarily.
    '''

    required_cols = [ #List of all needed columns for script
        "weight_lbs",
        "est_weight",
        "country",
        "variety",
        "city",
        "state_prov",
        "id"
    ]
    missing_cols = [] #Creates empty list for checks
    empty_cols = [] #Creates empty list for checks

    for col in required_cols: 
        if col not in dataframe.columns: #Checks if each required col is in data
            missing_cols.append(col)
        elif dataframe[col].isna().all() or len(dataframe[col]) == 0: #Checks if all NAs in the col
            empty_cols.append(col)
    
    if len(missing_cols) > 0 or len(empty_cols) > 0: #Quits and shows what cols are missing or empty
        print(f"Missing required columns: {missing_cols}\nEmpty columns: {empty_cols}")
        quit()
    return None


def find_highest(dataframe: pd.DataFrame,column: str):
    '''
    Function to get the row information of the highest value in a column

    Arguments:
    dataframe: the dataframe to search through
    column: the column to search through for the highest value
    '''
    if (isinstance(dataframe, pd.DataFrame)) == False: #Checks if a dataframe
        print(f"First argument must be a pandas dataframe")
        return None
    try:
        highest_row = dataframe.loc[dataframe[column].idxmax()] #Find row with max value of column
        return highest_row
    except KeyError: #Error if column not in dataframe
        print(f"{column} does not exist in the dataframe")
    except NameError: #Error if not valid variable
        print('Please provide a valid variable')
    except AttributeError: #Error if not str
        print('Please enter a valid argument type')
    return None

def lbs_to_kg(value: float|int) -> float:
    '''
    Function to convert a value in lbs to kg
    Takes a column input of values in lbs

    Arguments:
    value: a value to be converted

    Returns: new value as a float
    '''
    try:
        return ((float(value))/2.20462) #return converted value
    except ValueError: #Error if not a number
        print("Please enter a valid number")
        return None
    except TypeError: #Error if no value provided
        print("Please pass a number into the function")
        return None
    

def main():
    '''
    Main script to run analysis on pumpkins dataset
    '''

    #Importing dataset
    pumpkins = import_dataset('pumpkins_datasets/pumpkins_02.csv')

    #Checking for all needed values
    check_empty(pumpkins)

    #Finding heaviest pumpkin
    heaviest_pumpkin = find_highest(pumpkins,'weight_lbs')
    print(f"The heaviest pumpkin was a {heaviest_pumpkin['variety']} from {heaviest_pumpkin['city']}, {heaviest_pumpkin['state_prov']}, {heaviest_pumpkin['country']}. It weighed {round(heaviest_pumpkin['weight_lbs'],2)}lbs and was grown in the year {heaviest_pumpkin['id']}")

    #Create a column of weight in kg
    pumpkins[f"weight_in_kg"] = [(lbs_to_kg(i)) for i in pumpkins['weight_lbs']] #Creates new column using values by calling conversion function in list

    #Creates an outputs folder for the script results
    os.makedirs("outputs", exist_ok=True)


    #Create a weight class column
    classes = []
    for i in pumpkins['weight_in_kg']:
        if i<250: #Light weight class if weight <250
            classes.append('light')
        elif i<500: #Medium weight class if weight >250 but <500
            classes.append('medium')
        elif i>500: #Heavy weight class if weight >500
            classes.append('heavy')
        else:
            classes.append(np.nan) #Return NaN if not a valid number
    pumpkins["weight_class"] = classes #Create new column from classes list

    #Plot Estimated weight against actual weight in kgs
    pumpkins[f"est_weight_kg"] = [(lbs_to_kg(i)) for i in pumpkins['est_weight']] #Create new column of estimted weight in kg
    
    figure_1 = sns.scatterplot(data = pumpkins, x = 'est_weight_kg', y = 'weight_in_kg', hue = 'weight_class', palette='colorblind') #Creates a new figure to draw graph on
    figure_1.figure.set_size_inches(10,6)
    figure_1.figure.tight_layout(rect=[0, 0.05, 0.85, 0.95]) #Creates whitespace at top and bottom of graph
    figure_1.set_title('Estimated Pumpkin Weight vs Actual Pumpkin Weight') #Adding title and axis labels
    figure_1.legend(title = 'Weight Class', bbox_to_anchor=(1.05, 1), loc=2, borderaxespad=0.)
    figure_1.set_xlabel('Estimated Weight (kg)') #Adding x axis label
    figure_1.set_ylabel('Actual Weight (kg)'); #Adding y axis label
    figure_1.figure.text(
    0.5, #Adjusts caption
    0.02, #adjusts caption
    "A Scatterplot of the relationship between the estimated weight and the actual weight, in kilograms, of pumpkins from the pumpkin competitions dataset. \nThe different colours of plot represent the weight class of each point.", 
    ha = 'center', 
    fontsize = 9)

    figure_2 = plt.figure() #Creates a second figure to draw graph on
    plot_area_2 = figure_2.add_subplot() #Creates a new plotting area inside figure_2 to make axes
    plot_area_2.scatter(x = pumpkins['est_weight'],y = pumpkins['weight_lbs'],alpha = 0.25, color = 'red') #Creating the graph in lbs for checking
    plot_area_2.set_title('Estimated Pumpkin Weight vs Actual Pumpkin Weight') #Adding title and axis labels
    plot_area_2.set_xlabel('Estimated Weight (lbs)') #Adding x axis label
    plot_area_2.set_ylabel('Actual Weight (lbs)'); #Adding y axis label

    figure_1.figure.savefig("outputs/pumpkins_weight_relationship.png", dpi = 300) #Saves the first figure to disk.
    #plt.show() #Shows the figures when ran from terminal

    #Subsetting 3 countries and saving as csv
    filter_vars = [country in ['United Kingdom', 'Japan', 'Italy'] for country in pumpkins['country']] #Checks if country in list, creates list of true and false values
    filtered_pumpkins = pumpkins[filter_vars] #Creates list by adding the row if filter_vars returns True
    filtered_pumpkins.to_csv('outputs/pumpkins_filtered.csv') #Saves the filtered data to disk

    #Summarising filtered data
    print(f"Mean pumpkin weight per country: \n{filtered_pumpkins.groupby('country')['weight_in_kg'].mean()}") #Groups by country and filters to only weight and calculates mean
    mean_variety_country = filtered_pumpkins.groupby(['country','variety'])['weight_in_kg'].mean() #Groups by country and variety to calculate mean
    print(f"Mean weights of pumpkin by variety and country: \n {mean_variety_country}") 
    lowest_mean_row = mean_variety_country.idxmin() #Gets lowest row (country, variety)
    lowest_mean_value = mean_variety_country.min() #Gets lowest mean weight value
    print(f"The lowest mean weight in kg was {lowest_mean_row[1]} from {lowest_mean_row[0]}, weighing {round(lowest_mean_value,2)}kg.")

    #Weight distribution boxplot
    figure_3 = plt.figure(figsize=(8,6)) #Creates a new figure
    plot_area_3 = figure_3.add_subplot() #Creates new plotting area in figure
    filtered_pumpkins.boxplot(column = 'weight_in_kg', by = 'country', ax = plot_area_3)
    plt.suptitle("") #Removes pandas title so I can add my own
    figure_3.subplots_adjust(bottom=0.18) #Adds space at bottom for caption
    plot_area_3.set_title("Boxplot of Weight distribution by country")
    plot_area_3.set_xlabel('Country')
    plot_area_3.set_ylabel('Pumpkin Weight (kg)')
    figure_3.text(
    0.5, #Adjusts position of caption
    0.02, #Adjusts caption position
    "A boxplot showing the distribution of pumpkin weight of three countries from the filtered pumpkin competitions dataset.", 
    ha = 'center', 
    fontsize = 9)
    figure_3.savefig("outputs/filtered_boxplot.png", bbox_inches='tight', dpi = 300) #Saves the third figure (boxplot) to disk.

    #Facetplot previous graph
    facetplot = sns.catplot( #have to use catplot as boxplot has no facetting
        data = filtered_pumpkins, #Chooses filtered dataset
        x = 'variety', #Chooses axis for data
        y = 'weight_in_kg', #Chooses axis for data
        col = 'country',
        kind = 'box',
        hue = 'variety', #Creates coloured subplots based on variety
        palette = 'colorblind' #Changes palette to be *colourblind friendly*
    )
    facetplot.set_xticklabels(rotation=90)
    facetplot.figure.tight_layout(rect=[0, 0.05, 1, 0.95]) #Creates whitespace at top and bottom of graph
    facetplot.figure.set_size_inches(17,8)
    facetplot.set_axis_labels("Variety","Pumpkin Weight (kg)") #Names x and y axis
    facetplot.figure.suptitle("Boxplot of Pumpkin Weight by Variety and Country", y=0.98) #Adds main figure title
    facetplot.set_titles("{col_name}") #Gives each sub plot title
    facetplot.figure.text(
        0.5, #Adjusts caption
        0.02, #adjusts caption
        "A boxplot showing distribution of pumpkin weight by variety and country from the filtered pumpkin competitions dataset.", 
        ha = 'center', 
        fontsize = 9) #Saves facetplot to disk. to disk. Increased dpi to improve readability.
    #bbox_inches reduces whitespace making it easier to read
    plt.show() #Displays all the created figures.
    facetplot.figure.savefig("outputs/filtered_facet_boxplot.png",bbox_inches='tight', dpi = 300) #Saves facetplot to disk. to disk. Increased dpi to improve readability.
    #bbox_inches reduces whitespace making it easier to read

if __name__ == '__main__': #Ensures script runs
    main()