
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

# Sanity plot
ggplot() +
  geom_line(data = gt_climate_change_2004_2022, aes(x = Month, y = climate_change), color = "red") +
  geom_point(data = gt_climate_change_2004_2022, aes(x = Month, y = climate_change), color = "red") +
  geom_line(data = gt_climate_change_2004_2024, aes(x = Month, y = climate_change_new)) +
  geom_point(data = gt_climate_change_2004_2024, aes(x = Month, y = climate_change_new)) +
  ylim(0, 100) +
  theme_minimal()


  