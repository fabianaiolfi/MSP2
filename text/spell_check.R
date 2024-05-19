
# Spell check Rmd files

# Get all file names
main_folder_path <- here("text")

# Create a vector of all Rmd file names
rmd_files <- list.files(path = main_folder_path, 
                        pattern = "\\.Rmd$", 
                        recursive = TRUE, 
                        full.names = TRUE)

# List of files to exclude
exclude_files <- c("00_title.Rmd",
                   "01_abstract.Rmd",
                   "09_appendix.Rmd",
                   "10_authorship.Rmd",
                   "11_ai.Rmd",
                   "Outline.Rmd",
                   "master_seminar_paper.Rmd")

# Exclude specific files
rmd_files <- rmd_files[!basename(rmd_files) %in% exclude_files]

sc <- spelling::spell_check_files(rmd_files, lang = "en-GB", ignore = c("embeddings", "fasttext", "fastText", "GloVe", "https", "modelling", "ch", "ches"))

