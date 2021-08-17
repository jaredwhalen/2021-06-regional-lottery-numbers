##############
# WV Lottery
##############
cat("Downloading VA lottery numbers...")

va_html <- read_html("https://www.valottery.com/")


games <- va_html %>% 
  html_node("#winning-numbers-games-list") %>% 
  html_nodes(".game-logo-container img") %>% 
  html_attr("alt") %>% 
  .[!. %in% c("Keno", "Rolling Jackpot")]

numbers <- va_html %>% 
  html_node("#winning-numbers-games-list") %>% 
  html_nodes(".selected-numbers ul") %>% 
  html_text() %>% 
  gsub("\r|\n|\t|\\s", ",", .) %>% 
  gsub(",+", ", ", .) %>% 
  gsub("^, |, $|.*:, ", "", .)


dates <- va_html %>%
  html_node("#winning-numbers-games-list") %>%
  html_nodes(".date") %>%
  html_text() %>%
  .[grepl("Latest", .)] %>%
  gsub("Latest Drawing: ", "", .) %>%
  .[. != "Draws Every 4 Minutes"] %>%
  .[. != "As of"] %>%
  gsub("\r|\n|\\s+", "", .) %>%
  substr(., 4, nchar(.))


va_list <- list()
for (row in 1:length(numbers) ) {
  game <- games[]
  # if there is more than one set of numbers, set a Midday or Evening prefix
  prefix <- ifelse(length(numbers) == 2, ifelse(row == 1, 'Day ', 'Night '), '')
  name <- paste(prefix, game, sep="")
  # build dataframe and do some cleanup to the numbers to account for each game
  va_row <- tibble(
    date = as.Date(dates[row], format="%m-%d-%y"),
    state = "VA",
    game = name,
    numbers = numbers[row]
  ) %>%
    mutate(
      numbers = case_when(
        grepl("PICK", game) ~ paste(str_sub(numbers, 1, -2), str_sub(numbers, -1, -1), sep=', Wild Ball '),
        TRUE ~ gsub(", $", "", gsub("(.{2})", "\\1, ", numbers))
      )
    )
  # add rows to list
  va_list[[length(va_list) + 1]] <- va_row
}



# va_df <- 
  tibble(
  date = as.Date(dates, format="%m/%d/%Y"),
  state = "VA",
  game = games,
  numbers = numbers
) 

%>% 
  mutate(
    numbers = case_when(
      game == "powerball" ~ paste(str_sub(numbers, 1, -2), str_sub(numbers, -1, -1), sep=', Power Ball '),
      game == "megamillions" ~ paste(str_sub(numbers, 1, -2), str_sub(numbers, -1, -1), sep=', Mega Ball '),
      game == "lottoamerica" ~ paste(str_sub(numbers, 1, -2), str_sub(numbers, -1, -1), sep=', Star Ball '),
      TRUE ~ numbers
    )
  )


