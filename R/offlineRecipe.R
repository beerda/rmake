#' Recipe for requesting manual user action
#'
#' Instead of building the target, this recipe simply issues the given error message.
#' This recipe is useful for cases, where the target `target` depends on `depends`, but
#' has to be updated by some manual process. So if `target` is older than any of its
#' dependencies, `make` will throw an error until the user manualy updates the target.
#'
#' @param target A character vector of target file names of the manual (offline) build
#' command
#' @param message An error message to be issued if targets are older than dependencies
#' from `depends`
#' @param depends A character vector of file names the targets depend on
#' @param task A character vector of parent task names. The mechanism of tasks allows to
#' group recipes. Anything different from `'all'` will
#' cause creation of a new task depending on the given recipe. Executing `make taskname`
#' will then force building of this recipe.
#' @return Instance of S3 class `recipe`
#' @seealso [recipe()], [makefile()]
#' @author Michal Burda
#' @export
offlineRecipe <- function(target, message, depends=NULL, task='all') {
  assert_that(is.character(target))
  assert_that(is.string(message))
  assert_that(is.null(depends) || is.character(depends))
  assert_that(is.character(task))

  recipe(target=target,
         depends=c(depends),
         build=inShell({
           stop(message)
         }),
         clean=paste0('$(RM) ', paste0(target, collapse=' ')),
         task=task)
}
