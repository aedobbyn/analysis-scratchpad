
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

seg_seq_1 <- seq(seg_seq_start, seg_seq_end, by = seg_sep)
seg_seq_2 <- seq(seg_seq_start + 1, seg_seq_end + 1, by = seg_sep)

segs <-
  tibble(
    colour = "black",
    x = 1.55,
    xend = 2.45,
    y = seg_seq_1,
    yend = seg_seq_2,
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

