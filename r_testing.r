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
values
sapply(values, print)

# Question 4
animals <- c("tiger", "lion", "badger", "fox", "rabbit", "fish", "dog", "octopus")
animals <- replace(animals, c(6, 8), c("squirrel", "horse"))
animals

# Question 5
data(cars)
plot(cars, xlab = "Speed (mph)", ylab = "Stopping distance (ft)", main = "Scatterplot of car stopping distances vs speed")

# Question 6
install.packages("dplyr")
library(dplyr)
data(starwars)
head(arrange(starwars, desc(height)), 1)

data(storms)
uniquestorms <- unique(storms$name)
uniquestorms %>% count(year)

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
