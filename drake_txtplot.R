options(crayon.enabled = TRUE)
old.hooks <- fansi::set_knit_hooks(knitr::knit_hooks)

library(crayon)
library(drake)
library(txtplot)

data <- function(...) {123}
munge <- function(...) {123}
plan <- drake_plan(
  x = data(),
  y = target(munge(x, i), transform = map(i = !!seq_len(100))),
  z = target(y, transform = combine(y))
)

make(plan, verbose = 0L)
config <- drake_config(plan)
nodes <- drake_graph_info(config)$nodes
nodes$id <- paste0(nodes$id)
nodes$pch <- purrr::map2_chr(
  .x = nodes$id,
  .y = nodes$color,
  function(id, color) {
    pad <- rep("\b", nchar(id) - 1)
    chars <- c(pad, id)
    label <- paste(chars, collapse = "")
    crayon::make_style(color, bg = TRUE)(label)
  }
)

txtplot(x = nodes$x, y = nodes$y, pch = nodes$pch)