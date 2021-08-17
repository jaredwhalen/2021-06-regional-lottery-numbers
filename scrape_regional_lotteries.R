# Scrapes regional lottery numbers
library(rvest)
library(dplyr)
library(tidyr)
library(stringr)

source("state_scrapers/pa_scrape.R")
source("state_scrapers/md_scrape.R")
source("state_scrapers/wv_scrape.R")

lotteries <- bind_rows(pa_df, md_df, wv_df)  %>% 
  mutate(
    state = case_when(
      game %in% c("powerball", "megamillions", "Cash4Life") ~ "multi-state",
      TRUE ~ state
    )
  )

# Write out the scraped data
write.csv(lotteries,'lotteries.csv',row.names = FALSE)