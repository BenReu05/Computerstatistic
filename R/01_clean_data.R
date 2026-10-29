# R/01_clean_data.R

library(readr)
library(dplyr)
library(forcats)

clean_diabetes_data <- function(raw_data_path = "data/raw/diabetic_data.csv") {
  
  # 1. Ingest data and convert '?' placeholders to standard NA
  raw_df <- read_csv(raw_data_path, na = c("?", "NA", ""), show_col_types = FALSE)
  
  cleaned_df <- raw_df |>
    # 2. Exclude target leakage: deceased or hospice discharge
    filter(!discharge_disposition_id %in% c(11, 19, 20, 21)) |>
    
    # 3. Column-level omission: drop features with excessive missingness/noise
    select(-weight, -payer_code) |>
    
    # 4. Handle informative missingness in medical_specialty
    mutate(
      medical_specialty = if_else(is.na(medical_specialty), "Missing", medical_specialty),
      medical_specialty = factor(medical_specialty)
    ) |>
    
    # 5. Row-level omission: drop rows missing race or primary diagnosis
    filter(!is.na(race), !is.na(diag_1)) |>
    
    # 6. Recode target into binary 30-day readmission outcome
    mutate(
      readmitted_30d = if_else(readmitted == "<30", 1L, 0L),
      readmitted_30d = factor(readmitted_30d, levels = c(0, 1), labels = c("No", "Yes")),
      race = factor(race),
      gender = factor(gender),
      age = factor(age)
    )
  
  return(cleaned_df)
}