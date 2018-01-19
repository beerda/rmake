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
