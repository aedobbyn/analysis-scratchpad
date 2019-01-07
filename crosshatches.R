
# Goal is to add crosshatches to only eye_color_parent == "blue" where any_red == FALSE

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
    any_red =
      case_when(
        str_detect(eye_color, "red") ~ TRUE,
        TRUE ~ FALSE
      )
  ) %>%
  select(name, eye_color, eye_color_parent, any_red)

layers <-
  list(
    geom_bar(aes(eye_color_parent, fill = eye_color, color = any_red)),
    theme_light(),
    scale_color_manual(values = c("blue", "red")),
    scale_fill_brewer(palette = 3)
  )

(plt <-
  dat %>%
  ggplot() +
  layers +
  geom_segment(aes(x = 0.5, y = 5, xend = 1, yend = 5)) # Random geom_segment to get template
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
  pull(y)

seg_seq_end <-
  plt_dat$data[[1]] %>%
  filter(colour == "black") %>%
  arrange(desc(y)) %>%
  slice(1) %>%
  pull(y)

seg_seq <- seq(seg_seq_start, seg_seq_end, by = seg_sep)

segs <-
  tibble(
    colour = "black",
    x = 1.55,
    xend = 2.45,
    y = seg_seq,
    yend = seg_seq,
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

