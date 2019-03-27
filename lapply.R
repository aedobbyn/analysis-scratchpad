
# list1 contains 2 elements: dataframe1 and dataframe2.
# ref_df is a 2x2 dataframe. The Name column has the names of the two dataframes from list1. The Values1 column has some values.
# 
# I want list2 to have the same dataframes as list1, but each dataframe will have a new column Values2, which 10 times the value from the Values1 column in the corresponding row of the ref_df dataframe.
# 
# I am struggling to tell the mutate how to grab the correct cell from ref_df.


# Desired output
list_2 <- 
  list(
    "Element1" = 
      dataframe1 %>% 
      mutate(Values2 = 10 * 100),
    
    "Element2" = 
      dataframe1 %>% 
      mutate(Values2 = 10 * 200)
  )




suppressPackageStartupMessages(library(tidyverse))

dataframe1 <- data.frame("col_1" = c("a", "b", "c"), "col_2" = c("d", "e", "f"))
dataframe2 <- data.frame("col_1" = c("g", "h", "i"), "col_2" = c("x", "y", "z"))
ref_df <- data.frame("Name" = c("Element1", "Element2"), "Values1" = c(100, 200))

list1 <- list("Element1" = dataframe1, "Element2" = dataframe2)


list1 %>% 
  map2_df(names(list1), ~ mutate(.x, element_name = .y)) %>% 
  left_join(ref_df, by = c("element_name" = "Name")) %>% 
  mutate(Values2 = Values1 * 10)


attach_value_2 <- function(lst = list1, ref = ref_df) {
  for (i in seq_along(lst)) {
    nm <- names(lst[i])
    
    val <- ref %>% 
      filter(Name == nm) %>% 
      pull(Values1)
    
    lst[[i]] <- 
      lst[[i]] %>% 
        mutate(Values2 = val)
  }
  
  lst
}

attach_value_2()




