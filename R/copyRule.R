#' Rule for copying a file into a new location
#'
#' This rule is for copying a file from one location to another.
#' The rule executes the following command:
#' `$(CP) depends[1] target`
#'
#' @param target Target file name to copy the file to
#' @param depends name of the file to copy from (only the first element
#'     of the vector is used)
#' @param task A character vector of parent task names. The mechanism of tasks
#'     allows to group rules. Anything different from `'all'` will
#'     cause creation of a new task depending on the given rule.
#'     Executing `make taskname` will then force building of this rule.
#' @return Instance of S3 class `rmake.rule`
#' @seealso [rule()], [makefile()]
#' @author Michal Burda
#' @export
copyRule <- function(target, depends, task='all') {
  assert_that(is.string(target))
  assert_that(is.character(depends))
  assert_that(is.character(task))

  rule(target=target,
       depends=depends,
       build=paste0('$(CP) ', sanitizePath(depends[1]), ' ', sanitizePath(target)),
       clean=paste0('$(RM) ', paste0(sanitizePath(target), collapse=' ')),
       task=task,
       type='copy')
}
