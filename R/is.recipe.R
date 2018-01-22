#' @export
is.recipe <- function(x) {
  is.list(x) && inherits(x, 'recipe')
}

#' @importFrom assertthat on_failure
assertthat::on_failure(is.recipe) <- function(call, env) {
  paste0(deparse(call$x), " is not a recipe (a 'recipe' class list)")
}
