url_raredisease %>% 
  slice(1) %>% 
  pull(value) %>% 
  rvest::read_html() %>% 
  html_nodes("h4") 


url_raredisease %>% 
  slice(1) %>% 
  pull(value) %>% 
  rvest::read_html() %>% 
  html_nodes("h3") %>% html_text()


url_raredisease %>% 
  slice(1) %>% 
  pull(value) %>% 
  rvest::read_html() %>% 
  html_nodes("h4")

url_raredisease %>% 
  slice(1) %>% 
  pull(value) %>% 
  rvest::read_html() %>% 
  html_nodes("p") %>% html_text() %>% enframe() %>% 
  mutate(characters = nchar(value))



get_nord_data <- function(url){
  Sys.sleep(0.1)
  url %>% 
    rvest::read_html() %>% 
    html_nodes("p") %>% 
    html_text() %>%
    enframe() %>% 
    mutate(characters = nchar(value))
}

nord_list <-  
  url_raredisease %>% 
  #slice(1:10) %>% 
  pull(value) %>% purrr::map(get_nord_data)

disease_list <- url_raredisease %>% 
  mutate(disease = str_remove(value, "https://rarediseases.org/rare-diseases/")) %>%
  mutate(disease = str_remove(disease, "/")) %>%
  mutate(disease = str_replace_all(disease, "-", " ")) %>% pull(disease)
nord_list_disease <- purrr::map2(.x = nord_list, .y = disease_list,  function(x, y) {
  x %>% filter(characters > 400) %>% pull(value) %>% paste(collapse = "\\s")
} %>% enframe() %>% mutate(disease = y)  )

nord_list_disease <- nord_list_disease %>% reduce(bind_rows)


nord_list_disease %>% select(disease, value) %>% write_csv("nord_list_disease.csv")



View(nord_list_disease[1, ] )
