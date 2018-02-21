#' Check if the argument is a valid rule object.
#'
#' Function tests whether `x` is a valid rule object, i.e., whether
#' it is list a list and inherits from the `rmake.rule` S3 class. Instances
#' of `rule` represent an atomic building unit, i.e. a command that
#' has to be executed, which optionally depends on some files or other
#' rules -- see [rule()] for more details.
#'
#' @param x An argument to be tested
#' @return `TRUE` if `x` is a valid rule object and `FALSE` otherwise.
#' @author Michal Burda
#' @seealso [rule()], [makefile()], [rRule()], [markdownRule()], [offlineRule()]
#' @export
is.rule <- function(x) {
  is.list(x) && inherits(x, 'rmake.rule')
}

#' @importFrom assertthat on_failure
assertthat::on_failure(is.rule) <- function(call, env) {
  paste0(deparse(call$x), " is not a rule (a 'rmake.rule' class list)")
}
