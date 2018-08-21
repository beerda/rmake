.getter <- function(name) {
  function(job) {
    res <- NULL
    if (is.rule(job)) {
      res <- job[[name]]
    } else {
      assert_that(is.list(job))
      assert_that(all(vapply(job, is.rule, logical(1))))
      res <- unlist(lapply(job, function(r) r[[name]]))
    }
    unique(res)
  }
}


#' Return given set of properties of all rules in a list
#'
#' `targets()` returns a character vector of all unique values of `target` properties,
#' `prerequisites()` returns `depends` and `script` properties,
#'  and `tasks()` returns `task` properties of the given [rule()] or list of rules.
#'
#'  `terminals()` returns only such targets that are not prerequisites to any other rule.
#'
#' @param job An instance of the `rmake.rule` class or a list of such instances
#' @return A character vector of unique values of the selected property obtained from all rules in `job`
#' @seealso [rule()]
#' @author Michal Burda
#' @examples
#' job <- 'data.csv' %>>%
#'   rRule('process.R', task='basic') %>>%
#'   'data.rds' %>>%
#'   markdownRule('report.Rnw', task='basic') %>>%
#'   'report.pdf'
#'
#' prerequisites(job)    # returns c('process.R', data.csv', 'report.Rnw', 'data.rds')
#' targets(job)          # returns c('data.rds', 'report.pdf')
#' tasks(job)            # returns 'basic'
#' @export
#' @aliases getters
prerequisites <- .getter('depends')


#' @rdname prerequisites
#' @export
targets <- .getter('target')


#' @rdname prerequisites
#' @export
tasks <- .getter('task')


#' @rdname prerequisites
#' @export
terminals <- function(job) {
  setdiff(targets(job), prerequisites(job))
}
