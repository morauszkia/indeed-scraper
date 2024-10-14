library(RSelenium)
library(netstat)

create_remote_client <- function(version = "126.0.6478.126") {
  rs_driver_object <- rsDriver(browser = "chrome",
                               chromever = version,
                               verbose = F,
                               port = free_port())
  
  return(rs_driver_object$client)
}