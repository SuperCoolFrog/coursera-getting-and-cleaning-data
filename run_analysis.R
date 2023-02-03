# cls <- function() { shell("cls")}
# setwd("C:\\r-projects\\sandbox\\UCI HAR Dataset")
library(dplyr)
library(tidyr)
library(stringr)
library(readr)

#------------------------------------
#   Helpers
#------------------------------------
parse_x_data_file <- function(x_data_file) {
    tmp <- tempfile(fileext = ".csv")

    # read as char to clean up variable number of whitespaces
    data_char <- readChar(x_data_file, file.info(x_data_file)$size)
    data_char <- str_replace_all(data_char, "[ ]+", ",")

    # Much faster to save file and read.csv rather than parse string manually
    writeChar(data_char, tmp)

    suppressWarnings({
        # Expected warning is displayed.  First column is all null
        x <- read.csv(tmp, header = FALSE) # 7352 rows
    })
    # remove temp file
    unlink(tmp)

    # File starts with whitespace which leads to empty first column
    as_tibble(x[, -1])
}

parse_y_data_file <- function(y_data_file) {
    y_train_csv <- read.csv(y_data_file, header = FALSE, sep = " ")
    y_data <- as_tibble(y_train_csv)
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
    # left_join sorts automatically but this should not cause issues
    left_join(labels, xy_data, by = "y")
}


#------------------------------------
#   Activity Labels
#------------------------------------
# This only needs to be done once so I did not create helper functions

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

x_train_clean <- parse_x_data_file("./train/X_train.txt")

#------------------------------------
#   Y Train Data
#------------------------------------

y_train_clean <- parse_y_data_file("./train/Y_train.txt")

#------------------------------------
#   Tidy Train
#------------------------------------
tidy_train_data <- join_labels_x_y(activity_labels, x_train_clean, y_train_clean)
