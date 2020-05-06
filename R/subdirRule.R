#' Rule for running the make process on a subdirectory
#'
#' The subdirectory in the `target` argument is assumed to contain its own `Makefile`. This rule
#' causes the execution of `make <targetTask>` in this subdirectory (where `<targetTask>` is the
#' value of the `targetTask` argument).
#'
#' @param target Name of the subdirectory
#' @param depends Must be `NULL`
#' @param task A character vector of parent task names. The mechanism of tasks allows to group
#'   rules. Anything different from `'all'` will cause creation of a new task depending on the given
#'   rule. Executing `make taskname` will then force building of this rule.
#' @param targetTask What task to execute in the subdirectory.
#' @return An instance of S2 classs `rmake.rule`
#' @seealso [rule()], [makefile()]
#' @author Michal Burda
#' @export
subdirRule <- function(target, depends=NULL, task='all', targetTask='all') {
  assert_that(is.character(target))
  assert_that(length(target) == 1)
  assert_that(is.null(depends))
  assert_that(is.character(task))

  rule(target=target,
       depends=depends,
       build=paste0('$(MAKE) -C ', target, ' ', targetTask),
       clean=paste0('$(MAKE) -C ', target, ' clean'),
       task=task,
       type='subdir',
       phony=TRUE)
}
