# cls <- function() { shell("cls")}
# setwd("C:\\r-projects\\sandbox\\UCI HAR Dataset")
library(dplyr)
library(tidyr)
library(stringr)
library(readr)

# Get the labels
features_f <- read.csv("features.txt", header = FALSE) # 6 rows



#NEED TO remove NA from X_TRAIN_F column data