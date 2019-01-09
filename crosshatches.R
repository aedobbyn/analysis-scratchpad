
# Goal is to add crosshatches to only eye_color_parent == "blue" where mixed_color == FALSE

library(tidyverse)

raw <- starwars

# Make groups a bit more even
raw[1:2, ]$eye_color <- "red, blue"
raw[4:5, ]$eye_color <- "blue-gray"

dat <-
  raw %>%
  drop_na(eye_color) %>%
  filter(eye_color %in% c("black", "blue", "blue-gray", "red, blue")) %>%
  mutate(
    eye_color_parent =
      case_when(
        str_detect(eye_color, "blue") ~ "blue",
        TRUE ~ eye_color
      ),
    mixed_color =
      case_when(
        str_detect(eye_color, "[-,]") ~ TRUE,
        TRUE ~ FALSE
      )
  ) %>%
  select(name, eye_color, eye_color_parent, mixed_color)

layers <-
  list(
    geom_bar(aes(eye_color_parent, fill = eye_color, color = mixed_color)),
    theme_light(),
    scale_color_manual(values = c("blue", "red")),
    scale_fill_brewer(palette = 3)
  )

(plt <-
  dat %>%
  ggplot() +
  layers +
  geom_segment(aes(x = 0.5, y = 5, xend = 1, yend = 8)) # Random geom_segment to get template
)

# Dump the underlying plot data
plt_dat <-
  plt %>%
  ggplot_build()

# Check out data
plt_dat$data

# Create segments
seg_sep <- 0.3 

seg_seq_start <-
  plt_dat$data[[1]] %>%
  filter(colour == "blue") %>%
  arrange(ymin) %>% 
  pull(ymin) %>% 
  first()

seg_seq_end <-
  plt_dat$data[[1]] %>%
  filter(colour == "red") %>%
  arrange(desc(y)) %>%
  slice(1) %>%
  pull(y)

m <- 0.5

y2 <- 6
x2 <- 2.45
x1 <- 1.45
# (6 - y1) / (2.45 - 1.55) = m
y1 <- -1 * ((m * (x2 - x1)) - y2)

y_step <- y2 - y1
y3 <- y2 - y_step

b2 <- y2 - m*x2
b1 <- y1 - m*x1

# w2 <- (y2 - b2)/m
# w1 <- (y1 - b1)/m



y_start <- seq(seg_seq_start - y_step, seg_seq_end - y_step, by = seg_sep)
y_end <- seq(seg_seq_start, seg_seq_end, by = seg_sep)

# Take out ones where leftmost y val will be less than 0
y_start <- y_start[which(y_start >= 0)] 

seg_diff <- length(y_end) - length(y_start)

y_end <- y_end[seg_diff + 1:length(y_start)] %>% 
  c(rep(6, seg_diff))

x_ends_new <- seq(1.55, 2.45, 0.3)
# len_x_ends_new <- length(x_ends_new)
x_end <- rep(2.45, length(y_start)) %>% c(x_ends_new)

y_start <- seq(seg_seq_start, seg_seq_end, by = seg_sep)

segs <-
  tibble(
    colour = "black",
    x = 1.55,
    xend = x_end %>% sort(),
    y = y_start %>% sort(),
    yend = y_end %>% sort(),
    PANEL = 1,
    group = -1,
    size = 0.5,
    linetype = 1,
    alpha = NA
  )

# Replace our throwaway segment with segs
plt_dat$data[[2]] <- segs

# Get new plot
ggplot_gtable(plt_dat) %>%
  plot()

