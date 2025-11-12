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