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
import numpy as np
import matplotlib.pyplot as plt

def import_dataset(path :str): 
    '''
    Function to import a csv dataset from its filepath or url
    Checks to see if 
    Arguments:
    path: Takes a string of a url or filepath of a csv file to import.

    Returns:
    dataset - returns a pandas dataframe
    '''
    try:
        dataset = pd.read_csv(path)
        print('Dataset imported successfully!')
        return dataset
    except FileNotFoundError:
        print("File not found, please enter a valid path")


def find_highest(dataframe: pd,column: str):
    '''
    Function to get the row information of the highest value in a column

    Arguments:
    dataframe: the dataframe to search through
    column: the column to search through for the highest value
    '''
    try:
        highest_row = dataframe.loc[dataframe[column].idxmax()]
        return highest_row
    except KeyError:
        print("Please use a valid column name")
    except NameError:
        print('Please provide a valid variable')
    except AttributeError:
        print('Please enter a valid argument type')

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
    except:
        print("Please enter a valid value")

def main():
    '''
    Main script to run analysis on pumpkins dataset
    '''

    #Importing dataset
    pumpkins = import_dataset('Pumpkins/pumpkins_datasets/pumpkins_02.csv')

    #Finding heaviest pumpkin
    heaviest_pumpkin = find_highest(pumpkins,'weight_lbs')
    print(f"The heaviest pumpkin was a {heaviest_pumpkin['variety']} from {heaviest_pumpkin['city']}, {heaviest_pumpkin['state_prov']}, {heaviest_pumpkin['country']}. It weighed {round(heaviest_pumpkin['weight_lbs'],2)}lbs and was grown in the year {heaviest_pumpkin['id']}")

    #Create a column of weight in kg
    pumpkins[f"weight_in_kg"] = [(lbs_to_kg(i)) for i in pumpkins['weight_lbs']] #Creates new column using values by calling conversion function in list


    #Create a weight class column
    classes = []
    for i in pumpkins['weight_in_kg']:
        if i<250: #Light weight class if weight <250
            classes.append('light')
        elif i<500: #Medium weight class if weight >250 but <500
            classes.append('medium')
        else: #Heavy weight class if weight >500
            classes.append('heavy')
    pumpkins["weight_class"] = classes #Create new column from classes list

    #Plot Estimated weight against actual weight in kgs
    pumpkins[f"est_weight_kg"] = [(lbs_to_kg(i)) for i in pumpkins['est_weight']] #Create new column of estimted weight in kg
    print(pumpkins[['est_weight_kg','est_weight']])
    
    figure_1 = plt.figure() #Creates a new figure to draw graph on
    plot_area_1 = figure_1.add_subplot() #Creates a new plotting area inside figure_1 to make axes
    plot_area_1.scatter(x = pumpkins['est_weight_kg'],y = pumpkins['weight_in_kg'],alpha = 0.25, color = 'blue') #Creating the relationship graph
    plot_area_1.set_title('Estimated Pumpkin Weight vs Actual Pumpkin Weight') #Adding title and axis labels
    plot_area_1.set_xlabel('Estimated Weight (kg)') #Adding x axis label
    plot_area_1.set_ylabel('Actual Weight (kg)'); #Adding y axis label
    figure_1.show()

    figure_2 = plt.figure() #Creates a second figure to draw graph on
    plot_area_2 = figure_2.add_subplot() #Creates a new plotting area inside figure_2 to make axes
    plot_area_2.scatter(x = pumpkins['est_weight'],y = pumpkins['weight_lbs'],alpha = 0.25, color = 'red') #Creating the graph in lbs for checking
    plot_area_2.set_title('Estimated Pumpkin Weight vs Actual Pumpkin Weight') #Adding title and axis labels
    plot_area_2.set_xlabel('Estimated Weight (lbs)') #Adding x axis label
    plot_area_2.set_ylabel('Actual Weight (lbs)'); #Adding y axis label
    figure_2.show()

    figure_1.savefig("pumpkins_weight_relationship.png")
    print('figure saved')
if __name__ == '__main__': #Ensures script runs
    main()