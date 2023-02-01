library(readr)
library(dplyr)
library(tidyr)

x <- read.csv("./train/X_train.txt", header = FALSE, sep = " ") # 7352 rows

# r <- unclass(x[1, !is.na(r)])

# r2 <- r[!is.na(r)] 

x_clean <- list()

# for (row_idx in 1: nrow(x))
for (row_idx in 1: 1000) {
    x_row <- x[row_idx,]
    nu_row <- unlist(x_row[!is.na(x_row)])
    x_clean <- rbind(x_clean, nu_row)
    # print(paste("Row", row_idx, "complete"))
}


x2 <- as_tibble(x_clean) %>% mutate_all(function(c) { c[[1]] })
dim(x2)
