library(dplyr)
library(wdman)

source("create-remote-client.R")

selenium()

chromever <- binman::list_versions("chromedriver") %>% 
  tail(1)

remDr <- create_remote_client(chromever)

# Navigate to Indeed Hungarian main page
remDr$open()
remDr$navigate("hu.indeed.com")

# Locate search bar and pass first occupation string
inputField <- remDr$findElement(using = 'xpath', "//input[@id='text-input-what']")
inputField$sendKeysToElement(list("szakács", key='enter'))


# Test XPATH expressions to locate relevant data