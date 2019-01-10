
# Goal is to add crosshatches to only eye_color_parent == "blue" where mixed_color == FALSE

library(tidyverse)

# ------------------------- Make some sample data --------------------------
raw <- starwars

# Make groups a bit more even
raw[1:2, ]$eye_color <- "red, blue"
raw[4:5, ]$eye_color <- "blue-gray"

dat <-
  raw %>%
  drop_na(eye_color) %>%
  filter(eye_color %in% c("black", "blue", "blue-gray", "red, blue")) %>%
  mutate(
    eye_color = eye_color %>% map_chr(dobtools::simple_cap),
    eye_color_parent =
      case_when(
        str_detect(eye_color, "[Bb]lue") ~ "Blue",
        TRUE ~ eye_color
      ),
    mixed_color =
      case_when(
        str_detect(eye_color, "[-,]") ~ "Yes",
        TRUE ~ "No"
      ) %>%
        factor() %>%
        fct_relevel(c("Yes", "No"))
  ) %>%
  select(name, eye_color, eye_color_parent, mixed_color)

# --------------------------------------------------------------------------

# -------------------------- Prep plot layers ------------------------------
layers <-
  list(
    geom_bar(aes(eye_color_parent, fill = eye_color, color = mixed_color)),
    theme_light(),
    scale_color_manual(values = c("blue", "black")),
    scale_fill_brewer(palette = 3, direction = -1),
    ggtitle("Eye color in Starwars characters"),
    labs(
      x = "Parent group eye color", y = "N",
      fill = "Child group eye color", colour = "Mixed eye color?"
    )
  )

# ---------------------------------------------------------------------------

# Add little +s

add_dots <- function(dat, gg_layers,
                     bar_num = 2, # Which bar to add to?
                     groups = c(3, 4), # Groups counted from top -> bottom, left -> right
                     n_rows = 12, # Num rows of dots
                     buffer_perc = 2, # Percent buffer around top, bottom, and sides
                     y_len = 0.16, # Length of vertical part of +
                     line_colour = "black",
                     line_size = 0.5,
                     line_type = 1,
                     alpha = NA) {
  plt <-
    dat %>%
    ggplot() +
    layers +
    # Random geom_segment to get template for plt_dat$data[[2]]
    geom_segment(aes(x = 0.5, y = 5, xend = 1, yend = 8))

  # Dump the underlying plot data
  plt_dat <-
    plt %>%
    ggplot_build()

  coord_dat <-
    plt_dat$data[[1]] %>%
    filter(
      x == bar_num,
      group %in% groups
    )
  
  x_coords <-
    coord_dat %>%
    select(xmin, xmax) %>%
    slice(1) # These should be identical because we're only looking at one bar, so take only the first

  y_coords <-
    coord_dat %>%
    # Find highest high and lowest low
    mutate(
      ymin = min(ymin),
      ymax = max(ymax)
    ) %>%
    slice(1)

  box_dims <-
    tibble(
      xmin = x_coords$xmin,
      xmax = x_coords$xmax,
      ymin = y_coords$ymin,
      ymax = y_coords$ymax,
      x_buffer = (xmax - xmin) * buffer_perc / 100,
      y_buffer = (ymax - ymin) * buffer_perc / 100
    )

  x_seq <- seq(box_dims$xmin + box_dims$x_buffer,
    box_dims$xmax - box_dims$x_buffer,
    by = box_dims$x_buffer
  )
  # Take only the even indices
  x_seq <- x_seq[which(seq(length(x_seq)) %% 2 == 0)]
  
  # This will get nested and apply to all rows
  y_seq <- seq(box_dims$ymin + box_dims$y_buffer,
               box_dims$ymax - box_dims$y_buffer,
               length.out = n_rows)

  horiz_lines <- tibble(
    x_starts = x_seq,
    x_ends = x_starts + box_dims$x_buffer,
    y_starts = y_seq %>% list(),
    y_ends = y_starts
  ) %>%
    unnest() %>% 
  mutate(
    x_starts =
      case_when(
        row_number() %% 2 != 0 ~ (x_starts - box_dims$x_buffer*0.75),
        TRUE ~ x_starts
      ),
    x_ends =
      case_when(
        row_number() %% 2 != 0 ~ (x_ends - box_dims$x_buffer*0.75),
        TRUE ~ x_ends
      )
  )

  vert_lines <-
    horiz_lines %>%
    mutate(
      x_starts = (x_starts + x_ends) / 2, # Find midpoint of x lines
      x_ends = x_starts,
      y_starts = y_starts + y_len / 2, # Half above the x, half below
      y_ends = y_ends - y_len / 2
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
      colour = line_colour,
      PANEL = 1,
      group = -1,
      size = line_size,
      linetype = line_type,
      alpha = alpha
    )

  # Replace our throwaway segment with segs
  plt_dat$data[[2]] <- segments

  # Get new plot
  ggplot_gtable(plt_dat) %>%
    plot()
}

add_dots(dat, gg_layers = layers, groups = c(3, 4))
add_dots(dat, gg_layers = layers, n_rows = 16, groups = c(2, 3))
