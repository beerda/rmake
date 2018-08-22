#' Rule for requesting manual user action
#'
#' Instead of building the target, this rule simply issues the given error message.
#' This rule is useful for cases, where the target `target` depends on `depends`, but
#' has to be updated by some manual process. So if `target` is older than any of its
#' dependencies, `make` will throw an error until the user manually updates the target.
#'
#' @param target A character vector of target file names of the manual (offline) build
#' command
#' @param message An error message to be issued if targets are older than dependencies
#' from `depends`
#' @param depends A character vector of file names the targets depend on
#' @param task A character vector of parent task names. The mechanism of tasks allows to
#' group rules. Anything different from `'all'` will
#' cause creation of a new task depending on the given rule. Executing `make taskname`
#' will then force building of this rule.
#' @return Instance of S3 class `rmake.rule`
#' @seealso [rule()], [makefile()]
#' @author Michal Burda
#' @examples
#' r <- offlineRule(target='offlinedata.csv',
#'                  message='Please re-generate manually offlinedata.csv',
#'                  depends=c('source1.csv', 'source2.csv'))
#'
#' # generate the content of a makefile (as character vector)
#' makefile(list(r))
#'
#' # generate to file
#' tmp <- tempdir()
#' makefile(list(r), file.path(tmp, "Makefile"))
#' @export
offlineRule <- function(target, message, depends=NULL, task='all') {
  assert_that(is.character(target))
  assert_that(is.string(message))
  assert_that(is.null(depends) || is.character(depends))
  assert_that(is.character(task))

  rule(target=target,
       depends=c(depends),
       build=inShell({
         stop(message)
       }),
       clean=paste0('$(RM) ', paste0(target, collapse=' ')),
       task=task,
       type='offline')
}
