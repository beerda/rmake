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
