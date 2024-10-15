library(glue)

scrape_ad <- function(ad_number, remDr){
  
  # function to get element for each ad
  get_element_test <- function(tag, class, index){
    element <- remDr$findElement(
      using = 'xpath', 
      value = glue("//{tag}[contains(@class, '{class}')][{index}]"))
    
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