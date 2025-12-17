#' Convert R code to a character vector of shell commands evaluating the given R code.
#'
#' The function takes R commands, deparses them, substitutes existing variables, and converts
#' everything to character strings, from which a shell command is created that sends the given
#' R code to the R interpreter. The function is used internally to print the commands of R rules
#' into the `Makefile`.
#'
#' @param ... R commands to be converted
#' @return A character vector of shell commands that send the given R code by pipe to the R
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
inShell <- function(...) {
  pf <- as.list(parent.frame())
  theDots <- eval(substitute(alist(...)))

  exprs <- lapply(theDots, function(e) {
    call <- substitute(substitute(e, pf), list(e=e))
    eval(call)
  })

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
    INDENT <- '    '  # 4 spaces for indentation
    exprs <- encodeString(exprs)
    # Check if the first line is "{" and last line is "}" (from compound expression)
    # When deparse() processes a compound expression like { x <- 1; y <- 2 },
    # it produces lines: "{", "    x <- 1", "    y <- 2", "}"
    # In this case, we keep the structure as-is since indentation is already present
    if (length(exprs) >= 2 && exprs[1] == "{" && exprs[length(exprs)] == "}") {
      exprs <- c('$(R) - <<EOFrmake',
                 exprs,
                 'EOFrmake')
    } else {
      # No compound expression, wrap with braces and add indentation
      exprs <- c('$(R) - <<EOFrmake',
                 '{',
                 paste0(INDENT, exprs),
                 '}',
                 'EOFrmake')
    }
  }
  exprs
}

