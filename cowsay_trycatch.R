color <- tryCatch(
  crayon::make_style(color), 
  error = function(e) {
    message(e$message)
    return(say("sad", by = "cat"))
  },
  finally = return())