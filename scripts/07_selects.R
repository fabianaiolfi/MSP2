
# Selects EDA -----------------------------------------------------------

# Most important problem: Variable mip1

selects_df <- selects %>%
  select(year, userid, weighttot, mip1, mip2) %>% 
  left_join(mip_labels, by = c("mip1" = "value")) %>% 
  rename(mip1_name = name) %>% 
  left_join(mip_labels, by = c("mip2" = "value")) %>% 
  rename(mip2_name = name)

# test_df <- selects_df %>% 
  # select(year, weighttot, mip1_name, mip2_name)

# Calculating the total weight for "environment&energy" per year
env_energy_weights <- selects_df %>%
  dplyr::filter(mip1_name == "environment&energy") %>%
  group_by(year) %>%
  summarize(weight_for_env_energy = sum(weighttot, na.rm = TRUE))

# Calculating the total weight per year for all tags
total_weights_per_year <- selects_df %>%
  group_by(year) %>%
  summarize(total_weight = sum(weighttot, na.rm = TRUE))

yearly_share <- left_join(env_energy_weights, total_weights_per_year, by = "year") %>%
  mutate(share = weight_for_env_energy / total_weight)

ggplot(yearly_share, aes(x = year, y = share)) +
  geom_line() +
  labs(title = "Share of weight for 'environment&energy' per year",
       x = "Year",
       y = "Share of weight")
