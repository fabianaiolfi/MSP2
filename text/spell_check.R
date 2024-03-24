
# Spell check Rmd files

# Get all file names
main_folder_path <- here("text")

# Create a vector of all Rmd file names
rmd_files <- list.files(path = main_folder_path, 
                        pattern = "\\.Rmd$", 
                        recursive = TRUE, 
                        full.names = TRUE)

sc <- spelling::spell_check_files(rmd_files, lang = "en-US", ignore = c("embeddings", "fasttext", "fastText", "GloVe", "https", "modelling"))
