library(drake)

add <- function(a, b) {
  a + b
}

square <- function(x) {
  x ^ 2
}

plan <- 
  drake_plan(
    first = add(2, 3),
    second = square(first)
  )

make(plan)


# Use the target `first` as the sample size for this trigger
rand_is_even <- function(samp_size) {
  num <- sample(samp_size, 1)
  
  if (num %% 2 == 0) {
    TRUE
  } else {
    FALSE
  }
}

loadd(first)
rand_is_even(first)
rand_is_even(first)

plan <- 
  drake_plan(
    first = add(2, 3),
    second = target(
      command = square(first),
      trigger = trigger(
        condition = rand_is_even(first)
      )
    )
  )

make(plan)