'''
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

#Question 3
#for loop
for i in range(200,301):
    print(i)

#while loop
i = 200
while i <=300:
    print(i)
    i+=1

#list loop
nums = [i for i in range(200,301)]
for num in nums: print(num)

#Question 4
# Replace elements in this list
animals = ["tiger", "lion", "badger", "fox", "rabbit", "fish", "dog", "octopus"]

#Tasks 1-3
animals[5] = "horse" #Replace element 5 with horse
animals.append("badger") #Add badger to end of list
animals[animals.index("octopus")] = "squirrel" #Replace octopus with squirrel by finding its index first
print(animals) 

#Question 5
#Loading Requirements
import pandas as pd
import matplotlib.pyplot as plt
mtcars = "https://raw.githubusercontent.com/Apress/mastering-ml-w-python-in-six-steps/refs/heads/master/Chapter_2_Code/Data/mtcars.csv"
cars = pd.read_csv(mtcars)

#Creating plot
plt.scatter(x = cars['hp'],y = cars['mpg'], color = 'blue') #Plots data
plt.title("Car horsepower against mpg") #Adding labels
plt.xlabel("Horsepower (hp)")
plt.ylabel("Miles per Gallon (mpg)")
plt.grid(True, alpha = 0.25) #Adds grid in background
plt.show()

#Question 6
#Importing Requirements
import pandas as pd
starwars_dataset="https://www.fabricionarcizo.com/post/starwars/updated_starwars.csv"
starwars = pd.read_csv(starwars_dataset)

#Find tallest height (Yarael Poof)
most_tall = starwars.sort_values(by = 'height', ascending=False).head(1)
print(most_tall)

#Find the lowest mass (Ratts Tyerell)
lowest_mass = starwars.sort_values(by='mass', ascending=True).head(1)
print(lowest_mass)


#Question 7
#Loading requirements. 
import pandas as pd
import seaborn as sns
life_expectancy = sns.load_dataset('healthexp')

#Unique number of countries
#print(f"Unique number of countries: {life_expectancy['Country'].nunique()}")

#Country and year with highest life expectancy
highest_life = life_expectancy.loc[life_expectancy['Life_Expectancy'].idxmax()] #Gets the row with highest Life Expectancy
print(f"Country with the highest life expectancy was: {highest_life['Country']} in the year {highest_life['Year']}")

#Calculate year with the highest total expenditure
highest_expenditure = life_expectancy.groupby('Year')['Spending_USD'].sum().idxmax()
print(f"The year with the highest total expenditure was: {highest_expenditure}")

#Question 8
#Loading requirements
import seaborn as sns
import matplotlib.pyplot as plt
diamonds = sns.load_dataset('diamonds')

#Carat vs Price Scatterplot
plt.scatter(x=diamonds['carat'],y=diamonds['price'], color = 'blue',alpha=0.25)
plt.title("Scatterplot of relationship between Carat of diamonds and Price")
plt.xlabel("Carat (Weight of diamond)")
plt.ylabel("Price (Dollars)")
plt.grid(True, linestyle = '--', alpha = 0.1) #Adds grid in background
plt.tight_layout()
plt.show()

#Histogram of prices
plt.hist(x=diamonds['price'], color = 'blue')
plt.title("Histogram of quantity of diamonds by price")
plt.xlabel("Price (Dollars)")
plt.ylabel("Frequency")
plt.grid(True, linestyle = '--', alpha = 0.1) #Adds grid in background
plt.tight_layout()
plt.show()

#Boxplot of cut vs price
diamonds.boxplot(column = 'price', by = 'cut', color = 'blue')
plt.title("Boxplot of cut of diamond against price")
plt.xlabel("Cut of Diamond")
plt.ylabel("Price (Dollars)")
plt.grid(True, linestyle = '--', alpha = 0.1) #Adds grid in background
plt.tight_layout()
plt.show()

#Question 9
#Loading requirements
import seaborn as sns
diamonds = sns.load_dataset('diamonds')

#Find max and minimum diamond price
print(f"The highest priced diamond is: {diamonds['price'].max()}")
print(f"The lowest priced diamond is: {diamonds['price'].min()}")
'''

#Question 10
#SOLUTION IF SEPERATE PARTS
#Importing Requirements
import seaborn as sns
diamonds = sns.load_dataset('diamonds')


def carat_conversion(carat:float, unit:str):
    '''
    Function to convert a carat value to either grams or milligrams.
    Takes a carat as a float or integer and unit as a string either 'grams' or 'milligrams'.
    '''
    try: #Tries conversion
        if unit =='grams':
            return(carat*0.2)
        elif unit == 'milligrams':
            return(carat*200)
        else: #Error handling
            return("Error: Choose a valid unit ('grams' or 'milligrams')") 
    except: #Exception to account for invalid characters
        print(f"Please enter a valid carat value")
    
print(carat_conversion(200,'grams'))

#SOLUTION IF ONE FUNCTION
#Importing requirements
import seaborn as sns
diamonds = sns.load_dataset('diamonds')

def carat_conversion_max(dataset,unit: str):
    '''
    Function to convert the carat column in a dataset to grams or milligrams.
    Takes a dataset as a dataframe and unit as either 'grams' or 'milligrams'.
    '''
    mass = []
    if unit.lower() =='grams': #Adds all converted weights to list
        for i in dataset['carat']:
            mass.append(i*0.2)
    elif unit.lower() =='milligrams':
        for i in dataset['carat']:
            mass.append(i*200)
    else:
        return("Error: Choose a valid unit ('grams' or 'milligrams')") #Error Handling
    dataset[f"weight_in_{unit}"] = mass #Adds new column of weights to dataframe
    print(f"Heaviest diamond weighs: {diamonds[f"weight_in_{unit}"].max()} {unit}") #Finds heaviest diamond from new column

carat_conversion_max(diamonds,'grams') #Calling functionn