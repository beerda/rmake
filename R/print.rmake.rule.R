#' @export
print.rmake.rule <- function(x, ...) {
  cat('(')
  cat(paste(x$depends, collapse=', '))
  cat(') -> ')
  cat(x$type)
  cat(' -> (')
  cat(paste(x$target, collapse=', '))
  cat(')')
}
