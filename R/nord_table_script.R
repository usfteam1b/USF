library(tidyverse)
library(rvest)

ht <- "https://rarediseases.org/for-patients-and-families/information-resources/rare-disease-information/"


outputs <- paste0("https://rarediseases.org/?s=", LETTERS, "&post_type=rare-diseases" ) %>% 
  purrr::map(function(link){
    Sys.sleep(2)
    link %>% 
      rvest::read_html() %>% 
      html_nodes("a") %>% html_attr("href") %>% enframe() %>% 
      filter(grepl("https://rarediseases.org/rare-diseases/", value)) %>% 
      mutate(index = link) %>% 
      select(-name)
  })  




url_raredisease <-map2(outputs, LETTERS, 
       function(x, y) x %>% 
         mutate(id = y)
       ) %>%
  reduce(bind_rows)




source("R/get_nord_table.R")

headers <- url_raredisease %>% 
  #slice(1:10) %>% 
  pull(value) %>% 
  purrr::map(function(x) get_nord_table(x, 'h3'))

?possibly

get_nord_table_safely <- purrr::possibly(get_nord_table, NA)
content <- url_raredisease %>% 
#slice(1:10) %>% 
  pull(value) %>% 
  purrr::map(function(x) get_nord_table_safely(x, 'h4'))

