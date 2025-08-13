#' Expand template rules into a list of rules by replacing `rmake` variables with their values
#'
#' The functionality of `expandTemplate()` differs accordingly to the type of the first argument.
#' If the first argument is a template job (i.e., a list of template rules), or a template rule,
#' then a job is created from templates by replacing `rmake` variables in templates with values
#' of these variables, as specified in the second argument.
#' The `rmake` variable is a part of a string in the format
#' of `$[VARIABLE_NAME]`.
#'
#' If `vars` is a character vector then all variables in `vars` are replaced in `template` so that
#' the result will contain `length(template)` rules. If `vars` is a data frame or a character
#' matrix then the replacement of variables is performed row-wisely. That is, a new sequence of rules is
#' created from `template` for each row of variables in `vars` so that the result will contain
#' `nrow(vars) * length(template)` rules.
#'
#' If the first argument of `expandTemplate()` is a character vector then the result is a character
#' vector created by row-wise replacements of `rmake` variables, similarly as in the case of template jobs.
#' See examples.
#'
#' @param template An instance of the S3 `rmake.rule` class, or a list of such objects, or a character
#'   vector.
#' @param vars A named character vector, matrix, or data frame with variable definitions.
#'   For character vector, names are variable names, values are variable values. For matrix or
#'   data frame, colnames are variable names and column values are variable values.
#' @return If `template` is an instance of the S3 `rmake.rule` class, or a list of such objects,
#'   a list of rules created from `template` by replacing `rmake` variables is returned.
#'   If `template` is a character vector then a character vector with all variants of `rmake` values
#'   is returned.
#' @seealso [replaceVariables()], [rule()]
#' @author Michal Burda
#' @examples
#' # Examples with template jobs and rules:
#'
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
#'
#'
#' # Examples with template character vectors:
#' expandTemplate('data-$[MAJOR].$[MINOR].csv',
#'                c(MAJOR=3, MINOR=1))
#' # returns: c('data-3.1.csv')
#'
#' expandTemplate('data-$[MAJOR].$[MINOR].csv',
#'                expand.grid(MAJOR=c(3:4), MINOR=c(0:2)))
#' # returns: c('data-3.0.csv', 'data-4.0.csv',
#' #            'data-3.1.csv', 'data-4.1.csv',
#' #            'data-3.2.csv', 'data-4.2.csv')
#'
#' @export
expandTemplate <- function(template, vars) {
  if (is.data.frame(vars)) {
    assert_that(!is.null(colnames(vars)))
    if (!all(vapply(vars,
                    function(x) { is.character(x) || is.factor(x) },
                    logical(1L)))) {
      warning("Converting all values in `vars` to character vectors.")
    }
    vars <- lapply(vars, as.character)
    vars <- as.data.frame(vars)
    vars <- as.matrix(vars)
    mode(vars) <- 'character'
  } else if (is.atomic(vars)) {
    assert_that(!is.null(names(vars)))
    vars <- t(as.matrix(vars))
    mode(vars) <- 'character'
  }
  assert_that(is.matrix(vars) && is.character(vars))
  assert_that(!is.null(colnames(vars)))

  res <- NULL
  if (is.character(template)) {
    res <- character()
    for (i in seq_len(nrow(vars))) {
      res <- c(res,
               replaceVariables(template, vars[i, ]))
    }
    res <- lapply(seq_len(nrow(vars)),
                  function(i) {
                    replaceVariables(template, vars[i, ])
                  })
    res <- unlist(res)

  } else {
    if (is.rule(template)) {
      template <- list(template)
    }
    assert_that(is.list(template))
    assert_that(all(vapply(template, is.rule, logical(1L))))

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
  }

  unique(res)
}

