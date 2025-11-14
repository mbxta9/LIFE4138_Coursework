#!/usr/bin/env python3

#Importing requirements
import pandas as pd

#Importing student dataset

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

def convert_weight_column_to_kg(dataframe: pd,column='weight'):
    '''
    Function to create a new column of weight values in kg in a dataframe
    Takes a column input of values in lbs

    Arguments:
    dataframe: the dataframe to add column to
    column: the column of lbs values.

    Returns: original dataframe with new column 'weight_in_kg'
    '''
    try:
        dataframe[f"weight_in_kg"] = [(i/2.20462) for i in dataframe[column]] #Create new column based on list of weight using lbs to kg equation
        return dataframe #return dataframe if needed to assign to variable
    except KeyError:
        print("Please use a valid column name")
        



def main():
    '''
    Main script to run analysis on pumpkins dataset
    '''

    #Importing dataset
    pumpkins = import_dataset('Coursework/Pumpkins/pumpkins_datasets/pumpkins_02.csv')

    #Finding heaviest pumpkin
    heaviest_pumpkin = find_highest(pumpkins,'weight_lbs')
    print(f"The heaviest pumpkin was a {heaviest_pumpkin['variety']} from {heaviest_pumpkin['city']}, {heaviest_pumpkin['state_prov']}, {heaviest_pumpkin['country']}. It weighed {round(heaviest_pumpkin['weight_lbs'],2)}lbs and was grown in the year {heaviest_pumpkin['id']}")

    #Create a column of weight in kg
    convert_weight_column_to_kg(pumpkins, 'weight_lbs')
    print(pumpkins)
if __name__ == '__main__': #Ensures script runs
    main()