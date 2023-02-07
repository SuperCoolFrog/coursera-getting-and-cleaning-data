library(dplyr)
library(tidyr)
library(stringr)
library(readr)

#------------------------------------
#   Helpers
#------------------------------------
join_labels_x_y <- function(features_labels, y_labels, x_data, y_data) {
    # need to keep id with feature name so that it remains unique
    unique_labels <- paste(features_labels[,1], features_labels[,2], sep = "__")
    colnames(x_data) <- unique_labels

    # combine the y and x values
    xy_data <- cbind(y_data, x_data) %>%
        as_tibble() 

    # y_data is thekey found in activity_labels
    # left_join sorts automatically but this should not cause issues
    left_join(y_labels, xy_data, by = "y")
}


#------------------------------------
#   Activity Labels
#------------------------------------
# This only needs to be done once so I did not create helper functions

# Get the labels
activity_labels <- read.table("./data/activity_labels.txt", header = FALSE) # 6 rows
colnames(activity_labels) <- c("y", "label") # label y so that I can left join

#------------------------------------
#   Features
#------------------------------------
features_f <- read.table("./data/features.txt", header = FALSE, sep = " ")

#------------------------------------
#   X Train Data
#------------------------------------

x_train_clean <- read.table("./data/train/X_train.txt", header = FALSE)

#------------------------------------
#   Y Train Data
#------------------------------------

y_train_clean <- read.table("./data/train/Y_train.txt", header = FALSE)
colnames(y_train_clean) <- c("y")

#------------------------------------
#   Tidy Train
#------------------------------------
tidy_train_data <- join_labels_x_y(features_f, activity_labels, x_train_clean, y_train_clean)

#------------------------------------
#   X Test Data
#------------------------------------

x_test_clean <- read.table("./data/test/X_test.txt", header = FALSE)

#------------------------------------
#   Y Test Data
#------------------------------------

y_test_clean <- read.table("./data/test/Y_test.txt", header = FALSE)
colnames(y_test_clean) <- c("y")

#------------------------------------
#   Tidy Test
#------------------------------------
tidy_test_data <- join_labels_x_y(features_f, activity_labels, x_test_clean, y_test_clean)


#------------------------------------
#   Get label, mean, and std
#   Add reference column
#   Combine training and data
#------------------------------------

tidy_train_data_mean_std <- tidy_train_data %>%
    select(label | contains("std") | (contains("mean") & !contains("meanFreq"))) %>%
    mutate(type = "training", .after = label)

tidy_test_data_mean_std <- tidy_test_data %>%
    select(label | contains("std") | (contains("mean") & !contains("meanFreq"))) %>%
    mutate(type = "test", .after = label)

all_data <- bind_rows(tidy_train_data_mean_std, tidy_test_data_mean_std)


#------------------------------------
# Calculate means for type, label, variables
#------------------------------------
tidy_data <- all_data %>% group_by(type, label) %>% summarize_all("mean")

write.table(tidy_data, "out/tidy_data.txt", row.name = FALSE)
