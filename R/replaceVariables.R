#' Replace `rmake` variables in a character vector
#'
#' This function searches for all `rmake` variables in given vector `x` and replaces them
#' with their values that are defined in the `vars` argument. The `rmake` variable is a identified
#' by the `$[VARIABLE_NAME]` string.
#'
#' @param x A character vector where to replace the `rmake` variables
#' @param vars A named character vector with variable definitions (names are variable names, values
#'   are variable values)
#' @return A character vector with `rmake` variables replaced with their values
#' @seealso [expandTemplate()]
#' @author Michal Burda
#' @examples
#' vars <- c(SIZE='small', METHOD='abc')
#' replaceVariables('result-$[SIZE]-$[METHOD].csv', vars)   # returns 'result-small-abc.csv'
#'
#' @export
replaceVariables <- function(x, vars) {
  assert_that(is.character(x))
  assert_that(is.character(vars))
  assert_that(!is.null(names(vars)))

  res <- x
  for (n in names(vars)) {
    res <- gsub(paste0('$[', n, ']'), vars[n], res, fixed=TRUE)
  }
  res
}

