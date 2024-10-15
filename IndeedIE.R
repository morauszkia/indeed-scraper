# Scrape Indeed.IE for EqualStrength occupations  ##########################################
# https://ie.indeed.com (17/08/2023)
# load packages
library(tidyverse)
library(RSelenium)
library(rvest)
library(purrr)


# 1) Defining functions  ###########################################

# function to get a table with all ads for a single page
get_onepage <- function(ad_number){

    # function to get element for each ad
    get_element_test <- function(html_mark, class_id, x){
        element <- remDr$findElement(
                    using = 'xpath', 
                    value = paste0(paste0("(//", html_mark,  "[contains(@class, '", 
                                    class_id, "')])"),
                                "[", x, "]"))
        
        element$getElementText()[[1]]
        }

    # Modified function in case element is not present
    get_element <- purrr::possibly(get_element_test, otherwise = NA)

    # generating a table with all ads from the current page
    tibble(
        title = get_element("h2", "jobTitle", ad_number),
        company = get_element("span", "companyName", ad_number),
        location = get_element("div", "companyLocation", ad_number),
        type = get_element("div", "attribute_snippet", ad_number),
        desc = get_element("div", "job-snippet", ad_number),
        date = get_element("span", "date", ad_number)
        )
}

# Function to navigate through pages and get one table for each page
get_allpages <- function(url_base, page_number){
    # generate the URL of the page
    url_page <- paste0(url_base, "&filter=0&start=", page_number)

    # visit the page
    remDr$navigate(url_page)

    # sleep for a random amount of time to wait for the page to load
    Sys.sleep(sample(2:4, 1))

    # get the total number of ads on the page (usually 15 but apparently it can vary)
    n_ads <- length(remDr$findElements('xpath', "(//h2[contains(@class, 'jobTitle')])"))

    # generate table from the ads loaded on the current page
    map(1:n_ads, get_onepage) |> bind_rows()
}

# Function to generate URL from query parameters and scrape data
get_data <- function(occup_group, country, days){
    
    # Generating URL from the query parameters
    keywords <- str_split(ls_keyw$basic[ls_keyw$occup == occup_group], ", ")[[1]]
    url_what <- paste0("\"", keywords, "\"", collapse = "+OR+")
    url_base <- paste0("https://ie.indeed.com/jobs?q=", url_what, "&l=", country, 
                    "&sc=0kf%3Ajt(fulltime)%3B&fromage=", days)

    # Navigate to first page of the specified query
    remDr$navigate(url_base)

    # Accept cookies
    ls_cookies <- remDr$findElements(using = 'css', value = '#onetrust-accept-btn-handler')
    if(length(ls_cookies) > 0){
        remDr$findElement(using = 'css', value = '#onetrust-accept-btn-handler')$clickElement()
    } else { print("Cookies already accepted") }

    # Getting the total number of ads for the query
    elm_nads <- ".jobsearch-JobCountAndSortPane-jobCount"
    nads <- parse_number(remDr$findElement(using = 'css', value = elm_nads)$getElementText()[[1]])

    # scrape all pages based on the number of adds and store as a list
    ls_output <- map2(url_base, seq(0, nads/17*10, 10), get_allpages, .progress = TRUE)

    # bind all pages together into a single data frame identifying the occupation
    bind_rows(ls_output) |> mutate(occupation = occup_group)

}


# 2) Scraping the website #####################################################

# start the server
rsD <- rsDriver(browser = 'firefox')

# create a client object
remDr <- rsD$client

# defining query parameters and getting the results
ls_keyw  <- read_csv("occup_keyw.csv")

tb_result <- get_data(occup_group = "electrician", country = "Ireland", days = 14)

# binding results with other occupations
if (exists("tb_final")){
    tb_final <- bind_rows(tb_final, distinct(tb_result))
} else {
    tb_final <- tibble() |> bind_rows(distinct(tb_result))
}

# 3) Exporting table #####################################################

saveRDS(tb_final, file = "indeedIE.RDS")

# 4) Closing the server ##################################################
rsD$server$stop()
