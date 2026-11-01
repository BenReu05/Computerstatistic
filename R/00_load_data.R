library(here)
file_path <- here("data", "raw", "diabetic_data.csv")

diabetes <- read.csv(file_path,
                     stringsAsFactors = FALSE,
                     na.strings = c("NA", "", "?"))

# Inspect the dataset
dim(diabetes)
head(diabetes)
str(diabetes)
View(diabetes)
