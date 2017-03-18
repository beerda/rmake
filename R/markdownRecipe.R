#' @export
markdownRecipe <- function(target,
                           script,
                           depends=NULL,
                           format=markdownFormatFromExtension(tools::file_ext(target)),
                           ...) {
  recipe(target=target,
         depends=c(script, depends),
         build=inShell({
           library(rmarkdown)
           do.call('render', c(list(script,
                                    output_format=format,
                                    output_file=target),
                               list(...)))
         }),
         clean=paste0('rm ', target))
}
