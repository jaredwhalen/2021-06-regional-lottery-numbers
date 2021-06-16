# Scrapes regional lottery numbers
library(rvest)
library(dplyr)
library(tidyr)
library(stringr)

source("state_scrapers/pa_scrape.R")
source("state_scrapers/md_scrape.R")

lotteries <- bind_rows(pa_df, md_df)

# Write out the scraped data
write.csv(lotteries,'lotteries.csv',row.names = FALSE)