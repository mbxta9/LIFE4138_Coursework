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
