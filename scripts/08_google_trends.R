
# Plot -----------------------------------------------------------

ggplot(gt_climate_change_2004_2022, aes(x = Month, y = climate_change)) +
  geom_point() + geom_line() +
  theme_minimal()

ggplot(gt_climate_change_2004_2024, aes(x = Month, y = climate_change)) +
  geom_point() + geom_line() +
  theme_minimal()


# Re-Index -----------------------------------------------------------


df_2004_2022 <- gt_climate_change_2004_2022 %>% dplyr::filter(Month > "2007-02-01")
df_2004_2024 <- gt_climate_change_2004_2024 %>% dplyr::filter(Month > "2007-02-01")

ggplot(df_2004_2022, aes(x = Month, y = climate_change)) +
  geom_point() + geom_line() +
  ylim(0, 100) +
  theme_minimal()

ggplot(df_2004_2024, aes(x = Month, y = climate_change)) +
  geom_point() + geom_line() +
  theme_minimal()

first_value_2004_2022 <- df_2004_2022$climate_change[1]
first_value_2004_2024 <- df_2004_2024$climate_change[1]
df_2004_2022$index <- first_value_2004_2022 / df_2004_2022$climate_change

df_2004_2024$cor_1 <- df_2004_2024$climate_change + (first_value_2004_2022 - first_value_2004_2024)

ggplot(df_2004_2024, aes(x = Month, y = cor_1)) +
  geom_point() + geom_line() +
  theme_minimal()

# df_2004_2024 <- df_2004_2024 %>% left_join(select(df_2004_2022, Month, index), by = "Month")

df_2004_2024$index <- first_value_2004_2022 / df_2004_2024$cor_1

# df_2004_2024$cor_2 <- df_2004_2024$cor_1 / df_2004_2024$index

df_2004_2024$climate_change_new <- df_2004_2024$cor_1 / df_2004_2024$index

ggplot(df_2004_2024, aes(x = Month, y = climate_change_new)) +
  geom_point() + geom_line() +
  ylim(0, 100) +
  theme_minimal()


ggplot() +
  # geom_line(data = df_2004_2022, aes(x = Month, y = climate_change), color = "red") +
  # geom_point(data = df_2004_2022, aes(x = Month, y = climate_change), color = "red") +
  geom_line(data = df_2004_2024, aes(x = Month, y = climate_change_new)) +
  geom_point(data = df_2004_2024, aes(x = Month, y = climate_change_new)) +
  ylim(0, 100) +
  theme_minimal()


  