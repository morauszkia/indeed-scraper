scrape_occupation <- function(occupation, remDr, df) {
  inputField <- remDr$findElement(using = 'xpath', "//input[@id='text-input-what']")
  checkbox$sendKeysToElement(list(occupation, key='enter'))
  
}