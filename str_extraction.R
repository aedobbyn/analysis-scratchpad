
library(tidyverse)

dat <- 
  tibble(
    x = c(
      "00001 - stuff - more stuff",
      "0987 - asdf - jkl;",
      "123456789 - dododooooooo",
      "only words - here"
    )
  ) 

dat %>% 
  mutate(
    code = str_extract(x, "[0-9]+"),
    descrip = str_extract(x, "[A-Za-z- ]+") %>% 
      str_remove_all("[-]+") %>% 
      trimws()
  )
