# cls <- function() { shell("cls")}
# setwd("C:\\r-projects\\sandbox\\UCI HAR Dataset")
library(dplyr)
library(tidyr)
library(stringr)
library(readr)

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

x_train_f <- read.csv("./train/X_train.txt", header = FALSE, sep = "\n") #7352 rows

x_train_trimd <- sapply(x_train_f, str_trim)
x_train_split <- str_split(x_train_trimd, " ", simplify = TRUE)
colnames(x_train_split) <- sapply(1:ncol(x_train_split), function(c) { paste("x", c, sep = "") })

x_train_char_vecs <- as_tibble(x_train_split)
x_train_num_vecs <- x_train_char_vecs %>% mutate_if(is.character, parse_number)

#------------------------------------
#   Y Train Data
#------------------------------------

y_train_f <- read.csv("./train/Y_train.txt", header = FALSE, sep = " ")
y_train <- as_tibble(y_train_f) # 7352 X 1
colnames(y_train) <- c("y")

#------------------------------------
#   Tidy Train
#------------------------------------
xy_data <- cbind(y_train, x_train_num_vecs) %>%
    as_tibble() 

# y_train is the key found in activity_labels
tidy_train_data <- left_join(activity_labels, xy_data, by = "y")
