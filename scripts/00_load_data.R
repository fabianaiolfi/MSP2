
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