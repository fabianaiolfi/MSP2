
# Align Google Trends and Embedding Distances -----------------------------------------------------------

# Load data
load(file = here("data", "all_sessions.Rda"))
sp_greens_environmental_bills_distance_ft_embeddings <- readRDS(file = here("data", "sp_greens_environmental_bills_distance_ft_embeddings.Rda"))
load(file = here("data", "google_trends", "search_term", "gt_climate_change_2004_2024.Rda"))

# Get Month for each session
session_month <- all_sessions %>% 
  select(ID, EndDate) %>% 
  # convert date to first of the month
  mutate(Month = as.Date(paste0(format(EndDate, "%Y-%m"), "-01")))

# Add Month to embeddings
sp_greens_environmental_bills_distance_ft_embeddings <- sp_greens_environmental_bills_distance_ft_embeddings %>% 
  left_join(select(session_month, ID, Month), by = c("SubmissionSession" = "ID"))

# Join Embedding Distances with Google Trends
gt_embeddings <- gt_climate_change_2004_2024 %>% 
  select(Month, climate_change_new) %>% 
  left_join(sp_greens_environmental_bills_distance_ft_embeddings, by = "Month") %>% 
  select(-SubmissionSession) %>% 
  drop_na()

# Calculate differences between rows
gt_embeddings$climate_change_new_diff <- c(NA, diff(gt_embeddings$climate_change_new))
gt_embeddings$distance_diff <- c(NA, diff(gt_embeddings$distance))

# hist(gt_embeddings$climate_change_new_diff)
# hist(gt_embeddings$distance_diff)

# Add lag
gt_embeddings <- gt_embeddings %>% mutate(distance_diff_lagged = dplyr::lag(distance_diff, n = 1, default = NA))
  
# Clean up dataframe
gt_embeddings <- gt_embeddings %>% drop_na()


# Correlation -----------------------------------------------------------

cor1 <- cor.test(gt_embeddings$climate_change_new_diff, gt_embeddings$distance_diff)
round(cor1$estimate, 2)
round(cor1$p.value, 2)
plot(gt_embeddings$climate_change_new_diff, gt_embeddings$distance_diff)

cor2 <- cor.test(gt_embeddings$climate_change_new_diff, gt_embeddings$distance_diff_lagged)
round(cor2$estimate, 2)
round(cor2$p.value, 2)
plot(gt_embeddings$climate_change_new_diff, gt_embeddings$distance_diff_lagged)

# Linear Regression -----------------------------------------------------------

model1 <- lm(distance_diff ~ climate_change_new_diff, gt_embeddings)
model2 <- lm(distance_diff_lagged ~ climate_change_new_diff, gt_embeddings)

summary(model1)
summary(model2)

plot(model1)
plot(model2)
