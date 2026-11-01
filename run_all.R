# ==============================================================================
# ==============================================================================
# --- Medicine/Clinical Outcomes ---
# ==============================================================================
# ==============================================================================


# ==============================================================================
# --- Step 0: System requirements ---
# ==============================================================================

message("--- Step 0: Checking System Requirements ---")

# 1. Ensure 'here' is available for relative pathing
if (!requireNamespace("here", quietly = TRUE)) {
  install.packages("here")
}
library(here)

# 2. Ensure 'tinytex' and xelatex are available for PDF compilation
if (!requireNamespace("tinytex", quietly = TRUE)) {
  install.packages("tinytex")
}
if (!tinytex::is_tinytex()) {
  message("Installing tinytex (LaTeX distribution)... this may take a few minutes.")
  tinytex::install_tinytex()
}

message("Dependencies satisfied. Commencing pipeline...")

# ==============================================================================
# --- Step 1: Data Cleaning ---
# ==============================================================================
message("Step 1: Sourcing data cleaning functions...")

force_rebuild <- FALSE

raw_csv_path  <- here::here("data", "raw", "diabetic_data.csv")
processed_rds <- here::here("data", "processed", "diabetic_data_clean.rds")


if (file.exists(processed_rds) && !force_rebuild) {
  message("Found existing cleaned dataset. Loading from cache...")
  clean_df <- readRDS(processed_rds)
} else {
  message("Generating cleaned dataset from raw data...")
  source(here::here("R", "01_clean_data.R"))
  
  if (!file.exists(raw_csv_path)) {
    stop("Raw data missing! Please place 'diabetic_data.csv' in 'data/raw/'.")
  }
  
  clean_df <- clean_diabetes_data(raw_csv_path)
  saveRDS(clean_df, file = processed_rds)
  message("Cleaned data successfully saved to: ", processed_rds)
}

message("Dataset ready with ", nrow(clean_df), " observations.")


# ==============================================================================
# --- Step 1: Data Cleaning ---
# ==============================================================================
