#' Not In
#'
#' @description Shortcut for !x %in% y
#' @param ... Dots
#' @param lhs Left hand side object
#' @param rhs Right hand side object
#' @usage lhs \%notin\% rhs
#' @export
#'
#' @examples
#' mtcars$gear[mtcars$gear %notin% 3]
#'

`%notin%` <- Negate(`%in%`)


