#' Rule for running Python scripts
#'
#' This rule executes Python scripts to create various file outputs.
#'
#' In detail, this rule executes the following command in a shell:
#' `python script arguments`
#' where `arguments` are script arguments created from the `args` parameter. If
#' `args` is `NULL`, the arguments are created from the `depends` and `target`
#' parameters, in that order. If `args` is not `NULL`, it must be a string
#' with command line arguments that may contain variables `$[DEP1]`, `$[DEP2]`,
#'  ..., `$[TARGET1]`, `$[TARGET2]`, ... that are replaced with the corresponding
#' file names from `depends` and `target`.
#'
#' Issuing `make clean` from the shell causes removal of all files specified in
#' the `target` parameter.
#'
#' @param target Name of output files to be created
#' @param script Name of the Python script to be executed
#' @param depends A vector of file names that the Python script depends on, or
#'     `NULL`.
#' @param args A string with command line arguments for the Python script.
#'     This string may contain variables `$[DEP1]`, `$[DEP2]`, ..., `$[TARGET1]`,
#'     `$[TARGET2]`, ... that are replaced with the corresponding file names from
#'     `depends` and `target`. If `args` is `NULL`, the arguments are created
#'     from the `depends` and `target` parameters, in that order.
#' @param python The command to execute Python. By default, it is `python`, but
#'     it can be set to a specific path or to `python3` if needed.
#' @param task A character vector of parent task names. The mechanism of tasks allows
#'     grouping rules. Anything different from `'all'` will cause the creation of a
#'     new task depending on the given rule. Executing `make taskname` will then
#'     force building this rule.
#' @return Instance of S3 class `rmake.rule`
#' @seealso [rule()], [makefile()]
#' @author Michal Burda
#' @export
pythonRule <- function(target,
                       script,
                       depends=NULL,
                       args=NULL,
                       python='python',
                       task='all') {
  assert_that(is.character(target))
  assert_that(is.string(script))
  assert_that(is.null(depends) || is.character(depends))
  assert_that(is.null(args) || is.string(args))
  assert_that(is.character(task))

  arguments <- c(depends, target)
  if (!is.null(args)) {
    depVars <- depends
    names(depVars) <- paste0('DEP', seq_along(depends))

    targetVars <- target
    names(targetVars) <- paste0('TARGET', seq_along(target))

    vars <- c(depVars, targetVars)
    arguments <- replaceVariables(args, vars)
  }

  rule(target=target,
       depends=c(script, depends),
       build=paste(python,
                   script,
                   paste(arguments, collapse=' '),
                   sep=' '),
       clean=paste0('$(RM) ', paste0(sanitizePath(target), collapse=' ')),
       task=task,
       type='python')
}
