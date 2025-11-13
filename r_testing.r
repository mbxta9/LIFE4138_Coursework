# Question 1
df <- data.frame(
    People = c("Tahir", "Jiaan", "Caleb", "Layla", "Chris"),
    Height = c(160, 170, 185, 140, 160)
)
head(df)

# Question 2
my_vector <- seq(from = 1, to = 1000, by = 1)
my_matrix <- matrix(1:100, nrow = 10, ncol = 10)
my_dataframe <- data.frame(name = rep(c("a", "b"), each = 10), value = 21:40)
my_list <- list(my_vector, my_matrix, my_dataframe)

my_vector[4]
my_matrix[7, 4]
my_dataframe[10, "name"]
my_list[[1]][5]

# Question 3
# Method 1 - print
print(200:300)

# Method 2 - for loop
for (i in 200:300) {
    print(i)
}

# Method 3 - sapply
values <- 200:300
sapply(values, print)

# Question 4
animals <- c("tiger", "lion", "badger", "fox", "rabbit", "fish", "dog", "octopus")
animals <- replace(animals, c(6, 8), c("squirrel", "horse"))
animals

# Question 5
data(cars)
plot(cars, xlab = "Speed (mph)", ylab = "Stopping distance (ft)", main = "Scatterplot of car stopping distances vs speed")

# Question 6
library(dplyr)
data(starwars)
as.data.frame(head(arrange(starwars, desc(height)), 1))
as.data.frame(head(arrange(starwars, mass), 1))

# Question 7
library(dplyr)
data(storms)
head(unique(storms))
# Number of different storms
storms %>%
    distinct(name) %>%
    tally()

# Year with most storms
storms %>%
    distinct(name, year) %>%
    count(year) %>%
    arrange(desc(n)) %>%
    head(1)

# Highest Pressure
storms %>%
    select(name, year, pressure) %>%
    arrange(desc(pressure)) %>%
    head(1)

# Question 8
# Loading Requirements
library(tidyverse)
data(diamonds)

# Creating plot of relationship between carat and price
ggplot(aes(x = carat, y = price), data = diamonds) +
    geom_point(alpha = 0.25, colour = "blue") + # Creating scatterplot
    labs( # Adding labels to axis and title
        x = "Carat (Weight of Diamond)",
        y = "Price (Dollars)",
        title = "Scatterplot of relationship between Carat of diamonds and Price"
    ) +
    theme_light() + # Using Theme to centre title
    theme(plot.title = element_text(hjust = 0.5))

# Creating histogram of all prices
ggplot(aes(x = price), data = diamonds) +
    geom_histogram( # Creating Histogram
        binwidth = 500,
        colour = "black",
        fill = "blue"
    ) +
    labs( # Adding labels to axis and title
        x = "Price of Diamond (Dollars)",
        y = "Frequency",
        title = "Histogram of quantity of diamonds by price"
    ) +
    theme_light() + # Adjusting title to centre
    theme(plot.title = element_text(hjust = 0.5))

# Creating boxplot of diamond cut
ggplot(aes(x = cut, y = price), data = diamonds) +
    geom_boxplot( # Creating boxplot
        fill = "blue"
    ) +
    labs( # Adding axis labels and title
        x = "Cut of Diamond",
        y = "Price (Dollars)",
        title = "Boxplot of cut of diamond against price"
    ) +
    theme_light() + # Making title centred
    theme(plot.title = element_text(hjust = 0.5))

# Question 9
# Loading Requirements
library(dplyr)
data(diamonds)

# Find maximum and minimum prices
print(paste("Maximum price diamond: ", max(diamonds$price)))
print(paste("Minimum price diamond: ", min(diamonds$price)))

# Creating a price type column
diamonds <- diamonds %>%
    mutate(price_type = ifelse( # Create new column and pass in result of if else
        diamonds$price < 5000,
        "Low Price", # Result if True
        "High Price" # Result if False
    ))

# Question 10
# Function to convert diamond carat to grams or milligrams
carat_conversion <- function(carat, unit) {
    if (unit == "grams") { # Converts to grams
        return(carat * 0.2)
    } else if (unit == "milligrams") { # Converts to milligrams
        return(carat * 200)
    } else { # If no valid option selected
        return("Error: Choose a valid unit ('grams' or 'milligrams')")
    }
}
# Print the heaviest diamond (in grams)
print(paste("Heaviest Diamond weighs: ", carat_conversion(max(diamonds$carat), "grams"), " grams."))
