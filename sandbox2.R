library(readr)
library(dplyr)
library(tidyr)
library(profvis)
library(data.table)
library(stringr)

fileName <- "./train/X_train.txt"

mystring <- readChar(fileName, file.info(fileName)$size)
mystring <- str_replace_all(mystring, "  ", ",")
mystring <- str_replace_all(mystring, " ", ",")

writeChar(mystring, "x2.csv")


x <- read.csv("x2.csv", header = FALSE) # 7352 rows
# Expected warning is displayed.  First column is all null

x_clean <- as_tibble(x[, -1])

print(dim(x_clean))
