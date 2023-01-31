# cls <- function() { shell("cls")}
# setwd("C:\\r-projects\\sandbox\\UCI HAR Dataset")
library(dplyr)
library(tidyr)
library(stringr)
library(readr)

#------------------------------------
#   Helpers
#------------------------------------
parse_x_data_file <- function(x_data_f) {
    # Remove extra white space
    x_data_trimd <- sapply(x_data_f, str_trim)

    # split values into separate columns
    x_data_split <- str_split(x_data_trimd, " ", simplify = TRUE)

    # rename columns so I can use as_tibble
    colnames(x_data_split) <- sapply(1:ncol(x_data_split), function(c) {
        paste("x", c, sep = "")
    })

    # make tibble so I can mutate characters to numbers
    x_data_char_vecs <- as_tibble(x_data_split)
    
    # returns table with numeric values
    x_data_char_vecs %>% mutate_if(is.character, parse_number)
}

parse_y_data_file <- function(y_data_f) {
    y_data <- as_tibble(y_data_f)
    # rename column to y so I can easily left join
    colnames(y_data) <- c("y")
    
    # returns y data
    y_data
}

join_labels_x_y <- function(labels, x_data, y_data) {
    # combine the y and x values
    xy_data <- cbind(y_data, x_data) %>%
        as_tibble() 

    # y_data is thekey found in activity_labels
    left_join(labels, xy_data, by = "y")
}


#------------------------------------
#   Activity Labels
#------------------------------------

# Get the labels
activity_labels_f <- read.csv("activity_labels.txt", header = FALSE) # 6 rows
colnames(activity_labels_f) <- c("activitylabels")

# Clean the labels
## trim extra space
activity_labels_trimd <- sapply(activity_labels_f$activitylabels, str_trim)
## split out id and label
activity_labels_split <- str_split_fixed(activity_labels_trimd, " ", 2)
colnames(activity_labels_split) <- c("y", "label") # label y so that I can left join

# The working matrix with id as number and label as char
activity_labels <- as_tibble(activity_labels_split) %>% mutate(y = parse_number(y), label = label)

#------------------------------------
#   X Train Data
#------------------------------------

x_train_f <- read.csv("./train/X_train.txt", header = FALSE, sep = "\n") # 7352 rows
x_train_clean <- parse_x_data_file(x_train_f)

#------------------------------------
#   Y Train Data
#------------------------------------

y_train_f <- read.csv("./train/Y_train.txt", header = FALSE, sep = " ")
y_train_clean <- parse_y_data_file(y_train_f)

#------------------------------------
#   Tidy Train
#------------------------------------
tidy_train_data <- join_labels_x_y(activity_labels, x_train_clean, y_train_clean)
