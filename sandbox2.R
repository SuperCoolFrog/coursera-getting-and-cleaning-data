library(readr)
library(dplyr)
library(tidyr)
library(profvis)
library(data.table)
library(stringr)

fileName <- "./train/X_train.txt"
tmp <- tempfile(fileext = ".csv")

mystring <- readChar(fileName, file.info(fileName)$size)
mystring <- str_replace_all(mystring, "[ ]+", ",")
# mystring <- str_replace_all(mystring, " ", ",")

writeChar(mystring, tmp)

suppressWarnings({
    # Expected warning is displayed.  First column is all null
    x <- read.csv(tmp, header = FALSE) # 7352 rows
})
x_clean <- as_tibble(x[, -1])

print(dim(x_clean))
unlink(tmp)
