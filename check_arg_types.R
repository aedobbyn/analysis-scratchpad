check_arg_types <- function(arg_names = c("origin_zip", "destination_zip"), check = "is.character") {
  args <- list(lapply(arg_names, get))
  
  if (any(purrr::map(args, check) == FALSE)) {
    bad <- args[which(purrr::map(args, check) == FALSE)] %>%
      stringr::str_c(collapse = ", ")
    stop(glue::glue("Argument {bad} is not of type character."))
  }
}
