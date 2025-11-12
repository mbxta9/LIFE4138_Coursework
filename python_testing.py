#Question 1
import pandas as pd #Loading Requirements

data = { #Creating data for pandas dataframe
    "Name": ["Tahir", "Jiaan", "Layla", "Caleb", "Chris"],
    "Age": [22,21,21,22,26]
}

age_data_frame = pd.DataFrame(data) #Creating dataframe
print(age_data_frame) #Printing dataframe to workbook

#Question 2
int_list = [i for i in range(1,11)] #Creating list of integers 1-10
print(int_list[3]) #Printing 4th item of list

letters_tuple = ("A","B","C","D","E","F","G") #Creating a tuple of letters
print(letters_tuple) #Printing the tuple

dna_dict = { #Creating a dictionary of DNA bases and their count
    "A": 200,
    "T": 300,
    "C": 400,
    "G": 100
}
print(dna_dict) #Printing dna bases dictionary

float_lists = [[i, i+0.25, i+0.5] for i in range (1,30,3)] #Creates list of lists each with 3 numbers ranging to 30
print(float_lists[5][2]) #Print 3rd value in 6th list (16.5)

float_array = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9] #Create array of floats
print(float_array[:4]) #Print only first 4 values of array

data = { #Generates data for golf holes and score accumulated
    "Hole": [i for i in range(1,19)],
    "Score": [i+1 for i in range(1,19)]
}
golf_data_frame = pd.DataFrame(data) #Creates pandas dataframe with golf data
print(golf_data_frame[8:9]) #Print only the 9th row