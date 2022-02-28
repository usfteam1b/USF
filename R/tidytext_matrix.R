nord_list_disease %>% nord_list_disease <- read_csv("data-raw/nord_list_disease.csv")

nord_list_disease %>% slice(1:10) %>% 
  View()

library(tm)
library(tidytext)
nord_list_disease %>% slice(1:10) %>% 
  tidy()

nord_list_disease_bigrams <- nord_list_disease %>% 
  #slice(1:10) %>% 
  unnest_tokens(word, value, token = "ngrams", n = 2)

nord_list_disease_onegrams <- nord_list_disease %>% 
  #slice(1:10) %>% 
  unnest_tokens(word, value, token = "ngrams", n = 1)


nord_list_disease_onegrams_df_idf <- nord_list_disease_onegrams %>% 
  count(disease, word, sort = TRUE) %>%
  bind_tf_idf(term = word, document = disease, n) %>%
  group_by(disease) %>% 
  arrange((tf_idf)) 

nord_list_disease_bigrams_bigrams <- nord_list_disease_bigrams %>% 
  count(disease, word, sort = TRUE) %>%
  bind_tf_idf(term = word, document = disease, n) %>%
  group_by(disease) %>% 
  arrange(desc(tf_idf)) 


nord_list_disease_onegrams_df_idf %>% 
  group_by(disease) %>%
  arrange(desc(disease))


nord_list_disease_onegrams_df_idf %>% 
  group_by(disease) %>% 
  top_frac(0.3) %>% 
  arrange(disease, desc(tf_idf))
