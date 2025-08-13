#' Escape spaces in a string as needed in file names used in Makefile files
#'
#' @param x A character vector to be sanitized
#' @return A character vector with spaces replaced by `\ `
#' @author Michal Burda
#' @export
sanitizeSpaces <- function(x) {
  gsub(" ", "\\ ", x, fixed=TRUE)
}
