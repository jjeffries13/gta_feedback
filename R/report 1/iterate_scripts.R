library(pacman)
p_load("tidyverse", "rmarkdown", "here")

gta_report1 <- read_csv(file = here("./data/gta_report_data.csv"))

course_ids <- unique(gta_report1$course_id)

gta_report1 <- tibble(
  output_file = str_c(course_ids, "-report.html"),
  params = map(course_ids, ~list(course_ids = .))
)

gta_report1 %>%
  pwalk(rmarkdown::render, 
        input = here("./R/report 1/feedback_report1_template.Rmd"))