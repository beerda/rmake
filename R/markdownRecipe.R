#' @export
#' @importFrom rmarkdown render
markdownRecipe <- function(target,
                           script,
                           depends=NULL,
                           format='all',
                           params=NULL,
                           task='all') {
  assert_that(is.character(target))
  assert_that(is.string(script))
  assert_that(is.null(depends) || is.character(depends))
  assert_that(is.character(format))
  assert_that(is.character(task))

  format <- match.arg(format,
                      c('all', 'html_document', 'pdf_document', 'word_document',
                        'odt_document', 'rtf_document', 'md_document'),
                      several.ok=TRUE)
  allDeps <- c(script, depends)
  p <- params
  rm(params)

  recipe(target=target,
         depends=allDeps,
         build=inShell({
           library(rmarkdown)
           params <- p
           render(script, output_format=format, output_file=target)
         }),
         clean=paste0('$(RM) ', paste0(target, collapse=' ')),
         task=task)
}
