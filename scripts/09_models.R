
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

library(tseries)
library(forecast)
adf.test(gt_embeddings$climate_change_new)
hist(gt_embeddings$climate_change_new)
acf(gt_embeddings$climate_change_new)
ndiffs(x = gt_embeddings$climate_change_new)
auto.arima(x = gt_embeddings$climate_change_new)

adf.test(gt_embeddings$distance)
hist(log(gt_embeddings$distance))
acf(gt_embeddings$distance)
ndiffs(x = gt_embeddings$distance)
auto.arima(x = gt_embeddings$distance)

# If non-stationary, difference the series
gt_embeddings$climate_change_new_diff <- c(NA, diff(gt_embeddings$climate_change_new))
gt_embeddings$distance_diff <- c(NA, diff(gt_embeddings$distance))
gt_embeddings <- na.omit(gt_embeddings)
adf.test(gt_embeddings$climate_change_new_diff)

cor(gt_embeddings$climate_change_new_diff, gt_embeddings$distance_diff, method = "pearson")
cor.test(gt_embeddings$climate_change_new_diff, gt_embeddings$distance_diff, method = "pearson")

cor.test(gt_embeddings$climate_change_new, log(gt_embeddings$distance), method = "pearson")
plot(gt_embeddings$climate_change_new, log(gt_embeddings$distance))
summary(lm(log(distance) ~ climate_change_new, gt_embeddings))

cor.test(gt_embeddings$climate_change_new_diff, log(gt_embeddings$distance_diff), method = "pearson")
summary(lm(log(distance_diff) ~ climate_change_new_diff, gt_embeddings))

# lag distance
gt_embeddings <- gt_embeddings %>% 
  mutate(distance_lagged = dplyr::lag(distance, n = 1, default = NA))

cor.test(gt_embeddings$climate_change_new, log(gt_embeddings$distance_lagged), method = "pearson")
summary(lm(log(distance_lagged) ~ climate_change_new_diff, gt_embeddings))






