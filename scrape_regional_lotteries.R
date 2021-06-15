# Scrapes regional lottery numbers
library(rvest)
library(dplyr)
library(stringr)


# PA Lottery
cat("Downloading PA lottery nummers...")

pa_html <- read_html("https://www.palottery.state.pa.us/Print-Winning-Numbers.aspx?print=1")

pa_games <- pa_html %>% 
  html_nodes("li.stretch .logo-section img") %>% 
  html_attr("alt")


pa_dates <- pa_html %>% 
  html_nodes("li.stretch .holder .date") %>% 
  html_text()

pa_numbers <- pa_html %>%
  html_nodes("li.stretch .holder ul.circle-list") %>% 
  html_text() %>% 
   gsub("\r|\n|\t|\\s", "", .)

pa_df <- tibble(
  date = as.Date(pa_dates, format="%m-%d-%y"),
  state = "PA",
  game = pa_games,
  numbers = pa_numbers
)

stringr <- pa_df %>% 
  filter(grepl("PICK|Treasure Hunt", game)) %>% 
  mutate(
    numbers = case_when(
      grepl("PICK", game) ~ paste(str_sub(numbers, 1, -2), str_sub(numbers, -1, -1), sep=', Wild Ball '),
      game == "Treasure Hunt" ~ gsub("(.{2})", "\\1 ", numbers)
    )
  )

# Write out the scraped data
write.csv(pa_df,'lotteries.csv',row.names = FALSE)
