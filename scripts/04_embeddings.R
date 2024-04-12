
# Calculate Embeddings for All Bills ---------------------------------

# Load Fasttext model
# https://cran.r-project.org/web/packages/word2vec/readme/README.html -> Pretrained models
# https://fasttext.cc/docs/en/crawl-vectors.html
# ft_model <- read.word2vec(file = "/Volumes/iPhone_Backup_2/cc.de.300.vec", normalize = T)
# 
# # Prepare data for embeddings: Concatenate title and bill content
# all_businesses_embeddings <- all_businesses %>%
#   select(BusinessShortNumber, Title, SubmittedText) %>%
#   drop_na(SubmittedText) %>%
#   # Remove HTML tags from SubmittedText
#   mutate(SubmittedText_clean = gsub("<.*?>", "", SubmittedText)) %>%
#   # Concatenate title and SubmittedText
#   mutate(bill_content = paste(Title, SubmittedText_clean, sep = "\n")) %>%
#   select(BusinessShortNumber, bill_content)
# 
# ft_embeddings <- doc2vec(ft_model, all_businesses_embeddings$bill_content, type = "embedding")
# all_businesses_embeddings_bsn <- all_businesses_embeddings %>% select(BusinessShortNumber)
# ft_embeddings <- cbind(all_businesses_embeddings_bsn, ft_embeddings)
# 
# save(ft_embeddings, file = here("data", "ft_embeddings.Rda"))
load(file = here("data", "ft_embeddings.Rda"))


# Try another model: GloVe ---------------------------------

# https://czarrar.github.io/Gensim-Word2Vec/

# GloVe_vectors.txt: https://www.deepset.ai/german-word-embeddings

# File needs to be converted to Word2Vec format
# https://radimrehurek.com/gensim/scripts/glove2word2vec.html
# wc -l GloVe_vectors.txt -> 1'309'281 words, 300 dimensions

# Add number of words and dimension to file
# echo "1309281 300" | cat - GloVe_vectors.txt > GloVe_vectors_converted.txt
# Manually change ending to .vec

# glove_model <- read.word2vec(file = "/Volumes/iPhone_Backup_2/GloVe_vectors_converted.vec", normalize = T)
# glove_embeddings <- doc2vec(glove_model, all_businesses_embeddings$bill_content, type = "embedding")
# glove_embeddings <- cbind(all_businesses_embeddings_bsn, glove_embeddings)
# save(glove_embeddings, file = here("data", "glove_embeddings.Rda"))
# load(file = here("data", "glove_embeddings.Rda"))


# Calculate Embedding Distances ---------------------------------

# Select Model
embeddings <- ft_embeddings
model_name <- "ft_embeddings"
# embeddings <- glove_embeddings
# model_name <- "glove_embeddings"


# All Green bills, grouped by Session
all_green_bills <- eda %>% 
  select(-c(StartDate, year_session)) %>% 
  dplyr::filter(PartyAbbreviation == "GRÜNE") %>% 
  select(BusinessShortNumber, SubmissionSession) %>% 
  left_join(embeddings, by = "BusinessShortNumber") %>% 
  group_by(SubmissionSession) %>% 
  summarise(across(matches("^[0-9]"), \(x) mean(x, na.rm = TRUE))) %>% 
  # Add a "V" to column names that are digits
  rename_with(~paste0("V_green_", .), matches("^[0-9]"))

# All SP bills, grouped by Session
all_sp_bills <- eda %>% 
  select(-c(StartDate, year_session)) %>% 
  dplyr::filter(PartyAbbreviation == "SP") %>% 
  select(BusinessShortNumber, SubmissionSession) %>% 
  left_join(embeddings, by = "BusinessShortNumber") %>% 
  group_by(SubmissionSession) %>% 
  summarise(across(matches("^[0-9]"), \(x) mean(x, na.rm = TRUE))) %>% 
  # Add a "V" to column names that are digits
  rename_with(~paste0("V_sp_", .), matches("^[0-9]"))

# Merge the dataframes on the index column
all_bills_joined <- inner_join(all_green_bills, all_sp_bills, by = "SubmissionSession")

# Add a new column `distance` with the calculated distance between each pair of rows
sp_greens_all_bills_distance <- all_bills_joined %>%
  rowwise() %>%
  # Calculate Euclidean distances
  # mutate(distance = sqrt(sum((c_across(starts_with("V_green")) - c_across(starts_with("V_sp")))^2))) %>%
  # Calculate cosine similarity
  mutate(distance = 1 - sum(c_across(starts_with("V_green")) * c_across(starts_with("V_sp"))) / (sqrt(sum(c_across(starts_with("V_green"))^2)) * sqrt(sum(c_across(starts_with("V_sp"))^2)))) %>%
  ungroup() %>% 
  select(SubmissionSession, distance)

new_object_name <- paste0("sp_greens_all_bills_distance_", model_name)
assign(new_object_name, sp_greens_all_bills_distance)
saveRDS(get(new_object_name), file = here("data", paste0(new_object_name, ".Rda")))


# Green environmental bills, grouped by Session
green_environmental_bills <- eda %>% 
  select(-c(StartDate, year_session)) %>% 
  dplyr::filter(PartyAbbreviation == "GRÜNE") %>% 
  dplyr::filter(grepl("Umwelt", TagNames)) %>% 
  select(BusinessShortNumber, SubmissionSession) %>% 
  left_join(ft_embeddings, by = "BusinessShortNumber") %>% 
  group_by(SubmissionSession) %>% 
  summarise(across(matches("^[0-9]"), \(x) mean(x, na.rm = TRUE))) %>% 
  # Add a "V" to column names that are digits
  rename_with(~paste0("V_green_", .), matches("^[0-9]"))

# SP environmental bills, grouped by Session
sp_environmental_bills <- eda %>% 
  select(-c(StartDate, year_session)) %>% 
  dplyr::filter(grepl("SP", PartyAbbreviation)) %>% 
  dplyr::filter(grepl("Umwelt", TagNames)) %>% 
  select(BusinessShortNumber, SubmissionSession) %>% 
  left_join(ft_embeddings, by = "BusinessShortNumber") %>% 
  group_by(SubmissionSession) %>% 
  summarise(across(matches("^[0-9]"), \(x) mean(x, na.rm = TRUE))) %>% 
  # Add a "V" to column names that are digits
  rename_with(~paste0("V_sp_", .), matches("^[0-9]"))

# Merge the dataframes on the index column
environmental_bills_joined <- inner_join(green_environmental_bills, sp_environmental_bills, by = "SubmissionSession")

# Add a new column `distance` with the calculated distance between each pair of rows
sp_greens_environmental_bills_distance <- environmental_bills_joined %>%
  rowwise() %>%
  # Calculate Euclidean distances
  # mutate(distance = sqrt(sum((c_across(starts_with("V_green")) - c_across(starts_with("V_sp")))^2))) %>%
  # Calculate cosine similarity
  mutate(distance = 1 - sum(c_across(starts_with("V_green")) * c_across(starts_with("V_sp"))) / (sqrt(sum(c_across(starts_with("V_green"))^2)) * sqrt(sum(c_across(starts_with("V_sp"))^2)))) %>%
  ungroup() %>% 
  select(SubmissionSession, distance)

new_object_name <- paste0("sp_greens_environmental_bills_distance_", model_name)
assign(new_object_name, sp_greens_environmental_bills_distance)
saveRDS(get(new_object_name), file = here("data", paste0(new_object_name, ".Rda")))

# save(sp_greens_environmental_bills_distance, file = here("data", paste0("sp_greens_environmental_bills_distance_", model_name, ".Rda")))
