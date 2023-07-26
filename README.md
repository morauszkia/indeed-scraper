# IndeedScraping 🖱️
Let's dive into the code in more detail 🕵️‍♀️ 
You can find below a detailed breakdown of the code's functionality, explaining how it performs web scraping to collect job information from the Indeed website, e.g., for the occupation "kuchař" (cook) in the Czech Republic.


1. The code starts by loading necessary R packages (`RSelenium`, `wdman`, `openxlsx`, and `dplyr`) to support web scraping and data manipulation.

2. It then sets up an automated web browser (Google Chrome) using `RSelenium` and assigns a random port number to it.

3. The script navigates to the Czech Republic's Indeed website (https://cz.indeed.com/), which is the target website for job scraping.

4. Before performing the job search, the script has commented lines to navigate to other country-specific Indeed websites (Germany, Netherlands, Belgium, UK, Ireland, Spain, Hungary, and Switzerland). These lines can be uncommented to scrape data from those countries as well.

5. The script locates the search box on the website using its XPath expression and enters the search term "kuchař" (which means "cook" in Czech) into the search box. Then, it simulates pressing the "Enter" key to initiate the search.

6. The main part of the code is inside a `while (TRUE)` loop, meaning it will continue running indefinitely until manually stopped. The purpose of this loop is to keep scraping multiple pages of job listings.

7. Within the loop, the code iterates over the job listings on the current page (up to 15 listings) and collects the following information for each job:

   - `company`: The name of the hiring company.
   - `rating`: The job rating (if available). Note: Some job listings may not have a rating, so it will be `NA`.
   - `location`: The location of the job.
   - `occupation`: The job title or occupation (in this case, "kuchař").
   - `desc`: A short description of the job.
   - `type`: Type of employment, full-time or part-time. Note: Some job listings may not have salary information, so it will be `NA`.
   - `salary`: The salary information (if available). Note: Some job listings may not have salary information, so it will be `NA`.
   - `salaryANDtype`: type+salary. 
   - `date`: The posting date of the job.

8. To extract this information from each job listing, the script uses various XPath expressions for each element on the page. The `getElementTextOrNA` function is created to handle the extraction. If an element is not found or any error occurs during extraction, it returns `NA`.

9. After extracting the data from one page of job listings, the script clicks the "Next" button to move to the next page. A short pause of 1 second (`Sys.sleep(1)`) is added to allow the new page to load before proceeding with scraping.

10. The loop continues this process of scraping data from multiple pages until manually stopped.

11. Once the scraping process is complete, the code proceeds to merge the separate vectors (`company`, `rating`, `location`, `occupation`, `desc`, `salary`, `type`,`salaryANDtype`, and `date`) into a single data frame named `all`.

12. Finally, the script writes the collected data to an Excel file named "cook_cz.xlsx" using the `write.xlsx` function from the `openxlsx` package. 
