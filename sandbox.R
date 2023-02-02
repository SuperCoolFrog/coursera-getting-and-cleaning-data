library(readr)
library(dplyr)
library(tidyr)
library(profvis)
library(data.table)


x <- read.csv("./train/X_train.txt", header = FALSE, sep = " ") # 7352 rows

# r <- unclass(x[1, !is.na(r)])

# r2 <- r[!is.na(r)] 


# profvis({
 # x_clean <- list()
#    for (row_idx in 1: nrow(x))
    # for (row_idx in 1: 1000) { # took 6secs for 1000 records
    #     x_row <- x[row_idx,]
    #     nu_row <- unlist(x_row[!is.na(x_row)])
    #     x_clean <- rbind(x_clean, nu_row)
    #     # print(paste("Row", row_idx, "complete"))
    # }
# })

x_all <- list()
x_clean <- lapply(1:1000, function(row_idx) {
    x_row <- x[row_idx,]
    # nu_row <- unlist(x_row[!is.na(x_row)])
    nu_row <- as.list(x_row[!is.na(x_row)])
    names(nu_row) <- paste("x", seq_along(nu_row), sep = ".")
    nu_row
})

x_all <- rbindlist(x_clean)


# x2 <- as_tibble(x_clean) # %>% mutate_all(function(c) { c[[1]] })
# dim(x2)

x2 <- read.table("./train/X_train.txt", header = FALSE, sep = "  ")
