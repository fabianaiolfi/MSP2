
# Parliamentary Data -----------------------------------------------------------

load(file = here("data", "all_sessions.Rda"))
load(file = here("data", "all_businesses.Rda"))
load(file = here("data", "all_MemberCouncil.Rda"))
load(file = here("data", "all_businesses_wc.Rda"))
load(file = here("data", "all_businesses_eda.Rda"))
load(file = here("data", "eda.Rda"))


# Party Strength -----------------------------------------------------------

# https://www.bfs.admin.ch/asset/de/27145667
ch_parties <- read_csv(here("data", "ch_parties.csv"))


# CHES -----------------------------------------------------------

# 2019 Chapel Hill expert survey
# https://www.chesdata.eu/s/CHES2019V3.dta
ches_2019 <- haven::read_dta(here("data", "CHES2019V3.dta"))

# 2014 Chapel Hill expert survey
# https://www.chesdata.eu/s/2014_CHES_dataset_means-2.dta
ches_2014 <- haven::read_dta(here("data", "2014_CHES_dataset_means-2.dta"))


# Selects -----------------------------------------------------------

# https://www.swissubase.ch/en/researcher/my-downloads/107981/19952/download-details
selects <- haven::read_dta(here("data", "swissubase_495_6_0", "495_Selects_CumulativeFile_Data_1971-2019_v2.3.0.dta"))

# 495_Selects_CumulativeFile_Doc_1971-2019_EN.html#file_backg3_mip1
mip_labels <- read_csv(here("data", "swissubase_495_6_0", "mip_labels.csv"))


# Google Trends -----------------------------------------------------------

# Climate Change (search term)
gt_climate_change_2004_2022 <- read_csv(here("data", "google_trends", "search_term", "climate_change_2004_2022.csv"), skip = 1)
gt_climate_change_2004_2022$Month <- as.Date(paste0(gt_climate_change_2004_2022$Month, "-01"), format = "%Y-%m-%d")
gt_climate_change_2004_2022 <- gt_climate_change_2004_2022 %>% dplyr::rename(climate_change = `Climate change: (Switzerland)`)

gt_climate_change_2004_2024 <- read_csv(here("data", "google_trends", "search_term", "climate_change_2004_2024.csv"), skip = 1)
gt_climate_change_2004_2024$Month <- as.Date(paste0(gt_climate_change_2004_2024$Month, "-01"), format = "%Y-%m-%d")
gt_climate_change_2004_2024 <- gt_climate_change_2004_2024 %>% dplyr::rename(climate_change = `Climate Change: (Switzerland)`)
