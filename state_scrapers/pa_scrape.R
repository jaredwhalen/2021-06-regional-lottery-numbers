##############
# PA Lottery
##############
cat("Downloading PA lottery numbers...")

# download HTML from the print preview
pa_html <- read_html("https://www.palottery.state.pa.us/Print-Winning-Numbers.aspx?print=1")

# get each game node
nodes <- pa_html %>% 
  html_nodes("li.stretch")

# make empty list to store rows
pa_list <- list()

# iterate over each node. This is needed because some games include multiple drawings
for (node in nodes) {
  # access game name from the alt data within the image
  game <- node %>% 
    html_nodes(".logo-section img") %>% 
    html_attr("alt")
  
  # get and clean each set up winning numbers
  numbers <- node %>%
    html_nodes(".holder ul.circle-list, .bottom-area ul.circle-list") %>% 
    html_text() %>% 
    gsub("\r|\n|\t|\\s", "", .)
  
  # similiary, extract the drawing dates
  dates <- node %>%
    html_nodes(".date") %>%
    html_text()
  
  # iterate over the sets of numbers
  for (row in 1:length(numbers) ) {
    # if there is more than one set of numbers, set a Midday or Evening prefix
    prefix <- ifelse(length(numbers) == 2, ifelse(row == 1, 'Midday ', 'Evening '), '')
    name <- paste(prefix, game, sep="")
    # build dataframe and do some cleanup to the numbers to account for each game
    pa_row <- tibble(
      date = as.Date(dates[row], format="%m-%d-%y"),
      state = "PA",
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
    pa_list[[length(pa_list) + 1]] <- pa_row
  }
}

# bind rows into new dataframe
pa_df <- bind_rows(pa_list) %>%  filter(!game %in% c("Mega Millions", "Powerball"))