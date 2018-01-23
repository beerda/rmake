#' Check if the argument is a valid recipe object.
#'
#' Function tests whether `x` is a valid recipe object, i.e., whether
#' it is list a list and inherits from the `recipe` S3 class. Instances
#' of `recipe` represent an atomic building unit, i.e. a command that
#' has to be executed, which optionally depends on some files or other
#' recipes -- see [recipe()] for more details.
#'
#' @param x An argument to be tested
#' @return `TRUE` if `x` is a valid recipe object and `FALSE` otherwise.
#' @author Michal Burda
#' @seealso [recipe()], [makefile()], [rRecipe()], [markdownRecipe()], [offlineRecipe()]
#' @export
is.recipe <- function(x) {
  is.list(x) && inherits(x, 'recipe')
}

#' @importFrom assertthat on_failure
assertthat::on_failure(is.recipe) <- function(call, env) {
  paste0(deparse(call$x), " is not a recipe (a 'recipe' class list)")
}
