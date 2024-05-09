
# Party Strength -----------------------------------------------------------

ch_parties_long <- ch_parties %>% 
  gather(key = party, value = strength, -year) %>% 
  dplyr::filter(year != 2023)

ggplot(ch_parties_long, aes(x = year, y = strength, color = party)) +
  geom_line() + geom_point() +
  labs(x = "", y = "") +
  scale_y_continuous(labels = scales::percent_format(scale = 1), limits = c(0, 25)) +
  scale_x_continuous(breaks = ch_parties_long$year) +
  scale_color_manual(values = c("sp" = "red", "gps" = "dark green")) +
  theme_minimal() +
  theme(panel.grid.minor = element_blank()) +
  theme(legend.position = "right")

# Save plot
ggsave(
  "ch_parties.pdf",
  plot = last_plot(),
  device = "pdf",
  path = "plots/",
  scale = 3,
  units = "cm",
  width = 7,
  height = 5,
  dpi = 300,
  bg = "transparent"
)


# CHES -----------------------------------------------------------

ches_2014_clean <- ches_2014 %>%
  dplyr::filter(country == 36) %>% 
  select(party_id, party_name, lrgen, galtan)
ches_2014_clean$year <- 2014

ches_2019_clean <- ches_2019 %>%
  dplyr::filter(country == 36) %>% 
  select(party_id, party, lrgen, galtan) %>% 
  rename(party_name = party)
ches_2019_clean$year <- 2019
  
ches_clean <- bind_rows(ches_2014_clean, ches_2019_clean)
ches_clean <- ches_clean %>% mutate(party_name = str_remove(party_name, "/.*")) # remove strings after forward slash in party_name

ggplot(ches_clean, aes(x = lrgen, y = galtan, color = as.factor(year))) +
  # geom_point() +
  geom_label(aes(label = party_name), hjust = 0.5, vjust = 0.5) +
  labs(x = "Left-Right Position", y = "Gal-Tan Position") +
  xlim(0, 10) + ylim(0, 10) +
  theme_minimal()

# Save plot
ggsave(
  "ches.pdf",
  plot = last_plot(),
  device = "pdf",
  path = "plots/",
  scale = 3,
  units = "cm",
  width = 7,
  height = 5,
  dpi = 300,
  bg = "transparent"
)
