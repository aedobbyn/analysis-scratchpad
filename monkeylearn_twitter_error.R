
library(monkeylearn)
library(magrittr)
tweets <- rtweet::search_tweets("foo", n = 5)
monkey_classify(tweets, text, classifier_id = "cl_qkjxv9Ly", texts_per_req = 2) %>% 
  dplyr::select(status_id, text, confidence, category_id, probability, label)


library(monkeylearn)
tweets <- rtweet::search_tweets("foo", n = 5)
monkey_classify(tweets, text, classifier_id = "cl_qkjxv9Ly", texts_per_req = 2) 