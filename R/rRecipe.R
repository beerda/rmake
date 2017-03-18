#' @export
rRecipe <- function(target, script, depends=NULL) {
  recipe(target=target,
         depends=c(script, depends),
         build=inShell(source(script)),
         clean=paste0('rm ', target))
}
