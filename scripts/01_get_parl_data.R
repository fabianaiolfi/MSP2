
# Get all Sessions since 2004 --------------------------

all_sessions <- swissparl::get_data(
  table = "Session", 
  StartDate = ">2004-01-01",
  Language = "DE"
)

session_list <- all_sessions$ID

save(all_sessions, file = here("data", "all_sessions.Rda"))


## Get Data for each Session --------------------------

all_businesses <- as.data.frame(NULL)
counter <- 0

for (session in session_list) {
  temp_df <- swissparl::get_data(
    table = "Business", 
    SubmissionSession = session,
    Language = "DE")
  all_businesses <- rbind(all_businesses, temp_df)
  counter <- counter + 1
  message(counter, " / ", length(session_list))
}

save(all_businesses, file = here("data", "all_businesses.Rda"))
