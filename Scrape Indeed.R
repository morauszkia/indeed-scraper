#Load libraries
library(RSelenium)
library(wdman)
library(openxlsx)
library(dplyr)

#Launching an automated web
port <- as.integer(4444L + rpois(lambda = 1000, 1))
pJS <- wdman::chrome(port = port)
remDrPJS <- remoteDriver(browserName = "chrome", port = port)
remDrPJS$open()
#setwd("/Users/ketevanikapanadze/chromedriver_mac64")

# Navigate countries websites 
remDrPJS$navigate('https://cz.indeed.com/')
# dont forget to accept cookies (if any)
#remDrPJS$navigate('https://de.indeed.com/')
#remDrPJS$navigate('https://nl.indeed.com/')
#remDrPJS$navigate('https://be.indeed.com/')
#remDrPJS$navigate('https://uk.indeed.com/')
#remDrPJS$navigate('https://ie.indeed.com/')
#remDrPJS$navigate('https://es.indeed.com/')
#remDrPJS$navigate('https://hu.indeed.com/')
#remDrPJS$navigate('https://ch.indeed.com/')

# Click and check the search-box
checkbox <- remDrPJS$findElement(using = 'xpath', "//input[@id='text-input-what']")
#checkbox$clickElement()
#checkbox$clearElement()

# Navigate occupations 
checkbox$sendKeysToElement(list('kuchař',key='enter'))
#checkbox$sendKeysToElement(list('Köche',key='enter'))

remDrPJS$findElement(using='xpath','//div[@class="slider_container css-8xisqv eu4oa1w0"]')$clickElement()

# MAIN CODE
########################################################################################################
########################################################################################################
# Avoid interacting with automated web while Selenium is running.......
########################################################################################################
########################################################################################################
# Function to find element and return text or NA in case of an error
getElementTextOrNA <- function(remDrPJS, xpath_expression) {
  tryCatch({
    element <- remDrPJS$findElement("xpath", xpath_expression)
    if (is.null(element)) {
      return(NA)
    } else {
      return(element$getElementText())
    }
  }, error = function(e) {
    return(NA)
  }, silent = TRUE)
}

# Initialize vectors to store location, company name, occupation, description, rating, salary and date
location <- character()
company <- character()
occupation <- character()
desc <- character()
rating <- character()
salary <- character()
date <- character()
salaryANDtype <- character()
type <- character()

while (TRUE) {
  for (i in 1:15) {
    # Use sprintf to create a dynamic XPath expression with index i 
    xpath_expression_company <- sprintf("(//span[contains(@class, 'companyName')])[%d]", i)
    company_data <- getElementTextOrNA(remDrPJS, xpath_expression_company)
    company <- c(company, company_data)
    
    xpath_expression_rating <- sprintf("(//span[contains(@class, 'ratingNumber')])[%d]", i)
    rating_data <- getElementTextOrNA(remDrPJS, xpath_expression_rating)
    rating <- c(rating, rating_data)
    
    xpath_expression_location <- sprintf("(//div[contains(@class, 'companyLocation')])[%d]", i)
    location_data <- getElementTextOrNA(remDrPJS, xpath_expression_location)
    location <- c(location, location_data)
    
    xpath_expression_occupation <- sprintf("(//h2[contains(@class, 'jobTitle css-1h4a4n5 eu4oa1w0')])[%d]", i)
    occupation_data <- getElementTextOrNA(remDrPJS, xpath_expression_occupation)
    occupation <- c(occupation, occupation_data)
    
    xpath_expression_desc <- sprintf("(//div[contains(@class, 'job-snippet')])[%d]", i)
    desc_data <- getElementTextOrNA(remDrPJS, xpath_expression_desc)
    desc <- c(desc, desc_data)
    
    xpath_expression_salary <- sprintf("(//div[contains(@class, 'metadata salary-snippet-container')])[%d]", i)
    salary_data <- getElementTextOrNA(remDrPJS, xpath_expression_salary)
    salary <- c(salary, salary_data)
    
    xpath_expression_type <- sprintf("(//div[contains(@class, 'metadata')])[%d]", i)
    type_data <- getElementTextOrNA(remDrPJS, xpath_expression_type)
    type <- c(type, type_data)
    
    xpath_expression_salaryANDtype <- sprintf("(//div[contains(@class, 'heading6 tapItem-gutter metadataContainer noJEMChips salaryOnly')])[%d]", i)
    salaryANDtype_data <- getElementTextOrNA(remDrPJS, xpath_expression_salaryANDtype)
    salaryANDtype <- c(salaryANDtype, salaryANDtype_data)
    
    
    xpath_expression_date <- sprintf("(//span[contains(@class, 'date')])[%d]", i)
    date_data <- getElementTextOrNA(remDrPJS, xpath_expression_date)
    date <- c(date, date_data)
  }
  
  #click next page
  remDrPJS$findElement(using='xpath','//a[@data-testid="pagination-page-next"]')$clickElement()
  
  #sleep for a short while to allow the new page to load
  Sys.sleep(1)
}


########################################################################################################
########################################################################################################
# Avoid interacting with automated web while Selenium is running.......
########################################################################################################
########################################################################################################

#Merge/clean data
location<-do.call(rbind.data.frame, location)
colnames(location) <- c("location")
company<-do.call(rbind.data.frame, company)
colnames(company) <- c("company")
occupation<-do.call(rbind.data.frame, occupation)
colnames(occupation) <- c("occupation")
desc<-do.call(rbind.data.frame, desc)
colnames(desc) <- c("desc")
rating<-do.call(rbind.data.frame, rating)
colnames(rating) <- c("rating")
salary<-do.call(rbind.data.frame, salary)
colnames(salary) <- c("salary")
date<-do.call(rbind.data.frame, date)
colnames(date) <- c("date")
salaryANDtype<-do.call(rbind.data.frame, salaryANDtype)
colnames(salaryANDtype) <- c("salaryANDtype")
type<-do.call(rbind.data.frame, type)
colnames(type) <- c("type")

# Final data 
all <-cbind(location, company, occupation, desc, rating, salary, date, type, salaryANDtype)
write.xlsx(all, file = "cook_cz.xlsx", rowNames = FALSE)



#NOTE:  
# In the main code, I pass the remDr client and the corresponding xpath_expression 
# for each element to the getElementTextOrNA function. This will ensure that 
# we handle errors properly and return "NA" when an element is not found or any other error occurs.
# for more details, please see Indeed Scraping_readme file 
#Load libraries
library(RSelenium)
library(wdman)
library(openxlsx)
library(dplyr)

#Launching an automated web
port <- as.integer(4444L + rpois(lambda = 1000, 1))
pJS <- wdman::chrome(port = port)
remDrPJS <- remoteDriver(browserName = "chrome", port = port)
remDrPJS$open()
#setwd("/Users/ketevanikapanadze/chromedriver_mac64")

# Navigate countries websites 
remDrPJS$navigate('https://cz.indeed.com/')
# dont forget to accept cookies (if any)
#remDrPJS$navigate('https://de.indeed.com/')
#remDrPJS$navigate('https://nl.indeed.com/')
#remDrPJS$navigate('https://be.indeed.com/')
#remDrPJS$navigate('https://uk.indeed.com/')
#remDrPJS$navigate('https://ie.indeed.com/')
#remDrPJS$navigate('https://es.indeed.com/')
#remDrPJS$navigate('https://hu.indeed.com/')
#remDrPJS$navigate('https://ch.indeed.com/')

# Click and check the search-box
checkbox <- remDrPJS$findElement(using = 'xpath', "//input[@id='text-input-what']")
#checkbox$clickElement()
#checkbox$clearElement()

# Navigate occupations 
checkbox$sendKeysToElement(list('kuchař',key='enter'))
#checkbox$sendKeysToElement(list('Köche',key='enter'))

remDrPJS$findElement(using='xpath','//div[@class="slider_container css-8xisqv eu4oa1w0"]')$clickElement()

# MAIN CODE
########################################################################################################
########################################################################################################
# Avoid interacting with automated web while Selenium is running.......
########################################################################################################
########################################################################################################
# Function to find element and return text or NA in case of an error
getElementTextOrNA <- function(remDrPJS, xpath_expression) {
  tryCatch({
    element <- remDrPJS$findElement("xpath", xpath_expression)
    if (is.null(element)) {
      return(NA)
    } else {
      return(element$getElementText())
    }
  }, error = function(e) {
    return(NA)
  }, silent = TRUE)
}

# Initialize vectors to store location, company name, occupation, description, rating, salary and date
location <- character()
company <- character()
occupation <- character()
desc <- character()
rating <- character()
salary <- character()
date <- character()
salaryANDtype <- character()
type <- character()

while (TRUE) {
  for (i in 1:15) {
    # Use sprintf to create a dynamic XPath expression with index i 
    xpath_expression_company <- sprintf("(//span[contains(@class, 'companyName')])[%d]", i)
    company_data <- getElementTextOrNA(remDrPJS, xpath_expression_company)
    company <- c(company, company_data)
    
    xpath_expression_rating <- sprintf("(//span[contains(@class, 'ratingNumber')])[%d]", i)
    rating_data <- getElementTextOrNA(remDrPJS, xpath_expression_rating)
    rating <- c(rating, rating_data)
    
    xpath_expression_location <- sprintf("(//div[contains(@class, 'companyLocation')])[%d]", i)
    location_data <- getElementTextOrNA(remDrPJS, xpath_expression_location)
    location <- c(location, location_data)
    
    xpath_expression_occupation <- sprintf("(//h2[contains(@class, 'jobTitle css-1h4a4n5 eu4oa1w0')])[%d]", i)
    occupation_data <- getElementTextOrNA(remDrPJS, xpath_expression_occupation)
    occupation <- c(occupation, occupation_data)
    
    xpath_expression_desc <- sprintf("(//div[contains(@class, 'job-snippet')])[%d]", i)
    desc_data <- getElementTextOrNA(remDrPJS, xpath_expression_desc)
    desc <- c(desc, desc_data)
    
    xpath_expression_salary <- sprintf("(//div[contains(@class, 'metadata salary-snippet-container')])[%d]", i)
    salary_data <- getElementTextOrNA(remDrPJS, xpath_expression_salary)
    salary <- c(salary, salary_data)
    
    xpath_expression_type <- sprintf("(//div[contains(@class, 'metadata')])[%d]", i)
    type_data <- getElementTextOrNA(remDrPJS, xpath_expression_type)
    type <- c(type, type_data)
    
    xpath_expression_salaryANDtype <- sprintf("(//div[contains(@class, 'heading6 tapItem-gutter metadataContainer noJEMChips salaryOnly')])[%d]", i)
    salaryANDtype_data <- getElementTextOrNA(remDrPJS, xpath_expression_salaryANDtype)
    salaryANDtype <- c(salaryANDtype, salaryANDtype_data)
    
    xpath_expression_date <- sprintf("(//span[contains(@class, 'date')])[%d]", i)
    date_data <- getElementTextOrNA(remDrPJS, xpath_expression_date)
    date <- c(date, date_data)
  }
  
  #click next page
  remDrPJS$findElement(using='xpath','//a[@data-testid="pagination-page-next"]')$clickElement()
  
  #sleep for a short while to allow the new page to load
  Sys.sleep(1)
}


########################################################################################################
########################################################################################################
# Avoid interacting with automated web while Selenium is running.......
########################################################################################################
########################################################################################################

#Merge/clean data
location<-do.call(rbind.data.frame, location)
colnames(location) <- c("location")
company<-do.call(rbind.data.frame, company)
colnames(company) <- c("company")
occupation<-do.call(rbind.data.frame, occupation)
colnames(occupation) <- c("occupation")
desc<-do.call(rbind.data.frame, desc)
colnames(desc) <- c("desc")
rating<-do.call(rbind.data.frame, rating)
colnames(rating) <- c("rating")
salary<-do.call(rbind.data.frame, salary)
colnames(salary) <- c("salary")
date<-do.call(rbind.data.frame, date)
colnames(date) <- c("date")
salaryANDtype<-do.call(rbind.data.frame, salaryANDtype)
colnames(salaryANDtype) <- c("salaryANDtype")
type<-do.call(rbind.data.frame, type)
colnames(type) <- c("type")

# Final data 
all <-cbind(location, company, occupation, desc, rating, salary, date, type, salaryANDtype)
write.xlsx(all, file = "cook_cz.xlsx", rowNames = FALSE)



#NOTE:  
# In the main code, I pass the remDr client and the corresponding xpath_expression 
# for each element to the getElementTextOrNA function. This will ensure that 
# we handle errors properly and return "NA" when an element is not found or any other error occurs.
# for more details, please see Indeed Scraping_readme file 
