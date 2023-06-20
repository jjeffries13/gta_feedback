library(pacman)

p_load("tidyverse", "qualtRics", "janitor", "here", install = T)

gta_data_raw <- fetch_survey(surveyID = "SV_b93hZrr85f3AZMy",
                             force_request = TRUE) # forces retrieval of most recent surcey data

gta_data_clean <- gta_data_raw |> 
  select(-c(StartDate:IPAddress), -c(Finished:RecordedDate), -c(RecipientLastName:UserLanguage)) |>
  clean_names() 

gta_report_data <- gta_data_clean |>
  mutate(across(.cols = contains("q"), ~case_when(.x == "Strongly disagree" ~ 1, 
                                                  .x == "Somewhat disagree" ~ 2,
                                                  .x == "Neither agree nor disagree" ~ 3,
                                                  .x == "Somewhat agree" ~ 4,
                                                  .x == "Strongly agree" ~ 5)),
         across(.cols = contains("q"), as.numeric),
         total_score = sc0) |>
  select(course_id, -c(progress:duration_in_seconds), q1:r9, sc0)

write.csv(gta_data_raw, file = here("./data/gta_data_raw.csv"))
write.csv(gta_data_clean, file = here("./data/gta_data_clean.csv"))
write.csv(gta_report_data, file = here("./data/gta_report_data.csv"))

