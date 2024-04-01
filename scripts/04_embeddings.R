
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
# embeddings <- doc2vec(ft_model, all_businesses_embeddings$bill_content, type = "embedding")
# all_businesses_embeddings_bsn <- all_businesses_embeddings %>% select(BusinessShortNumber)
# embeddings <- cbind(all_businesses_embeddings_bsn, embeddings)
# 
# save(embeddings, file = here("data", "embeddings.Rda"))
load(file = here("data", "embeddings.Rda"))
