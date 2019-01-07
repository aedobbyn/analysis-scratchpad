
library(tidyverse)

foo <- 
  starwars %>% 
  drop_na(eye_color) %>% 
  filter(eye_color %in% c("black", "blue", "blue-gray", "red, blue")) %>% 
  mutate(eye_color_parent = 
           case_when(str_detect(eye_color, "blue") ~ "blue",
                     TRUE ~ eye_color),
         any_red = 
           case_when(str_detect(eye_color, "red") ~ TRUE,
                     TRUE ~ FALSE)
         ) %>% 
  select(name, eye_color, eye_color_parent, any_red)

bar <- 
  foo %>% 
  group_by(eye_color, eye_color_parent, any_red) %>% 
  count()

layers <-
  list(
      theme_light(),
      scale_color_manual(values = c("black", "blue")),
      scale_fill_brewer(palette = 3)
  )

(foo_plt <- 
  foo %>% 
    ggplot() +
    geom_bar(aes(eye_color_parent, fill = eye_color, color = any_red)) +
    layers +
    # geom_hline(yintercept = 4) +
    geom_segment(aes(x = 0.5, y = 5, xend = 1, yend = 5)) +
    geom_segment(aes(x = 1.55, y = 10, xend = 2, yend = 10))
  )

bar %>% 
  ggplot() +
  geom_bar(aes(eye_color_parent, n, 
               fill = eye_color, color = any_red), stat = "identity") +
  layers +
  geom_segment(aes(x = 0.5, y = 5, xend = 1, yend = 5))


foo_plt_dat <- 
  foo_plt %>% ggplot_build()


foo_plt_dat$data

foo_plt_dat$data[[2]]$yintercept <- 10
foo_plt_dat$data[[2]]$xmin <- 0.55
foo_plt_dat$data[[2]]$xmax <- 1.55


hlines <- 
  tibble(
    yintercept = 2:21
  ) %>% 
  mutate(
    PANEL = 1,
    group = -1,
    colour = "black",
    size = 0.5,
    linetype = 1,
    alpha = NA
  )

foo_plt_dat$data[[2]] <- hlines

segs <- 
  tibble(
    colour = "black",
    x = 2,
    xend = 3,
    y = 2:21,
    yend = 2:21
  ) %>% 
  mutate(
    PANEL = 1,
    group = -1,
    size = 0.5,
    linetype = 1,
    alpha = NA
  )


foo_plt_dat$data[[2]] <- segs

ggplot_gtable(foo_plt_dat) %>% plot()












pattern.type<-c('hdashes', 'blank', 'crosshatch')
pattern.color=c('black','black', 'black')
background.color=c('white','white', 'white')
density<-c(20, 20, 10)

patternbar(foo, eye_color, eye_color_parent, group = eye_color_parent, pattern.type=pattern.type,
           pattern.color=pattern.color, background.color=background.color,
           pattern.line.size=0.5,frame.color=c('black', 'black', 'black'), density=density)


library("ggplot2")
library("gridSVG")
library("gridExtra")
library("dplyr")
library("RColorBrewer")

dfso <- structure(list(Sample = c("S1", "S2", "S1", "S2", "S1", "S2"), 
                       qvalue = c(14.704287341, 8.1682824035, 13.5471896224, 6.71158432425, 
                                  12.3900919038, 5.254886245), type = structure(c(1L, 1L, 2L, 
                                                                                  2L, 3L, 3L), .Label = c("A", "overlap", "B"), class = "factor"), 
                       value = c(897L, 1082L, 503L, 219L, 388L, 165L)), class = c("tbl_df", 
                                                                                  "tbl", "data.frame"), row.names = c(NA, -6L), .Names = c("Sample", 
                                                                                                                                           "qvalue", "type", "value"))

cols <- brewer.pal(7,"YlOrRd")
pso <- ggplot(dfso)+
  geom_bar(aes(x = Sample, y = value, fill = qvalue), width = .8, colour = "black", stat = "identity", position = "stack", alpha = 1)+
  ylim(c(0,2000)) + 
  theme_classic(18)+
  theme( panel.grid.major = element_line(colour = "grey80"),
         panel.grid.major.x = element_blank(),
         panel.grid.minor = element_blank(),
         legend.key = element_blank(),
         axis.text.x = element_text(angle = 90, vjust = 0.5))+
  ylab("Count")+
  scale_fill_gradientn("-log10(qvalue)", colours = cols, limits = c(0, 20))
