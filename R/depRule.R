#' A rule that defines a dependency between targets without actually providing
#' any execution script.
#'
#' This rule is useful when you want to specify that a target depends on
#' another target, but you do not want to execute any script to build it.
#'
#' @param target Target file name that depends on `depends`
#' @param depends A character vector of prerequisite file names that `target` depends on.
#' @param task A character vector of parent task names. The mechanism of tasks
#'     allows to group rules. Anything different from `'all'` will
#'     cause creation of a new task depending on the given rule.
#'     Executing `make taskname` will then force building of this rule.
#' @return Instance of S3 class `rmake.rule`
#' @seealso [rule()], [makefile()]
#' @author Michal Burda
#' @export
depRule <- function(target, depends=NULL, task='all') {
  rule(target=target,
       depends=depends,
       task=task,
       type='dependency')
}
