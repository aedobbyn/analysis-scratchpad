
# gmailr

library(gmailr)
library(ggplot2)
library(here)
library(xtable)

email <- "amanda.e.dobbyn@gmail.com"

gmail_auth()

ggplot(mtcars) +
  geom_point(aes(carb, mpg))
ggsave(filename = here("plt.png"), device = "png")

msg_body <- print(xtable(mtcars), type="html")

msg <- 
  mime() %>%
  to(email) %>%
  from(email) %>% 
  html_body(msg_body) %>%
  attach_part(msg_body) %>%
  attach_file(here("plt.png"))

send_message(msg)
