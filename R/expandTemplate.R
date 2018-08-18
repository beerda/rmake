#' Expand template rules into a list of rules by replacing `rmake` variables with their values
#'
#' Take a template job (i.e., a list of template rules), or a template rule, and create a job (or rule)
#' from them by replacing `rmake` variables in the template with their values. The `rmake` variable
#'  is a identified by the `$[VARIABLE_NAME]` string anywhere in the definition of a rule.
#'
#' If `vars` is a character vector then all variables in `vars` are replaced in `template` so that
#' the result will contain `length(template)` rules. If `vars` is a data frame or a character
#' matrix then the replacement of variables is performed row-wisely. That is, a new sequence of rules is
#' created from `template` for each row of variables in `vars` so that the result will contain
#' `nrow(vars) * length(template)` rules.
#'
#' @param template An instance of the S3 `rmake.rule` class or a list of such objects.
#' @param vars A named character vector, matrix, or data frame with variable definitions.
#'   For character vector, names are variable names, values are variable values. For matrix or
#'   data frame, colnames are variable names and column values are variable values.
#' @return A list of rules created from `template` by replacing `rmake` variables.
#' @seealso [replaceVariables()], [rule()]
#' @author Michal Burda
#' @examples
#' tmpl <- rRule('data-$[VERSION].csv', 'process-$[TYPE].R', 'output-$[VERSION]-$[TYPE].csv')
#'
#' job <- expandTemplate(tmpl, c(VERSION='small', TYPE='a'))
#' # is equivalent to
#' job <- list(rRule('data-small.csv', 'process-a.R', 'output-small-a.csv'))
#'
#' job <- expandTemplate(tmpl, expand.grid(VERSION=c('small', 'big'), TYPE=c('a', 'b', 'c')))
#' # is equivalent to
#' job <- list(rRule('data-small.csv', 'process-a.R', 'output-small-a.csv'),
#'             rRule('data-big.csv', 'process-a.R', 'output-big-a.csv'),
#'             rRule('data-small.csv', 'process-b.R', 'output-small-b.csv'),
#'             rRule('data-big.csv', 'process-b.R', 'output-big-b.csv'),
#'             rRule('data-small.csv', 'process-c.R', 'output-small-c.csv'),
#'             rRule('data-big.csv', 'process-c.R', 'output-big-c.csv'))
#' @export
expandTemplate <- function(template, vars) {
  if (is.rule(template)) {
    template <- list(template)
  }
  assert_that(is.list(template))
  assert_that(all(vapply(template, is.rule, logical(1L))))

  if (is.data.frame(vars)) {
    assert_that(!is.null(colnames(vars)))
    vars <- as.matrix(vars)
    mode(vars) <- 'character'
  } else if (is.atomic(vars)) {
    assert_that(!is.null(names(vars)))
    vars <- t(as.matrix(vars))
    mode(vars) <- 'character'
  }
  assert_that(is.matrix(vars) && is.character(vars))
  assert_that(!is.null(colnames(vars)))

  res <- list()
  for (i in seq_len(nrow(vars))) {
    for (r in template) {
      rule <- r
      for (n in names(rule)) {
        if (is.character(rule[[n]])) {
          rule[[n]] <- replaceVariables(rule[[n]], vars[i, ])
        }
      }
      res <- c(res, list(rule))
    }
  }
  res
}

