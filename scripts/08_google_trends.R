
# Re-Index -----------------------------------------------------------

# Remove missing values at start of timeline
gt_climate_change_2004_2022 <- gt_climate_change_2004_2022 %>% dplyr::filter(Month > "2007-02-01")
gt_climate_change_2004_2024 <- gt_climate_change_2004_2024 %>% dplyr::filter(Month > "2007-02-01")

# "Lift up" values to have same starting point
gt_climate_change_2004_2024$lifted <- gt_climate_change_2004_2024$climate_change + (gt_climate_change_2004_2022$climate_change[1] - gt_climate_change_2004_2024$climate_change[1])

# Calculate index compared to first value
gt_climate_change_2004_2024$index <- gt_climate_change_2004_2022$climate_change[1] / gt_climate_change_2004_2024$lifted

# Calculate new climate change value
gt_climate_change_2004_2024$climate_change_new <- gt_climate_change_2004_2024$lifted / gt_climate_change_2004_2024$index

# Replace values bigger than 100 with 100
gt_climate_change_2004_2024 <- gt_climate_change_2004_2024 %>% 
  mutate(climate_change_new = case_when(climate_change_new > 100 ~ 100,
                                        T ~ climate_change_new))

save(gt_climate_change_2004_2024, file = here("data", "google_trends", "search_term", "gt_climate_change_2004_2024.Rda"))

# Sanity plot
ggplot() +
  geom_line(data = gt_climate_change_2004_2022, aes(x = Month, y = climate_change), color = "red") +
  geom_point(data = gt_climate_change_2004_2022, aes(x = Month, y = climate_change), color = "red") +
  geom_line(data = gt_climate_change_2004_2024, aes(x = Month, y = climate_change_new)) +
  geom_point(data = gt_climate_change_2004_2024, aes(x = Month, y = climate_change_new)) +
  # ylim(0, 100) +
  theme_minimal()

# Compare Selects with Google Trends
selects_yearly_share <- yearly_share %>% 
  # mutate(share = share * 100) %>% 
  # mutate(share = share + 49) %>%
  mutate(year = as.Date(paste0(year, "-01-01"), format = "%Y-%m-%d"))
  
ggplot() +
  geom_point(data = gt_climate_change_2004_2024, aes(x = Month, y = climate_change_new)) +
  geom_point(data = selects_yearly_share, aes(x = year, y = (share * 100) + 49), color = "red") +
  geom_line(data = selects_yearly_share, aes(x = year, y = (share * 100) + 49), color = "red") +
  geom_line(data = gt_climate_change_2004_2024, aes(x = Month, y = climate_change_new)) +
  scale_y_continuous(
    "asd", 
    sec.axis = sec_axis(transform = ~ . * 1, name = "qwe")
  ) +
  # ylim(0, 100) +
  xlim(as.Date("2003-01-01"), as.Date("2023-12-31"))
  # theme_minimal()
