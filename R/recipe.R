#' General creator of an instance of the S3 `recipe` class
#'
#' Recipe is an atomic element of the build process. It defines a set of `target` file names,
#' which are to be built with a given `build` command from a given set `depends` of files
#' that targets depend on, and which can be removed by a given `clean` command.
#'
#' If there is a need to group some recipes together, one can assign them the same task identifier in
#' the `task` argument. Each recipe may get assigned one or more tasks. Tasks may be then built
#' by executing `make task_name` on the command line, which forces to rebuild all recipes assigned to the
#' task `'task_name'`. By default, all recipes are assigned to task `all`,
#' which causes `make all` command to build everything.
#'
#' @param target A character vector of target file names that are created by the given build command
#' @param depends A character vector of file names the build command depends on
#' @param build A shell command that runs the build of the given target
#' @param clean A shell command that erases all files produced by the build command
#' @param task A character vector of parent task names. The mechanism of tasks allows to
#' group recipes. Anything different from `'all'` will
#' cause creation of a new task depending on the given recipe. Executing `make taskname`
#' will then force building of this recipe.
#' @return Instance of S3 class `recipe`
#' @seealso [makefile()]
#' @author Michal Burda
#' @export
recipe <- function(target, depends=NULL, build=NULL, clean=NULL, task='all') {
  assert_that(is.character(target))
  assert_that(is.null(depends) || is.character(depends))
  assert_that(is.null(build) || is.character(build))
  assert_that(is.null(clean) || is.character(clean))
  assert_that(is.character(task))

  pattern <- target
  if (length(target) > 1) {
    if (!all(grepl('.', target, fixed=TRUE))) {
      stop('"." not found in all targets')
    }
    pattern <- sub('.', '%', target, fixed=TRUE)
  }

  structure(list(target=target,
                 pattern=pattern,
                 depends=unique(depends),
                 build=build,
                 clean=clean,
                 task=task),
            class='recipe')
}
