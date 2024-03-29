
# Define Party for each Bill --------------------------

all_businesses_party <- all_businesses %>% 
  select(BusinessShortNumber, BusinessTypeName, Title, SubmittedBy) %>% 
  drop_na(SubmittedBy) %>% 
  dplyr::filter(BusinessTypeName != "Standesinitiative") %>% 
  dplyr::filter(SubmittedBy != "Büro-NR-Nationalrat") %>% 
  dplyr::filter(SubmittedBy != "Büro-SR-Ständerat")


## Get party for each MP -------------------

# Attach Party to MPs
unique_submitters <- all_businesses_party %>% distinct(SubmittedBy)

all_mps_edit <- all_MemberCouncil %>% 
  select(PersonIdCode, FirstName, LastName, PartyAbbreviation) %>% 
  mutate(SubmittedBy = paste(LastName, FirstName)) %>% 
  select(PersonIdCode, SubmittedBy, PartyAbbreviation) %>% 
  distinct(PersonIdCode, .keep_all = T)

mp_submitters <- unique_submitters %>%
  left_join(all_mps_edit, by = "SubmittedBy") %>% 
  drop_na(PersonIdCode) %>% 
  select(-PersonIdCode)

## Get non-MPs with clear party association ----------------

# Who are non-MPs with clear party association?
# temp_df <- unique_submitters %>%
#   dplyr::filter(is.na(PersonIdCode) == T) %>% 
#   # Filter out rows that contain the string "Fraktion" in the SubmittedBy column
#   dplyr::filter(!grepl("Fraktion", SubmittedBy)) %>%
#   dplyr::filter(!grepl("Fachstelle", SubmittedBy)) %>%
#   dplyr::filter(!grepl("Association", SubmittedBy)) %>%
#   dplyr::filter(!grepl("Associazione", SubmittedBy)) %>%
#   dplyr::filter(!grepl("Komitee", SubmittedBy)) %>%
#   dplyr::filter(!grepl("Kommission", SubmittedBy)) %>%
#   dplyr::filter(!grepl("session", SubmittedBy)) %>%
#   dplyr::filter(!grepl("lobby", SubmittedBy)) %>%
#   dplyr::filter(!grepl("OK", SubmittedBy))

# Get non-MPs and add their party association
non_mps <- unique_submitters %>%
  # Filter using \\b for whole words
  dplyr::filter(grepl("\\b(Fraktion|SVP|SP|Lega|EDU|MCG|Mitte|CVP|EVP|FDP|Grüne|Grünliberal|GLP|Mouvement Citoyens Genevois)\\b", SubmittedBy)) %>%
  mutate(PartyAbbreviation = case_when(
    grepl("\\bGrüne\\b", SubmittedBy) ~ "GRÜNE",
    grepl("\\bMitte\\b", SubmittedBy) ~ "M-E",
    grepl("Sozial|\\bSP\\b", SubmittedBy) ~ "SP",
    grepl("\\bVolkspartei\\b|SVP", SubmittedBy) ~ "SVP",
    grepl("FDP", SubmittedBy) ~ "FDP",
    grepl("EDU", SubmittedBy) ~ "EDU",
    grepl("EVP", SubmittedBy) ~ "EVP",
    grepl("\\bBD\\b", SubmittedBy) ~ "BDP",
    grepl("Mouvement Citoyens Genevois", SubmittedBy) ~ "MCG",
    grepl("Grünliberale", SubmittedBy) ~ "glp",
    TRUE ~ NA_character_
  ))

# Merge MPs and non-MPs
submitters_with_party <- rbind(mp_submitters, non_mps)
submitters_with_party <- submitters_with_party %>% distinct(SubmittedBy, .keep_all = T)

# Join submitters with bills
all_businesses_party <- all_businesses_party %>% 
  left_join(submitters_with_party, by = "SubmittedBy") %>% 
  drop_na(PartyAbbreviation) %>% 
  select(BusinessShortNumber, PartyAbbreviation)

save(all_businesses_party, file = here("data", "all_businesses_party.Rda"))
