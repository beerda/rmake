#' Rule for running R scripts
#'
#' This rule is for execution of R scripts in order to create various file outputs.
#'
#' In detail, this rule executes the following command in a separate R process:
#' `params <- params; source(script)`
#'
#' That is, parameters given in the `params` argument are stored into the global variable
#' and then the `script` is sourced. That is, the re-generation of the `Makefile` with any change
#' to `params` will not cause the re-execution of the recipe unless any other script dependencies change.
#'
#' Issuing `make clean` from the shell causes removal of all files specified in `target` parameter.
#'
#' @param target Name of output files to be created
#' @param script Name of the R script to be executed
#' @param depends A vector of file names that the R script depends on, or `NULL`.
#' @param params A list of R values that become available within the `script` in
#' a `params` variable.
#' @param task A character vector of parent task names. The mechanism of tasks allows to
#' group rules. Anything different from `'all'` will
#' cause creation of a new task depending on the given rule. Executing `make taskname`
#' will then force building of this rule.
#' @return Instance of S3 class `rmake.rule`
#' @seealso [rule()], [makefile()], [markdownRule()]
#' @author Michal Burda
#' @examples
#' r <- rRule(target='cleandata.csv',
#'            script='clean.R',
#'            depends=c('data1.csv', 'data2.csv'))
#'
#' # generate the content of a makefile (as character vector)
#' makefile(list(r))
#'
#' # generate to file
#' tmp <- tempdir()
#' makefile(list(r), file.path(tmp, "Makefile"))
#' @export
rRule <- function(target, script, depends=NULL, params=list(), task='all') {
  assert_that(is.character(target))
  assert_that(is.string(script))
  assert_that(is.null(depends) || is.character(depends))
  assert_that(is.list(params))
  assert_that(is.character(task))

  p <- c(list(.target=target,
              .script=script,
              .depends=depends,
              .task=task),
         params)
  rm(params)

  rule(target=target,
       depends=c(script, depends),
       build=inShell({
         params <- p
         source(script)
       }),
       clean=paste0('$(RM) ', paste0(target, collapse=' ')),
       task=task)
}
