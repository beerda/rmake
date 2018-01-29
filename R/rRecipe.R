#' Recipe for running R scripts
#'
#' This recipe is for execution of R scripts in order to create various file outputs.
#'
#' In detail, this recipe executes the following command in a separate R process:
#' `params <- params; source(script)`
#'
#' Issuing `make clean` from the shell causes removal of all files specified in `target` parameter.
#'
#' @param target Name of output files to be created
#' @param script Name of the R script to be executed
#' @param depends A vector of file names that the R script depends on, or `NULL`.
#' @param params `NULL` or a list of R values that become available within the `script` in
#' a `params` variable.
#' @param task A character vector of parent task names. The mechanism of tasks allows to
#' group recipes. Anything different from `'all'` will
#' cause creation of a new task depending on the given recipe. Executing `make taskname`
#' will then force building of this recipe.
#' @return Instance of S3 class `recipe`
#' @seealso [recipe()], [makefile()], [markdownRecipe()]
#' @author Michal Burda
#' @export
rRecipe <- function(target, script, depends=NULL, params=NULL, task='all') {
  assert_that(is.character(target))
  assert_that(is.string(script))
  assert_that(is.null(depends) || is.character(depends))
  assert_that(is.character(task))

  p <- params
  rm(params)
  recipe(target=target,
         depends=c(script, depends),
         build=inShell({
           params <- p
           source(script)
         }),
         clean=paste0('$(RM) ', paste0(target, collapse=' ')),
         task=task)
}
