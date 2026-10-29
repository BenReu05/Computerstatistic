
file_path <- "https://raw.githubusercontent.com/BenReu05/Computerstatistic/main/diabetes.csv"

diabetes <- read.csv(file_path,
                     stringsAsFactors = FALSE,
                     na.strings = c("NA", ""))

# Inspect the dataset
dim(diabetes)
head(diabetes)
str(diabetes)
