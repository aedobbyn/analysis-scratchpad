
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


box_dims <- 
  tibble(
    xmin = 1.55,
    xmax = 2.45,
    ymin = 0, 
    ymax = 6
  )

n_rows <- 8

x_seq <- seq(box_dims$xmin + 0.01, box_dims$xmax - 0.01, by = 0.01)
# Take only the even indices
x_seq <- x_seq[which(seq(length(x_seq)) %% 2 == 0)]

horiz_lines <- tibble(
  x_starts = x_seq,
  x_ends = x_starts + 0.01,
  y_starts = seq(box_dims$ymin + 0.3, box_dims$ymax - 0.3, length.out = n_rows) %>% 
    list(),
  y_ends = y_starts 
) %>% 
  unnest()

vert_lines <- 
  horiz_lines %>% 
  mutate(
    x_starts = (x_starts + x_ends)/2,
    x_ends = x_starts,
    y_starts = y_starts + 0.08,
    y_ends = y_ends - 0.08
  )

lines <- 
  bind_rows(horiz_lines, vert_lines)

segments <-
  lines %>% 
  rename(
    x = x_starts,
    xend = x_ends,
    y = y_starts,
    yend = y_ends
  ) %>% 
  mutate(
    colour = "black",
    PANEL = 1,
    group = -1,
    size = 0.5,
    linetype = 1,
    alpha = NA
  )
  
# Replace our throwaway segment with segs
plt_dat$data[[2]] <- segments

# Get new plot
ggplot_gtable(plt_dat) %>%
  plot()

