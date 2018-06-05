#' Convert R code to the character vector of shell commands evaluating the given R code.
#'
#' The function takes R commands, deparses them, substitutes existing variables, and converts
#' everything to character strings, from which a shell command is created that sends the given
#' R code to the R interpreter. Function is used internally to print the commands of R rules
#' into `Makefile`.
#'
#' @param ... R commands to be converted
#' @return  A character vector of shell commands, which send the given R code by pipe to the R
#' interpreter
#' @author Michal Burda
#' @seealso [rRule()], [markdownRule()]
#' @examples
#' inShell({
#'   x <- 1
#'   y <- 2
#'   print(x+y)
#' })
#' @export
#' @importFrom pryr dots
#' @importFrom pryr substitute_q
inShell <- function(...) {
  f <- as.list(parent.frame())
  exprs <- lapply(dots(...), function(e) {
    substitute_q(e, f)
  })
  #exprs <- as.character(exprs)

  ctrl <- c('keepInteger', 'showAttributes', 'useSource', 'warnIncomplete', 'keepNA')
  if (getRversion() > '3.4.4') {
    ctrl <- c(ctrl, 'niceNames')
  }
  exprs <- lapply(exprs, function(e) {
    deparse(e,
            width.cutoff=500L,
            control=ctrl)
  })

  exprs <- unlist(exprs)
  if (length(exprs) > 0) {
    last <- length(exprs)
    notLast <- seq_len(last-1)
    exprs <- encodeString(exprs)
    exprs <- paste0('-e \'', exprs, '\'')
    exprs[1] <- paste0('$(R) ', exprs[1])
    exprs[notLast] <- paste0(exprs[notLast], ' \\')
  }
  exprs
}

