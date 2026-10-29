
file_path <- "/Users/ben/Library/CloudStorage/OneDrive-Persönlich/Ben/TU Wien/Semester5/compstat/diabetes+130-us+hospitals+for+years+1999-2008/diabetic_data.csv"


diabetes <- read.csv(file_path,
                     stringsAsFactors = FALSE,
                     na.strings = c("NA", ""))

# Inspect the dataset
dim(diabetes)
head(diabetes)
str(diabetes)
