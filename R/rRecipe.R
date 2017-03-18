#' @export
rRecipe <- function(target, script, depends=NULL) {
  assert_that(is.string(target))
  assert_that(is.string(script))
  assert_that(is.null(depends) || is.character(depends))

  recipe(target=target,
         depends=c(script, depends),
         build=inShell(source(script)),
         clean=paste0('$(RM) ', target))
}
