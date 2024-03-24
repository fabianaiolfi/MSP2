
# Preliminary Data Collection --------------------------

## Get all Sessions since 2004

all_sessions <- swissparl::get_data(
  table = "Session", 
  StartDate = ">2004-01-01",
  Language = "DE"
)

## Get Data for each Session

swissparl::get_variables("Business")
business_glimpse <- swissparl::get_glimpse("Business", rows = 5)

businesses_session_4702 <- swissparl::get_data(
  table = "Business", 
  SubmissionSession = 4702,
  Language = "DE"
)

businesses_session_4703 <- swissparl::get_data(
  table = "Business", 
  SubmissionSession = 4703,
  Language = "DE"
)

businesses_session_4704 <- swissparl::get_data(
  table = "Business", 
  SubmissionSession = 4704,
  Language = "DE"
)
