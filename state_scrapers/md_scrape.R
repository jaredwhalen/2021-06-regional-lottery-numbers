##############
# MD Lottery
##############
cat("Downloading MD lottery numbers...")

md_html <- read_html("https://www.mdlottery.com/player-tools/winning-numbers/#mega-millions")

md_list <- list()

md_list[[length(md_list) + 1]] <- md_html %>% 
  html_node("#table_multi-match") %>% 
  html_table() %>% 
  head(1) %>%
  rename(date = Date, numbers = `Winning Numbers`) %>% 
  mutate(
    game = "Multi-Match",
    state = "MD",
    date = as.Date(date, format="%m/%d/%y"),
    numbers = gsub(" \\+ ", ", ", numbers)
  ) %>% 
  select(
    date,
    state,
    game,
    numbers
  )

md_list[[length(md_list) + 1]] <- md_html %>% 
  html_node("#table_pick-3-4") %>% 
  html_table() %>% 
  head(1) %>%
  select(1:3) %>%
  rename(date = `Pick 3`) %>% 
  pivot_longer(
    cols=c("Midday", "Evening"),
    names_to = "game",
    values_to = "numbers"
  ) %>% 
  mutate(
    game = paste(game, " Pick 3", sep=""),
    state = "MD",
    date = as.Date(date, format="%m/%d/%y"),
    numbers = gsub(" \\+ ", ", ", numbers)
  ) %>% 
  select(
    date,
    state,
    game,
    numbers
  )

md_list[[length(md_list) + 1]] <- md_html %>% 
  html_node("#table_pick-3-4") %>% 
  html_table() %>% 
  head(1) %>%
  select(4:6) %>%
  rename(date = `Pick 4`) %>% 
  pivot_longer(
    cols=c("Midday", "Evening"),
    names_to = "game",
    values_to = "numbers"
  ) %>% 
  mutate(
    game = paste(game, " Pick 4", sep=""),
    state = "MD",
    date = as.Date(date, format="%m/%d/%y"),
    numbers = gsub(" \\+ ", ", ", numbers)
  ) %>% 
  select(
    date,
    state,
    game,
    numbers
  )

md_list[[length(md_list) + 1]] <- md_html %>% 
  html_node("#table_bonus-match-5") %>% 
  html_table() %>% 
  head(1) %>% 
  mutate(
    game = "Bonus Match 5",
    date = as.Date(Date, format="%m/%d/%y"),
    state = "MD",
    numbers = paste(gsub(" \\+ ", ", ", Daily), " Bonus Ball ", Bonus, sep=""  )
  ) %>% 
  select(
    date,
    state,
    game,
    numbers
  )

md_list[[length(md_list) + 1]] <- md_html %>% 
  html_node("#table_cash-4-life") %>% 
  html_table() %>% 
  head(1) %>%
  rename(date = Date, numbers = `Winning Numbers`) %>% 
  mutate(
    game = "Cash 4 Life",
    state = "MD",
    date = as.Date(date, format="%m/%d/%y"),
    numbers = paste(gsub(" \\+ ", ", ", numbers), " Cash Ball ", `Cash Ball`, sep="")
  ) %>% 
  select(
    date,
    state,
    game,
    numbers
  )

# bind rows into new dataframe
md_df <- bind_rows(md_list)
