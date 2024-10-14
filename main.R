library(dplyr)
library(wdman)

source("create_remote_client.R")


selenium()

chromever <- binman::list_versions("chromedriver") %>% 
  tail(1)

remDr <- create_remote_client(chromever)

occupations_list <- c("szakács", "konyhafőnök", "bolti eladó", "boltvezető", 
                      "pénztáros", "telefonos értékesítő", "bérszámfejtő",
                      "irodavezető", "irodai asszisztens", "adminisztrátor",
                      "ügyintéző", "referens", "recepciós", 
                      "sales representative", "sales manager", 
                      "account manager", "területi képviselő", 
                      "szoftverfejlesztő", "software developer", 
                      "szoftver tesztelő", "programozó", "villanyszerelő", 
                      "targoncavezető", "targoncás", "raktáros", 
                      "áru összekészítő", "kommunikációs menedzser", 
                      "kommunikációs munkatárs")

test_occupations <- occupations_list[1]

url <- "https://hu.indeed.com/"

remDr$open()
remDr$navigate(url)