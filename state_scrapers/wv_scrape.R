##############
# WV Lottery
##############
cat("Downloading WV lottery numbers...")

wv_html <- read_html("https://wvlottery.com/")


wv_html %>% 
  html_nodes(".game") %>% 
  html_nodes(".game-drawing__numbers") %>% 
  html_text()



games <- wv_html %>% 
  html_nodes("li.cell") %>% 
  html_attr("class") %>% 
  gsub("cell|medium-12|large-3|large-4|medium-6|auto|\\s", "", .) %>% 
  .[. != ""]  %>% 
  .[. != "keno"]

numbers <- wv_html %>% 
  html_nodes(".game-drawing__numbers") %>% 
  html_text() %>% 
  gsub("\r|\n|\t|\\s", ",", .) %>% 
  gsub(",+", ", ", .) %>% 
  gsub(", $", "", .)


dates <- wv_html %>% 
  html_nodes(".game-time") %>% 
  html_text() %>% 
  .[grepl("Latest", .)] %>%
  gsub("Latest Draw: ", "", .) %>% 
  gsub(".*, ", "", .) %>%
  .[. != "Draws Every 3 Minutes"]

 
 wv_df <- tibble(
   date = as.Date(paste(dates, format(Sys.Date(), "%Y"), sep=" "), format="%B %d"),
   state = "WV",
   game = games,
   numbers = numbers
 ) %>% 
   mutate(
     numbers = case_when(
       game == "powerball" ~ paste(str_sub(numbers, 1, -2), str_sub(numbers, -1, -1), sep=', Power Ball '),
       game == "megamillions" ~ paste(str_sub(numbers, 1, -2), str_sub(numbers, -1, -1), sep=', Mega Ball '),
       game == "lottoamerica" ~ paste(str_sub(numbers, 1, -2), str_sub(numbers, -1, -1), sep=', Star Ball '),
       TRUE ~ numbers
     )
   )
 

 