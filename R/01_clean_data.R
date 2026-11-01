library(readr)
library(here)
file_path <- here("data", "raw", "diabetic_data.csv")


raw_df <- read_csv(file_path,
                   na = c("?", "NA", ""),
                   stringsAsFactors = FALSE)


clean_diabetes_data <- function(df) {
  
  #remove deceased patients (as they can´t be readmitted...)
  df <- df[!df$discharge_disposition_id %in% c(11, 19, 20, 21), ]
  
  # drop weight and payer id column
  df$weight <- NULL
  df$payer_code <- NULL
  
  #add Missing 
  df$medical_specialty[is.na(df$medical_specialty)] <- "Missing"
  df$medical_specialty <- factor(df$medical_specialty)
  
  #remove rows with missing race or diag1 entry
  df <- df[!is.na(df$race) & !is.na(df$diag_1), ]
  
  
  #binary outcome
  df$readmitted_30d <- factor(
    ifelse(df$readmitted == "<30", 1L, 0L),
    levels = c(0, 1),
    labels = c("No", "Yes")
  )
  
  #recode diag2 and diag3 NAs to "None"
  df$diag_2[is.na(df$diag_2)] <- "None"
  df$diag_3[is.na(df$diag_3)] <- "None"
  
  df$A1Cresult <- factor(df$A1Cresult, levels = c("None", "Norm", ">7", ">8"))
  # gives the HbA1c Test result. (>8 signifies highly uncontrolled blood sugar)
  
  df$change    <- factor(df$change,    levels = c("No", "Ch"))
  #change in medication 
  
  df$race      <- factor(df$race)
  df$gender    <- factor(df$gender)
  df$age       <- factor(df$age)
  
  #only the first encounter for each unique patient_nbr
  df <- df[!duplicated(df$patient_nbr), ]
  
  message("Original rows: 101766 | Cleaned rows: ", nrow(df))
  return(df)
}

clean_df <-clean_diabetes_data(raw_df)
saveRDS(clean_df, here("data", "processed", "diabetic_data_clean.rds"))
message("Cleaned data successfully saved to data/processed/")